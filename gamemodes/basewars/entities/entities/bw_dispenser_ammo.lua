AddCSLuaFile()

ENT.Base 				= "bw_base_electronics"
ENT.Type 				= "anim"

ENT.PrintName 			= "Ammo Dispenser"
ENT.Author 				= "Q2F2"

ENT.Model 				= "models/props_lab/reciever_cart.mdl"
ENT.Sound				= Sound("HL1/fvox/blip.wav")

ENT.ConnectPoint = Vector (-12.923860549927, 4.9223861694336, 7.6732382774353)

ENT.UseSpline = false 

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
	
	local gun = ply:GetActiveWeapon()
	if not IsValid(gun) then return end
	
	local ammo = gun:GetPrimaryAmmoType()
	if not ammo then return end
	
	ply:GiveAmmo(math.min(15, gun:GetMaxClip1()), ammo)
	self:EmitSound(self.Sound, 100, 60)
	
end
