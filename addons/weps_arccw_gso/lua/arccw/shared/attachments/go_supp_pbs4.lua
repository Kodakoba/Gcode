att.PrintName = "PBS-4 Suppressor"
att.Icon = Material("entities/acwatt_go_supp_pbs4.png", "mips smooth")
att.Description = "Large sound suppressor with ballistic-enhancing qualities. Somewhat cumbersome. Russian equivalent to the QDSS."

att.SortOrder = 2

att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "muzzle"

att.SortOrder = 15

att.Model = "models/weapons/arccw_go/atts/supp_pbs4.mdl"

att.Silencer = true
att.Override_MuzzleEffect = "muzzleflash_suppressed"
att.IsMuzzleDevice = true

att.Mult_ShootPitch = 1
att.Mult_ShootVol = 0.75
att.Mult_AccuracyMOA = 0.8
att.Mult_Range = 1.1

att.Mult_SightTime = 1.1
att.Mult_HipDispersion = 1.15

att.Add_BarrelLength = 8

att.Hook_Compatible = function(wep)
    if wep:GetIsShotgun() then return false end
end