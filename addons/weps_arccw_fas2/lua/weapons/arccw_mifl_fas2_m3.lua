SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - FA:S2"
SWEP.AdminOnly = false

SWEP.PrintName = "M3 Super 90"
SWEP.Trivia_Class = "Shotgun"
SWEP.Trivia_Desc = "Modern shotgun with dual operation."
SWEP.Trivia_Manufacturer = "Benelli Armi SpA"
SWEP.Trivia_Calibre = "12 Gauge"
SWEP.Trivia_Mechanism = "Pump-Action"
SWEP.Trivia_Country = "Italy"
SWEP.Trivia_Year = 2006

SWEP.Slot = 2

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/mifl/fas2/c_m3s90.mdl"
SWEP.WorldModel = "models/weapons/arccw/mifl/fas2/c_m3s90.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "000000000000"

SWEP.Damage = 14
SWEP.DamageMin = 4 -- damage done at maximum range
SWEP.Num = 8
SWEP.Range = 40 -- in METRES
SWEP.Penetration = 1
SWEP.DamageType = DMG_BUCKSHOT
SWEP.ShootEntity = nil -- entity to fire, if any
SWEP.ChamberSize = 1 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 4 -- DefaultClip is automatically set.

SWEP.PhysBulletMuzzleVelocity = 700

SWEP.Recoil = 2.2
SWEP.RecoilSide = 1.3
SWEP.RecoilRise = 0.8

SWEP.ShotgunReload = true
SWEP.Delay = 60 / 210 -- 60 / RPM.
SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "Semi"
    },
    {
        Mode = 1,
        PrintName = "Pump",
		Override_ManualAction = true,
		Mult_Recoil = 0.8,
		Mult_RecoilSide = 0.4,
		Mult_VisualRecoilMult = 0.8,
		Mult_AccuracyMOA = 0.75,
		Mult_HipDispersion = 0.8,
		Mult_SightsDispersion = 0.5,	
		Mult_MoveDispersion = 0.75,
    },	
}

SWEP.NPCWeaponType = "weapon_shotgun"
SWEP.NPCWeight = 170

SWEP.AccuracyMOA = 30 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 300 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 100

SWEP.Primary.Ammo = "buckshot" -- what ammo type the gun uses

SWEP.ShootVol = 120 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "weapons/arccw_mifl/fas2/m3s90/m3s90_fire1.wav"
SWEP.ShootSoundSilenced = "weapons/arccw_mifl/fas2/rem870/sd_fire.wav"
SWEP.DistantShootSound = "weapons/arccw_mifl/fas2/m3s90/m3s90_distance_fire1.wav"

SWEP.MeleeSwingSound = "arccw_go/m249/m249_draw.wav"
SWEP.MeleeMissSound = "weapons/iceaxe/iceaxe_swing1.wav"
SWEP.MeleeHitSound = "arccw_go/knife/knife_hitwall1.wav"
SWEP.MeleeHitNPCSound = "physics/body/body_medium_break2.wav"

SWEP.MuzzleEffect = "muzzleflash_shotgun"
SWEP.ShellModel = "models/weapons/arccw/mifl/fas2/shell/buck.mdl"
SWEP.ShellPitch = 100
SWEP.ShellSounds = ArcCW.ShotgunShellSoundsTable
SWEP.ShellScale = 1
SWEP.ShellRotateAngle = Angle(0, 0, 0)

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 3 -- which attachment to put the case effect on

