setfenv(0, _G)

if not muldim then include("multidim.lua") end
if not netstack then include("netstack.lua") end

--[[
	Emits:

		SV: "CustomWriteChanges" : changes_table
			If you have a custom encoder for the whole object, use this event and return anything from it
	
		SV: "ShouldNetwork"
			Returning false from this will prevent networking
			Changes won't be lost to networking, meaning it might attempt to network in the future

		SV: "ShouldEncode" : change_key, change_value
			If you return false from this, the change won't be written (but will be lost to networking!)
			Should be primarily used for equality checks

		SV: "WriteChangeValue" : key, value, ...
			If you return false from this, the change value won't be written
			Should be primarily used to encode a value your own way


		CL: "CustomReadChanges"
			If you have a custom encoder for the whole object, use this event and return anything from it

		CL: "ReadChangeValue" : key
			If you had a custom encoder for the value in WriteChangeValue, this is the hook to read it from

		CL: "NetworkedVarChanged" : key, old_var, new_var
			Kinda like NetworkVarNotify

		CL: "NetworkedChanged" : changes_table
			Kinda like NetworkVarNotify, except after _everything_ was updated


	If you're using .Filter, that implies you'll also handle when to network.
]]
Networkable = Networkable or Emitter:callable()
local nw = Networkable

local update_freq = 0.3

_NetworkableCache = _NetworkableCache or {}-- _NetworkableCache or {}

_NetworkableNumberToID = _NetworkableNumberToID or {} --[num] = name
_NetworkableIDToNumber = _NetworkableIDToNumber or {} --[name] = num
_NetworkableQueue = _NetworkableQueue or {}	-- [seq_id] = [name] ; FIFO

_NetworkableChanges = _NetworkableChanges or muldim:new()-- _NetworkableChanges or muldim:new()

_NetworkableAwareness = _NetworkableAwareness or muldim:new() --[ply] = {'ID', 'ID'} , not numberids

_NetworkableData = _NetworkableData or muldim:new() 	-- stores networkable data as [num_id] = {bunch of key-values}
local idData = _NetworkableData							-- only used clientside

Networkable.Verbose = Networkable.Verbose or (Networkable.Verbose == nil and false)
Networkable.Warnings = true

local SZ = {
	NUMBERID = 16,
	CHANGES_COUNT = 12,

	INTERVAL_UPDATE = 1024 * 12, -- 12kb
	FULL_UPDATE = 1024 * 32, -- 32kb
}

local realPrint = print
local print = function(...)
	if not Networkable.Verbose then return end
	realPrint(...)
end

local realPrintf = printf
local printf = function(...)
	if not Networkable.Verbose then return end
	realPrintf(...)
end

local warnf = function(s, ...)
	if not Networkable.Warnings then return end
	MsgC(Colors.Warning, "[NWble] ", color_white, s:format(...), "\n")
end

warn = warnf

local fakeNil = newproxy() --lul

local cache = _NetworkableCache

local numToID = _NetworkableNumberToID -- these tables are not sequential!!!
local IDToNum = _NetworkableIDToNumber

function Networkable.ResetAll()
	table.Empty(cache)
	table.Empty(numToID)
	table.Empty(IDToNum)

	table.Empty(_NetworkableChanges)
	table.Empty(_NetworkableAwareness)
end

function Networkable.CreateIDPair(id, numid)
	numToID[numid] = id
	IDToNum[id] = numid
end

local encoderIDLength = 5 --5 bits fit 16 (0-15) encoders

-- make sure you up encoderIDLength if you go above encoder ID of 15
local ns = netstack:new()
-- write hijacked versions of net.*

ns:Hijack(true)

local _vONCache = {}
local _CurrentNWKey -- used for debug

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

local decoders = {
	["string"] = {0, net.ReadString},
	["entity"] = {1, function()
		local entID = net.ReadUInt(16)
		if IsValid(Entity(entID)) then return Entity(entID) end
		error("Reading '" .. _CurrentNWKey .. "' : Entity isn't valid. Consider networking something else...?")
	end},
	["vector"] = {2, net.ReadVector},

	["table"] = {3, function(t)
		--if t.Networkable_Decoder then return t:Networkable_Decoder() end

		local len = net.ReadUInt(16)
		local von_data = net.ReadData(len)

		local de_vonned = von.deserialize(von_data)

		return de_vonned
	end},

	["boolean"] = {4, net.ReadBool},
	["angle"] = {5, net.ReadAngle},
	["color"] = {6, net.ReadColor},

	["uint"] = {7, net.ReadUInt, 32},
	["ushort"] = {8, net.ReadUInt, 16},

	["int"] = {9, net.ReadInt},
	["float"] = {10, net.ReadFloat, 32},
	["nil"] = {11, BlankFunc}
}

