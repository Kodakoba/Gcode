local bw = BaseWars.Bases
local nw = bw.NW

--[[-------------------------------------------------------------------------
	Basezone modify requests
---------------------------------------------------------------------------]]

function bw.RequestBaseCoreCreation(baseid)
	net.Start("BWBases")
		net.WriteUInt(nw.BASE_CORENEW, 4)
		local pr = net.StartPromise()
		net.WriteUInt(baseid, nw.SZ.base)
	net.SendToServer()

	return pr
end

function bw.RequestBaseCoreSave(baseid, eid)
	net.Start("BWBases")
		net.WriteUInt(nw.BASE_CORESAVE, 4)
		local pr = net.StartPromise()
		net.WriteUInt(baseid, nw.SZ.base)
		net.WriteUInt(eid, 16)
	net.SendToServer()

	return pr
end

function bw.RequestBaseCreation(name)
	net.Start("BWBases")
		net.WriteUInt(nw.BASE_NEW, 4)
		local pr = net.StartPromise()
		net.WriteString(name)
	net.SendToServer()

	return pr
end

function bw.RequestZoneYeet(zoneID)
	net.Start("BWBases")
		net.WriteUInt(nw.ZONE_YEET, 4)
		local pr = net.StartPromise()
		net.WriteUInt(zoneID, nw.SZ.zone)
	net.SendToServer()

	return pr
end

function bw.RequestBaseYeet(baseID)
	net.Start("BWBases")
		net.WriteUInt(nw.BASE_YEET, 4)
		local pr = net.StartPromise()
		net.WriteUInt(baseID, nw.SZ.base)
	net.SendToServer()

	return pr
end

function bw.RequestZoneCreation(name, baseID, mins, maxs)
	net.Start("BWBases")
		net.WriteUInt(nw.ZONE_NEW, 4)
		local pr = net.StartPromise()
		net.WriteUInt(baseID, nw.SZ.base)
		net.WriteString(name)
		net.WriteVector(mins)
		net.WriteVector(maxs)
	net.SendToServer()

	return pr
end

function bw.RequestZoneEdit(id, name, mins, maxs)
	if not id or not name or not mins or not maxs then
		errorf("missing argument #%d", (not id and 1) or (not name and 2) or (not mins and 3) or (not maxs and 4))
		return
	end

	net.Start("BWBases")
		net.WriteUInt(nw.ZONE_EDIT, 4)
		local pr = net.StartPromise()
		net.WriteUInt(id, nw.SZ.zone)
		net.WriteString(name)
		net.WriteVector(mins)
		net.WriteVector(maxs)
	net.SendToServer()

	return pr
end

function bw.RequestBaseEdit(id, name)
	if not id or not name then
		errorf("missing argument #%d", (not id and 1) or (not name and 2) or (not mins and 3) or (not maxs and 4))
		return
	end

	net.Start("BWBases")
		net.WriteUInt(nw.BASE_EDIT, 4)
		local pr = net.StartPromise()
		net.WriteUInt(id, nw.SZ.base)
		net.WriteString(name)
	net.SendToServer()

	return pr
end

net.Receive("BWBases", function()
	net.ReadPromise()
end)