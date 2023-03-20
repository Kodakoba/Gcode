att.PrintName = "NT-4 Suppressor"
att.Icon = Material("entities/acwatt_go_supp_nt4.png", "mips smooth")
att.Description = "Lightweight tactical suppressor. Reduces audible report with no significant bulk. However, it has a negative impact on weapon performance."

att.SortOrder = 1

att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "muzzle"

att.SortOrder = 15

att.Model = "models/weapons/arccw_go/atts/supp_ntr.mdl"

att.ModelScale = Vector(1.25, 1.25, 1.25)

att.Silencer = true
att.Override_MuzzleEffect = "muzzleflash_suppressed"
att.IsMuzzleDevice = true

att.Mult_ShootPitch = 1.1
att.Mult_ShootVol = 0.75
att.Mult_Range = 0.9

att.Add_BarrelLength = 8

att.Hook_Compatible = function(wep)
    if wep:GetIsShotgun() then return false end
end