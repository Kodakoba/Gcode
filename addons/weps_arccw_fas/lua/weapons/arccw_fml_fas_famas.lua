SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - FA:S1" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "BR 556"
SWEP.TrueName = "FAMAS"
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = "Bullpup-styled assault rifle, recognized for its insanely high rate of fire. Fitted with an usuable bipod.The Felin Conversion allowing for ultra fast firing 3 round burst"
SWEP.Trivia_Manufacturer = "GIAT Industries"
SWEP.Trivia_Calibre = "5.56x45mm NATO"
SWEP.Trivia_Country = "France"
SWEP.Trivia_Year = "1975"

SWEP.Slot = 2

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 145

SWEP.CrouchPos = Vector(-8, 2, -0.5)
SWEP.CrouchAng = Angle(0, 0, -45)

if GetConVar("arccw_truenames"):GetBool() then SWEP.PrintName = SWEP.TrueName end

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/fml/fas1/c_famas.mdl"
SWEP.WorldModel = "models/weapons/arccw/fml/fas1/w_famas.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "0"

SWEP.Damage = 33
SWEP.DamageMin = 21 -- damage done at maximum range
SWEP.Range = 80 -- in METRES
SWEP.Penetration = 8
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 25 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 60
SWEP.ReducedClipSize = 15

SWEP.Recoil = 0.5
SWEP.RecoilSide = 0.2
SWEP.RecoilRise = 0.45

SWEP.Delay = 60 / 950 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 125

SWEP.AccuracyMOA = 4.8 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 550 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 220

SWEP.Primary.Ammo = "smg1" -- what ammo type the gun uses
SWEP.MagID = "stanag" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "weapons/arccw_fml/ar_famas/famas_fire1.wav","weapons/arccw_fml/ar_famas/famas_fire2.wav","weapons/arccw_fml/ar_famas/famas_fire3.wav","weapons/arccw_fml/ar_famas/famas_fire4.wav","weapons/arccw_fml/ar_famas/famas_fire5.wav"
SWEP.ShootSoundSilenced = "weapons/arccw_fml/fas1_suppr/famas.wav"
SWEP.DistantShootSound = "weapons/arccw/famas/famas_distant_01.wav"

SWEP.MuzzleEffect = "muzzleflash_1"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 95
SWEP.ShellScale = 1.5

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.875
SWEP.SightedSpeedMult = 0.715
SWEP.SightTime = 0.295

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-4.12, -6, -0.601),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
}

SWEP.DefaultBodygroups = "0000000000000"

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, 3, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(10, -6, -4.011)
SWEP.HolsterAng = Angle(1.898, 54.613, -10.113)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 30

