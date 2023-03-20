SWEP.Base = "arccw_base"
SWEP.Spawnable = true
SWEP.Category = "ArcCW - Urban Coalition"
SWEP.AdminOnly = false
SWEP.UseHands = true

-- Muzzle and shell effects --

SWEP.MuzzleEffect = "muzzleflash_1"
SWEP.ShellModel = "models/weapons/arccw/uc_shells/9x19.mdl"
SWEP.ShellScale = 1
--SWEP.ShellMaterial = "models/weapons/arcticcw/shell_9mm"
SWEP.ShellPitch = 100
SWEP.ShellSounds = ArcCW.PistolShellSoundsTable

SWEP.MuzzleEffectAttachment = 1
SWEP.CaseEffectAttachment = 2
SWEP.CamAttachment = 3
SWEP.TracerNum = 1
SWEP.TracerCol = Color(25, 255, 25)
SWEP.TracerWidth = 2

-- Fake name --

SWEP.PrintName = "PV"

-- True name --

SWEP.TrueName = "PM"

-- Trivia --

SWEP.Trivia_Class = "Pistol"
SWEP.Trivia_Desc = [[Basic Soviet pistol that can be found around the globe. Better known by its colloquial moniker, the "Makarov," after its designer. Although it lacks the modularity of modern sidearms, the weapon and its many derivatives remain trustworthy sidearms.

With low offensive potential but very compact handling, its main use is as an emergency backup weapon.]]
SWEP.Trivia_Manufacturer = "Sikov Machining Plant"
SWEP.Trivia_Calibre = "9x18mm Makarov"
SWEP.Trivia_Mechanism = "Blowback"
SWEP.Trivia_Country = "Russia"
SWEP.Trivia_Year = 1951

-- Weapon slot --

SWEP.Slot = 1

-- Weapon's manufacturer real name --

if GetConVar("arccw_truenames"):GetBool() then
    SWEP.PrintName = SWEP.TrueName
    SWEP.Trivia_Manufacturer = "Izhevsk Mechanical Plant"
end

-- Viewmodel / Worldmodel / FOV --

SWEP.ViewModel = "models/weapons/arccw/c_ur_pm.mdl"
SWEP.WorldModel = "models/weapons/arccw/c_ur_pm.mdl"
SWEP.ViewModelFOV = 60
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.DefaultBodygroups = "00000"

-- Damage --

SWEP.Damage = 30 -- 4 shot close range kill (3 on chest)
SWEP.DamageMin = 15 -- 7 shot long range kill
SWEP.RangeMin = 15
SWEP.Range = 50 -- 4 shot until ~35m
SWEP.Penetration = 6
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil
SWEP.MuzzleVelocity = 315
SWEP.PhysBulletMuzzleVelocity = 315

SWEP.BodyDamageMults = ArcCW.UC.BodyDamageMults

-- Mag size --

SWEP.ChamberSize = 1
SWEP.Primary.ClipSize = 8

-- Recoil --

SWEP.Recoil = 1.0
SWEP.RecoilSide = 0.5

SWEP.RecoilRise = 0.24
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 0.5
SWEP.MaxRecoilPunch = 0.6

SWEP.Sway = 1

-- Firerate / Firemodes --

SWEP.Delay = 60 / 575
SWEP.Num = 1
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0,
    }
}

SWEP.ShootPitch = 100
SWEP.ShootVol = 120

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.ReloadInSights = true

-- NPC --

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 60

-- Accuracy --

SWEP.AccuracyMOA = 7
SWEP.HipDispersion = 500
SWEP.MoveDispersion = 250
SWEP.JumpDispersion = 1000

SWEP.Primary.Ammo = "pistol"
SWEP.MagID = "glock"

SWEP.HeatCapacity = 50
SWEP.HeatDissipation = 20
SWEP.HeatDelayTime = 3

SWEP.MalfunctionMean = 150
SWEP.MalfunctionTakeRound = false

-- Speed multipliers --

SWEP.SpeedMult = 0.975
SWEP.SightedSpeedMult = 0.9
SWEP.SightTime = 0.35
SWEP.ShootSpeedMult = 1

-- Length --

SWEP.BarrelLength = 8
SWEP.ExtraSightDist = 7

-- Ironsights / Customization / Poses --

SWEP.HolsterPos = Vector(-0.5, 0, -1)
SWEP.HolsterAng = Angle(3.5, 7, -20)

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"

SWEP.IronSightStruct = {
     Pos = Vector(-2.327, 10, 1),
     Ang = Angle(0.195, 0, 3.3),
     Magnification = 1,
     ViewModelFOV = 55,
     SwitchToSound = ratel, -- sound that plays when switching to this sight
     SwitchFromSound = ratel
}

