AddCSLuaFile()
ENT.Base = "bw_base_xpprinters"

ENT.Skin = 0

ENT.Capacity 		= 10
ENT.PrintInterval 	= 15
ENT.PrintAmount		= 1 
ENT.MaxLevel        = 350

ENT.PrintName = "Cosmic Printer"
ENT.EXPCurrency = "LVL"
ENT.FontColor = Color(0, 150, 230)
ENT.BackColor = color_black

ENT.IsValidRaidable = true

ENT.PresetMaxHealth = 650

function ENT:UseFuncBypass(activator, caller, usetype, value)

    if self.Disabled then return end

    if activator:IsPlayer() and caller:IsPlayer() and self:GetMoney() > 0 then
        if self:CPPIGetOwner()~=activator then return end
        activator:AddLevel(self:GetMoney())
        self.Money = 0
    end

end