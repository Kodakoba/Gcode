att.PrintName = "Hunter Compact (2.5x)"
att.Icon = Material("entities/acwatt_go_optic_hunter.png", "mips smooth")
att.Description = "Reduced size scope for pistols and light rifles."

att.SortOrder = 2.5

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"optic", "optic_lp"}

att.Model = "models/weapons/arccw_go/atts/hunter.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 12, -1.43061),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        IgnoreExtra = true
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/ssr_go.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 20
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw_go/atts/hunter_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 2.5

att.Mult_SightTime = 1.1
att.Mult_SpeedMult = 0.975