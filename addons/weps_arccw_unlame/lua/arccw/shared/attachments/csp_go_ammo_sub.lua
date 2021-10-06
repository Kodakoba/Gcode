att.PrintName = "(GSO) Subsonic Rounds"
att.Icon = Material("entities/acwatt_go_ammo_sub.png", "mips smooth")
att.Description = "Reduced load rounds which are more quiet than standard ammo. Makes tracers invisible."
att.Desc_Pros = {
    "pro.invistracers"
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "ammo_bullet"
att.InvAtt = "go_ammo_sub"

att.Mult_Range = 0.75
att.Mult_Recoil = 0.8
att.Mult_ShootVol = 0.85

att.Override_PhysTracerProfile = 7
att.Override_TracerNum = 0