SWEP.AttachmentElements = {
    ["felin_cum"] = {
        VMBodygroups = {{ind = 1, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
		NameChange = "BR200",
		TrueNameChange = "Felin",	
        Override_IronSightStruct = {
            Pos = Vector(-4.12, -6, -0.6),
            Ang = Angle(-0.5, 0, 0),
            Magnification = 1.1,
        },			
		AttPosMods = {
			[1] = {
					vpos = Vector(0, -7.2, 2),
					wpos = Vector(4.762, 0.832, -5.5),
			},
			[11] = {
			        vpos = Vector(0.7, -6.3, -3),
			}				
		},
	
},
    ["mount"] = {
        VMElements = {
            {
                Model = "models/weapons/arccw/atts/mount_rail_fas1_famas.mdl",
                Bone = "Weapon_Main",
                Scale = Vector(1, 1, 1),
                Offset = {
                    pos = Vector(0, -7.2, 2),
                    ang = Angle(90, 0, -90)
                }
            }
        },
    },
    ["fml_fas1_famas_giat"] = {	
        VMBodygroups = {{ind = 2, bg = 1}},
        WMBodygroups = {},	
    },	
    ["bkrail"] = {
     VMElements = {
        {
            Model = "models/weapons/arccw/atts/backup_rail.mdl",
              Bone = "Weapon_Main",
                Offset = {
                    pos = Vector(0, -7.2, 10),
                ang = Angle(180, 90, 180),
           },
		 },
      }
    },		
}

SWEP.Hook_TranslateAnimation = function(wep, anim)
    if wep:Clip2() == 0 then
        if anim == "exit_ubgl" then
            return "exit_ubgl2"
		end	
	end		

    if wep:Clip2() == 1 then
        if anim == "enter_ubgl" then
            return "enter_ubgl2"
		end	
	end			
end

SWEP.RejectAttachments = {
    ["perk_fastreload"] = true	
}

SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot =  {"optic", "optic_lp"}, -- what kind of attachments can fit here, can be string or table
        Bone = "Weapon_Main", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0, -7.5, 2), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -90),
            wpos = Vector(4.762, 0.832, -6.1),
            wang = Angle(-10.393, 0, 180)
        },		
        InstalledEles = {"mount"},	
		ExtraSightDist = 5,		
    },
    {
        PrintName = "Backup Optic", -- print name
        Slot = {"optic_lp"}, -- what kind of attachments can fit here, can be string or table
        Bone = "Weapon_Main", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(-0.6, -7.5, 10), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -45),
            wpos = Vector(15, 0.832, -5),
            wang = Angle(-10.393, 0, -135)
        },	
        InstalledEles = {"bkrail"},		
        KeepBaseIrons = true,
		ExtraSightDist = 8,
        ExcludeFlags = {"felin"},			
    },		
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = {"muzzle", "fas1_famas_grenadier"},
        Bone = "Weapon_Main",
        Offset = {
            vpos = Vector(0.1, -3.4, 17),
            vang = Angle(90, 0, -90),
            wpos = Vector(16.2, 0.847, -5.3),
            wang = Angle(-10.393, 0, 180)
        },
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip", "ubgl", "bipod"},
        Bone = "Weapon_Main",
        Offset = {
            vang = Angle(90, 0, -90),
            wang = Angle(-10.216, 0, 180)
        },
        SlideAmount = {
            vmin = Vector(0, -1.5, 8),
            vmax = Vector(0,-1.5, 12),
            wmin = Vector(10, 0.832, -3),
            wmax = Vector(10, 0.832, -3),
        }
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "Weapon_Main",
        Offset = {
            vpos = Vector(1, -3, 12), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, 0),
            wpos = Vector(12, -0.253, -4),
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
        DefaultAttName = "Standard FCG",
        MergeSlots = {12},		
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
        Bone = "Weapon_Main",
        Offset = {
            vpos = Vector(0.7, -4.8, -2.8),
            vang = Angle(90, 0, -90),
            wpos = Vector(4, 1, -3),
            wang = Angle(-9, 0, 180)
        },
		FreeSlot = true,
    },		
    {
        Hidden = true,
        Slot = "fas1_felin",
		FreeSlot = true,	
        GivesFlags = {"felin"},			
    },		
}

SWEP.Animations = {
    ["idle"] = false,
    ["draw"] = {
        Source = "draw",
        Time = 35/60,
        SoundTable = {{s = "weapons/arccw/ak47/ak47_draw.wav", t = 0}},
        LHIK = true,
        LHIKIn = 1,
        LHIKOut = 1,
    },
    ["ready"] = {
        Source = "deploy",
        Time = 75/60,		
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.25,
    },
    ["fire"] = {
        Source = {"fire"},
        Time = 30/60,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "iron",
        Time = 30/60,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "wet",
        Time = 170/60,	
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71},
        FrameRate = 37,
        LHIK = false,
        LHIKIn = 0.35,
        LHIKOut = 0.6,
    },
    ["reload_empty"] = {
        Source = "dry_nor",
        Time = 225/60,		
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71, 89},
        FrameRate = 37,
        LHIK = false,
        LHIKIn = 0.35,
        LHIKOut = 0.6,
    },
    ["reload_empty_felin"] = {
        Source = "dry",
        Time = 225/60,		
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71, 89},
        FrameRate = 37,
        LHIK = false,
        LHIKIn = 0.35,
        LHIKOut = 0.6,
    },	
    ["reload_soh"] = {
        Source = "soh_wet",
        Time = 120/60,	
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71, 89},
        FrameRate = 37,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.3,
    },
    ["reload_empty_soh"] = {
        Source = "soh_dry_nor",
        Time = 160/60,		
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71, 89},
        FrameRate = 37,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.3,
    },	
    ["reload_empty_soh_felin"] = {
        Source = "soh_dry",
        Time = 160/60,		
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71, 89},
        FrameRate = 37,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.3,
    },		
    ["enter_ubgl"] = {
        Source = "idle",
        Time = 1/60,	
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.35,
        LHIKOut = 0.3,
    },	
    ["enter_ubgl2"] = {
        Source = "gl_equip",
        Time = 120/60,	
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.35,
        LHIKOut = 0.5,
    },		
    ["exit_ubgl"] = {
        Source = "gl_deequip",
        Time = 100/60,	
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.35,
        LHIKOut = 0.5,
    },		
    ["exit_ubgl2"] = {
        Source = "idle",
        Time = 1/60,	
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.35,
        LHIKOut = 0.3,
    },			
}