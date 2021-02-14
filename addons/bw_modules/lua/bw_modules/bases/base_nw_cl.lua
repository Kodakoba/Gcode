local bw = BaseWars.Bases

local zNW = bw.NW.Zones
local bNW = bw.NW.Bases
local adNW = bw.NW.Admin

local nw = bw.NW

nw.SZ = {
	base = 12,
	zone = 12
}

local bIDSZ = nw.SZ.base
local zIDSZ = nw.SZ.zone

zNW:On("CustomReadChanges", "DecodeZones", function(self)
	self.Networked.Zones = self.Networked.Zones or {}

	local amtChanges = net.ReadUInt(16)

	for i=1, amtChanges do
		local zID = net.ReadUInt(zIDSZ)
		local mins, maxs = net.ReadVector(), net.ReadVector()
		local name = net.ReadCompressedString(bw.MaxZoneNameLength)
		
		self.Networked.Zones[zID] = bw.Zone(zID, mins, maxs)
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

function bw:RequestCreation(name)
	net.Start("BWBases")
		net.WriteUInt(nw.BASE_NEW, 2)
		local pr = net.StartPromise()
		net.WriteString(name)
	net.SendToServer()

	return pr
end

net.Receive("BWBases", function()
	net.ReadPromise()
end)