SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - GSO (ARs)" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Galil AR"
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = "Isareli assault rifle based off the AK pattern but firing NATO cartridges, eventually replaced by the modern ACE."
SWEP.Trivia_Manufacturer = "Israeli Weapon Industries"
SWEP.Trivia_Calibre = "5.56x45mm NATO"
SWEP.Trivia_Mechanism = "Gas-Operated"
SWEP.Trivia_Country = "Israel"
SWEP.Trivia_Year = 1993

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw_go/v_rif_galil_ar.mdl"
SWEP.WorldModel = "models/weapons/arccw_go/v_rif_galil_ar.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "00000000000"

SWEP.Damage = 25
SWEP.DamageMin = 20 -- damage done at maximum range
SWEP.Range = 100 -- in METRES
SWEP.Penetration = 10
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.MuzzleVelocity = 1050 -- projectile or phys bullet muzzle velocity
-- IN M/S
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 35 -- DefaultClip is automatically set.

SWEP.PhysBulletMuzzleVelocity = 800

SWEP.Recoil = 0.550
SWEP.RecoilSide = 0.175
SWEP.RecoilRise = 0.25

SWEP.Delay = 60 / 650 -- 60 / RPM.
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
SWEP.NPCWeight = 100

SWEP.AccuracyMOA = 3 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 350 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 120

SWEP.Primary.Ammo = "smg1" -- what ammo type the gun uses
SWEP.MagID = "stanag" -- the magazine pool this gun draws from

SWEP.ShootVol = 110 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.FirstShootSound = "arccw_go/galil_arm/galil-1.wav"
SWEP.ShootSound = "arccw_go/galil_arm/galil-1.wav"
SWEP.ShootSoundSilenced = "arccw_go/m4a1/m4a1_silencer_01.wav"
SWEP.DistantShootSound = "arccw_go/galil_arm/galil-1-distant.wav"

SWEP.MeleeSwingSound = "arccw_go/m249/m249_draw.wav"
SWEP.MeleeMissSound = "weapons/iceaxe/iceaxe_swing1.wav"
SWEP.MeleeHitSound = "arccw_go/knife/knife_hitwall1.wav"
SWEP.MeleeHitNPCSound = "physics/body/body_medium_break2.wav"

SWEP.MuzzleEffect = "muzzleflash_3"
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 95
SWEP.ShellScale = 1.25
SWEP.ShellRotateAngle = Angle(0, 180, 0)

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.93
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.36

SWEP.IronSightStruct = {
    Pos = Vector(-5.145, -8, 2.03),
    Ang = Angle(-0.601, 0, 1.5),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(-1, 2, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-4, 0, -1)
SWEP.CrouchAng = Angle(0, 0, -10)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)

SWEP.CustomizePos = Vector(8, 0, 1)
SWEP.CustomizeAng = Angle(5, 30, 30)

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {
    ["altrs"] = {
        VMBodygroups = {{ind = 4, bg = 1}},
    },
    ["nors"] = {
        VMBodygroups = {{ind = 4, bg = 2}},
    },
    ["sidemount"] = {
        VMBodygroups = {{ind = 5, bg = 1}},
        AttPosMods = {
            [4] = {
                vpos = Vector(1.1, -4, 2),
            },
        }
    },
    ["ubrms"] = {
        VMBodygroups = {{ind = 6, bg = 1}},
        WMBodygroups = {{ind = 6, bg = 1}},
    },
    ["fh_none"] = {
        VMBodygroups = {{ind = 2, bg = 4}},
        WMBodygroups = {{ind = 2, bg = 4}},
    },
    ["go_stock"] = {
        VMBodygroups = {
            {ind = 3, bg = 1},
        },
    },
    ["go_galil_ar_barrel_short"] = {
        NameChange = "Galil SAR",
        VMBodygroups = {
            {ind = 1, bg = 2},
            {ind = 2, bg = 2},
        },
        WMBodygroups = {
            {ind = 1, bg = 2},
            {ind = 2, bg = 2},
        },
        AttPosMods = {
            [6] = {
                vpos = Vector(0, -3.2, 20.5),
            }
        }
    },
    ["go_galil_ar_barrel_long"] = {
        VMBodygroups = {
            {ind = 1, bg = 1},
            {ind = 2, bg = 1},
        },
        WMBodygroups = {
            {ind = 1, bg = 1},
            {ind = 2, bg = 1},
        },
        AttPosMods = {
            [6] = {
                vpos = Vector(0, -3.2, 27.5),
            }
        }
    }
}

