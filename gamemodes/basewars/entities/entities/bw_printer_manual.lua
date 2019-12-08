AddCSLuaFile()
ENT.Base = "bw_base_moneyprinter"

ENT.Skin = 0

ENT.Capacity        = 15000
ENT.PrintAmount     = 15
ENT.PowerRequired = 0
ENT.PowerCapacity = 50
ENT.PrintName = "Manual Printer"

ENT.FontColor = Color(200, 117, 51)
ENT.BackColor = color_black
ENT.IsValidRaidable = false

ENT.PrintAmount = 5
ENT.MaxLevel = 5
ENT.BypassMaster = true 

function ENT:UseFunc(act, call)
    if not (act==call && act:IsPlayer() && self:CPPIGetOwner()==act) then print(act, call) return end
    if self:GetPower() < 5 then return end

	act:GiveMoney(self.PrintAmount*self:GetLevel())
	act:AddXP((self.PrintAmount*self:GetLevel())/50)
	self:DrainPower(5)
end

function ENT:Draw()
	self:DrawModel()
end
function ENT:ThinkFunc()
return
end

function ENT:UseBypass()
return
end