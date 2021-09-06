SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - FA:S1" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "MK4"
SWEP.TrueName = "M4A1"
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = "Shorter and lighter variant of the M16A2 assault rifle, extensively used by the United States Armed Forces and is largely replacing the M16 rifle in combat units as the primary infantry weapon and service rifle."
SWEP.Trivia_Manufacturer = "Colt"
SWEP.Trivia_Calibre = "5.56x45mm NATO"
SWEP.Trivia_Country = "United States"
SWEP.Trivia_Year = "1991"

if GetConVar("arccw_truenames"):GetBool() then SWEP.PrintName = SWEP.TrueName end

SWEP.Slot = 2

SWEP.NPCWeaponType = {"weapon_ar2", "weapon_smg1"}
SWEP.NPCWeight = 150

SWEP.CrouchPos = Vector(-5, 3, -0.5)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/fml/fas1/c_m4a1.mdl"
SWEP.WorldModel = "models/weapons/arccw/fml/fas1/w_m4a1.mdl"
SWEP.ViewModelFOV = 70

SWEP.DefaultBodygroups = "000000"

SWEP.Damage = 31
SWEP.DamageMin = 21 -- damage done at maximum range
SWEP.Range = 70 -- in METRES
SWEP.Penetration = 4
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1000 -- projectile or phys bullet muzzle velocity
-- IN M/S

SWEP.TracerNum = 1 -- tracer every X
SWEP.TracerCol = Color(255, 25, 25)
SWEP.TracerWidth = 3

SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 30 -- DefaultClip is automatically set.
SWEP.ExtendedClipSize = 45
SWEP.ReducedClipSize = 20

SWEP.Recoil = 0.4
SWEP.RecoilSide = 0.125
SWEP.RecoilRise = 0.8
SWEP.VisualRecoilMult = 0.5

SWEP.Delay = 60 / 775 -- 60 / RPM.
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

SWEP.AccuracyMOA = 5 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 800 -- inaccuracy added by hip firing.

SWEP.Primary.Ammo = "smg1" -- what ammo type the gun uses
SWEP.MagID = "stanag" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 95 -- pitch of shoot sound

SWEP.FirstShootSound = "weapons/arccw_fml/ar_m4a1/m4_fire1.wav"
SWEP.ShootSound = "weapons/arccw_fml/ar_m4a1/m4_fire2.wav", "weapons/arccw_fml/ar_m4a1/m4_fire3.wav", "weapons/arccw_fml/ar_m4a1/m4_fire4.wav","weapons/arccw_fml/ar_m4a1/m4_fire5.wav"
SWEP.ShootSoundSilenced = "weapons/arccw_fml/fas1_suppr/m4a1.wav"
SWEP.DistantShootSound = "weapons/arccw/m4a1/m4a1_us_distant_03.wav"

SWEP.MuzzleEffect = "muzzleflash_1"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 95
SWEP.ShellScale = 1.5

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.8
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.325

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-2.445, -2, -0.825),
    Ang = Angle(0,0,0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, 5, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(8, -2, -4.011)
SWEP.HolsterAng = Angle(1.898, 54.613, -10.113)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 27

SWEP.ExtraSightDist = 5

SWEP.AttachmentElements = {
    ["noch"] = {
        VMBodygroups = {{ind = 1, bg = 1}},
        WMBodygroups = {{ind = 1, bg = 1}},
    },
    ["bkrail"] = {
     VMElements = {
        {
            Model = "models/weapons/arccw/atts/backup_rail.mdl",
              Bone = "v_weapon.m4_Parent",
             Offset = {
                pos = Vector(0, -6, 10),
                ang = Angle(180, 90, 180),
           },
		 },
      }
    },	
}

SWEP.RejectAttachments = {
    ["perk_fastreload"] = true	
}

SWEP.Attachments = {
    {
        PrintName = "Optic", -- print name
        DefaultAttName = "Iron Sights",
        Slot = "optic", -- what kind of attachments can fit here, can be string or table
        Bone = "v_weapon.m4_Parent", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0.05, -6, 2), -- offset that the attachment will be relative to the bone
            vang = Angle(90,0, -90),
            wpos = Vector(7, 0.739, -5),
            wang = Angle(-10, 0, 180)
        },
        InstalledEles = {"noch"},
    },
    {
        PrintName = "Backup Optic", -- print name
        Slot = {"optic_lp"}, -- what kind of attachments can fit here, can be string or table
        Bone = "v_weapon.m4_Parent", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(-0.6, -6.4, 10), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -45),
            wpos = Vector(15, -0.45, -6.5),
            wang = Angle(-10.393, 0, -135)
        },	
        InstalledEles = {"bkrail"},		
        KeepBaseIrons = true,
		ExtraSightDist = 9	
    },		
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "v_weapon.m4_Parent",
        Offset = {
            vpos = Vector(0, -4.6, 20.5),
            vang = Angle(90, 0, -90),
            wpos = Vector(25, 0.782, -7.45),
            wang = Angle(-9.79, 0, 180)
        },
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip", "ubgl", "bipod"},
        Bone = "v_weapon.m4_Parent",
        Offset = {
            vang = Angle(90,0, -90),
            wpos = Vector(14.329, 0.602, -4.453),
            wang = Angle(-10.216, 0, 180)
        },
        SlideAmount = {
            vmin = Vector(0, -3.9, 7.2),
            vmax = Vector(0, -3.9, 12),
            wmin = Vector(14, 0.832, -4.8),
            wmax = Vector(14, 0.832, -4.8),
        },			
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "v_weapon.m4_Parent",
        Offset = {
            vpos = Vector(-1, -4.5, 10), -- offset that the attachment will be relative to the bone
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
        Bone = "v_weapon.m4_Parent",
        Offset = {
            vpos = Vector(0.5, -5, 4),
            vang = Angle(90, 0, -90),
            wpos = Vector(7, 1.2, -4),
            wang = Angle(-9, 0, 180)
        },
		FreeSlot = true,
    },		
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
        Time = 1
    },
    ["draw"] = {
        Source = "draw",
        Time = 35/60,
        SoundTable = {{s = "weapons/arccw/aug/aug_draw.wav", t = 0}},
        LHIK = true,
        LHIKIn = 1,
        LHIKOut = 1,
    },
    ["ready"] = {
        Source = "deploy",
        Time = 85/60,
        SoundTable = {
        SoundTable = {{s = "weapons/arccw/aug/aug_draw.wav", t = 0}},
		{s = "weapons/arccw_fml/ar_m4a1/m4_charge.wav", t = 25/60},		
		},		
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
        Source = "idle",
        Time = 30/60,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "wet",
        Time = 180/60,	
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71},
        FrameRate = 37,
        LHIK = true,
        LHIKIn = 0.35,
        LHIKOut = 0.6,
    },
    ["reload_empty"] = {
        Source = "dry",
        Time = 230/60,		
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71, 89},
        FrameRate = 37,
        LHIK = true,
        LHIKIn = 0.35,
        LHIKOut = 0.6,
    },
    ["reload_soh"] = {
        Source = "soh_wet",
        Time = 110/60,	
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71, 89},
        FrameRate = 37,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.3,
    },
    ["reload_empty_soh"] = {
        Source = "soh_dry",
        Time = 125/60,		
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Checkpoints = {24, 42, 59, 71, 89},
        FrameRate = 37,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.3,
    },	
}