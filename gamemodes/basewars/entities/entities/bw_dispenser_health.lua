
AddCSLuaFile()

ENT.Base = "bw_base_electronics"
ENT.Type = "anim"

ENT.PrintName = "Health Dispenser"
ENT.Author = "grmx"

ENT.Model = "models/props_combine/health_charger001.mdl"

ENT.Sound = Sound("HL1/fvox/blip.wav")

function ENT:Init()

	self:SetModel(self.Model)
	self:SetHealth(500)
	
	self:SetUseType(CONTINUOUS_USE)
	
end

function ENT:CheckUsable()

	if self.Time and self.Time + 0.5 > CurTime() then return false end
	
end

function ENT:UseFunc(ply)
	
	if not IsPlayer(ply) then return end
	
	self.Time = CurTime()
	
	local hp = ply:Health()
	if hp >= ply:GetMaxHealth() then return end
	
	ply:SetHealth(math.min(hp + 10, math.max(ply:Health(), ply:GetMaxHealth())))
	self:EmitSound(self.Sound, 100, 60)
	
end
