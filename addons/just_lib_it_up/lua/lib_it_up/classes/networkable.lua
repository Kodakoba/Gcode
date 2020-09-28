setfenv(0, _G)

if not muldim then include("multidim.lua") end

--[[
	Emits:
		"NetworkedChanged" : `changes` table
								[changed_key] = {old_val, new_val}

		"NetworkedVarChanged" : key, old_val, new_val
]]


Networkable = Networkable or Emitter:callable()
local nw = Networkable

local update_freq = 0.3

_NetworkableCache = _NetworkableCache or {}-- _NetworkableCache or {}

_NetworkableNumberToID = _NetworkableNumberToID or {} --[num] = name
_NetworkableIDToNumber = _NetworkableIDToNumber or {} --[name] = num

_NetworkableChanges = _NetworkableChanges or muldim:new()-- _NetworkableChanges or muldim:new()

_NetworkableAwareness = _NetworkableAwareness or muldim:new() --[ply] = {'ID', 'ID'} , not numberids

Networkable.Verbose = true

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

local encoderIDLength = 5 --5 bits fit 16 (0-15) encoders

-- make sure you up encoderIDLength if you go above encoder ID of 15
local ns = netstack:new()
-- write hijacked versions of net.*

ns:Hijack(true)

local _vONCache = {}

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

	--7, 8, 9, 10 are used!!!!!! do not use them!
}
ns:Hijack(false)

local decoders = {
	["string"] = {0, net.ReadString},
	["entity"] = {1, net.ReadEntity},
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
	["int"] = {8, net.ReadInt},
	["float"] = {9, net.ReadFloat, 32},
	["nil"] = {10, BlankFunc}
}

local decoderByID = {}

for typ,v in pairs(decoders) do
	decoderByID[v[1]] = v
end

local NetworkAll --pre-definition

local function determineEncoder(typ, val)
	if val == fakeNil then --lol
		return BlankFunc, 10
	end

	if typ == "number" then --numbers are a bit more complicated
		if math.ceil(val) == val then
			if val >= 0 then return net.WriteUInt, 7, 32
			else return net.WriteInt, 8, 32 end
		else
			return net.WriteFloat, 9
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
	self.LastSerialized = {} -- purely for networked tables

	self:On("ShouldEncode", "TablesvONCheck", function(self, k, v)
		if istable(v) then
			local vonData = von.serialize(v)
			if self.LastSerialized[k] == vonData then return end
			_vONCache[k] = vonData
		end
	end)

	if self.__instance ~= nw then 	-- extension of Networkable; let's try to set the meta to it
		if cache[id] then			-- in case we received nw data before the object was constructed
			setmetatable(cache[id], self.__instance)
			self:ChangeInitArgs(cache[id], id, ...) --eheheh
		end
	end

	if not rawget(self.__instance, "AutoAssignID") then return end 	-- if this object is constructed from an Networkable extension,
																	-- ignore the fact we don't have an ID

	if not id then error("Networkable creation requires an ID!") return end

	if cache[id] then return cache[id] end

	self:SetNetworkableID(id)
end

function nw:SetNetworkableID(id)

	self.NetworkableID = id

	if cache[id] then
		for k,v in pairs(cache[id]) do --basically copy
			self[k] = v
		end
		return setmetatable(cache[id], getmetatable(self))
	end

	local typ = type(id):lower()

	local encoder, encoderID, additionalArg = determineEncoder(typ, id)

	self.NetworkableIDEncoder = {
		Func = encoder, --function which will encode the ID
		ID = encoderID, --ID of the encoder function so the client knows how to figure it out
		IDArg = additionalArg, --additional arg for the encoder function, for cases like UInt and whatnot which require a second arg
	}

	if SERVER then
		local key = #numToID + 1
		numToID[key] = id
		IDToNum[id] = key
		self.NumberID = key
	end

	cache[id] = self

	return self
end

function nw:Set(k, v)
	if self.Valid == false then return end

	if not self.NetworkableID then
		error("Set a NetworkableID first!")
		return
	end

	if v == nil then v = fakeNil end --lul
	if self.Networked[k] == v and not istable(v) then --[[adios]] return end

	if istable(v) then --we have to check if tables are exact
		local last_von = self.LastSerialized[v]
		local new_von = von.serialize(v)

		if last_von == new_von then --[[ adios ]] return end

		self.LastSerialized[v] = new_von
	end

	self.Networked[k] = v
	_NetworkableChanges:Set(v, self.NetworkableID, k)
	return self
end

function nw:Get(k, default)
	local ret = self.Networked[k]
	if ret == nil then return default end

	return ret
end

