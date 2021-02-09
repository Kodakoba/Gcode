local bw = BaseWars

local zNW = bw.Bases.NWZones
local bNW = bw.Bases.NWBases


zNW:On("CustomWriteChanges", "EncodeZones", function(self, changes)
	local write = {}

	net.WriteUInt(table.Count(changes), 16)
	for zID, zone in pairs(changes) do
		net.WriteUInt(zID, 12)
		net.WriteVector(zone.Mins)
		net.WriteVector(zone.Maxs)
	end

	return true
end)

bNW:On("CustomWriteChanges", "EncodeZones", function(self, changes)
	local write = {}

	net.WriteUInt(table.Count(changes), 16)
	for bNW, base in pairs(changes) do
		net.WriteUInt(base:GetID(), 12)
		
		net.WriteUInt(#base:GetZones(), 8)
		for k,v in ipairs(base:GetZones()) do
			net.WriteUInt(v:GetID(), 12)
		end
	end

	return true
end)