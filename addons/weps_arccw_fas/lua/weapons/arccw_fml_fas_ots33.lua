SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - FA:S1" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "SBZ-2"
SWEP.TrueName = "OTs-33"
SWEP.Trivia_Class = "Pistol"
SWEP.Trivia_Desc = "Derived from the 5.45mm OTs-23 Drotik machine pistol, the Pernach is an automatic pistol designed to replace the Stechkin APS in various special OMON units within the Russian police, the MVD and other paramilitary units"
SWEP.Trivia_Manufacturer = "KBP Instrument Design Bureau"
SWEP.Trivia_Calibre = "9×18mm Soviet"
SWEP.Trivia_Country = "Russia"
SWEP.Trivia_Year = "1996"

SWEP.Slot = 1

SWEP.CrouchPos = Vector(-4.5, 0, -1)
SWEP.CrouchAng = Angle(0, 0, -30)

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 150

if GetConVar("arccw_truenames"):GetBool() then SWEP.PrintName = SWEP.TrueName end

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/fml/fas1/c_ots33.mdl"
SWEP.WorldModel = "models/weapons/arccw/fml/fas1/w_ots33.mdl"
SWEP.ViewModelFOV = 70

SWEP.Damage = 22
SWEP.DamageMin = 13-- damage done at maximum range
SWEP.Range = 30 -- in METRES
SWEP.Penetration = 2
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 330 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = false

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 18 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 27
SWEP.ReducedClipSize = 12

SWEP.Recoil = 0.8
SWEP.RecoilSide = 0.15
SWEP.RecoilRise = 0.2
SWEP.VisualRecoilMult = 0.3

SWEP.Delay = 60 / 1000 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.

SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 0
    }
}

SWEP.AccuracyMOA = 12 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 150

SWEP.Primary.Ammo = "pistol" -- what ammo type the gun uses
SWEP.MagID = "ppa" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "weapons/arccw_fml/pistol_ots33/ots33_fire1.wav", "weapons/arccw_fml/pistol_ots33/ots33_fire2.wav", "weapons/arccw_fml/pistol_ots33/ots33_fire3.wav", "weapons/arccw_fml/pistol_ots33/ots33_fire4.wav","weapons/arccw_fml/pistol_ots33/ots33_fire5.wav"
SWEP.ShootSoundSilenced = "weapons/arccw_fml/fas1_suppr/glock20.wav"
SWEP.DistantShootSound = "weapons/arccw/glock18/glock18-1-distant.wav"

SWEP.MuzzleEffect = "muzzleflash_pistol"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellScale = 1.5

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SightTime = 0.2

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.75