SWEP.ActivePos = Vector(1, 3, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(7, -2, -2)
SWEP.CustomizeAng = Angle(15, 25, 0)

SWEP.CrouchPos = Vector(-2, 0, 1)
SWEP.CrouchAng = Angle(0, 0, -20)

SWEP.BarrelOffsetHip = Vector(3.5, 0, -3)

SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos        =    Vector(-10.9, 5.5, -3.5),
    ang        =    Angle(-6, 6, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
}

-- Firing sounds --

local path = ")^weapons/arccw_ur/pm/"
local path1 = ")^weapons/arccw_ud/glock/"
local path2 = ")^weapons/arccw_ud/uzi/"
local common = ")^/arccw_uc/common/"
SWEP.ShootSound = path1 .. "fire_380.ogg" -- Placeholder
SWEP.ShootSoundSilenced = path1 .. "fire_supp.ogg"
SWEP.DistantShootSound = path1 .. "fire_dist_380.ogg" -- Placeholder
SWEP.DistantShootSoundSilenced = common .. "sup_tail.ogg"
SWEP.ShootDrySound = path1 .. "dryfire.ogg"

-- Bodygroups --

// SWEP.BulletBones = {
   // [2] = "glock_bullet1"
// }

SWEP.AttachmentElements = {
    ["ur_pmm"] = {
        VMBodygroups = {
            {ind = 1, bg = 1},
            {ind = 2, bg = 1},
            {ind = 3, bg = 1},
        },
    },
    ["ur_peanutbutter"] = {
        VMBodygroups = {
            {ind = 1, bg = 2},
            {ind = 2, bg = 2},
            {ind = 3, bg = 2},
        },
    },
    ["ur_pb_supp"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
    },
}

-- Animations --

SWEP.Hook_Think = ArcCW.UD.ADSReload

-- CHAN_ITEM doesn't sound too right
local ci = CHAN_AUTO
local ratel = {path1 .. "pistol_rattle_1.ogg", path1 .. "pistol_rattle_2.ogg", path1 .. "pistol_rattle_3.ogg"}
local rottle = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}

SWEP.Animations = {
    ["ready"] = {
        Source = "fix",
        ProcDraw = true,
    },
    ["idle"] = {
        Source = "idle",
    },
    ["idle_empty"] = {
        Source = "idle_empty",
    },
    ["draw"] = {
        Source = "draw",
        SoundTable = {
            {s = path1 .. "draw.ogg", t = 0}, -- Not Temporary
            {s = common .. "raise.ogg", t = 0.05},
        },
    },
    ["draw_empty"] = {
        Source = "draw_empty",
        SoundTable = {
            {s = path1 .. "draw.ogg", t = 0}, -- Not Temporary
            {s = common .. "raise.ogg", t = 0.05},
        },
    },
    ["holster"] = {
        Source = "holster",
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0,
        LHIKOut = 0,
        Time = 18/30,
        SoundTable = {
            {s = common .. "cloth_2.ogg", t = 0},
            {s = "weapons/arccw/firemode.wav", t = 0.15},
            {s = path1 .. "holster.ogg", t = 0.25}, -- Not Temporary
        },
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0,
        LHIKOut = 0,
        Time = 26/30,
        SoundTable = {
            {s = common .. "cloth_2.ogg", t = 0},
            {s = path1 .. "holster.ogg", t = 0.25}, -- Not Temporary
        },
    },
    ["fire"] = {
        Source = "fire",
        ShellEjectAt = 0.03,
        Time = .5,
        SoundTable = {{ s = {path1 .. "mech-01.ogg", path1 .. "mech-02.ogg", path1 .. "mech-03.ogg", path1 .. "mech-04.ogg", path1 .. "mech-05.ogg", path1 .. "mech-06.ogg"}, t = 0.03 }},
    },
    ["fire_empty"] = {
        Source = "fire_empty",
        ShellEjectAt = 0.03,
        Time = .5,
        SoundTable = {
            {s = path1 .. "mech_last.ogg", t = 0, c = ci}, -- Not Temporary
        },
    },
    ["fix"] = {
        Source = "fix",
        ShellEjectAt = false,
        SoundTable = {
            {s = path1 .. "magtap.ogg",    t = 0.18, c = ci},
            {s = path1 .. "slide_pull_new.ogg",  t = 0.5, c = ci},
            {s = path1 .. "sliderel_deact.ogg",  t = 0.5, c = ci},
            {s = path1 .. "slide_rel_new.ogg",        t = 0.7, c = ci},
        },
        LHIK = true,
        LHIKIn = 0.2,
        LHIKEaseIn = 0.1,
        LHIKEaseOut = 0.1,
        LHIKOut = 0.2,
    },
    ["fix_empty"] = {
        Source = "fix_empty",
        ShellEjectAt = false,
        SoundTable = {
            {s = path1 .. "magtap.ogg",    t = 0.18, c = ci},
            {s = path1 .. "slide_pull_new.ogg",  t = 0.5, c = ci},
            {s = path1 .. "sliderel_deact.ogg",  t = 0.5, c = ci},
        },
        LHIK = true,
        LHIKIn = 0.2,
        LHIKEaseIn = 0.1,
        LHIKEaseOut = 0.1,
        LHIKOut = 0.2,
    },  
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        MinProgress = 1.1,
        LastClip1OutTime = 0.9,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKEaseIn = 0.2,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.3,
        SoundTable = {
            {s = rottle, t = 0},
            {s = rattel, t = 0.3},
            {s = path .. "magout.ogg",        t = 0.3, c = ci},
            {s = common .. "magpouch_replace_small.ogg", t = .6},
            {s = common .. "magpouch_pull_small.ogg", t = .9},
            {s = rattel, t = 0.35},
            {s = path .. "magstruggle.ogg",         t = 1.45, c = ci},
            {s = path .. "magin.ogg",         t = 1.5, c = ci},
            {s = rottle, t = 0.5},
        },
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        MinProgress = 1.5,
        LastClip1OutTime = 0.7,
        LHIK = true,
        LHIKIn = 0.2,
        LHIKEaseIn = 0.2,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.3,
        SoundTable = {
            {s = rottle, t = 0},
            {s = rattel, t = 0.3},
            {s = path .. "magout.ogg",        t = 0.3, c = ci},
            {s = rattel, t = 0.5},
            {s = common .. "magpouch_pull_small.ogg", t = 0.8},
            {s = common .. "pistol_magdrop.ogg",  t = 1},
            {s = rottle, t = 1.15},
            {s = path .. "magstruggle.ogg",         t = 1.45, c = ci},
            {s = path .. "magin.ogg",         t = 1.5, c = ci},
            {s = path1 .. "chamber.ogg",      t = 2.1, c = ci},
        },
    },
}

