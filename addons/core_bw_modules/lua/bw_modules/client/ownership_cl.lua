
local eidToOwner = BaseWars.Ents.EIDToOwner or {}
BaseWars.Ents.EIDToOwner = eidToOwner

function BaseWars.Ents.AssignOwner(eid, sid)
	if IsEntity(eid) then eid = eid:EntIndex() end
	if IsPlayer(sid) then sid = sid:SteamID() end

	assert(isnumber(eid))
	assert(isstring(sid))

	eidToOwner[eid] = sid

	local ent = EventualEntity(eid):Then(function()
		hook.Run("EntityOwnershipChanged",
			player.GetBySteamID(sid), Entity(eid))
	end)
end

function BaseWars.Ents.UnassignOwner(eid)
	if IsEntity(eid) then eid = eid:EntIndex() end
	assert(isnumber(eid))

	eidToOwner[eid] = nil
end

function BaseWars.Ents.EntityToSteamID(eid)
	if IsEntity(eid) then eid = eid:EntIndex() end
	assert(isnumber(eid))

	return eidToOwner[eid]
end

hook.Add("EntityActuallyRemoved", "BW_OwnershipYeet", function(ent, tbl, eid)
	BaseWars.Ents.UnassignOwner(eid)
end)

net.Receive("BW_OwnershipChange", function()
	local eid, sid = net.ReadUInt(16), net.ReadSteamID()
	BaseWars.Ents.AssignOwner(eid, sid)
end)

net.Receive("BW_OwnershipChange_Mass", function()
	local sids = net.ReadUInt(16)

	for i=1, sids do
		local sid = net.ReadSteamID()
		local entCnt = net.ReadUInt(16)
		for e = 1, entCnt do
			local eid = net.ReadUInt(16)
			BaseWars.Ents.AssignOwner(eid, sid)
		end
	end
end)