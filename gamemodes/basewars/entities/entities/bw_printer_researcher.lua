AddCSLuaFile()
ENT.Base = "bw_base_moneyprinter"

ENT.Skin = 0

ENT.Capacity 		= 250000
ENT.PrintInterval 	= 1
ENT.PrintAmount		= 50

ENT.PrintName = "Research Printer"

ENT.FontColor = Color(0, 150, 230)
ENT.BackColor = color_black

ENT.IsValidRaidable = true

ENT.PresetMaxHealth = 650

function ENT:UseFuncBypass(activator, caller, usetype, value)

        if self.Disabled then return end

        if activator:IsPlayer() and caller:IsPlayer() and self:GetMoney() > 0 then
            BaseWars.PlayerLevel:AddXP(activator, (self:GetMoney() * 5))
            self:PlayerTakeMoney(activator)

        end

    end