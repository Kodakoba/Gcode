att.PrintName = "EOTech 553 (RDS)"
att.Icon = Material("entities/acwatt_go_optic_eotech.png", "mips smooth")
att.Description = "Boxy holographic sight for long rifles."

att.SortOrder = 1

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "optic"

att.Model = "models/weapons/arccw_go/atts/eotech.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0.025, 10, -1.13633) * 1.25,
        Ang = Angle(0, 0, 0),
        Magnification = 1.1,
        ScrollFunc = ArcCW.SCROLL_NONE,
        IgnoreExtra = false
    }
}

att.ModelScale = Vector(1.25, 1.25, 1.25)
att.ModelOffset = Vector(0, -0.05, 0)

att.Holosight = true
att.HolosightReticle = Material("hud/holosight/go_eotech.png", "mips smooth")
att.HolosightSize = 1
att.HolosightBone = "holosight"
att.HolosightNoFlare = true

att.Mult_SightTime = 1.01

att.Colorable = true