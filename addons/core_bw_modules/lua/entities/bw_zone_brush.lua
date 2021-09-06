ENT.Base = "base_brush"
ENT.Type = "brush"
ENT.IsZoneBrush = true

function ENT:Initialize()
	self._Initialized = true
	self:SetSolid(SOLID_BBOX)
	self:SetTrigger(true)

	if self.Zone and self.Zone:IsValid() then
		self:UpdateZone(self.Zone)
	end

	self.MolestedEnts = {}
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
	if not self.Zone:IsValid() then self:Remove() return end

	-- the _Entity* is defined in the tracker
	self.Zone:_EntityEntered(self, what)
	self.Zone:Emit("EntityEntered", self, what)
	self.MolestedEnts[what] = true
end

function ENT:EndTouch(what)
	self.Zone:_EntityExited(self, what)
	self.Zone:Emit("EntityExited", self, what)
	self.MolestedEnts[what] = nil

	if not self.Zone:IsValid() then self:Remove() return end
end

function ENT:ForceScanEnts()
	-- expensive!
	if not self.Zone or not self.Zone:IsValid() then return end

	local mins, maxs = self:GetCollisionBounds()
	mins, maxs = self:LocalToWorld(mins), self:LocalToWorld(maxs)

	for k,v in ipairs(ents.FindInBox(mins, maxs)) do
		self.Zone:_EntityEntered(self, v)
		self.Zone:Emit("EntityEntered", self, v)
	end
end

hook.PAdd("EntityRemoved", "ZoneBrushUntrack", function(ent)
	-- the idea is that when the ents within the brush get removed, EndTouch gets called for me
	-- however if the brush gets removed first, nothing gets called
	-- so we do that manually

	if not ent.IsZoneBrush then return end
	if not ent.Zone or not ent.Zone:IsValid() then return end

	local zone = ent.Zone
	local ents = zone:GetEntities()

	for k,v in pairs(ent.MolestedEnts) do
		if ents[k] then
			zone:_EntityExited(ent, k)
			zone:Emit("EntityExited", ent, k)
		end
	end
end)