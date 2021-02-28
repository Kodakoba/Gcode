include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")


function ENT:Init(me)
	self:PhysicsInit(SOLID_VPHYSICS)
end

function ENT:SetBase(base)
	self.BWBase = base
	self:SetBaseID(base:GetID())
end

function ENT:GetBase()
	return self.BWBase
end

function ENT:Think()
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
end

function ENT:UpdateTransmitState()
	if not self:GetClaimed() then
		return TRANSMIT_ALWAYS -- unclaimed bases are always transmitted
	end

	return TRANSMIT_PVS
end

function ENT:Use(ply)

end