SWEP.ExtraSightDist = 10
SWEP.GuaranteeLaser = true

SWEP.WorldModelOffset = {
    pos = Vector(-12, 6, -5.5),
    ang = Angle(-10, 0, 180)
}

SWEP.MirrorVMWM = true

SWEP.Attachments = {
    {
        PrintName = "Optic",
        Slot = "optic",
        Bone = "v_weapon.sg556_Parent",
        DefaultAttName = "Iron Sights",
        Offset = {
            vpos = Vector(-0.03, -5.2, 2),
            vang = Angle(90, 0, -90),
        },
        VMScale = Vector(1, 1, 1),
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(1.5, 0, 0),
        InstalledEles = {"nors", "sidemount"},
    },
    {
        PrintName = "Underbarrel",
        Slot = "foregrip",
        Bone = "v_weapon.sg556_Parent",
        Offset = {
            vpos = Vector(0, -2.22, 12),
            vang = Angle(90, 0, -90),
        },
        MergeSlots = {3},
    },
    {
        Hidden = true,
        Slot = "ubgl",
        Bone = "v_weapon.sg556_Parent",
        Offset = {
            vpos = Vector(0, -2.2, 9),
            vang = Angle(90, 0, -90),
        },
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "v_weapon.sg556_Parent",
        Offset = {
            vpos = Vector(0.5, -3.3, 7),
            vang = Angle(90, 0, 0),
        },
    },
    {
        PrintName = "Barrel",
        Slot = "go_galil_ar_barrel",
        DefaultAttName = "460mm ARM Barrel"
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "v_weapon.sg556_Parent",
        Offset = {
            vpos = Vector(0, -3.2, 24.5),
            vang = Angle(90, 0, -90),
        },
        InstalledEles = {"fh_none"},
    },
    {
        PrintName = "Magazine",
        Slot = {}, -- "go_ace_mag", "go_ammo_556_60"
        DefaultAttName = "35-Round 5.56mm Galil"
    },
    {
        PrintName = "Stock",
        Slot = {"go_stock_none", "go_stock"},
        DefaultAttName = "Standard Stock",
        Bone = "v_weapon.sg556_Parent",
        Offset = {
            vpos = Vector(0, -3, 1.2),
            vang = Angle(90, 0, -90),
        },
        InstalledEles = {"go_stock"},
    },
    {
        PrintName = "Ammo Type",
        Slot = "go_ammo",
        DefaultAttName = "Standard Ammo"
    },
    {
        PrintName = "Perk",
        Slot = "go_perk"
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "v_weapon.sg556_Parent", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0.5, -3, 6), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -90),
        },
    },
}

function SWEP:Hook_TranslateAnimation(anim)
    if anim == "fire_iron" then
        if self:GetBuff_Override("NoStock") then return "fire" end
    elseif anim == "fire_iron_empty" then
        if self:GetBuff_Override("NoStock") then return "fire_empty" end
    end
end

SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["draw"] = {
        Source = "draw",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0.5,
    },
    ["ready"] = {
        Source = "ready",
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 1.7,
        LHIKEaseOut = 1.5
    },
    ["fire"] = {
        Source = "shoot1",
        Time = 0.3,
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "ironsight_fire",
        Time = 0.3,
        ShellEjectAt = 0,
    },
    ["reload"] = {
        Source = "reload_part",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        FrameRate = 30,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKOut = 0.6,
        LHIKEaseOut = 0.4
    },
    ["reload_empty"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        FrameRate = 30,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKOut = 1.8,
        LHIKEaseOut = 1.6
    },
    ["enter_inspect"] = false,
    ["idle_inspect"] = false,
    ["exit_inspect"] = false,
}

sound.Add({
    name = "ARCCW_GO_GALIL_ARM.Draw",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/galil_arm/galil_draw.wav"
})

sound.Add({
    name = "ARCCW_GO_GALIL_ARM.Clipout",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/galil_arm/galil_clipout.wav"
})

sound.Add({
    name = "ARCCW_GO_GALIL_ARM.Clipin",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/galil_arm/galil_clipin.wav"
})

sound.Add({
    name = "ARCCW_GO_GALIL_ARM.Boltforward",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/galil_arm/galil_boltforward.wav"
})

sound.Add({
    name = "ARCCW_GO_GALIL_ARM.Boltback",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/galil_arm/galil_boltback.wav"
})