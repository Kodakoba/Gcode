SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - FA:S1" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "D50"
SWEP.TrueName = "Deagle"
SWEP.Trivia_Class = "Pistol"
SWEP.Trivia_Desc = "Semi-automatic pistol notable for chambering the largest centerfire cartridge of any magazine-fed, self-loading pistol. Since 2009, the Desert Eagle Pistol has been produced in the United States at MRI's Pillager, Minnesota facility. Kahr Arms acquired Magnum Research in 2010."
SWEP.Trivia_Manufacturer = "Magnum Research"
SWEP.Trivia_Calibre = ".50 Action Express"
SWEP.Trivia_Mechanism = "Gas-operated, Rotating Bolt"
SWEP.Trivia_Country = "United States"
SWEP.Trivia_Year = "1982"

SWEP.Slot = 1

if GetConVar("arccw_truenames"):GetBool() then SWEP.PrintName = SWEP.TrueName end

SWEP.NPCWeaponType = "weapon_357"
SWEP.NPCWeight = 80

SWEP.UseHands = true

SWEP.CrouchPos = Vector(-4.5, 3, -1)
SWEP.CrouchAng = Angle(0, 0, -30)

SWEP.ViewModel = "models/weapons/arccw/fml/fas1/c_deagle.mdl"
SWEP.WorldModel = "models/weapons/arccw/fml/fas1/w_deagle.mdl"
SWEP.ViewModelFOV = 70

SWEP.DefaultSkin = 1

SWEP.Damage = 79
SWEP.DamageMin = 43 -- damage done at maximum range
SWEP.Range = 40 -- in METRES
SWEP.Penetration = 9
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 500 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = false

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 7 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 12
SWEP.ReducedClipSize = 5

SWEP.Recoil = 2
SWEP.RecoilSide = 0.7
SWEP.RecoilRise = 1.1
SWEP.MaxRecoilBlowback = 2.2

SWEP.Delay = 60 / 450 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 250 -- inaccuracy added by hip firing.

SWEP.Primary.Ammo = "357" -- what ammo type the gun uses
SWEP.MagID = "gce" -- the magazine pool this gun draws from

SWEP.ShootVol = 130 -- volume of shoot sound
SWEP.ShootPitch = 95 -- pitch of shoot sound

SWEP.ShootSound = "weapons/arccw_fml/pistol_deserteagle/de_fire1.wav"
SWEP.ShootSound = "weapons/arccw_fml/pistol_deserteagle/de_fire2.wav", "weapons/arccw_fml/pistol_deserteagle/de_fire3.wav", "weapons/arccw_fml/pistol_deserteagle/de_fire4.wav","weapons/arccw_fml/pistol_deserteagle/de_fire5.wav"
SWEP.DistantShootSound = "weapons/arccw/deagle/deagle-1-distant.wav"
SWEP.ShootSoundSilenced = "weapons/arccw_fml/fas1_suppr/deagle.wav"

SWEP.MuzzleEffect = "muzzleflash_pistol_deagle"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellScale = 2
SWEP.ShellPitch = 85

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SightTime = 0.275

SWEP.SpeedMult = 0.975
SWEP.SightedSpeedMult = 0.65

