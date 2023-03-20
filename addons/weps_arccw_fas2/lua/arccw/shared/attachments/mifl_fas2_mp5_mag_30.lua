att.PrintName = "30-Round 10mm Auto"
att.Icon = Material("entities/arccw_mifl_fas2_mp5_mag_10mm.png", "mips smooth")
att.Description = "Convert weapon to fire the more powerful 10mm Auto with increased damage. The straight magazine is ever so slightly heavier."
att.SortOrder = 30 + 1500
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "mifl_fas2_mp5_mag"

att.Override_ClipSize = 30 

att.Mult_Damage = 1.15
att.Mult_DamageMin = 1.15

att.Mult_Recoil = 1.1
att.Mult_RPM = 0.9

att.Mult_ReloadTime = 1.1
att.Mult_SightTime = 1.1

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == "weapons/arccw_mifl/fas2/mp5/mp5_fire1.wav" then return "weapons/arccw_mifl/fas2_custom/mp5/30.wav" end
    if fsound == "weapons/arccw_mifl/fas2/mp5/mp5k_suppressed_fire1.wav" then return "weapons/arccw_mifl/fas2_custom/mp5/30sd.wav" end
end