SWEP.BarrelLength = 18

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-1.721, -2, 0.56),
    Ang = Angle(0.514, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.ActivePos = Vector(0, 2, 0.5)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(2, -1.5, -5)
SWEP.HolsterAng = Angle(30.833, 1.792, -1.269)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 2

SWEP.RejectAttachments = {
    ["perk_fastreload"] = true	
}

SWEP.AttachmentElements = {
    ["roni_conv"] = {
		NameChange = "Roni AP33",
		TrueNameChange = "Roni OTs-33",	
		Override_ActivePos = Vector(0, 3, -2),
		Override_ActiveAng = Angle(0, 0, 0),			
        Override_IronSightStruct = {
			Pos = Vector(-2.662, -1.5, -3),
			Ang = Angle(0.349, 0, 0),
            Magnification = 1.1,
        },				
		AttPosMods = {
			[1] = {
					bone = "deagle",			
					vpos = Vector(0, -3, 1),
					wpos = Vector(4.762, 0.832, -5.5),
			},
			[12] = {
					bone = "deagle",			
					vpos = Vector(0, -3, 1),
					wpos = Vector(4.762, 0.832, -5.5),
			},			
			[2] = {
            vpos = Vector(0, -3.2, 12),
			}				
		},
	
},
    ["stock"] = {
        VMElements = {
            {
                Model = "models/weapons/arccw/atts/stock_fab.mdl",
				Bone = "Weapon_Main",
                Offset = {
                    pos = Vector(0, 2, -1),
                    ang = Angle(90 , 0, -90)
                }
            }
        },
        WMElements = {
            {
                Model = "models/weapons/arccw/atts/stock_fab.mdl",
                Offset = {
                    pos = Vector(0, 1, 0),
                    ang = Angle(0, -4.211, 0)
                }
            }
        }
    }
}

SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = "optic_lp", -- what kind of attachments can fit here, can be string or table
        Bone = "Weapon_Bolt", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0, -0.8, -1), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -90),
            wpos = Vector(5.36, 0.739, -3.5),
            wang = Angle(-10, 0, 180)
        },			
		ExtraSightDist = 6		
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "Weapon_Main",
        Offset = {
            vpos = Vector(0, -2, 8.5),
            vang = Angle(90, 0, -90),
            wpos = Vector(27, 0.5, -9.1),
            wang = Angle(-9.79, 0, 180)
        },
    },	
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip_pistol", "style_pistol"},
        Bone = "Weapon_Main",
        Offset = {
            vpos = Vector(0, -1.5, 3.8),
            vang = Angle(90,0, -90),
            wpos = Vector(9, 0.602, -2.5),
            wang = Angle(-10.216, 0, 180)
        },		
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "Weapon_Bolt",
        Offset = {
            vpos = Vector(-0.65, 0, 0), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, 180),
            wpos = Vector(15.625, -0.253, -6.298),
            wang = Angle(-8.829, -0.556, 90)
        },
    },
    {
        PrintName = "Grip",
        Slot = "grip",
        DefaultAttName = "Standard Grip"
    },
    {
        PrintName = "Stock",
        Slot = "stock",
        DefaultAttName = "Standard Stock"
    },
    {
        PrintName = "Fire Group",
        Slot = "fcg",
        DefaultAttName = "Standard FCG"
    },
    {
        PrintName = "Ammo Type",
        Slot = {"ammo_bullet"}
    },
    {
        PrintName = "Perk",
        Slot = {"perk", "perk_fas"}
    },	
    {
        PrintName = "Charm",
        DefaultAttName = "None",
        Slot = {"fml_charm", "charm"},
        Bone = "Weapon_Bolt",
        Offset = {
            vpos = Vector(0.5, -0.2, -0.2),
            vang = Angle(90, 0, -90),
            wpos = Vector(8, 1, -3),
            wang = Angle(-9, 0, 180)
        },
		FreeSlot = true,
    },	
}


SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 1,
    },
    ["idle_empty"] = {
        Source = "idle_empty",
        Time = 1,
    },
    ["ready"] = {
        Source = "deploy",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
    },
    ["draw_empty"] = {
        Source = "draw_empty",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 1,		
        SoundTable = {
            {
            s = "weapons/arccw/usp/usp_draw.wav",
            t = 0
            }
        },
    },
    ["draw"] = {
        Source = "draw",
        LHIK = true,
        LHIKIn = 1,
        LHIKOut = 1,		
        SoundTable = {
            {
            s = "weapons/arccw/usp/usp_draw.wav",
            t = 0
            }
        },
    },
    ["fire"] = {
        Source = "fire",
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "fire_empty",
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "iron",
        Time = 40/60,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "iron_empty",
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "wet",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Checkpoints = {36, 57, 77},
        FrameRate = 60,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.3,
    },
    ["reload_empty"] = {
        Source = "dry",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Checkpoints = {36, 57, 77, 88},
        FrameRate = 60,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.3,
    },
    ["reload_soh"] = {
        Source = "soh_wet",
        Time = 105/60,	
        Checkpoints = {24, 42, 59, 71, 89},
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,		
        FrameRate = 60,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.3,
    },
    ["reload_empty_soh"] = {
        Source = "soh_dry",
        Time = 110/60,		
        Checkpoints = {24, 42, 59, 71, 89},
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,		
        FrameRate = 60,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.3,
    },		
}