att.PrintName = "Basilisk Heavy Compensator" -- fictional
att.AbbrevName = "Basilisk Compensator"
att.Icon = Material("entities/att/muzzle4.png", "mips smooth")
att.Description = "A muzzle device that redirects propellant gases to counter muzzle rise, particularly in the lateral directions."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.AutoStats = true
att.Slot = {"muzzle","muzzle_shotgun"}

att.SortOrder = 100

att.Model = "models/weapons/arccw/atts/uc_muzzle5.mdl"
att.ModelOffset = Vector(1.3, 0, 0)
att.ModelScale = Vector(.85, .85, .85)
att.OffsetAng = Angle(0, 0, 0)

att.IsMuzzleDevice = true

--att.Mult_ShootPitch = .95 please don't
att.Mult_Recoil = .85
att.Mult_RecoilSide = .75

att.Add_BarrelLength = 2
att.Mult_SightTime = 1.2
att.Mult_Sway = 1.5
att.Mult_ShootVol = 1.25

att.AttachSound = "arccw_uc/common/gunsmith/suppressor_thread.ogg"