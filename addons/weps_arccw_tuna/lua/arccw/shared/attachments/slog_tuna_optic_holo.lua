att.PrintName = "E33 (Holo)"
att.Icon = Material("entities/slog_tuna_optic_holo.png", "mips smooth")
att.Description = "Boxy holographic sight."

att.SortOrder = 1

att.Desc_Pros = {
    "autostat.holosight",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"fortuna_optic"}

att.Model = "models/weapons/arccw/slog_osi_suck/att/holo.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 9, -1.4),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        ScrollFunc = ArcCW.SCROLL_NONE
    }
}

att.Holosight = true
att.HolosightReticle = Material("slog_tuna_reticle/holo.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 4
att.HolosightBone = "holosight"
att.Colorable = true

att.Mult_SightTime = 1.075

att.ModelScale = Vector(0.75, 0.75, 0.75)
att.ModelOffset = Vector(0.35, 0, 0)