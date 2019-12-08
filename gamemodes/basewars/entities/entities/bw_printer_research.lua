AddCSLuaFile()
ENT.Base = "bw_base_xpprinters"

ENT.Skin = 0

ENT.Capacity 		= 50000
ENT.PrintInterval 	= 1
ENT.PrintAmount		= 150

ENT.PrintName = "Research Printer"

ENT.FontColor = Color(0, 150, 230)
ENT.BackColor = color_black

ENT.IsValidRaidable = true

ENT.PresetMaxHealth = 650

function ENT:UseFuncBypass(activator, caller, usetype, value)

    if self.Disabled then return end

    if activator:IsPlayer() and caller:IsPlayer() and self:GetMoney() > 0 then
        if self:CPPIGetOwner()~=activator then return end

        activator:AddXP(self:GetMoney())
        self.Money = 0

    end

end

