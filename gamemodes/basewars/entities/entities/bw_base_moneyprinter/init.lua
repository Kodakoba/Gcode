AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    baseclass.Get("bw_base_electronics").Initialize(self)

    local me = self:GetTable()

    me.Power = 0
    me.MaxPower = self.PowerCapacity

    self.time = CurTime()
    self.time_p = CurTime()

    self:SetCapacity(self.Capacity)

    self.Money = 0
    self.Multiplier = 1
    self:SetHealth(self.PresetMaxHealth or 100)

    self:SetMultiplier(1)

    self.Level = 1
    self:SetLevel(1)

    self.Overclockable = true
    self.Overclocker = false
    self.Mods = {}

    if self.TTR and self.CurrentValue then
        self.PrintAmount = math.Round(self.CurrentValue / self.TTR)
    end

    self:SetPrintAmount(self.PrintAmount)

    if not self.BypassMaster then
        BaseWars.Printers.Add(self)
    end
end

function ENT:NetworkMods()
    local m = self.Mods
    self:SetMods(util.TableToJSON(m))
end

function ENT:Overclock(lv, mult)
    if not self.Overclockable or self.Overclocker then return false end
    self.Overclockable = false
    self.Overclocker = lv
    self:SetMultiplier(self.Multiplier * mult)
    self.Multiplier = self.Multiplier * mult

    BaseWars.Printers.MasterTable[self].mult = self.Multiplier

    self.Mods["o"] = lv
    self:NetworkMods()
    return true
end

function ENT:DoUpgrade()
    local lvl = self:GetLevel()
    local calcM = self:GetUpgradeValue() * lvl
    self.CurrentValue = (self.CurrentValue or 0) + calcM
    self.Level = self.Level + 1
    self:SetLevel(self.Level)

    self:EmitSound("replay/rendercomplete.wav")

    local amt = BaseWars.Printers.GetPrintRate(self)
    if amt then
        self:SetPrintAmount(amt)
    end
end

function ENT:RequestUpgrade(ply)
    if not ply then return end

    local ow = self:BW_GetOwner()

    if GetPlayerInfo(ply) ~= ow then
        ply:Notify("You can't upgrade others' printers!", BASEWARS_NOTIFICATION_ERROR)
        return false
    end

    local lvl = self:GetLevel()
    local plyM = ply:GetMoney()
    local calcM = self:GetUpgradeValue() * lvl

    if plyM < calcM then
        ply:Notify(BaseWars.LANG.UpgradeNoMoney, BASEWARS_NOTIFICATION_ERROR)
        return false
    end

    if lvl >= self.MaxLevel then
        ply:Notify(BaseWars.LANG.UpgradeMaxLevel, BASEWARS_NOTIFICATION_ERROR)
        return false
    end

    ply:TakeMoney(calcM)

    self:DoUpgrade()
end

function ENT:NetworkVars()
    local t = self:GetTable()

    t.SetNWMoney(self, t.Money)
    t.SetMultiplier(self, t.Multiplier)
end

function ENT:PlayerTakeMoney(ply, suppress)
    local owInfo = self:BW_GetOwner()
    if owInfo:GetPlayer() ~= ply then return end

    local money = self.Money

    local can, msg = hook.Run("BaseWars_PlayerCanEmptyPrinter", ply, self, money)

    if can == false then
            if msg then ply:Notify(msg, BASEWARS_NOTIFICATION_ERROR) end
        return
    end

    self:SetNWMoney(0)

    self.Money = 0

    ply:GiveMoney(money)

    if not suppress then
        ply:EmitSound("mvm/mvm_money_pickup.wav")
    end

    hook.Run("BaseWars_PlayerEmptyPrinter", ply, self, money)

    return money
end

function ENT:UseFunc(activator, caller, usetype, value, suppress)

    if self.Disabled then print('no') return end

    if activator:IsPlayer() and caller:IsPlayer() and self:GetNWMoney() > 0 then
        return self:PlayerTakeMoney(activator, suppress)
    end

end

function ENT:SetDisabled(a)

    self.Disabled = a and true or false
    self:SetNWBool("printer_disabled", a and true or false)

end
