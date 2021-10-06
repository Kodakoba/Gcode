SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - Danger Armory" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "KH29A2"
SWEP.TrueName = "HK94A2"
SWEP.Trivia_Class = "Semi-Automatic Carbine"
SWEP.Trivia_Desc = "The HK94 is an American import model of the famous MP5 submachine gun. It has an exposed 16.54-inch [420mm] barrel and usually a special SF (safe/semi-automatic) trigger group, designed for civilian use. This is a special version with a retrofitted barrel shroud for comestic purposes and cannot be fitted with any muzzle attachment due to said barrel."
SWEP.Trivia_Manufacturer = "Heckler & Koch"
SWEP.Trivia_Calibre = "9×19mm Para"
SWEP.Trivia_Country = "(West) Germany"
SWEP.Trivia_Year = "1966"

if GetConVar("arccw_truenames"):GetBool() then SWEP.PrintName = SWEP.TrueName end

SWEP.Slot = 2

SWEP.NPCWeaponType = "weapon_smg1"
SWEP.NPCWeight = 150

SWEP.DefaultBodygroups = "0000000000"

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/dm1973/c_dmi_pms_hk94a2.mdl"
SWEP.WorldModel = "models/weapons/arccw/dm1973/w_dmi_pms_hk94a2.mdl"
SWEP.ViewModelFOV = 70

SWEP.CrouchPos = Vector(-5.8, 2, -0.5)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.Damage = 27
SWEP.DamageMin = 21 -- damage done at maximum range
SWEP.Range = 30 -- in METRES
SWEP.Penetration = 4
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 430 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.CanFireUnderwater = false

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 15 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 30
SWEP.ReducedClipSize = 10

SWEP.Recoil = 0.4
SWEP.RecoilSide = 0.275
SWEP.RecoilRise = 0.3

SWEP.Delay = 60 / 800 -- 60 / RPM.
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
SWEP.HipDispersion = 270 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 200

SWEP.Primary.Ammo = "pistol" -- what ammo type the gun uses
SWEP.MagID = "mk201" -- the magazine pool this gun draws from

SWEP.ShootVol = 100 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.FirstShootSound = "weapons/arccw/dmi_gunsdefense_2/10mm_smg1.wav"
SWEP.ShootSound = "weapons/arccw/dmi_gunsdefense_2/10mm_smg2.wav", "weapons/arccw/dmi_gunsdefense_2/10mm_smg3.wav"
SWEP.ShootSoundSilenced = "weapons/arccw_fml/fas1_suppr/mp5.wav"
SWEP.DistantShootSound = "weapons/arccw/Weapon_Rotate/Weapon_Rotate-1-distant.wav"

SWEP.MuzzleEffect = "muzzleflash_1"
SWEP.ShellModel = "models/shells/shell_9mm.mdl"
SWEP.ShellScale = 1.5

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SightTime = 0.235

SWEP.SpeedMult = 0.8
SWEP.SightedSpeedMult = 0.775

