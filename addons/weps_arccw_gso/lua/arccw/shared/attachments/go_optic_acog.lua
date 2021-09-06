att.PrintName = "ACOG TA01 (4x)"
att.Icon = Material("entities/acwatt_go_optic_acog.png", "mips smooth")
att.Description = "Magnified medium-range optic. ACOG stands for 'Advanced Combat Optical Gunsight'. Has a backup iron sight that can be used in a pinch."

att.SortOrder = 4

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "optic"

att.Model = "models/weapons/arccw_go/atts/acog.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 9, -1.292),
        Ang = Angle(0, 0, 0),
        Magnification = 2,
        IgnoreExtra = true
    },
    {
        Pos = Vector(0, 9, -2.508),
        Ang = Angle(0.774, 0, 0),
        Magnification = 1.1,
        HolosightData = {
            Holosight = false
        }
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/acog2_go.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 15
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw_go/atts/acog_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 2

att.Mult_SightTime = 1.1
att.Mult_SpeedMult = 0.95