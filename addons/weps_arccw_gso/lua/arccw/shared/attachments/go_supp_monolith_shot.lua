att.PrintName = "Monolith Suppressor"
att.Icon = Material("entities/acwatt_go_supp_monolith.png", "mips smooth")
att.Description = "Huge suppressor that makes shots whisper-quiet and enhances muzzle velocity. However, it is very bulky. Can be used on shotguns."

att.SortOrder = 3

att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "muzzle"

att.InvAtt = "go_supp_monolith"

att.SortOrder = 15

att.Model = "models/weapons/arccw_go/atts/supp_monolith.mdl"

att.Silencer = true
att.Override_MuzzleEffect = "muzzleflash_suppressed"
att.IsMuzzleDevice = true

att.Mult_ShootPitch = 0.9
att.Mult_ShootVol = 0.75
att.Mult_SightTime = 1.15

att.Add_BarrelLength = 16

att.Hook_Compatible = function(wep)
    if !wep:GetIsShotgun() then return false end
end