SWEP.BarrelLength = 24

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-3.507, -4, 0.33),
    Ang = Angle(0.8, -0.16, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, 4, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(10, -6, -4.011)
SWEP.HolsterAng = Angle(1.898, 54.613, -10.113)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.ExtraSightDist = 3

SWEP.RejectAttachments = {
    ["perk_fastreload"] = true
}

SWEP.AttachmentElements = {
    ["ammo_bullet"] = {
        ExcludeFlags = {"perk_cmags"},
    },
    ["hk94_fg"] = {
        VMBodygroups = {{ind = 6, bg = 1}},
        WMBodygroups = {{ind = 6, bg = 1}},		
    },
    ["mount"] = {
        VMBodygroups = {{ind = 5, bg = 1},{ind = 1, bg = 1}},
        WMBodygroups = {{ind = 5, bg = 1},{ind = 1, bg = 1}},		
    },
	["extendedmag"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
        WMBodygroups = {{ind = 3, bg = 1}},		
    },
    ["stock_re"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
		WMBodygroups = {{ind = 4, bg = 1}},				
	},
	["stock_strafe"] = {
        VMBodygroups = {{ind = 4, bg = 2}},
		WMBodygroups = {{ind = 4, bg = 2}},	
    },
	
	["stock_skeleton"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
		WMBodygroups = {{ind = 4, bg = 1}},	
    },

	["stock_light"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
		WMBodygroups = {{ind = 4, bg = 1}},	
    },
	
	["stock_heavy"] = {
        VMBodygroups = {{ind = 4, bg = 0}},
		WMBodygroups = {{ind = 4, bg = 0}},	
    },
	["stock_sturdy"] = {
        VMBodygroups = {{ind = 4, bg = 0}},
		WMBodygroups = {{ind = 4, bg = 0}},	
    },
	["stock_bahkins"] = {
        VMBodygroups = {{ind = 4, bg = 0}},
		WMBodygroups = {{ind = 4, bg = 0}},	
    },
	["stock_jinc_polimeric"] = {
        VMBodygroups = {{ind = 4, bg = 0}},
		WMBodygroups = {{ind = 4, bg = 0}},	
    },
}

SWEP.Attachments = {
	{	--1
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = {"optic_lp","optic"}, -- what kind of attachments can fit here, can be string or table
        Bone = "Weapon_Rotate", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0.02, -6.3, 3), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -90),
            wpos = Vector(6.8, 0.8, -6.1),
            wang = Angle(-10, 0, 180)
        },
        InstalledEles = {"mount"},
    },
	{	--3
        PrintName = "Underbarrel",
        Bone = "Weapon_Rotate",
        Slot = {"foregrip", "style_pistol", "bipod"},		
        Offset = {	
            vpos = Vector(0, -3.5, 16.8),
            vang = Angle(90,0, -90),
            wpos = Vector(13.8, 0.602, -4.3),
            wang = Angle(-10.216, 0, 180)
        },	
		InstalledEles = {"hk94_fg"},		
    },
	{	--4
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "Weapon_Rotate",
        Offset = {
            vpos = Vector(-1, -3.5, 5), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, 180),
            wpos = Vector(13.5, -0.26, -5.5),
            wang = Angle(-9, -0.556, 90)
        },
    },
	{	--5
        PrintName = "Grip",
        Slot = "grip",
        DefaultAttName = "Standard Grip"
    },
	{	--6
        PrintName = "Stock",
        Slot = "stock",
        DefaultAttName = "Standard Stock",
        InstalledEles = {"stock_re"},
    },
	{	--7
		PrintName = "Fire Group",
        Slot = "fcg",
        DefaultAttName = "Standard FCG"
    },
	{	--8
        PrintName = "Ammo Type",
        Slot = {"ammo_bullet"}
    },	
	{	--9,10
        PrintName = "Perk",
        Slot = {"perk", "perk_fas"}
    },
	{	--11,12
        PrintName = "Charm",
        DefaultAttName = "None",
        Slot = {"fml_charm", "charm"},
        Bone = "Weapon_Rotate",
        Offset = {
            vpos = Vector(0.98, -4.2, 6.6),
            vang = Angle(90, 0, -90),
            wpos = Vector(9.6, 1.4, -4.75),
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
    ["ready"] = {
        Source = "deploy",
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.5,
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
        Time = 20/60,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "iron",
        Time = 20/60,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "wet",
        Time = 165/60,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Checkpoints = {36, 57, 77},
        FrameRate = 60,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.3,
    },
    ["reload_empty"] = {
        Source = "dry",
        Time = 205/60,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        Checkpoints = {36, 57, 77, 88},
        FrameRate = 60,
        LHIK = true,
        LHIKIn = 0.1,
        LHIKOut = 0.25,
    },
    ["reload_soh"] = {
        Source = "wet_soh",
        Time = 120/60,	
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71, 89},
        FrameRate = 37,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKOut = 0.3,
    },
    ["reload_empty_soh"] = {
        Source = "dry_soh",
        Time = 165/60,		
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71, 89},
        FrameRate = 37,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.3,
    },	
}