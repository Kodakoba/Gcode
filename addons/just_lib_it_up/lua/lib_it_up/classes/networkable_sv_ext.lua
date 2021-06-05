LibItUp.SetIncluded()
setfenv(0, _G)

if CLIENT then
	for i=1, 100 do
		ErrorNoHalt("WTF? Networkable_sv included clientside\n")
	end
end

if not muldim then include("multidim.lua") end
if not netstack then include("netstack.lua") end

local nw = LibItUp.Networkable
--[[
	Emits:

		SV: "CustomWriteChanges" : changes_table
			If you have a custom encoder for the whole object, use this event and return anything from it

		SV: "ShouldNetwork"
			Returning false from this will prevent networking
			Changes won't be lost to networking, meaning it might attempt to network in the future

		SV: REMOVED || 	"ShouldEncode" : change_key, change_value
						If you return false from this, the change won't be written (but will be lost to networking!)
						Should be primarily used for equality checks

		SV: "WriteChangeValue" : key, value, players
			If you return false from this, the change value won't be written
			Should be primarily used to encode a value your own way


		CL: "CustomReadChanges"
			If you have a custom encoder for the whole object, use this event and return anything from it

		CL: "ReadChangeValue" : key
			If you had a custom encoder for the value in WriteChangeValue, this is the hook to read it from
			Return your value from it, and if it's nil, return the 2nd arg as "true"

		CL: "NetworkedVarChanged" : key, old_var, new_var
			Kinda like NetworkVarNotify

		CL: "NetworkedChanged" : changes_table
			Kinda like NetworkVarNotify, except after _everything_ was updated
]]

local update_freq = Networkable._UpdateFrequency
local SZ = Networkable._Sizes



local realPrint = print
local print = function(...)
	if not nw.Verbose then return end
	realPrint(...)
end

local realPrintf = printf
local printf = function(...)
	if not nw.Verbose then return end
	realPrintf(...)
end

local warnf = function(s, ...)
	if not nw.Warnings then return end
	MsgC(Colors.Warning, "[NWble] ", color_white, s:format(...), "\n")
end

local cache = _NetworkableCache

local numToID = _NetworkableNumberToID -- these tables are not sequential!!!
local IDToNum = _NetworkableIDToNumber

local encoderIDLength = 5 --5 bits fit 16 (0-15) encoders

local _vONCache = {}

local fakeNil = nw.FakeNil
--[[
	encoders
]]

-- make sure you up encoderIDLength if you go above encoder ID of 15
local ns = netstack:new()

-- write hijacked versions of net.*
ns:Hijack(true)

