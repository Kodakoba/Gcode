att.PrintName = "Arctic Warfare (10x)"
att.Icon = Material("entities/acwatt_go_optic_awp.png", "mips smooth")
att.Description = "Long-range optic used for military and police snipers in cold weather conditions."

att.SortOrder = 10

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "optic"

att.Model = "models/weapons/arccw_go/atts/awp.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 11, -1.58597),
        Ang = Angle(0, 0, 0),
        Magnification = 5,
        IgnoreExtra = true
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/ssr_go.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 20
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw_go/atts/awp_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 2

att.Mult_SightTime = 1.25
att.Mult_SpeedMult = 0.925