local decoderByID = {}

for typ,v in pairs(decoders) do
	decoderByID[v[1]] = v
end

local NetworkAll --pre-definition

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

nw.AutoAssignID = true

function nw:Initialize(id, ...)
	self.Networked = {}
	self.Aliases = {}

	self.__LastSerialized = {} -- purely for networked tables
	self.__Aware = muldim:new()

	self:On("ShouldEncode", "TablesvONCheck", function(self, k, v)
		if istable(v) then
			local vonData = von.serialize(v)
			if self.__LastSerialized[k] == vonData then return end
			_vONCache[k] = vonData
		end
	end)

	if not rawget(self.__instance, "AutoAssignID") then return end 	-- if this object is constructed from an Networkable extension,
																	-- ignore the fact we don't have an ID

	if not id then error("Networkable creation requires an ID!") return end

	if cache[id] then return cache[id] end

	self:SetNetworkableID(id)
end

function nw:__tostring()
	return ("[Networkable][%d][`%s`]"):format(self.NumberID or -1, self.NetworkableID or "[no ID]")
end

function nw:SetNetworkableID(id, replace)

	self.NetworkableID = id

	local before = cache[id]

	if cache[id] and cache[id] ~= self and not replace then errorf("This isn't supposed to happen -- setting NWID with a networkable already existing! NWID: %s", id) return end
	cache[id] = self

	printf("SetNetworkableID called %s %s %s", Realm(true, true), id, idData[id])

	if CLIENT and idData[id] then
		print("woah!!!! existssss")
		for k, v in pairs(idData[id]) do
			if self.Aliases[k] then k = self.Aliases[k] end
			printf("pulling cached change: %s = %s", k, v)
			self:Set(k, v)
		end
	end

	if SERVER then
		local typ = type(id):lower()

		local encoder, encoderID, additionalArg = determineEncoder(typ, id)

		self.NetworkableIDEncoder = {
			Func = encoder, --function which will encode the ID
			ID = encoderID, --ID of the encoder function so the client knows how to figure it out
			IDArg = additionalArg, --additional arg for the encoder function, for cases like UInt and whatnot which require a second arg
		}


		local key = (replace and before and before.NumberID) or #numToID + 1
		numToID[key] = id
		IDToNum[id] = key
		self.NumberID = key
	end

	return self
end

function nw:SetNetworkableNumberID(numid)
	if not self.NetworkableID then error("Networkable must have an ID before setting a number ID!") return end

	numToID[numid] = self.NetworkableID
	self.NumberID = numid
end

function nw:IsValid()
	return self.Valid ~= false
end

function nw:Set(k, v)
	if self.Valid == false then
		error("Attempted to set a networked var on an invalid Networkable!", 2)
		return
	end

	if not self.NetworkableID then
		error("Set a NetworkableID first!")
		return
	end

	if not _NetworkableCache[self.NetworkableID] then
		printf("didn't find self with nwid?... %s", self.NetworkableID)
		self:SetNetworkableID(self.NetworkableID)
	end -- maybe resetall happened

	if self.Aliases[k] ~= nil then k = self.Aliases[k] end

	if CLIENT then -- don't bother
		self.Networked[k] = v
		return self
	end

	if v == nil then v = fakeNil end --lul
	if self.Networked[k] == v and not istable(v) then --[[adios]] return end

	if istable(v) then --we have to check if tables are exact
		local last_von = self.__LastSerialized[v]
		local new_von = von.serialize(v)

		if last_von == new_von then --[[ adios ]] return end

		self.__LastSerialized[v] = new_von
	end

	self.Networked[k] = v
	_NetworkableChanges:Set(v, self.NetworkableID, k)
	return self
end

function nw:Get(k, default)
	if self.Aliases[k] ~= nil then k = self.Aliases[k] end

	local ret = self.Networked[k]
	if ret == fakeNil then return nil end
	if ret == nil then return default end

	return ret