SWEP.SpeedMult = 0.95
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.25
SWEP.NoLastCycle = true
SWEP.IronSightStruct = {
    Pos = Vector(-4.52, -5, 3.4	),
    Ang = Angle(0, 0, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "shotgun"
SWEP.HoldtypeSights = "ar2"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG

SWEP.ActivePos = Vector(-1, -2, 1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-0.2, 0, -1)
SWEP.CrouchAng = Angle(0, 0, -5)
SWEP.HolsterPos = Vector(1, -2, 1)
SWEP.HolsterAng = Angle(-15, 25, -10)
SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)
SWEP.CustomizePos = Vector(6, -1, -5)
SWEP.CustomizeAng = Angle(15, 15, -5)

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {
    ["mifl_fas2_m3_stock_re"] = {
        VMBodygroups = {	{ind = 4, bg = 1},	},	
    },
    ["mifl_fas2_uni_rif_nostock"] = {
        VMBodygroups = {	{ind = 4, bg = 3},	},	
    },	
    ["mifl_fas2_m3_stock_ex"] = {
        VMBodygroups = {	{ind = 4, bg = 2},	},	
    },
    ["mifl_fas2_m3_tube_x"] = {
        VMBodygroups = {	{ind = 2, bg = 1},	},	
    },	
    ["mifl_fas2_m3_tube_xx"] = {
        VMBodygroups = {	{ind = 2, bg = 2},	},	
    },		
    ["mifl_fas2_ks23_barrel_l"] = {
        VMBodygroups = {	{ind = 1, bg = 2}, {ind = 3, bg = 2}	},
        AttPosMods = {
            [5] = {vpos = Vector(49, -1.15, 0),},
        }		
    },
    ["mifl_fas2_ks23_barrel_k"] = {
        VMBodygroups = {	{ind = 1, bg = 1}, {ind = 3, bg = 1}	},
        AttPosMods = {
            [5] = {vpos = Vector(32, -1.15, 0),},
        }		
    },
    ["mifl_fas2_ks23_barrel_sd"] = {
        VMBodygroups = {	{ind = 1, bg = 4}, {ind = 3, bg = 4}	},	
    },	
    ["mifl_fas2_m3_barrel_s"] = {
        VMBodygroups = {	{ind = 0, bg = 1}, {ind = 1, bg = 3}, {ind = 2, bg = 3}, {ind = 3, bg = 5}	},
        AttPosMods = {
            [5] = {vpos = Vector(25.5, -1.15, 0),},
        }		
    },	
    ["rail"] = {
        VMBodygroups = {{ind = 5, bg = 1}},
    },
    ["go_ammo_sg_slug"] = {
        VMBodygroups = {{ind = 6, bg = 1}},
		Override_ShellModel = "models/weapons/arccw/mifl/fas2/shell/slug.mdl"		
    },
    ["go_ammo_sg_sabot"] = {
        VMBodygroups = {{ind = 6, bg = 2}},
		Override_ShellModel = "models/weapons/arccw/mifl/fas2/shell/flet.mdl"			
    },	
}

SWEP.Hook_ModifyBodygroups = function(wep, data)
    local vm = data.vm
    if wep.Attachments[1].Installed then vm:SetBodygroup(3, 3) end
end


SWEP.ExtraSightDist = 10

SWEP.WorldModelOffset = {
    pos = Vector(-14, 6, -7),
    ang = Angle(-10, 0, 180)
}

SWEP.MirrorVMWM = true

SWEP.Attachments = {
    {
        PrintName = "Optic",
        Slot = "optic",
        Bone = "Dummy01",
        DefaultAttName = "Iron Sights",
        Offset = {
            vpos = Vector(7.5, -2.5, 0),
            vang = Angle(0, 0, -90),
        },
        CorrectiveAng = Angle(0, 0, 0),
        InstalledEles = {"rail"},
    },
    {
        PrintName = "Underbarrel",
        Slot = "foregrip",
        Bone = "Bone29",
        Offset = {
            vpos = Vector(4,1.3,0),
            vang = Angle(0, 0, -90),
        },
        InstalledEles = {"ubrms"},
    },
    {
        PrintName = "Tactical",
        Slot = "tac",
        Bone = "Bone29",
        Offset = {
            vpos = Vector(5, -0.65, -1),
            vang = Angle(0, 0, 0),
        },
        InstalledEles = {"tacms"},
        ExtraSightDist = 20,
        CorrectivePos = Vector(0.75, 0, -2)		
    },
    {
        PrintName = "Barrel",
        Slot = "mifl_fas2_m3_barrel",
        DefaultAttName = "Standard Barrel",
        Bone = "Bone29",
        Offset = {
            vpos = Vector(1,1,-0.8),
            vang = Angle(0, 0, -90),
        },		
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = "muzzle",
        Bone = "Dummy01",
        Offset = {
            vpos = Vector(40, -1.15, 0),
            vang = Angle(0, 0, -90),
        },
        ExcludeFlags = {"mifl_fas2_ks23_barrel_sd"},		
    },
    {
        PrintName = "Magazine",
        Slot = "mifl_fas2_m3_mag",
        DefaultAttName = "4-Round 12-Gauge Tube",
        ExcludeFlags = {"mifl_fas2_m3_barrel_s"},			
    },
    {
        PrintName = "Stock",
        Slot = {"mifl_fas2_m3_stock", "mifl_fas2_uni_stock"},
        DefaultAttName = "Standard Stock",
        Bone = "Dummy01",
        Offset = {
            vpos = Vector(0, -0.25, 1),
            vang = Angle(90, 0, -90),
        },
    },
    {
        PrintName = "Ammo Type",
        Slot = "go_ammo",
        DefaultAttName = "Buckshot Shells"
    },
    {
        PrintName = "Perk",
        Slot = "go_perk"
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "Dummy01", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0.5, -0.5, -0.8), -- offset that the attachment will be relative to the bone
            vang = Angle(0, 0, -90),
        },
    },
}

