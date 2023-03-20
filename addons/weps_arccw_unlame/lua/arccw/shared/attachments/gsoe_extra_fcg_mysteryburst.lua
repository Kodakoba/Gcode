att.PrintName = "(CSExtras) Mystery Burst"
att.Icon = Material("entities/acwatt_fcg_mysteryburst.png", "smooth mips")
att.Description = "A tampered Smart Burst fire system that a random amount of bullets. Very fast but suffers from inconsistency."
att.Desc_Neutrals = {
    "Each burst fires 10%~30% of total capacity",
}
att.Desc_Pros = {
    "Mystery burst mode"
}
att.Desc_Cons = {
    "con.burstdelay2",
}
att.Slot = "go_perk"
att.InvAtt = "fcg_mysteryburst"

att.Ignore = false

att.Override_Firemodes = {
    {
        Mode = -1000,
        CustomBars = "_____",
        PrintName = "??BST",
        RunawayBurst = true,
    },
    {
        Mode = 0
    }
}

att.AutoStats = true

att.Mult_RPM = 1.3

att.Hook_GetBurstLength = function(wep)

    local bstCnt = math.max(math.ceil(wep:GetCapacity() * (math.random() * 0.2 + 0.1)), 2)

    if wep:GetNWInt("ArcCW_SmartBurst", -1) < 0 then
        wep:SetBurstCount(0)
        wep:SetNWInt("ArcCW_SmartBurst", bstCnt)
    end

    return wep:GetNWInt("ArcCW_SmartBurst", -1) < 0 and nil or wep:GetNWInt("ArcCW_SmartBurst")
end

-- Using this as a makeshift onReload hook right now
att.Hook_SelectReloadAnimation = function(wep, mult)
    wep:SetNWInt("ArcCW_SmartBurst", -1)
end

att.Hook_ShouldNotFire = function(wep)
    if wep:GetNWInt("ArcCW_SmartBurst", -1) > 1 and wep:GetNWInt("ArcCW_SmartBurst", -1) <= wep:GetBurstCount() then
        wep:SetNWInt("ArcCW_SmartBurst", -1)
        wep.Primary.Automatic = false
        wep:SetNextPrimaryFire(CurTime() + 0.2)
        return true
    end
end