end

function nw:Alias(k, k2)
	self.Aliases[k] = k2
end

function nw:GetNetworked() --shrug
	return self.Networked
end


function nw:Invalidate()
	self.Valid = false

	if self.NetworkableID then
		cache[self.NetworkableID] = nil
		idData[self.NetworkableID] = nil

		if self.NumberID and numToID[self.NumberID] == self.NetworkableID then numToID[self.NumberID] = nil end

		IDToNum[self.NetworkableID] = nil
	end

	self:Emit("Invalidated")

	if SERVER then
		_NetworkableChanges[self.NetworkableID] = nil

		for ply, ids in pairs(_NetworkableAwareness) do
			ids[self.NetworkableID] = nil
		end

		-- TODO: Awareness check here
		net.Start("NetworkableInvalidated")
			net.WriteUInt(self.NumberID, 24)
		net.Broadcast()
	end

end


function nw:Bond(what)

	if isentity(what) then

		hook.OnceRet("EntityRemoved", ("Networkable.Bond:%p"):format(what), function(ent)
			if ent ~= what then return false end

			if CLIENT then
				timer.Simple(0.1, function()
					if IsValid(ent) then self:Bond(ent) return end --fullupdates :v
					self:Invalidate()
				end)
			else
				self:Invalidate()
			end

		end)
	else
		errorf("Can't bind to %q (%s)!", type(what), what)
	end

	return self
end
nw.Bind = nw.Bond

local function IDToNumber(id)
	return IDToNum[id]
end

local function NumberToID(id)
	return numToID[id]
end

if SERVER then

	local function WriteNWID(obj)
		net.WriteUInt(obj.NetworkableIDEncoder.ID, encoderIDLength)
		obj.NetworkableIDEncoder.Func(obj.NetworkableID, obj.NetworkableIDEncoder.IDArg)
	end

	local function WriteChange(key, val, obj, ...)

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

		local res = obj:Emit("WriteChangeValue", key, val, ...)

		if res == false then print("not writing change serverside", key, val) return end

		op = net.WriteUInt(v_encoderID, encoderIDLength)
		v_encoder(val, v_additionalArg, key)

		if net.ActiveNetstack then
			op.Description = "Changed value encoder ID"
		end
	end

	util.AddNetworkString("NetworkableSync")
	util.AddNetworkString("NetworkableInvalidated")

	function Networkable:_SendNet(who, full, budget)
		if self:Emit("ShouldNetwork", who) == false then return end

		budget = budget or 32 * 1024 * 8

		local numID, nameID = self.NumberID, self.NetworkableID
		local unaware = false

		for _, ply in ipairs(who) do
			-- if some player didn't know about this NWID, network the ID as well
			if not _NetworkableAwareness[ply] or not _NetworkableAwareness[ply][nameID] then 
				unaware = true
				_NetworkableAwareness:Set(true, ply, nameID)
			end
		end

		local changes = full and self:GetNetworked() or _NetworkableChanges[nameID]
		local changes_count = 0

		for k,v in pairs(changes) do
			local should = self:Emit("ShouldEncode", k, v)
			if should == false then changes[k] = nil continue end

			changes_count = changes_count + 1
		end

		local written = 0

		net.Start("NetworkableSync")
			local ns = netstack:new()
			ns:Hijack()

			-- write numberID + NWID if there are any unaware people
			net.WriteBool(unaware)
			net.WriteUInt(numID, SZ.NUMBERID)

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
					WriteChange(k, v, self)
					changes[k] = nil
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

			net.WriteNetStack(ns)
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
	function NetworkAll()
		if not next(_NetworkableChanges) then return end

		local everyone = player.GetAll()
		local sendTo = table.Copy(everyone)

		for nwID, changes in pairs(_NetworkableChanges) do
			if cache[nwID] then
				cache[nwID]:_Queue()
			end
		end

		local all = player.GetAll()
		local copy = {}
		local len = 0

		local total_written = 0

		for i=1, #_NetworkableQueue do
			local name = table.remove(_NetworkableQueue, 1)

			local obj = _NetworkableCache[name]
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

			local ns, written = obj:_SendNet(copy, false, SZ.INTERVAL_UPDATE - total_written)
			total_written = total_written + written
							-- written more than INTERVAL_UPDATE = halt until next nw frame
			if total_written > SZ.INTERVAL_UPDATE then
				return
			end
		end

	end

	_G.NWAll = NetworkAll
	local nwAll = function()
		local ok, err = pcall(NetworkAll)
		if not ok then
			realPrint("NetworkableNetwork Error:", err)
		end
	end

	-- Updates every player in `who` table on every networkable
	-- in `what` table, regardless of their awareness
	function Networkable.UpdateFull(who, what)
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
				copy = all
			end

			obj:_SendNet(copy, true)
		end
	end

	timer.Create("NetworkableNetwork", update_freq, 0, nwAll)

	hook.Add("PlayerFullyLoaded", "NetworkableUpdate", function(ply)
		Networkable.UpdateFull(ply, _NetworkableCache)
	end)

	function nw:Network(now) 	--networks everything in the next tick (or right now if `now` is true OR networkable has a filter)
		local to = istable(nwTo) and nwTo or player.GetAll()
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

