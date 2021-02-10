local bw = BaseWars

local zNW = bw.Bases.NWZones
local bNW = bw.Bases.NWBases
local adNW = bw.Bases.NWAdmin

zNW:On("CustomReadChanges", "DecodeZones", function(self)
	self.Networked.Zones = self.Networked.Zones or {}

	local amtChanges = net.ReadUInt(16)

	for i=1, amtChanges do
		local zID = net.ReadUInt(12)
		local mins, maxs = net.ReadVector(), net.ReadVector()
		self.Networked.Zones[zID] = bw.Zone(zID, mins, maxs)
	end

	zNW:Emit("ReadZones", self.Networked.Zones)
	return true
end)

bNW:On("CustomReadChanges", "DecodeBases", function(self)

	local amtChanges = net.ReadUInt(16)
	
	for i=1, amtChanges do
		local bID = net.ReadUInt(12)
		local base = bw.Base(bID)
		base:ReadNetwork()

		self.Networked[bID] = base
	end

	return true
end)