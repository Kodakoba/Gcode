AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Init()

    local me = BWEnts[self]
    
    me.Power = 0 
    me.MaxPower = self.PowerCapacity

    self.time = CurTime()
    self.time_p = CurTime()

    self:SetCapacity(self.Capacity)
    
    self.Money = 0
    self.Multiplier = 1
    self:SetHealth(self.PresetMaxHealth or 100)

    self.rtb = 0

    self:SetUpgradeCost(self.UpgradeCost)
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

function ENT:SetUpgradeCost(val)
    self.UpgradeCost = val
    self:SetUpgradeValue(val)
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

util.AddNetworkString("OverclockPrinter")

net.Receive("OverclockPrinter", function(_, ply)
    local pr = net.ReadEntity()
    local uid = net.ReadUInt(32)
    if not pr or not IsValid(pr) or not pr.IsPrinter or not pr.Overclock then return end --printer invalid
    if not pr.CPPIGetOwner or pr:CPPIGetOwner() ~= ply then return end --owner invalid
    if not pr.Overclockable then return end --cant overclock 
    
    if not uid or not ply:HasItem(uid) then return end --uid invalid

    local it = ply:HasItem(uid)
    if not it.ItemID == ItemIDs.Overclocker then return end --not overclocker

    it:SetPermaStat("uses", it:GetPermaStat("uses", 1337) - 1)

    local var = it:GetPermaStat("var", 1)
    pr:Overclock(var, OverclockGetMult(var))
    if it:GetPermaStat("uses", 1337) <= 0 then 
        it:Delete()
    end
end)

function ENT:Upgrade(ply)

    if ply then
        if ply~=self:CPPIGetOwner() then 
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
        self.CurrentValue = (self.CurrentValue or 0) + calcM

        self.Level = self.Level + 1
        self:SetLevel(self.Level)
        
        self:EmitSound("replay/rendercomplete.wav")
    
    end
        
end

function ENT:NetworkVars()
    
    local me = BWEnts[self]
    local t = self:GetTable()

    t.SetNWMoney(self, t.Money)
    t.SetMultiplier(self, t.Multiplier)
end

function ENT:PlayerTakeMoney(ply, suppress)

    if self:CPPIGetOwner()~=ply then return end

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
