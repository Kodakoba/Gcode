att.PrintName = "Micro T1 (LP)"
att.Icon = Material("entities/acwatt_go_optic_t1lp.png", "mips smooth")
att.Description = "Low-profile red dot sight that provides an effective aiming dot, mounted on a low-profile rail."

att.SortOrder = 0

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "optic_lp"

att.Model = "models/weapons/arccw_go/atts/t1lp.mdl"

att.InvAtt = "go_optic_t1"

att.AdditionalSights = {
    {
        Pos = Vector(0, 10, -0.815288),
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