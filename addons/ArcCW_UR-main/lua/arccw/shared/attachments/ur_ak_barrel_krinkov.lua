att.PrintName = "8\" Compact Barrel"
att.Icon = Material("entities/att/ur_ak/barrel/aksu.png", "mips smooth")
att.Description = "Special carbine length handguard and barrel. Its reduced length leads to less unwieldiness, and the shortened gas system increases cyclic rate respectably.\nThese traits combined, however, result in a difficult weapon to control."
att.Slot = {"ur_ak_barrel"}
att.AutoStats = true

att.SortOrder = 8
att.Mult_ShootPitch = 115/100
att.Add_BarrelLength = -6
att.Mult_RPM = 1.131
att.Mult_SightTime = .8
att.Mult_HipDispersion = .8
att.Mult_SightedSpeedMult = 1.1
att.Mult_SpeedMult = 1.025
att.Mult_Sway = .8

att.Mult_Recoil = 1.5
att.Mult_AccuracyMOA = 2
att.Mult_Range = .5

att.ActivateElements = {"barrel_krinkov"}
att.GivesFlags = {"ak_barrelchange","barrel_carbine","ak_barrelkrinkov"}