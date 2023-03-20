att.PrintName = "(CSExtras) Smart Burst"
att.Icon = Material("entities/acwatt_fcg_smartburst.png", "smooth mips")
att.Description = "A burst firemode conversion that varies its length to magazine capacity. Fires faster than traditional bursting."
att.Desc_Neutrals = {
    "Each burst fires 10% of magazine (min. 2)",
}
att.Desc_Cons = {
    "con.burstdelay"
}
att.Slot = "go_perk"
att.InvAtt = "fcg_smartburst"

att.Ignore = false

att.Override_Firemodes = {
    {
        Mode = -1000,
        CustomBars = "---__",
        PrintName = "S-BST",
        RunawayBurst = true,
    },
    {
        Mode = 0
    }
}

att.Mult_RPM = 1.15
att.AutoStats = true

att.Hook_GetBurstLength = function(wep)

    local bstCnt = math.max(math.ceil(wep:GetCapacity() * 0.1), 2)

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
        wep:SetNextPrimaryFire(CurTime() + 0.12)
        return true
    end
end