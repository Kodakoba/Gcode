att.PrintName = "SG1 Scope (6x)"
att.Icon = Material("entities/acwatt_go_optic_sg1.png", "mips smooth")
att.Description = "Long range optic designed specifically for the G3SG1 rifle."

att.SortOrder = 100

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "go_g3_scope"

att.Model = "models/weapons/arccw_go/atts/sg1.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0.025, -2, -8.667),
        Ang = Angle(0, 0, 0),
        Magnification = 3,
        IgnoreExtra = true
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/triple_go.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 15
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw_go/atts/sg1_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 2

att.Mult_SightTime = 1.15
att.Mult_SpeedMult = 0.95