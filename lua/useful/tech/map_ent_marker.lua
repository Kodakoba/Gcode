-- touch:
-- must be consistent across realms
local CreationIDToMapName = {
	[374] = "Some map prop",
	[375] = "Some map prop",

	[2622] = "Some map door",
}

-- dont touch:
local id2num, num2id = {}, {}
for k,v in SortedPairs(CreationIDToMapName) do
	local k = #num2id + 1
	num2id[k] = v
	id2num[v] = k
end

if SERVER then
	util.AddNetworkString("network_mapents")

	local function networkAll(recip)
		local all_ents = ents.GetAll()
		local to_nw = {}

		for k,v in ipairs(all_ents) do
			if CreationIDToMapName[ v:GetCreationID() ] then
				local id = CreationIDToMapName[ v:GetCreationID() ]
				local numid = id2num[id]
				local eid = v:EntIndex()

				to_nw[#to_nw + 1] = {eid, numid}
			end
		end

		net.Start("network_mapents")
			net.WriteUInt(#to_nw, 12)
			for k,v in ipairs(to_nw) do
				net.WriteUInt(v[1], 12)
				net.WriteUInt(v[2], 12)
			end
		net.Send(recip)
	end

	-- THIS ISN'T A GMOD HOOK; I ASSUME YOU HAVE A HOOK FOR WHEN A CLIENT CAN RECEIVE NETS
	hook.Add("PlayerReadyForNetworking", "NetworkMapIDs", function(ply)
		networkAll(ply)
	end)

	networkAll(player.GetAll()) -- autorefresh
else

	local ent2id = {}
	local id2ent = {}

	local eid2num = {}

	local function addEnt(ent, isin)
		if not isin then return end
		if not eid2num[ent:EntIndex()] then return end
		local id = num2id[ eid2num[ent:EntIndex()] ]
		ent2id[ent] = id

		id2ent[id] = id2ent[id] or {}
		id2ent[id][#id2ent[id] + 1] = ent
	end

	local function refreshEnts()
		for k,v in ipairs(ents.GetAll()) do
			addEnt(v, true)
		end
	end

	local function remEnt(ent)
		if not eid2num[ent:EntIndex()] then return end
		local id = num2id[ eid2num[ent:EntIndex()] ]
		ent2id[ent] = nil

		id2ent[id] = id2ent[id] or {}
		table.RemoveByValue(id2ent[id], ent)
	end

	net.Receive("network_mapents", function()
		local to = net.ReadUInt(12)

		for i=1, to do
			local eid = net.ReadUInt(12)
			eid2num[eid] = net.ReadUInt(12)
		end

		refreshEnts()
	end)


	hook.Add("NotifyShouldTransmit", "MapEntsToID", addEnt)
	hook.Add("EntityRemoved", "MapEntsCleanup", remEnt)
	refreshEnts()

	local ENTITY = FindMetaTable("Entity")

	function ENTITY:GetMapID()
		return ent2id[self]
	end

	function ENTITY:IsMapID(id)
		return ent2id[self] == id
	end

	function ents.GetByMapID(id)
		if not id2ent[id] then return {} end

		local cpy = {}
		for k,v in ipairs(id2ent[id]) do
			cpy[k] = v
		end

		return cpy
	end
end