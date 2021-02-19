local bw = BaseWars.Bases

local zNW = bw.NW.Zones
local bNW = bw.NW.Bases

local nw = bw.NW

local bIDSZ = nw.SZ.base
local zIDSZ = nw.SZ.zone

zNW:On("CustomReadChanges", "DecodeZones", function(self)
	self.Networked.Zones = self.Networked.Zones or {}

	local amtChanges = net.ReadUInt(16)

	for i=1, amtChanges do
		local zID = net.ReadUInt(zIDSZ)
		local mins, maxs = net.ReadVector(), net.ReadVector()
		local name = net.ReadCompressedString(bw.MaxZoneNameLength)


		local zone = bw.GetZone(zID) or bw.Zone(zID, mins, maxs) -- don't recreate a zone if we knew about it; just update it instead
		self.Networked.Zones[zID] = zone

		zone:SetName(name)
		zone:SetBounds(mins, maxs)
	end

	zNW:Emit("ReadZones", self.Networked.Zones)
	bw:Emit("ReadZones")
	return true
end)

bNW:On("CustomReadChanges", "DecodeBases", function(self)
	local new = {}

	local amtChanges = net.ReadUInt(16)

	for i=1, amtChanges do
		local bID = net.ReadUInt(bIDSZ)
		local base = bw.Base(bID)

		base:ReadNetwork()
		new[bID] = base
		self.Networked[bID] = base
	end

	bw:Emit("ReadBases", new)

	return true
end)

function bw.RequestBaseCreation(name)
	net.Start("BWBases")
		net.WriteUInt(nw.BASE_NEW, 4)
		local pr = net.StartPromise()
		net.WriteString(name)
	net.SendToServer()

	return pr
end

function bw.RequestZoneCreation(name, baseID)
	net.Start("BWBases")
		net.WriteUInt(nw.ZONE_NEW, 4)
		local pr = net.StartPromise()
		net.WriteUInt(baseID, nw.SZ.base)
		net.WriteString(name)
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

net.Receive("BWBases", function()
	net.ReadPromise()
end)