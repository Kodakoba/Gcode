att.PrintName = "Trijicon RMR (LP)"
att.Icon = Material("entities/acwatt_go_optic_lp_rmr.png", "mips smooth")
att.Description = "Low-profile red dot sight for pistols with a triangular reticle."

att.SortOrder = 0

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "optic_lp"

att.Model = "models/weapons/arccw_go/atts/rmr.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 10, -1.00037),
        Ang = Angle(0, 0, 0),
        Magnification = 1.1,
        ScrollFunc = ArcCW.SCROLL_NONE,
        IgnoreExtra = false
    }
}

att.Holosight = true
att.HolosightReticle = Material("hud/holosight/go_delta.png", "mips smooth")
att.HolosightSize = 0.5
att.HolosightNoFlare = true
att.HolosightBone = "holosight"

att.Mult_SightTime = 1.01

att.Colorable = true