att.PrintName = "60-Round 5.56mm"
att.Icon = Material("entities/arccw_mifl_fas2_m4a1_ammo_60.png", "mips smooth")
att.Description = "Heavy quad stack magazine holding twice the rounds."
att.Desc_Pros = {
    "pro.magcap"
}
att.Desc_Cons = {
}
att.SortOrder = 60 + 100
att.AutoStats = true
att.Slot = {"mifl_fas2_m4a1_mag", "mifl_fas2_m249_mag", "mifl_fas2_g36_mag"}

att.ActivateElements = {"60"}

att.Mult_MoveSpeed = 0.95
att.Mult_SightTime = 1.1
att.Override_ClipSize = 60
att.Mult_ReloadTime = 1.2