SWEP.BarrelLength = 18

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-2.201, 0, 0.097),
    Ang = Angle(0.842, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER

SWEP.ActivePos = Vector(0.2, 5, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(2.276, -1.167, -8.44)
SWEP.HolsterAng = Angle(30.833, 1.792, -1.269)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 5

SWEP.AttachmentElements = {
    ["roni_conv"] = {
		NameChange = "Roni D50",
		TrueNameChange = "Roni Deagle",	
		Override_ActivePos = Vector(0, 3, -2),
		Override_ActiveAng = Angle(0, 0, 0),		
        Override_IronSightStruct = {
		Pos = Vector(-2.201, 0, -3),
		Ang = Angle(0.842, 0, 0),
            Magnification = 1.1,
        },				
		AttPosMods = {
			[2] = {
					vpos = Vector(0, -5.7, 2),
					wpos = Vector(4.762, 0.832, -5.5),
			},
			[13] = {
					vpos = Vector(0, -5.7, 2),
					wpos = Vector(4.762, 0.832, -5.5),
			},			
			[3] = {
            vpos = Vector(0, -3.15, 11),
			}				
		},
	
},
    ["stock"] = {
        VMElements = {
            {
                Model = "models/weapons/arccw/atts/stock_fab.mdl",
                Bone = "deagle",
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

SWEP.RejectAttachments = {
    ["perk_fastreload"] = true	
}

SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = "optic_lp", -- what kind of attachments can fit here, can be string or table
        Bone = "deagle", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0, -4.1, 7), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -90),
            wpos = Vector(5, 0.739, -3.8),
            wang = Angle(-10, 0, 180)
        },
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "deagle",
        Offset = {
            vpos = Vector(0, -3.15, 10.5),
            vang = Angle(90, 0, -90),
            wpos = Vector(12, 0.782, -3.75),
            wang = Angle(-9.79, 0, 180)
        },	
    },	
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip_pistol", "style_pistol"},
        Bone = "deagle",
        Offset = {
            vpos = Vector(0, -2.5, 4.2),
            vang = Angle(90,0, -90),
            wpos = Vector(8, 0.602, -2),
            wang = Angle(-10.216, 0, 180)
        },	
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "deagle",
        Offset = {
            vpos = Vector(-0.65, -3.5, 5), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, 180),
            wpos = Vector(6, -0.253, -3.75),
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
        Slot = {"perk", "perk_fas"},		
    },	
    {
        PrintName = "Charm",
        DefaultAttName = "None",
        Slot = {"fml_charm", "charm"},
        Bone = "deagle",
        Offset = {
            vpos = Vector(0.5, -3, 9),
            vang = Angle(90, 0, -90),
            wpos = Vector(10, 1, -3.5),
            wang = Angle(-9, 0, 180)
        },
		FreeSlot = true,
    },		
    {
		Hidden = true,
        Slot = {"roni_standalone"},
        Bone = "deagle",
        Offset = {
            vpos = Vector(0, -2.5, 4.2),
            vang = Angle(90,0, -90),
            wpos = Vector(8, 0.602, -2),
            wang = Angle(-10.216, 0, 180)
        },
        GivesFlags = {"fml_roni_conversion_kit"},			
    },	
    {
		Hidden = true,
        Slot = "optic", -- what kind of attachments can fit here, can be string or table
        Bone = "deagle", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0, -4.1, 7), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -90),
            wpos = Vector(5, 0.739, -3.8),
            wang = Angle(-10, 0, 180)
        },
        RequireFlags = {"fml_roni_conversion_kit"},	
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
        Time = 55/60,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
    },
    ["draw_empty"] = {
        Source = "draw_empty",
        Time = 30/60,
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
        Time = 30/60,
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
        Time = 40/60,
        ShellEjectAt = 0,
    },
    ["fire_empty"] = {
        Source = "fire_empty",
        Time = 40/60,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "iron",
        Time = 40/60,
        ShellEjectAt = 0,
    },
    ["fire_iron_empty"] = {
        Source = "iron_empty",
        Time = 40/60,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "wet",
        Time = 135/60,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Checkpoints = {36, 57, 77},
        FrameRate = 60,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.3,
    },
    ["reload_empty"] = {
        Source = "dry",
        Time = 175/60,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Checkpoints = {36, 57, 77, 88},
        FrameRate = 60,
        LHIK = true,
        LHIKIn = 0.1,
        LHIKOut = 0.25,
    },
    ["reload_empty_roni"] = {
        Source = "dry_roni",
        Time = 175/60,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Checkpoints = {36, 57, 77, 88},
        FrameRate = 60,
        LHIK = true,
        LHIKIn = 0.1,
        LHIKOut = 0.25,
    },	
    ["reload_soh"] = {
        Source = "soh_wet",
        Time = 95/60,	
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71, 89},
        FrameRate = 37,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.3,
    },
    ["reload_empty_soh"] = {
        Source = "soh_dry",
        Time = 120/60,		
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71, 89},
        FrameRate = 37,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.3,
    },		
}