SWEP.Hook_SelectInsertAnimation = function(wep, data)
    --local nomen = (wep:GetBuff_Override("Override_FAS2NomenBackup") and "_nomen") or ""

    local insertAmt = math.min(math.floor(wep:GetCapacity()) + wep:GetChamberSize() - wep:Clip1(),
    	wep:GetOwner():GetAmmoCount(wep.Primary.Ammo),
    	4)

    local anim = "sgreload_insert" .. insertAmt

    return {count = insertAmt, anim = anim, empty = false}
end

SWEP.Hook_SelectFireAnimation = function(wep, data)
    if wep:GetCurrentFiremode().Override_ManualAction then
        return "fire_pump"
    end
end

SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["draw"] = {
        Source = "deploy",
    },
    ["ready"] = {
        Source = "deploy",
    },
    ["fire"] = {
        Source = "fire1",
        ShellEjectAt = 0.1,		
    },
    ["fire_empty"] = {
        Source = "fire_last",
        ShellEjectAt = 0.1,		
    },	
    ["fire_pump"] = {
        Source = "fire1",
    },	
    ["fire_iron_pump"] = {
        Source = "fire1_scoped",
    },		
    ["fire_iron"] = {
        Source = "fire1_scoped",
        ShellEjectAt = 0.1,			
    },
    ["fire_iron_empty"] = {
        Source = "fire_last_iron",
        ShellEjectAt = 0.1,			
    },	
    ["cycle"] = {
        Source = "pump",
		Time = 0.8,
        ShellEjectAt = 0.1,
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
        MinProgress = 0.5,		
    },
    ["sgreload_start"] = {
        Source = "reload_start",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        Time = 0.3
    },
    ["sgreload_start_empty"] = {
        Source = "reload_start_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
    },
    ["sgreload_insert"] = {
        Source = "reload_load1",   
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        TPAnimStartTime = 0.3,
    },
    ["sgreload_insert1"] = {
        Source = "reload_load1",     
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        TPAnimStartTime = 0.3,
        Time = 0.8,
    },
    ["sgreload_insert2"] = {
        Source = "reload_load2",     
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        TPAnimStartTime = 0.3,
        Time = 1.05,
    },
    ["sgreload_insert3"] = {
        Source = "reload_load3",    
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        Time = 1.3,
        TPAnimStartTime = 0.3,
    },
    ["sgreload_insert4"] = {
        Source = "reload_load4",
		Time = 1.6,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        TPAnimStartTime = 0.3,
    },
    ["sgreload_finish"] = {
        Source = "reload_abort",
        Time = 0.3,
    },
}