att.PrintName = "FAS1 Aimpoint (RDS)"
att.Icon = Material("entities/arrcw_fml_fas1_aimpoint.png")
att.Description = "Reflex sight designed for rifles."
att.Desc_Pros = {
    "+Precision sight picture",
}
att.Desc_Cons = {
}
att.Slot = "optic"

att.AutoStats = true

att.Model = "models/weapons/arccw/fml_atts/fas1/optic_eotech.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 5, -1.35),
        Ang = Angle(0, 0, 0),
        Magnification = 1.1,
        ScrollFunc = ArcCW.SCROLL_NONE
    }
}

att.AutoStats = true

att.Holosight = true
att.HolosightReticle = Material("holosights/mw_kobra.png")
att.HolosightNoFlare = true
att.HolosightSize = 1
att.HolosightBone = "holosight"

att.Mult_SightTime = 1.07

att.Colorable = false

att.HolosightColor = Color(168, 255, 101)