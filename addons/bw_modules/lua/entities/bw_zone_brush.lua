ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
	self:SetSolid(SOLID_BBOX)
end

function ENT:SetZone(zone)
	CheckArg(1, zone, BaseWars.Bases.IsZone, "zone")

	-- note: the zone has no information about its' base at this point
	self.Zone = zone

	self:SetCollisionBoundsWS(zone:GetBounds())

	-- whether this is necessary is questionable
	local mins, maxs = zone:GetBounds()
	local mid = (mins + maxs) / 2
	self:SetPos(mid)
end

function ENT:GetZone()
	return self.Zone
end

function ENT:GetBase()
	return self.Zone:GetBase()
end