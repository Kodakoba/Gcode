att.PrintName = "M4A1 (Carry Handle)"
att.Icon = Material("entities/arccw_fml_fas1_m4a1.png")
att.Description = "M4A1 carry handle for ultra gamer precision."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "+Good luck hitting anything beyond 20m",
}
att.Slot = "optic"

att.AutoStats = true

att.ModelOffset = Vector(1.5, 0, 0)

att.Model = "models/weapons/arccw/fml_atts/fas1/optic_m4a1.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 4, -1.625),
        Ang = Angle(0, 0, 0),
        Magnification = 1.1,
        ScrollFunc = ArcCW.SCROLL_NONE
    }
}

att.AutoStats = true

att.Holosight = true

att.Mult_SightTime = 0.98