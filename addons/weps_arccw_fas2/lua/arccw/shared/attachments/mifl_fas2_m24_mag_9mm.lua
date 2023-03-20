att.PrintName = "9x19mm"
att.Icon = Material("entities/arccw_mifl_fas2_m24_ammo_9mm.png", "mips smooth")
att.Description = "Rechamber the rifle to fire pistol-caliber cartridges. Pathetic as it may be, it can probably still hurt someone's feelings."
att.SortOrder = 0
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "mifl_fas2_m24_mag"

att.Override_Ammo = "pistol"
att.Override_ShellModel = "models/shells/shell_9mm.mdl"
att.Override_Trivia_Calibre = "9x19mm Parabellum"

att.Mult_Damage = 0.45
att.Mult_DamageMin = 0.3
att.Mult_Range = 0.7

att.Mult_Recoil = 0.25
att.Mult_RecoilSide = 0.3

att.Mult_Penetration = 0.3

att.Mult_ReloadTime = 0.7
att.Mult_CycleTime = 0.75

att.Mult_ShootVol = 0.8
att.AddSuffix = " 9mm"

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == "weapons/arccw_mifl/fas2/m24/m24_fire1.wav" then return "weapons/arccw_mifl/fas2/mac11/mac11_fire1.wav" end
    if fsound == "weapons/arccw_mifl/fas2/m24/m24_suppressed_fire1.wav" then return "weapons/arccw_mifl/fas2/mac11/mac11_suppressed_fire1.wav" end
end