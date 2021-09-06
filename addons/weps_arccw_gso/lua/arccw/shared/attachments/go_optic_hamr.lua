att.PrintName = "Leupold HAMR (HYBR)"
att.Icon = Material("entities/acwatt_go_optic_hamr.png", "mips smooth")
att.Description = "Zoom scope with integrated red dot sight. Slightly heavier than similar scopes."

att.SortOrder = 2.5

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Cons = {
}

att.AutoStats = true
att.Slot = "optic"

att.Model = "models/weapons/arccw_go/atts/hamr.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 9, -1.56325),
        Ang = Angle(0, 0, 0),
        Magnification = 2,
        ScopeMagnification = 3,
        HolosightBone = "scope",
        HolosightData = {
            Holosight = true,
            HolosightMagnification = 2,
            HolosightReticle = Material("hud/scopes/hamr_go.png", "mips smooth"),
            HolosightNoFlare = true,
            HolosightSize = 12,
            HolosightBlackbox = true,
            Colorable = true,
            HolosightPiece = "models/weapons/arccw/atts/hamr_hsp.mdl"
        },
        IgnoreExtra = true,
    },
    {
        Pos = Vector(0, 10, -2.94738),
        Ang = Angle(0, 0, 0),
        Magnification = 1.5,
        HolosightBone = "holosight",
        HolosightData = {
            Holosight = true,
            HolosightReticle =  Material("hud/holosight/go_aimpoint.png", "mips smooth"),
            HolosightSize = 0.25,
            Colorable = true,
            HolosightNoHSP = true
        },
        IgnoreExtra = true
    },
}

att.Holosight = true
att.HolosightPiece = "models/weapons/arccw_go/atts/hamr_hsp.mdl"

att.Mult_SightTime = 1.15
att.Mult_SpeedMult = 0.925