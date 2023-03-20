att.PrintName = "ACOG TA50 (3x)"
att.Icon = Material("entities/acwatt_go_optic_acog2.png", "mips smooth")
att.Description = "Lower-magnification magnified gunsight. Lacks a backup iron sight."

att.SortOrder = 3

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "optic"

att.Model = "models/weapons/arccw_go/atts/acog2.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 7.5, -1.370),
        Ang = Angle(0, 0, 0),
        Magnification = 1.5,
        IgnoreExtra = true
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/acog_go.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 15
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw_go/atts/acog2_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 2

att.Mult_SightTime = 1.1
att.Mult_SpeedMult = 0.95