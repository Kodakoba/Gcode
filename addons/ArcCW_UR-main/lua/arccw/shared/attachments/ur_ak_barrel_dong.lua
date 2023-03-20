att.PrintName = "\"Romanian Dong\" Integral Foregrip"
att.AbbrevName = "Dong Foregrip"
att.Icon = Material("entities/att/ur_ak/dong.png", "mips smooth")
att.Description = "Romanian lower handguard design, shaped into an integrated foregrip. Functions like a Stubby Foregrip with slightly less added weight."
att.Slot = {"ur_ak_ub"}
--att.Desc_Cons = {"uc.noubs"}
att.AutoStats = true

att.SortOrder = 16

att.Mult_Recoil = .825
att.Mult_SightTime = 1.125
att.Mult_MoveDispersion = 1.25

att.ActivateElements = {"barrel_dong"}
att.ExcludeFlags = {"barrel_carbine","nodong"}

att.LHIK = true

att.ModelOffset = Vector(-23, -2.6, 3.8)
--att.ModelScale = Vector(1.111, 1.111, 1.111)
att.Model = "models/weapons/arccw/ak_lhik_dong.mdl"

att.Override_HoldtypeActive = "smg"