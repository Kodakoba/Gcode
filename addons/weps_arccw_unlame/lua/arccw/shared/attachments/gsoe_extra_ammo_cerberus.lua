att.PrintName = "(CSExtras) Cerberus"
att.Icon = Material("entities/acwatt_ammo_cerberus.png", "smooth mips")
att.Description = "Unorthodox pistol round that splits into three upon leaving the chamber. Horrible accuracy, but flays point blank targets effectively."
att.Desc_Pros = {
    "+2 projectiles per shot", "+Due to GSO not having support for Reduced Mags,", "you get to use this at max capacity!"
}
att.Desc_Cons = {
    "-Reload speed penalty to compensate"
}
att.Desc_Neutrals = {
    "Can only be used with pistol or magnum ammo",
}
att.Slot = "go_ammo"
att.InvAtt = "ammo_cerberus"

att.Override_Num = 3

att.Mult_ShootPitch = 0.85
att.Mult_Damage = 1.5
att.Mult_DamageMin = 0.2
att.Mult_AccuracyMOA = 4
att.Mult_Range = 0.7
att.Mult_Penetration = 0.1

att.AutoStats = true

att.Hook_Compatible = function(wep)
    if wep.Num ~= 1 or (wep.Primary.Ammo ~= "pistol" and wep.Primary.Ammo ~= "357") then return false end
end