ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
	self._Initialized = true
	self:SetSolid(SOLID_BBOX)
	self:SetTrigger(true)

	if self.Zone and self.Zone:IsValid() then
		self:UpdateZone(self.Zone)
	end
end

function ENT:UpdateZone(zone)
	-- note: the zone has no information about its' base at this point
	self.Zone = zone

	if not self._Initialized then return end -- :Initialize() will run this

	-- whether this is necessary is questionable
	local mins, maxs = zone:GetBounds()

	local mid = (mins + maxs)
	mid:Div(2)

	self:SetPos(mid)
	self:SetCollisionBoundsWS(mins, maxs)
end

function ENT:SetZone(zone)
	CheckArg(1, zone, BaseWars.Bases.IsZone, "zone")
	self:UpdateZone(zone)
	
	zone:On("BoundsChanged", self, function()
		self:UpdateZone(zone)
	end)
end

function ENT:GetZone()
	return self.Zone
end

function ENT:GetBase()
	return self.Zone:GetBase()
end

function ENT:StartTouch(what)
	self.Zone:_EntityEntered(self, what)
	self.Zone:Emit("EntityEntered", self, what)
end

function ENT:EndTouch(what)
	self.Zone:_EntityExited(self, what)
	self.Zone:Emit("EntityExited", self, what)
end