end

if CLIENT then

	local function ReadNWID()
		local enc_id = net.ReadUInt(encoderIDLength)

		local dec = decoderByID[enc_id]
		local name = dec[2](dec[3])

		return name
	end

	local function ReadChange(obj)
		local k_encID = net.ReadUInt(encoderIDLength)

		local k_dec = decoderByID[k_encID]

		if not k_dec then
			print("	failed to read k_dec", k_dec, k_encID)
		end

		local decoded_key = k_dec[2](k_dec[3])
		if obj and obj.Aliases[decoded_key] then decoded_key = obj.Aliases[decoded_key] end

		if obj then
			local customValue, setNil = obj:Emit("ReadChangeValue", decoded_key)
			if customValue ~= nil and not setNil then return decoded_key, customValue end
		end

		local v_encID = net.ReadUInt(encoderIDLength)

		local v_dec = decoderByID[v_encID]
		local decoded_val = v_dec[2](v_dec[3])

		--print("	decoded key, val:", decoded_key, decoded_val)
		return decoded_key, decoded_val
	end

	net.Receive("NetworkableSync", function(len)
		printf("received sync: %d bytes", len/8)
		local is_new = net.ReadBool()
		local num_id = net.ReadUInt(SZ.NUMBERID)
		local nwID

		if is_new then
			nwID = ReadNWID(num_id)
		else
			nwID = NumberToID(num_id)
		end

		if not nwID then
			warn("Something went wrong while reading networkable: failed to grab NWID for numID %d.", num_id)
			return
		end

		_CurrentNWKey = nwID

		if not cache[nwID] then
			Networkable.CreateIDPair(nwID, num_id)
		else
			cache[nwID]:SetNetworkableNumberID(num_id)
		end

		local obj = cache[nwID]
		if not obj then
			warnf("Networkable with the name `%s` (%d) didn't exist clientside.", nwID, num_id)
		end

		if obj and obj:Emit("CustomReadChanges") ~= nil then
			printf("	networkable %s(%d) had custom reader", nwID or "nil", num_id)
			return
		end

		local cng_amt = net.ReadUInt(SZ.CHANGES_COUNT)
		printf("	amt of changed keys for %s(id: %s): %d", obj, nwID:Quote(), cng_amt)

		local changes = {}
		for i=1, cng_amt do
	
			printf("	reading change #%d", i)

			local k, v = ReadChange(obj)

			if obj then
				changes[k] = {obj.Networked[k], v}
				obj.Networked[k] = v
				obj:Emit("NetworkedVarChanged", k, changes[k][1], v) -- key, old, new
			else

				idData:Set(v, NumberToID(num_id), k)
				warn("	Couldn't find object with numID %d; stashing change...", num_id)
			end


			if obj then
				obj:Emit("NetworkedChanged", changes)
			end
		end
	end)

	net.Receive("NetworkableInvalidated", function()
		local num_id = net.ReadUInt(SZ.NUMBERID)
		print("invalidated nwable with numID", num_id)
		local id = NumberToID(num_id)
		print("that's ID", id)

		if not id then print("we dont know that") return end

		_NetworkableData[id] = nil
		if _NetworkableCache[id] then
			_NetworkableCache[id]:Invalidate()
		end

		_NetworkableNumberToID[num_id] = nil
		_NetworkableIDToNumber[id] = nil
	end)
end