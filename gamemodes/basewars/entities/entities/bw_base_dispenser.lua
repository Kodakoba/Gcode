AddCSLuaFile()

local base = "bw_base_upgradable"
ENT.Base = base
ENT.Type = "anim"
ENT.PrintName = "Base Dispenser"
ENT.Sound = Sound("HL1/fvox/blip.wav")
ENT.Model = "models/props_c17/FurnitureToilet001a.mdl"

local lvT = {
	{
		Cost = 0,
		DispenseMult = 1,
	}, {
		Cost = 0,
		DispenseMult = 1.5,
	}, {
		Cost = 0,
		DispenseMult = 2,
	}
}

function ENT:Initialize()
	baseclass.Get(base).Initialize(self)
	if SERVER then
		self:SetUseType(CONTINUOUS_USE)
	end
end

function ENT:Dispense()
	-- for override
end

function ENT:CheckUsable()
	if self.Time and self.Time + 0.5 > CurTime() then
		return false
	end
end

function ENT:UseFunc(ply)
	if not IsPlayer(ply) then return end

	self.Time = CurTime()
	local emit = self:Dispense(ply, self:GetLevelData())
	if emit ~= false then
		self:EmitSound(self.Sound, 100, 60)
	end
end