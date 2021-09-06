att.PrintName = "PVS-4 (2xIR)"
att.Icon = Material("entities/acwatt_go_optic_pvs4.png", "mips smooth")
att.Description = "Bulky, low-zoom night vision image intensifying optic that picks up infrared light as yellow, highlighting hot targets."

att.SortOrder = 102

att.Desc_Pros = {
    "autostat.thermal",
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "optic"

att.Model = "models/weapons/arccw_go/atts/pvs4.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 12, -1.70029),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        IgnoreExtra = true,
        Thermal = true,
        ThermalScopeColor = Color(0, 255, 0),
        ThermalHighlightColor = Color(255, 255, 0),
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/pvs4_go.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 10
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw_go/atts/pvs4_hsp.mdl"
att.Colorable = false
att.HolosightColor = Color(0, 255, 0)

att.HolosightBlackbox = true

att.HolosightMagnification = 2

att.Mult_SightTime = 1.5
att.Mult_SpeedMult = 0.875