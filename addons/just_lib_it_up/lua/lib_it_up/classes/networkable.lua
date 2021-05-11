LibItUp.SetIncluded()
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

LibItUp.Networkable = LibItUp.Networkable or Emitter:callable()
Networkable = LibItUp.Networkable
local nw = Networkable


Networkable._UpdateFrequency = 0.1

Networkable._Sizes = {
	NUMBERID = 16,
	CHANGES_COUNT = 12,

	INTERVAL_UPDATE = 1024 * 12 * Networkable._UpdateFrequency, -- 12kb
	FULL_UPDATE = 1024 * 32 * Networkable._UpdateFrequency, -- 32kb
}



_NetworkableCache = _NetworkableCache or {}

_NetworkableNumberToID = _NetworkableNumberToID or {} 	-- [num] = name
_NetworkableIDToNumber = _NetworkableIDToNumber or {} 	-- [name] = num
_NetworkableQueue = _NetworkableQueue or {}				-- [seq_id] = [name] ; FIFO

_NetworkableChanges = _NetworkableChanges or muldim:new()
_NetworkableAwareness = _NetworkableAwareness or muldim:new() --[ply] = {'NameID', 'NameID'}

_NetworkableData = _NetworkableData or muldim:new() 	-- stores networkable data as [num_id] = {bunch of key-values}
local idData = _NetworkableData							-- only used clientside for handling net races for primitive nw's
														-- (no custom decoders)

nw.Verbose = nw.Verbose or (nw.Verbose == nil and false)
nw.Warnings = true
nw.BytesWarn = nw.BytesWarn or 500


nw.Profiling = {}
nw.Profiling._NWDataInstances = {}

-- { [CurTime] = { [nameID] = amt_bytes, ... }

timer.Create("NetworkableCleanProfiler", 60, 0, function()
	local ct = CurTime()

	for time, data in pairs(nw.Profiling._NWDataInstances) do
		if time < ct - 60 then
			nw.Profiling._NWDataInstances[time] = nil
		end
	end

end)


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

local fakeNil = newproxy() --lul

local cache = _NetworkableCache
local numToID = _NetworkableNumberToID -- these tables are not sequential!!!
local IDToNum = _NetworkableIDToNumber

function nw.ResetAll()
	table.Empty(cache)
	table.Empty(numToID)
	table.Empty(IDToNum)

	table.Empty(_NetworkableChanges)
	table.Empty(_NetworkableAwareness)
end

function nw.CreateIDPair(id, numid)
	numToID[numid] = id
	IDToNum[id] = numid
end

local encoderIDLength = 5 --5 bits fit 16 (0-15) encoders

local _vONCache = {}
local _CurrentNWKey -- used for debug

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

nw.AutoAssignID = true

function nw:Initialize(id, ...)
	self.Networked = {}

	self.__Aliases = {}			-- [name] = alias
	self.__AliasesBack = {}		-- [alias] = name

	self.__LastSerialized = {} -- purely for networked tables
	self.__Aware = muldim:new()

	self.Valid = true
	--[[
	self:On("ShouldEncode", "TablesvONCheck", function(self, k, v)
		if istable(v) and not v.__isobject then
			local vonData = "bruh"--von.serialize(v)
			if self.__LastSerialized[k] == vonData then return end
			_vONCache[k] = vonData
		end
	end)
	]]

	if not rawget(self.__instance, "AutoAssignID") then return end 	-- if this object is constructed from an Networkable extension,
																	-- ignore the fact we don't have an ID

	assert(id, "Networkable creation requires an ID!")

	if cache[id] then return cache[id] end

	self:SetNetworkableID(id)
end

function nw:__tostring()
	return ("[Networkable][%d][`%s`]"):format(self.NumberID or -1, self.NetworkableID or "[no ID]")
end

function nw:SetNetworkableID(id, replace)
	self.NetworkableID = id

	local before = cache[id]

	if cache[id] and cache[id] ~= self and not replace then
		errorf("This isn't supposed to happen -- setting NWID with a networkable already existing! NWID: %s", id)
		return
	end
	cache[id] = self

	printf("SetNetworkableID called %s %s %s", Realm(true, true), id, idData[id])

	if CLIENT and idData[id] then
		printf("stashed data for %s existed; merging", id)
		for k, v in pairs(idData[id]) do
			if self.__Aliases[k] then k = self.__Aliases[k] end
			printf("pulling cached change: %s = %s", k, v)
			self:Set(k, v)
		end
	end

	if SERVER then
		self:_SVSetNWID(id, replace)
	end

	return self
end

function nw:SetNetworkableNumberID(numid)
	assert(self.NetworkableID, "Networkable must have an ID before setting a number ID!")

	numToID[numid] = self.NetworkableID
	IDToNum[self.NetworkableID] = numid

	self.NumberID = numid
end

function nw:IsValid()
	return self.Valid ~= false
end

function nw:_ValidateNW(k, v)
	assert(self.Valid, "Attempted to set a networked var on an invalid Networkable!")
	assert(self.NetworkableID, "Networkable must have an ID!")

	if not _NetworkableCache[self.NetworkableID] then
		printf("didn't find self with nwid?... %s", self.NetworkableID)
		self:SetNetworkableID(self.NetworkableID)
	end -- maybe resetall happened

end

function nw:SetTable(k, v)
	self:_ValidateNW(k, v)

	if not istable(v) then
		errorf("Calling SetTable on a non-table value! (%s = %s `%s`)", k, v, type(v))
		return
	end

	if v.__isobject then
		errorf("Calling SetTable on an object! (%s = %s `%s`)", k, v, type(v))
		return
	end

	if SERVER then
		self:_SVSetTable(k, v)
	end

	return self:Set(k, v)
end

function nw:Set(k, v)
	-- if you're using a table or an object as `v`, it's assumed you have a custom encoder for it
	-- if you don't, well, expect issues...
	self:_ValidateNW(k, v)

	if CLIENT then -- don't bother
		self.Networked[k] = v
		return self
	end

	if self.Networked[k] == v and not istable(v) then --[[adios]] return end

	self.Networked[k] = v

	if v == nil then v = fakeNil end
	_NetworkableChanges:Set(v, self.NetworkableID, k)
	return self
end

function nw:Get(k, default)
	--if self.__Aliases[k] ~= nil then k = self.__Aliases[k] end

	local ret = self.Networked[k]
	if ret == fakeNil then return nil end
	if ret == nil then return default end

	return ret
end

function nw:Alias(k, k2)
	if self.__Aliases[k] then
		self.__AliasesBack[k2] = nil
	end

	self.__Aliases[k] = k2
	self.__AliasesBack[k2] = k
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
		self:_SVBroadcastInvalidate()
	end

end


function nw:Bind(what)

	if IsPlayer(what) then
		local origUID = what:UserID()

		gameevent.Listen("player_disconnect")
		hook.OnceRet("player_disconnect", ("Networkable.Bind:%p"):format(what), function(data)
			local uid = data.userid
			if uid ~= origUID then return false end

			self:Invalidate()
		end)
	elseif isentity(what) then

		hook.OnceRet("EntityRemoved", ("Networkable.Bind:%p"):format(what), function(ent)
			if ent ~= what then return false end

			if CLIENT then
				timer.Simple(0.1, function()
					if IsValid(ent) then self:Bind(ent) return end --fullupdates :v
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
nw.Bond = nw.Bind


if CLIENT then
	include("networkable_cl_ext.lua")
else
	include("networkable_sv_ext.lua")
end