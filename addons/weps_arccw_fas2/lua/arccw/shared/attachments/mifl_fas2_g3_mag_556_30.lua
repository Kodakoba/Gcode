att.PrintName = "30-Round 5.56mm"
att.Icon = Material("entities/arccw_mifl_fas2_g3_mag_556_30.png", "mips smooth")
att.Description = "Convert the weapon into a HK33, firing a less powerful intermediate cartridge."
att.SortOrder = 5.3
att.Desc_Pros = {
    "pro.magcap"
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "mifl_fas2_g3_mag"

att.Override_ClipSize = 30

-- 5.56
att.Mult_Damage = 0.6
att.Mult_DamageMin = 0.4
att.Mult_Recoil = 0.5
att.Mult_RecoilSide = 0.5
att.Mult_Penetration = 0.6
att.Mult_Range = 0.5
att.Mult_RPM = 1.1
att.Override_Ammo = "smg1"
att.Override_Trivia_Class = "Assault Rifle"
att.Override_Trivia_Calibre = "5.56x45mm NATO"

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == wep.ShootSound then return "weapons/arccw_mifl/fas2_custom/g3/556.wav" end
    if fsound == wep.ShootSoundSilenced then return "weapons/arccw_mifl/fas2_custom/g3/556sd.wav" end
end