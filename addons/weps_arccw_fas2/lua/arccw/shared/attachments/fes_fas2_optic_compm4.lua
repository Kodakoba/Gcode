att.PrintName = "CompM4 (RDS)"
att.Icon = Material("entities/fes_fas2_optic_compm4.png", "smooth")
att.Description = "Large tube-style optic provides a bright red reticle to ease aiming."

att.SortOrder = 1

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "optic"

att.Model = "models/weapons/arccw/mifl_atts/compm4.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 5, -2.04),
        Ang = Angle(0, 0, 0),
        Magnification = 1.2,
        ScrollFunc = ArcCW.SCROLL_NONE,
    },
}
att.Holosight = true
att.HolosightReticle = Material("mifl_fas2_reticle/dot.png" , "mips smooth")
att.HolosightFlare = Material("mifl_fas2_reticle/dot_flare.png" , "mips smooth")
att.HolosightSize = 2
att.HolosightBone = "holosight"

att.Mult_SightTime = 1.01

att.Colorable = true