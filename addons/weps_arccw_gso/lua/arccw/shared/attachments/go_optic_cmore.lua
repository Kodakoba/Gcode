att.PrintName = "C-More (RDS)"
att.Icon = Material("entities/acwatt_go_optic_cmore.png", "mips smooth")
att.Description = "Open multipurpose red dot sight."

att.SortOrder = 1

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "optic"

att.Model = "models/weapons/arccw_go/atts/cmore.mdl"

att.ModelOffset = Vector(0, 0, 0.1)

att.AdditionalSights = {
    {
        Pos = Vector(0, 10, -1.26295),
        Ang = Angle(0, 0, 0),
        Magnification = 1.1,
        ScrollFunc = ArcCW.SCROLL_NONE,
        IgnoreExtra = false
    }
}

att.Holosight = true
att.HolosightReticle = Material("hud/holosight/go_cmore.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 2
att.HolosightBone = "holosight"

att.Mult_SightTime = 1.01

att.Colorable = true