att.PrintName = "LPVO Scope (8x)"
att.Icon = Material("entities/acwatt_go_optic_ssr.png", "mips smooth")
att.Description = "Low Power Variable Optic with the ability to adjust its zoom level depending on the situation."

att.SortOrder = 8

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "optic"

att.Model = "models/weapons/arccw_go/atts/ssr.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 12, -1.95),
        Ang = Angle(0, 0, 0),
        Magnification = 4,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        IgnoreExtra = true,
        ZoomLevels = 6,
        ZoomSound = "arccw_go/fiveseven/fiveseven_slideback.wav",
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/ssr_go.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 20
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw_go/atts/ssr_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 2
att.HolosightMagnificationMin = 1.01
att.HolosightMagnificationMax = 2

att.Mult_SightTime = 1.2
att.Mult_SpeedMult = 0.925