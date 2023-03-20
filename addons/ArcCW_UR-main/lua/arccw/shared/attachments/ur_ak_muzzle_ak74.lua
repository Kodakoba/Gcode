att.PrintName = "AK-74M Compensator"
att.Icon = Material("entities/att/ur_ak/muzzle_74m.png", "mips smooth")
att.Description = "External compensator used since the '70s for AKs of multiple calibers. Efficiently reduces horizontal recoil and marginally reduces vertical recoil at the cost of a frontal counterweight that will inevitably raise swaying."
att.AutoStats = true
att.Slot = {"ur_ak_muzzle"}

att.Mult_Recoil = .95
att.Mult_RecoilSide = .65

att.Add_BarrelLength = 2.5
att.Mult_SightTime = 1.05
att.Mult_Sway = 1.25

att.SortOrder = 999

att.AttachSound = "arccw_uc/common/gunsmith/suppressor_thread.ogg"
att.ActivateElements = {"muzzle_ak74"}
att.ExcludeFlags = {"ak_barrelchange"}