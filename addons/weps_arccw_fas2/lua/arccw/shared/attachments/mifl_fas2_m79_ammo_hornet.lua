att.PrintName = "M79 Hornet's Nest"
att.Icon = Material("entities/arccw_mifl_fas2_m79_hornet.png", "mips smooth")
att.Description = "A grenade loaded with 18 .22LR rounds, and thus uses pistol ammo. It is much more accurate and has more range than buckshot, but doesn't do as much damage."
att.Desc_Pros = {
    "pro.fas2.m79.hornet"
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
    "info.fas2.m79.hornet"
}
att.SortOrder = 2.5

att.Slot = {"mifl_fas2_m79_ammo"}
att.Override_ShootEntity = false
att.Override_Num = 18
att.Mult_Damage = 180 / 150
att.Mult_DamageMin = 90 / 60
att.Mult_AccuracyMOA = 0.4
att.Mult_Range = 2
att.Mult_ShootPitch = 0.75
att.Mult_ReloadTime = 0.9

att.Override_AmmoPerShot = 18
att.Override_ClipSize = 18
att.Override_Ammo = "pistol"

att.Hook_Compatible = function(wep, data)
    if wep.Attachments[4] and wep.Attachments[4].Installed == "mifl_fas2_m79_tube_q" then return false end
end

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == wep.ShootSound then return "weapons/arccw_mifl/fas2/ks23/ks23_fire1.wav" end
end