att.PrintName = "C87 (LP)"
att.Icon = Material("entities/slog_tuna_optic_reflex.png", "mips smooth")
att.Description = "Holographic option for small arms."

att.SortOrder = 0.25

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"fortuna_optic","fortuna_optic_s"}

att.Model = "models/weapons/arccw/slog_osi_suck/att/reflex.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 12, -0.5),
        Ang = Angle(0, 0, 0),
        Magnification = 1.125,
        ScrollFunc = ArcCW.SCROLL_NONE
    }
}

att.Holosight = true
att.HolosightReticle = Material("slog_tuna_reticle/reflex.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 2.5
att.HolosightBone = "holosight"
att.Colorable = true

att.Mult_SightTime = 1.05

att.ModelScale = Vector(0.75, 0.75, 0.75)