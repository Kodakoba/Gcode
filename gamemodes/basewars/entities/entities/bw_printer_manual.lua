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
   
    if not self:GetGrid():TakePower(5) then return end

    local printed = self.PrintAmount * self:GetLevel()
    
	act:GiveMoney(printed)
	hook.Run("BaseWars_PlayerEmptyPrinter", call, self, printed)

end

function ENT:Draw()
	self:DrawModel()
end

function ENT:ThinkFunc()
end

function ENT:UseBypass()
end