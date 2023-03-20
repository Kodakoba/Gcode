att.PrintName = "Micro T1 (RDS)"
att.Icon = Material("entities/acwatt_go_optic_t1.png", "mips smooth")
att.Description = "Low-profile red dot sight that provides an effective aiming dot. Mounted on a riser to improve clearance."

att.SortOrder = 1

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "optic"

att.Model = "models/weapons/arccw_go/atts/t1.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 10, -1.21455),
        Ang = Angle(0, 0, 0),
        Magnification = 1.1,
        ScrollFunc = ArcCW.SCROLL_NONE,
        IgnoreExtra = false
    }
}

att.Holosight = true
att.HolosightReticle = Material("hud/holosight/go_aimpoint.png", "mips smooth")
att.HolosightSize = 0.25
att.HolosightBone = "holosight"

att.Mult_SightTime = 1.01

att.Colorable = true