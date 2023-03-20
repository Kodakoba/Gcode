att.PrintName = "(CSExtras) Tidal"
att.Icon = Material("entities/acwatt_fcg_tidal.png", "smooth mips")
att.Description = "Fire system that harnesses the magnetic field to cycle bullets at a dramatic rate. Like its namesake, the actual rate of fire increases and decreases periodically."
att.Desc_Neutrals = {
    "250% maximum firerate",
    "100% minimum firerate",
}
att.Desc_Pros = {
    "+ Fully automatic fire",
    "+ Potential fire rate increase"
}
att.Desc_Cons = {
    "- Inconsistent fire rate",
}
att.Slot = "go_perk"
att.InvAtt = "fcg_tidal"

att.Override_Firemodes = {
    {
        Mode = 2,
        PrintName = "TIDAL",
    },
    {
        Mode = 0
    }
}

att.AutoStats = true

att.Mult_RPM = 1
att.Mult_AccuracyMOA = 1.4

att.Hook_ModifyRPM = function(wep, delay)
    return delay * (0.4 + math.abs(math.sin(CurTime() * 0.6) * 1))
end