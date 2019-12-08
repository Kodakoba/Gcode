AddCSLuaFile()

ENT.Base 				= "bw_base_electronics"
ENT.Type 				= "anim"

ENT.PrintName 			= "Armor Dispenser T2"
ENT.Author 				= "Q2F2"

ENT.Model 				= "models/props_combine/suit_charger001.mdl"
ENT.Sound				= Sound("HL1/fvox/blip.wav")

function ENT:Init()

	self:SetModel(self.Model)
	self:SetHealth(1500)
	self:SetColor(Color(70,70,200))
	self:SetUseType(CONTINUOUS_USE)
	
end

function ENT:CheckUsable()

	if self.Time and self.Time + 0.5 > CurTime() then return false end
	
end

function ENT:UseFunc(ply)
	
	if not IsPlayer(ply) then return end
	
	self.Time = CurTime()
	
	local Armor = ply:Armor()
	if Armor >= 150 then return end
	
	ply:SetArmor(Armor + 50)
	self:EmitSound(self.Sound, 100, 60)
	
	if ply:Armor() > 150 then ply:SetArmor(150) end
	
end
