include("shared.lua")
AddCSLuaFile("cl_init.lua")

ENT.Model 		= "models/hunter/blocks/cube025x025x025.mdl"

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetZoneName(self.ZoneName)
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
end
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end