local encoders = {
	["string"] = {0, net.WriteString},
	["entity"] = {1, net.WriteEntity},
	["vector"] = {2, net.WriteVector},

	["table"] = {3, function(t, _, key)
		--if t.Networkable_Encoder then return t:Networkable_Encoder() end
		local vonned = _vONCache[key] or von.serialize(t)
		_vONCache[key] = nil

		net.WriteUInt(#vonned, 16)
		net.WriteData(vonned, #vonned)
	end},

	["boolean"] = {4, net.WriteBool},	--please don't use bools as keys for ID's lmao
	["angle"] = {5, net.WriteAngle},
	["color"] = {6, net.WriteColor},

	--7 to 11 are used!!!!!! do not use them!
}

ns:Hijack(false)
ns = nil

local function determineEncoder(typ, val)
	if val == fakeNil then --lol
		return BlankFunc, 11
	end

	if typ == "number" then --numbers are a bit more complicated
		if math.ceil(val) == val then
			if val >= 0 then
				if val > 65535 then
					return net.WriteUInt, 7, 32 -- uint
				else
					return net.WriteUInt, 8, 16 -- ushort
				end
			else
				return net.WriteInt, 9, 32		-- int
			end
		else
			return net.WriteFloat, 10
		end
	end

	if typ == "player" or typ == "weapon" then typ = "entity" end

	local enc = encoders[typ]
	if not enc then errorf("Failed to find Encoder function for type %s! Value is %s", typ, val) return end

	return enc[2], enc[1], enc[3]
end


--[[
	server-only methods used in shared
]]

function nw:_SVSetTable(k, v)
	-- like :Set() but does vON checking
	-- this is intended to be used with arrays/lists with von encodable shit

	-- setting objects will proc a networkablechange regardless of whether or not they're exact von-wise
	-- as we have no way of tracking it for custom objects
	-- they aren't intended to be serialized and are expected to be encoded in an emit ( and via an :Encode method when i get around to doing it :) )

	-- for tables, however, we can check if the data is exact

	local last_von = self.__LastSerialized[v]

	local err, new_von = pcall(von.serialize, v)

	if err then
		errorf("%s: Attempted to serialize a non-vON'able table! %s = %s\n%s", self, k, v, new_von)
	else
		if last_von == new_von then --[[ adios ]] return self end
		self.__LastSerialized[v] = new_von
	end
end

function nw:_SVBroadcastInvalidate()
	_NetworkableChanges[self.NetworkableID] = nil

	for ply, ids in pairs(_NetworkableAwareness) do
		ids[self.NetworkableID] = nil
	end

	-- TODO: Awareness check here
	net.Start("NetworkableInvalidated")
		net.WriteUInt(self.NumberID, 24)
	net.Broadcast()
end

function nw:_SVSetNWID(id, replace)
	local typ = type(id):lower()

	local encoder, encoderID, additionalArg = determineEncoder(typ, id)

	self.NetworkableIDEncoder = {
		Func = encoder, --function which will encode the ID
		ID = encoderID, --ID of the encoder function so the client knows how to figure it out
		IDArg = additionalArg, --additional arg for the encoder function, for cases like UInt and whatnot which require a second arg
	}


	local key = (replace and before and before.NumberID) or #numToID + 1
	assert(not numToID[key]) -- just in case since luajit has issues with gapped tables iinm

	numToID[key] = id
	IDToNum[id] = key
	self.NumberID = key
end

--[[
	actual networking:
]]

local function WriteNWID(obj)
	net.WriteUInt(obj.NetworkableIDEncoder.ID, encoderIDLength).Description = "Encoder ID"
	obj.NetworkableIDEncoder.Func(obj.NetworkableID, obj.NetworkableIDEncoder.IDArg)
end

local function WriteChange(key, val, obj, ...)
	key = obj.__Aliases[key] ~= nil and obj.__Aliases[key] or key

	local key_typ = type(key):lower()
	local val_typ = type(val):lower()

	local k_encoder, k_encoderID, k_additionalArg = determineEncoder(key_typ, key)
	local v_encoder, v_encoderID, v_additionalArg = determineEncoder(val_typ, val)

	-- write key encoderID and the encoded key
	local op = net.WriteUInt(k_encoderID, encoderIDLength)
	k_encoder(key, k_additionalArg, val)

	if net.ActiveNetstack then
		op.Description = "Changed key encoder ID"
	end
	-- write val encoderID and the encoded val
	print("WriteChange called", key, val)
	local unAliased = obj.__AliasesBack[key] or key
	local res = obj:Emit("WriteChangeValue", unAliased, val, ...)

	if res == false then printf("WriteChangeValue asked to not write change (%s = %s)", unAliased, val) return end

	op = net.WriteUInt(v_encoderID, encoderIDLength)
	v_encoder(val, v_additionalArg, key)

	if net.ActiveNetstack then
		op.Description = "Changed value encoder ID"
	end
end

util.AddNetworkString("NetworkableSync")
util.AddNetworkString("NetworkableInvalidated")

function nw:_SendNet(who, full, budget)
	if self:Emit("ShouldNetwork", who) == false then return end

	budget = budget or 32 * 1024 * 8

	local numID, nameID = self.NumberID, self.NetworkableID
	local unaware = full or false

	if not full then -- fullupdate ignores nw awareness
		for _, ply in ipairs(who) do
			-- if some player didn't know about this NWID, network the ID as well
			if not _NetworkableAwareness[ply] or not _NetworkableAwareness[ply][nameID] then
				unaware = true
				_NetworkableAwareness:Set(true, ply, nameID)
			end
		end
	end

	local changes = full and self:GetNetworked() or _NetworkableChanges[nameID]
	if not changes then return end --/shrug

	local changes_count = table.Count(changes)

	--[[
	for k,v in pairs(changes) do
		local should = self:Emit("ShouldEncode", k, v)
		if should == false then changes[k] = nil continue end

		changes_count = changes_count + 1
	end
	]]

	local written = 0

	net.Start("NetworkableSync")
		local ns = netstack:new()
		ns:Hijack()

		-- write numberID + NWID if there are any unaware people
		net.WriteBool(unaware)
		net.WriteUInt(numID, SZ.NUMBERID).Description = "NumberID for `" .. nameID .. "`"

		if unaware then
			WriteNWID(self)
		end

		self:Emit("StartWritingChanges", changes)

		local actuallyWritten = 0
		local nsCursor = 0

		if self:Emit("CustomWriteChanges", changes) == nil then
			net.WriteUInt(changes_count, SZ.CHANGES_COUNT).IsChangesCount = true
			nsCursor = ns:GetCursor() - 1

			for k,v in pairs(changes) do
				WriteChange(k, v, self, who)
				if not full then changes[k] = nil end
				actuallyWritten = actuallyWritten + 1
				if ns:BytesWritten() > budget then
					goto send -- YEET IT
				end
			end
		end

		_NetworkableChanges[nameID] = nil 	-- don't erase all changes if we didn't write all of them
											-- (eg went over budget)

		::send::
		written = ns:BytesWritten()
		ns:Hijack(false)

		ns:SetCursor(nsCursor)
		ns:WriteUInt(actuallyWritten, SZ.CHANGES_COUNT)

		print( tostring(ns), "networking to:")
		for k,v in pairs(who) do
			print(k, v)
		end

		local ct = math.floor(CurTime())
		local instances = nw.Profiling._NWDataInstances[ct] or {}
		nw.Profiling._NWDataInstances[ct] = instances

		local instBytes = instances[nameID] or 0

		net.WriteNetStack(ns)
		instances[nameID] = instBytes + (net.BytesWritten())
	net.Send(who)

	return ns, written
end

function Networkable:_Queue()
	local q = _NetworkableQueue
	for k,v in ipairs(q) do
		if v == self.NetworkableID then return end
	end

	q[#q + 1] = self.NetworkableID
end

-- networks all networkables to all players
local function NetworkAll()
	if not next(_NetworkableChanges) then return end

	for nwID, changes in pairs(_NetworkableChanges) do
		if cache[nwID] then
			cache[nwID]:_Queue()
		end
	end

	local all = player.GetAll()
	local copy = {}

	local total_written = 0

	-- every NW that needs networking will be in this queue
	-- so we pop the first one and network it
	for i=1, #_NetworkableQueue do
		local name = table.remove(_NetworkableQueue, 1)

		local obj = _NetworkableCache[name]
		local shouldFull = false

		if not obj or not obj:IsValid() then continue end

		if obj.Filter then
			copy = {}

			for k,v in ipairs(all) do
				if obj:Filter(v) ~= false then
					copy[#copy + 1] = v
				end
			end
		else
			copy = all
		end

		local _, written = obj:_SendNet(copy, shouldFull, SZ.INTERVAL_UPDATE - total_written)
		total_written = total_written + written
						-- written more than INTERVAL_UPDATE = halt until next nw frame
		if total_written > SZ.INTERVAL_UPDATE then
			return
		end
	end

end

_G.NWAll = NetworkAll

local nwErr = Curry(printf, "NetworkableNetwork error: %s")
local nwAll = function()
	xpcall(NetworkAll, nwErr)
end

-- Updates every player in `who` table on every networkable
-- in `what` table, regardless of their awareness
function Networkable.UpdateFull(who, what)
	if not what then
		what = _NetworkableCache
	end

	if istable(who) then
		Filter(who, true):Filter("IsValid", true)
	else
		who = {who}
	end

	local copy = {}

	for _, obj in pairs(what) do
		if obj.Filter then
			copy = {}

			for k,v in ipairs(who) do
				if obj:Filter(v) ~= false then
					copy[#copy + 1] = v
				end
			end

		else
			copy = who
		end
		print("Fullupdating:")
		for k,v in pairs(copy) do
			print("	", k, v)
		end
		obj:_SendNet(copy, true)
	end
end

Networkable.FullUpdate = Networkable.UpdateFull

timer.Create("NetworkableNetwork", update_freq, 0, nwAll)

hook.Add("PlayerFullyLoaded", "NetworkableUpdate", function(ply)
	Networkable.UpdateFull(ply, _NetworkableCache)
end)

function nw:Network(now) 	--networks everything in the next tick (or right now if `now` is true OR networkable has a filter)
	local to = player.GetAll()
	local copy = {}

	if self.Filter then
		copy = {}

		for k,v in ipairs(to) do
			if self:Filter(v) ~= false then
				copy[#copy + 1] = v
			end
		end

	else
		copy = to
	end

	self:_SendNet(copy)
end