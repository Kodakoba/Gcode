att.PrintName = "High Power Scope (2-8x)"
att.Icon = Material("entities/arrcw_fml_fas1_m82s.png")
att.Description = "Sniper rifle optic with the ability to be adjusted between long and medium range magnification options."

att.SortOrder = 2000
att.Ignore = true

att.Desc_Pros = {
    "+ Precision sight picture",
    "+ Zoom",
}
att.Desc_Cons = {
    "- Visible scope glint",
}

att.ModelOffset = Vector(-1.5, 0, 0)

att.AutoStats = true
att.Slot = "optic_fas1_m82"

att.Model = "models/weapons/arccw/fml_atts/fas1/optic_m82.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 20, -1.25),
        Ang = Angle(0, 0, 0),
        Magnification = 1.5,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 8,
        ZoomSound = "weapons/arccw/fiveseven/fiveseven_slideback.wav",
        IgnoreExtra = true
    }
}

att.ScopeGlint = true

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/rangefinder.png")
att.HolosightNoFlare = true
att.HolosightSize = 3.2
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/fml_atts/fas1/optic_m82_hsp.mdl"
att.Colorable = true

att.HolosightMagnification = 3
att.HolosightBlackbox = true

att.HolosightMagnificationMin = 2
att.HolosightMagnificationMax = 8

att.Mult_SightTime = 1
att.Mult_SightedSpeedMult = 0.7
att.Mult_SpeedMult = 0.94