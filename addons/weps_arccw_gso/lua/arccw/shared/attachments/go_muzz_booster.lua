att.PrintName = "Muzzle Booster"
att.Icon = Material("entities/acwatt_go_muzz_booster.png", "mips smooth")
att.Description = "Muzzle device that increases gas pressure, improving fire rate on automatic weapons at the cost of increased recoil. Does nothing on manual-action firearms."

att.SortOrder = 1

att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "muzzle"

att.Model = "models/weapons/arccw_go/atts/booster.mdl"

att.IsMuzzleDevice = true

att.Add_BarrelLength = 3

att.Mult_ShootPitch = 1.1

att.Mult_SightTime = 1.05

att.Mult_MoveSpeed = 0.95

att.Mult_RPM = 1.1

att.Mult_Recoil = 1.15