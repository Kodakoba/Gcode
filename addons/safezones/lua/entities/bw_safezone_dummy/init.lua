include("shared.lua")
AddCSLuaFile("cl_init.lua")
print('server dummy brush')

ENT.Model 		= "models/hunter/blocks/cube025x025x025.mdl"

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetZoneName(self.ZoneName)
end
