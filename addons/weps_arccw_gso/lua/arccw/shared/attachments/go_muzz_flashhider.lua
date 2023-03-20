att.PrintName = "Flash Hider"
att.Icon = Material("entities/acwatt_go_muzz_flashhider.png", "mips smooth")
att.Description = "Muzzle device which hides muzzle flash while improving hip fire characteristics."

att.SortOrder = 1

att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "muzzle"

att.Model = "models/weapons/arccw_go/atts/flashhider.mdl"

att.Override_MuzzleEffect = "muzzleflash_pistol"
att.IsMuzzleDevice = true

att.Mult_HipDispersion = 0.9

att.Add_BarrelLength = 3

att.Mult_ShootPitch = 1.05

att.Mult_SightTime = 1.05

att.Mult_MoveSpeed = 0.95