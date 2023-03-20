att.PrintName = "ELCAN C79 (3.5x)"
att.Icon = Material("entities/acwatt_go_optic_elcan.png", "mips smooth")
att.Description = "Magnified precision combat optic for light machine guns. Provides effective magnification."

att.SortOrder = 3.5

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "optic"

att.Model = "models/weapons/arccw_go/atts/elcan.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 9, -1.51577),
        Ang = Angle(0, 0, 0),
        Magnification = 1.75,
        IgnoreExtra = true
    },
    {
        Pos = Vector(0, 9, -2.75),
        Magnification = 1.1,
        HolosightData = {
            Holosight = false
        }
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/elcan_go.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 11
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw_go/atts/elcan_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 2

att.Mult_SightTime = 1.1
att.Mult_SpeedMult = 0.95