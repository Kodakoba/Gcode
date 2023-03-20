att.PrintName = "M7 (LP)"
att.Icon = Material("entities/slog_tuna_optic_m7.png", "mips smooth")
att.Description = "Simple holographic option reminiscent of ironsight."

att.SortOrder = 0.25

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"fortuna_optic","fortuna_optic_s"}

att.Model = "models/weapons/arccw/slog_osi_suck/att/m7.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 12, -0.95),
        Ang = Angle(0, 0, 0),
        Magnification = 1.125,
        ScrollFunc = ArcCW.SCROLL_NONE
    }
}

att.Holosight = true
att.HolosightReticle = Material("slog_tuna_reticle/brokets.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 2.5
att.HolosightBone = "holosight"
att.Colorable = true

att.Mult_SightTime = 1.025

att.ModelOffset = Vector(0.15, 0, -0.15)
att.ModelScale = Vector(1.15, 1.15, 1.15)