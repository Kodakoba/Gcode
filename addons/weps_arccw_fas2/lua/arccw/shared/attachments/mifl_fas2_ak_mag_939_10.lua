att.PrintName = "10-Round 9x39mm SPP"
att.Icon = Material("entities/arccw_mifl_fas2_ak_mag_asval3.png", "mips smooth")
att.Description = "Load 9x39mm cartridges with increased penetration and damage over distance, designed for subsonic velocities in suppressed weapons. Lighter magazine improves handling."
att.Desc_Pros = {
    "pro.invistracers"
}
att.Desc_Cons = {"con.magcap"}
att.SortOrder = 10 + 100
att.AutoStats = true
att.Slot = "mifl_fas2_ak_mag"

-- 10rnd stats
att.ActivateElements = {"10_939", "9x39mm"}
att.Override_ClipSize = 10
att.Mult_MoveSpeed = 1.1
att.Mult_SightTime = 0.85
att.Mult_ReloadTime = 0.9

-- 7.62x39 -> 9x39mm stats
att.Mult_Damage = 0.95
att.Mult_DamageMin = 3.5
att.Mult_Recoil = 1.2
att.Mult_ShootVol = 0.85
att.Mult_Range = 3
att.Mult_RPM = 0.8

att.Override_Ammo = "smg1"
att.Override_PhysTracerProfile = 5
att.Override_TracerNum = 0

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == "weapons/arccw_mifl/fas2/ak47/ak47_fire1.wav" then return "weapons/arccw_mifl/fas2_custom/asval/556.wav" end
    if fsound == "weapons/arccw_mifl/fas2/ak47/ak47_suppressed_fire1.wav" then return "weapons/arccw_mifl/fas2_custom/asval/sd.wav" end
end