SWEP.AutosolveSourceSeq = "idle"

SWEP.Attachments = {
    {
        PrintName = "Optic",
        DefaultAttName = "Iron Sights",
        Slot = {"optic_lp"},
        Bone = "slide",
        Offset = {
            vpos = Vector(0, -0.55, -0.4),
            vang = Angle(0, 90, 180),
        },
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, 180, 0),
        VMScale = Vector(1, 1, 1),
        WMScale = Vector(1.25, 1.25, 1.25),
    },
    {
        PrintName = "Variant",
        DefaultAttName = "Classic Makarov",
        DefaultAttIcon = Material("entities/att/acwatt_ud_glock_slide.png", "smooth mips"),
        Slot = "ur_pm_variant",
    },
    -- {
    --     PrintName = "Caliber",
    --     DefaultAttName = "9x19mm Parabellum",
    --     DefaultAttIcon = Material("entities/att/acwatt_ud_glock_caliber.png", "smooth mips"),
    --     Slot = "ud_glock_caliber",
    -- },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = {"muzzle", "pm_supp"},
        Bone = "flashbone",
        Offset = {
            vpos = Vector(0, 0.1, 0),
            vang = Angle(180, 90, 0),
        },
        VMScale = Vector(0.8, 0.8, 0.8)
    },
   // { i hate this gay ass little pistol bruh
       // PrintName = "Tactical",
      //  Slot = {"tac_pistol"},
      //  Bone = "pm_parent",
      //  Offset = {
      //      vpos = Vector(0, -5.6, -0.2),
      //      vang = Angle(0, 90, 180),
       // },
   // },
    {
        PrintName = "Stock",
        Slot = {"uc_stock", "go_stock_pistol_bt"},
        DefaultAttName = "No Stock",
        Bone = "pm_parent",
        Offset = {
            vpos = Vector(0, 1, 3.5),
            vang = Angle(180, 90, 0),
        },
    },
    {
        PrintName = "Ammo Type",
        DefaultAttName = "\"FMJ\" Full Metal Jacket",
        DefaultAttIcon = Material("entities/att/arccw_uc_ammo_generic.png", "mips smooth"),
        Slot = "uc_ammo",
    },
    {
        PrintName = "Powder Load",
        Slot = "uc_powder",
        DefaultAttName = "Standard Load"
    },
    {
        PrintName = "Training Package",
        Slot = "uc_tp",
        DefaultAttName = "Basic Training"
    },
    {
        PrintName = "Internals",
        Slot = "uc_fg", -- Fire group
        DefaultAttName = "Standard Internals"
    },
    {
        PrintName = "Charm",
        Slot = {"charm", "fml_charm"},
        FreeSlot = true,
        Bone = "slide",
        Offset = {
            vpos = Vector(0.4, 0, 4),
            vang = Angle(90, 0, -90),
        },
        VMScale = Vector(0.7, 0.7, 0.7),
    },
}