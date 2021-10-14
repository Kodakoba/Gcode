include("shared.lua")
AddCSLuaFile("cl_init.lua")

ENT.Model 		= "models/hunter/blocks/cube025x025x025.mdl"

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

function ENT:Initialize()
	self:SetModel(self.Model)
	local dat = Safezones.Points[self.ZoneName]
	self:SetMinsZone(dat[1])
	self:SetMaxsZone(dat[2])
end
