SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - FA:S1" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "MK3"
SWEP.TrueName = "M16A2"
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = "Adapted from the ArmaLite AR-15 rifle for the United States military. Somehow have a removeable carry handle for optic mounting. Its charging handle is appeared to be broken and has been replaced with a modified pullable forward assist"
SWEP.Trivia_Manufacturer = "Colt"
SWEP.Trivia_Calibre = "5.56x45mm NATO"
SWEP.Trivia_Country = "United States"
SWEP.Trivia_Year = "1963"

if GetConVar("arccw_truenames"):GetBool() then SWEP.PrintName = SWEP.TrueName end

SWEP.Slot = 2

SWEP.NPCWeaponType = {"weapon_ar2", "weapon_smg1"}
SWEP.NPCWeight = 150

SWEP.CrouchPos = Vector(-6.2, 0, 0.5)
SWEP.CrouchAng = Angle(0, 0, -45)

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/fml/fas1/c_m16a2.mdl"
SWEP.WorldModel = "models/weapons/arccw/fml/fas1/w_m16a2.mdl"
SWEP.ViewModelFOV = 70

SWEP.DefaultBodygroups = "000000"

SWEP.Damage = 32
SWEP.DamageMin = 19 -- damage done at maximum range
SWEP.Range = 80 -- in METRES
SWEP.Penetration = 5
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

SWEP.Recoil = 0.65
SWEP.RecoilSide = 0.17
SWEP.RecoilRise = 0.45
SWEP.VisualRecoilMult = 0.5

SWEP.Delay = 60 / 800 -- 60 / RPM.
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

SWEP.AccuracyMOA = 4.75 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 800 -- inaccuracy added by hip firing.

SWEP.Primary.Ammo = "smg1" -- what ammo type the gun uses
SWEP.MagID = "stanag" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 95 -- pitch of shoot sound

SWEP.FirstShootSound = "weapons/arccw_fml/ar_m16a2/m16a2_fire1.wav"
SWEP.ShootSound = "weapons/arccw_fml/ar_m16a2/m16a2_fire2.wav", "weapons/arccw_fml/ar_m16a2/m16a2_fire3.wav", "weapons/arccw_fml/ar_m16a2/m16a2_fire4.wav","weapons/arccw_fml/ar_m16a2/m16a2_fire5.wav"
SWEP.ShootSoundSilenced = "weapons/arccw_fml/fas1_suppr/m16a2.wav"
SWEP.DistantShootSound = "weapons/arccw/m4a1/m4a1_us_distant_03.wav"

SWEP.MuzzleEffect = "muzzleflash_1"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 95
SWEP.ShellScale = 1.5

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.8
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.35

SWEP.BulletBones = { -- the bone that represents bullets in gun/mag
    -- [0] = "bulletchamber",
    -- [1] = "bullet1"
}

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.CaseBones = {}

SWEP.IronSightStruct = {
    Pos = Vector(-3.356, -6.127, 0.302),
    Ang = Angle(0.319,0,0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0.5, 4, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.HolsterPos = Vector(8, -2, -4.011)
SWEP.HolsterAng = Angle(1.898, 54.613, -10.113)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.BarrelLength = 25

SWEP.ExtraSightDist = 5

SWEP.AttachmentElements = {
    ["noch"] = {
        VMBodygroups = {{ind = 1, bg = 1}},
        WMBodygroups = {},
    },
    ["bkrail"] = {
     VMElements = {
        {
            Model = "models/weapons/arccw/atts/backup_rail.mdl",
              Bone = "Weapon_Main",
             Offset = {
                 pos = Vector(0, -4, 13),
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
        Slot = {"optic", "optic_lp"}, -- what kind of attachments can fit here, can be string or table
        Bone = "Weapon_Main", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0.05, -4.2, 3), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -90),
            wpos = Vector(5.36, 0.739, -6.801),
            wang = Angle(-10, 0, 180)
        },
        InstalledEles = {"noch"},
    },
    {
        PrintName = "Backup Optic", -- print name
        Slot = {"optic_lp"}, -- what kind of attachments can fit here, can be string or table
        Bone = "Weapon_Main", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(-0.7, -4.4, 13), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -45),
            wpos = Vector(15, -0.8, -7),
            wang = Angle(-10.393, 0, -135)
        },	
        InstalledEles = {"bkrail"},		
        KeepBaseIrons = true,
		ExtraSightDist = 10	
    },			
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "Weapon_Main",
        Offset = {
            vpos = Vector(0, -3, 29),
            vang = Angle(90, 0, -90),
            wpos = Vector(30, 0.782, -8.35),
            wang = Angle(-9.79, 0, 180)
        },
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip", "ubgl", "bipod"},
        Bone = "Weapon_Main",
        Offset = {
            vang = Angle(90,0, -90),
            wpos = Vector(14.329, 0.602, -4.453),
            wang = Angle(-10.216, 0, 180)
        },
        SlideAmount = {
            vmin = Vector(0, -2, 10),
            vmax = Vector(0, -2, 15),
            wmin = Vector(15, 0.832, -5),
            wmax = Vector(15, 0.832, -5),
        }		
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "Weapon_Main",
        Offset = {
            vpos = Vector(-1, -2, 10), -- offset that the attachment will be relative to the bone
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
        Bone = "Weapon_Main",
        Offset = {
            vpos = Vector(0.4, -2, 7),
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
        Time = 70/60,
        SoundTable = {
        SoundTable = {{s = "weapons/arccw/aug/aug_draw.wav", t = 0}},
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
        Source = "iron",
        Time = 30/60,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "m16_wet",
        Time = 155/60,	
		Checkpoints = {37, 58, 75, 92, 119, 124},	
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    },
    ["reload_empty"] = {
        Source = "m16_dry",
        Checkpoints = {37, 58, 75, 92, 119, 124},		
        Time = 220/60,		
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
    },
    ["reload_soh"] = {
        Source = "m16_soh_wet",
        Time = 105/60,	
		Checkpoints = {37, 58, 75, 92, 119, 124},	
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.3,
    },
    ["reload_empty_soh"] = {
        Source = "m16_soh_dry",
        Time = 140/60,		
		Checkpoints = {37, 58, 75, 92, 119, 124},	
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0.3,
    },
}