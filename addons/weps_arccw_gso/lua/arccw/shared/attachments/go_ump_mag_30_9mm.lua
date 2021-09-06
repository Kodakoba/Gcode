att.PrintName = "30-Round 9mm UMP-9"
att.Icon = Material("entities/acwatt_go_ump_mag_30_9mm.png", "mips smooth")
att.Description = "9mm magazine conversion for the UMP-45 submachine gun."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.SortOrder = 30
att.AutoStats = true
att.Slot = "go_ump_mag"

att.Mult_Range = 1.15
att.Mult_Penetration = 1.15
att.Mult_Recoil = 0.85
att.Mult_SightTime = 0.95
att.Mult_RPM = 1.25
att.Mult_AccuracyMOA = 1.25
att.Override_ClipSize = 30
att.Mult_Damage = 0.9
att.Mult_DamageMin = 0.9
att.Mult_ShootPitch = 1.25

-- ump45_9mm

att.Hook_GetShootSound = function(wep, ss)
    if ss == "arccw_go/ump45/ump45_02.wav" or ss == "arccw_go/ump45/ump45_02.wav" then
        return "arccw_go/ump45/ump45_9mm.wav"
    end
end