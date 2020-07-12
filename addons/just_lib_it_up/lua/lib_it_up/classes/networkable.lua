setfenv(0, _G)

if not muldim then include("multidim.lua") end

Networkable = Emitter:callable()
local nw = Networkable

local update_freq = 0.3

_NetworkableCache = _NetworkableCache or {}-- _NetworkableCache or {}

_NetworkableNumberToID = _NetworkableNumberToID or {} --[num] = name
_NetworkableIDToNumber = _NetworkableIDToNumber or {} --[name] = num

_NetworkableLastNetworkedIDs = 0		--how many NumberToID pairs existed when it was last networked

_NetworkableChanges = muldim:new()-- _NetworkableChanges or muldim:new()

local cache = _NetworkableCache

local numToID = _NetworkableNumberToID
local IDToNum = _NetworkableIDToNumber

local encoderIDLength = 5 --5 bits fit 16 (0-15) encoders

-- make sure you up encoderIDLength if you go above encoder ID of 15

local encoders = {
	["string"] = {0, net.WriteString},
	["entity"] = {1, net.WriteEntity},
	["vector"] = {2, net.WriteVector},

	["table"] = {3, function(t)
		--if t.Networkable_Encoder then return t:Networkable_Encoder() end

		local vonned = von.serialize(t)
		print("serialized into", vonned, #vonned)
		net.WriteUInt(#vonned, 16)
		net.WriteData(vonned, #vonned)
	end},

	["boolean"] = {4, net.WriteBool},	--please don't use bools as keys for ID's lmao
	["angle"] = {5, net.WriteAngle},
	["color"] = {6, net.WriteColor},

	--7, 8, 9 are used!!!!!! do not use them!
}

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
	["float"] = {8, net.ReadFloat},
	["int"] = {9, net.ReadInt, 32},
}

local decoderByID = {}

for typ,v in pairs(decoders) do
	decoderByID[v[1]] = v
end



local function determineEncoder(typ, val)
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
	if not enc then errorf("Failed to find Encoder function for type %s!", typ) return end

	return enc[2], enc[1], enc[3]
end

function nw:Initialize(id)
	if not id then error("Networkable creation requires an ID!") return end
	if _NetworkableCache[id] then return _NetworkableCache[id] end

	self.ID = id
	self.Networked = {}

	local typ = type(id):lower()

	local encoder, encoderID, additionalArg = determineEncoder(typ, id)

	self.IDEncoder = {
		Func = encoder, --function which will encode the ID
		ID = encoderID, --ID of the encoder function so the client knows how to figure it out
		IDArg = additionalArg, --additional arg for the encoder function, for cases like UInt and whatnot which require a second arg
	}

	if SERVER then
		numToID[#numToID + 1] = id
		IDToNum[id] = #numToID
	end
	--self.NumberID = nil

	_NetworkableCache[id] = self
end


function nw:Set(k, v)
	if self.Networked[k] == v then print("no not doing") return end

	self.Networked[k] = v
	_NetworkableChanges:Set(v, self.ID, k)
end

local function IDToNumber(id)
	return IDToNum[id]
end

if SERVER then

	local function WriteIDPair(i)
		local num = #numToID - (i - 1)
		local name = numToID[num]
		local obj = cache[name]
		print(name, cache[name])
		--[[print("IDEncoder:", obj.IDEncoder.IDArg)
		PrintTable(obj.IDEncoder)]]

		net.WriteUInt(num, 24)
		net.WriteUInt(obj.IDEncoder.ID, encoderIDLength)
		obj.IDEncoder.Func(name, obj.IDEncoder.IDArg)
	end

	local function WriteChange(key, val)
		local key_typ = type(key):lower()
		local val_typ = type(val):lower()

		local k_encoder, k_encoderID, k_additionalArg = determineEncoder(key_typ, key)
		local v_encoder, v_encoderID, v_additionalArg = determineEncoder(val_typ, val)

		-- write key encoderID and the encoded key
		net.WriteUInt(k_encoderID, encoderIDLength)
		k_encoder(key, k_additionalArg)

		-- write val encoderID and the encoded val

		net.WriteUInt(v_encoderID, encoderIDLength)
		v_encoder(val, v_additionalArg)

	end

	util.AddNetworkString("NetworkableSync")

	timer.Create("NetworkableNetwork", update_freq, 0, function()
		if not next(_NetworkableChanges) then return end

		local changes_count = table.Count(_NetworkableChanges)
		local newid_count = #numToID - _NetworkableLastNetworkedIDs
		_NetworkableLastNetworkedIDs = #numToID
		local nw = netstack:new()

		print("networking")
		net.Start("NetworkableSync")
			net.WriteUInt(newid_count, 16)
			for i=1, newid_count do
				WriteIDPair(i)
			end

			local ns = netstack:new()
			ns:Hijack()

			net.WriteUInt(changes_count, 16) --amount of changed networkable objects
			local changed = 0

			local bits = select(2, net.BytesWritten())

			for id, changes in pairs(_NetworkableChanges) do
				changed = changed + 1
				net.WriteUInt(IDToNumber(id), 24)
				net.WriteUInt(table.Count(changes), 16) --amount of changed values in the Networkable object

				for k,v in pairs(changes) do
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

			ns.Ops[1].args[1] = changed --this is the changes_count, change it to `changed` in case we broke out of the loop early

			_AAA = ns
			net.WriteNetStack(ns)

		net.Send(player.GetAll())
	end)

	hook.Add("PlayerFullyLoaded", "NetworkableUpdate", function(ply)

		net.Start("NetworkableSync")
			net.WriteUInt(#_NetworkableNumberToID, 16)
			for i=1, #_NetworkableNumberToID do
				WriteIDPair(i)
			end

			net.WriteUInt(#_NetworkableNumberToID, 16) --amount of networkable objects in total

			for id, obj in pairs(_NetworkableCache) do
				net.WriteUInt(IDToNumber(id), 24)
				net.WriteUInt(table.Count(obj.Networked), 16) --amount of changed values in the Networkable object

				for k,v in pairs(obj.Networked) do
					WriteChange(k, v)
				end
			end

		net.Send(ply)

	end)

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
		local decoded_key = k_dec[2](k_dec[3])

		local v_encID = net.ReadUInt(encoderIDLength)
		local v_dec = decoderByID[v_encID]
		local decoded_val = v_dec[2](v_dec[3])

		return decoded_key, decoded_val
	end

	net.Receive("NetworkableSync", function(len)
		print("received networkable sync: length", len/8, "bytes")
		-- read new numid:id pairs
		local new_ids = net.ReadUInt(16)
		for i=1, new_ids do
			local num_id, id = ReadIDPair(i)

			if not _NetworkableCache[id] then --that object doesn't exist clientside; create it ahead of time
				_NetworkableCache[id] = Networkable(id)
			end

			numToID[num_id] = id
		end

		--read networkable changes
		local changes = net.ReadUInt(16)
		for i=1, changes do
			local num_id = net.ReadUInt(24)
			local changed_keys = net.ReadUInt(16)

			local obj = _NetworkableCache[numToID[num_id]]

			for key_i = 1, changed_keys do
				local k,v = ReadChange()
				if obj then obj.Networked[k] = v end
			end

			if obj then obj:Emit("Changed") end
		end
	end)
end