function nw:GetNetworked() --shrug
	return self.Networked
end

function nw:Invalidate()
	self.Valid = false

	cache[self.NetworkableID] = nil

	if self.NumberID and numToID[self.NumberID] == self.NetworkableID then numToID[self.NumberID] = nil end

	IDToNum[self.NetworkableID] = nil
	_NetworkableChanges[self.NetworkableID] = nil

	for ply, ids in pairs(_NetworkableAwareness) do
		ids[self.NetworkableID] = nil
	end

end


function nw:Bond(what)
	if not self.NetworkableID then error("Assign an ID first!") return end

	if isentity(what) then
		hook.OnceRet("EntityRemoved", ("Networkable.Bond:%p"):format(what), function(ent)
			if ent ~= what then return false end

			if CLIENT then
				timer.Simple(0.1, function()
					if IsValid(self) then print("Disregard...?") self:Bond(self) return end --fullupdates :v
					self:Invalidate()
				end)
			else
				self:Invalidate()
			end

		end)
	end

	return self
end


local function IDToNumber(id)
	return IDToNum[id]
end

if SERVER then

	local function WriteIDPair(i)

		local name = numToID[i]
		local obj = cache[name]

		if not obj then
			realPrintf("Failed obtaining networkable object serverside: ID %d; name %s", i, name)
		end

		net.WriteUInt(i, 24)
		net.WriteUInt(obj.NetworkableIDEncoder.ID, encoderIDLength)

		obj.NetworkableIDEncoder.Func(name, obj.NetworkableIDEncoder.IDArg)
	end

	local function WriteChange(key, val)
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

		op = net.WriteUInt(v_encoderID, encoderIDLength)
		v_encoder(val, v_additionalArg, key)

		if net.ActiveNetstack then
			op.Description = "Changed value encoder ID"
		end
	end

	util.AddNetworkString("NetworkableSync")


	-- this networks to ALL PLAYERS!

	--[[local]] function NetworkAll()
		if not next(_NetworkableChanges) then return end

		local everyone = player.GetAll()

		local changes_count = 0


		-- count networkables someone might not know about

		local newids = {--[[ [seq_id] = name ]]}
		local added = {--[[ [name] = true ]]}

		for _, ply in ipairs(everyone) do
			for numID, nameID in pairs(numToID) do
				if added[nameID] then continue end

				if not _NetworkableAwareness[ply] or not _NetworkableAwareness[ply][nameID] then
					local obj = _NetworkableCache[nameID]
					if obj.Filter then continue end

					newids[#newids + 1] = numID
					_NetworkableAwareness:Set(true, ply, nameID)
					added[nameID] = true
				end
			end
		end

		-- store their awareness
		for id, v in pairs(_NetworkableChanges) do
			-- if an obj has a filter it gets removed from all-player-broadcasting
			local obj = cache[id]

			if not obj.Filter then
				changes_count = changes_count + 1
				for k, ply in ipairs(everyone) do
					local arr = _NetworkableAwareness:GetOrSet(ply)
					arr[obj.NetworkableID] = true
				end
			end
		end

		if #newids == 0 and changes_count == 0 then return end

		local nw = netstack:new()

		net.Start("NetworkableSync")
			local ns = netstack:new()
			ns:Hijack()

			net.WriteUInt(#newids, 16)
			for i=1, #newids do
				WriteIDPair(newids[i])
			end

			net.WriteUInt(changes_count, 8).Description = "Changed objects count" --amount of changed networkable objects
			local changedCountID = #ns.Ops
			local changed = 0

			local bits = select(2, net.BytesWritten())

			for id, changes in pairs(_NetworkableChanges) do
				local obj = cache[id]
				if obj.Filter then continue end --nyope

				changed = changed + 1
				net.WriteUInt(IDToNumber(id), 24).Description = "IDToNumber"

				local changesAmt = 0
				local writeChanges = {}

				for k,v in pairs(changes) do
					local should = obj:Emit("ShouldEncode", k, v) 	-- this should mostly be used for equality checks
					if should == false then continue end 			-- keep in mind that if you return false the change will be lost to networking

					changesAmt = changesAmt + 1

					writeChanges[k] = v
				end

				net.WriteUInt(changesAmt, 8).Description = "Amount of changes in an object" --amount of changed values in the Networkable object

				for k,v in pairs(writeChanges) do
					WriteChange(k, v)
				end

				_NetworkableChanges[id] = nil

				local cur_written = select(2, ns:BytesWritten())
										--16 kb
				if bits + cur_written > 16*1024*8 then
					printf("too much written; halting for this network frame @ %d/%d", changed, changes_count)
					break
				end
			end

			ns:Hijack(false)

			ns.Ops[changedCountID].args[1] = changed --this is the changes_count, change it to `changed` in case we broke out of the loop early
			--print("sent:", ns)
			net.WriteNetStack(ns)

		net.Send(player.GetAll())
	end

	local nwAll = function()
		local ok, err = pcall(NetworkAll)
		if not ok then
			realPrint("NetworkableNetwork Error:", err)
		end
	end

	timer.Create("NetworkableNetwork", update_freq, 0, nwAll)

	hook.Add("PlayerFullyLoaded", "NetworkableUpdate", nwAll)


	function nw:Network(now) 	--networks everything in the next tick (or right now if `now` is true OR networkable has a filter)

		if not self.Filter then
			if not now then
				timer.Adjust("NetworkableNetwork", 0, 0, function()
					nwAll()
					timer.Adjust("NetworkableNetwork", update_freq, 0, nwAll)
				end)
			else
				nwAll()
			end
		else
			if not _NetworkableChanges[self.NetworkableID] then return end

			local anyone_missing = false
			local nw = {}

			for k, ply in ipairs(player.GetAll()) do
				if self:Filter(ply) ~= false then
					nw[#nw + 1] = ply
					print("networking to", ply)
				else
					print("not networking to", ply)
				end
			end

			for k, ply in ipairs(nw) do
				if not _NetworkableAwareness[ply] or not _NetworkableAwareness[ply][self.NetworkableID] then anyone_missing = true break end --awh
			end

			net.Start("NetworkableSync")
				net.WriteUInt(anyone_missing and 1 or 0, 16) --don't write yourself if everyone knows
				if anyone_missing then
					WriteIDPair(self.NumberID, true)
				end

				net.WriteUInt(1, 8) --amount of changed networkable objects (just self)
				net.WriteUInt(IDToNumber(self.NetworkableID), 24) -- self's NetworkableID
				net.WriteUInt(table.Count(_NetworkableChanges[self.NetworkableID]), 8) -- amt of changes in self

				for k,v in pairs(_NetworkableChanges[self.NetworkableID]) do 
					WriteChange(k, v)
				end

				_NetworkableChanges[self.NetworkableID] = nil

			net.Send(nw)
		end
	end

end

if CLIENT then

	local function ReadIDPair(i)
		local num = net.ReadUInt(24)
		local enc_id = net.ReadUInt(encoderIDLength)

		local dec = decoderByID[enc_id]
		local name = dec[2](dec[3])

		return num, name
	end

	local function ReadChange()
		local k_encID = net.ReadUInt(encoderIDLength)

		local k_dec = decoderByID[k_encID]

		if not k_dec then
			print("	failed to read k_dec", k_dec, k_encID)
		end

		local decoded_key = k_dec[2](k_dec[3])

		local v_encID = net.ReadUInt(encoderIDLength)

		local v_dec = decoderByID[v_encID]
		local decoded_val = v_dec[2](v_dec[3])

		print("	decoded key, val:", decoded_key, decoded_val)
		return decoded_key, decoded_val
	end

	net.Receive("NetworkableSync", function(len)
		print("received networkable sync: length", len/8, "bytes")
		-- read new numid:id pairs
		local new_ids = net.ReadUInt(16)
		print("reading", new_ids, "new pairs")

		for i=1, new_ids do
			local num_id, id = ReadIDPair(i)
			printf("	new pair: %d = %s", num_id, id)
			if not cache[id] then --that object doesn't exist clientside; create it ahead of time
				cache[id] = Networkable(id)
			end
			numToID[num_id] = id
		end

		--read networkable changes
		local changes = net.ReadUInt(8) --how many networkable objects were changed
		print("reading", changes, " changes")
		for i=1, changes do
			local num_id = net.ReadUInt(24)			--numberID of the networkable object
			local changed_keys = net.ReadUInt(8)	--amt of changed keys

			local obj = cache[numToID[num_id]]
			local changes = {}

			printf("	amt of changed keys for %s(id: %d): %d", obj, num_id, changed_keys)

			for key_i = 1, changed_keys do
				printf("	reading change #%d", key_i)
				local k, v = ReadChange()
				if obj then		-- [1] = old, [2] = new
					changes[k] = {obj.Networked[k], v}
					obj.Networked[k] = v
					obj:Emit("NetworkedVarChanged", k, changes[k][1], v) -- key, old, new
				end
			end

			print("	ID of obj:", numToID[num_id], num_id)
			if obj then
				obj.NumberID = num_id
				obj:Emit("NetworkedChanged", changes)
			end
		end
	end)
end