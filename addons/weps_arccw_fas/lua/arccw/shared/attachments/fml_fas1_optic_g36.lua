att.PrintName = "Integrated Scope (2-4x)"
att.Icon = Material("entities/arccw_fml_fas1_g36_scope.png")
att.Description = "G36 Optic. Switch between irons and optic with 2x +USE"

att.SortOrder = 200

att.Desc_Pros = {
    "+ Poop",
    "+ Why are you reading this",	
}
att.Desc_Cons = {
    "- Arctic very gay",
}
att.Slot = "optic_fas1_g36"

att.AutoStats = true

att.Model = "models/weapons/arccw/fml_atts/fas1_zf_fake.mdl"

att.AdditionalSights = {
    {
        Pos = Vector(0, 9, -0.5),
        Magnification = 1.25,
        ScrollFunc = ArcCW.SCROLL_ZOOM,
        ZoomLevels = 3,
        ZoomSound = "weapons/arccw/fiveseven/fiveseven_slideback.wav",
        HolosightBone = "holosight",
        HolosightData = {
            Holosight = true,
            HolosightMagnification = 2.7,
            HolosightReticle = Material("holosights/g36c.png"),
            HolosightNoFlare = true,
            HolosightSize = 5,
            HolosightBlackbox = true,
            Colorable = true,
            HolosightPiece = "models/weapons/arccw/fml_atts/fas1_zf_hsp.mdl"
	      },
        IgnoreExtra = true		  
    },
    {
        Pos = Vector(0, 7.5, -1.5),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        HolosightBone = "holosight",
        HolosightData = {
            Holosight = true,
            HolosightReticle =  Material("holosights/dot.png"),
            HolosightSize = 0.75,
            Colorable = true,
            HolosightNoHSP = false
        }
    },
}

att.ScopeGlint = true

att.Holosight = true
att.HolosightPiece = "models/weapons/arccw/fml_atts/fas1_zf_hsp.mdl"
att.ActivateElements = {"scope_u"}

att.Mult_SightTime = 1.15
att.Mult_SightedSpeedMult = 0.85
att.Mult_SpeedMult = 0.98

att.ColorOptionsTable = {
    Color(255, 50, 50),
    Color(50, 255, 50)
}