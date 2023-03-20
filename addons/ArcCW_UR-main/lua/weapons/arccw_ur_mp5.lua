SWEP.Base = "arccw_base"
SWEP.Spawnable = true
SWEP.Category = "ArcCW - Urban Coalition"
SWEP.AdminOnly = false
SWEP.UseHands = true

-- Effects --

SWEP.MuzzleEffect = "muzzleflash_mp5"
SWEP.ShellModel = "models/weapons/arccw/uc_shells/9x19.mdl"
SWEP.ShellScale = 1
--SWEP.ShellMaterial = "models/weapons/arcticcw/shell_9mm"
SWEP.ShellPitch = 100
SWEP.ShellSounds = ArcCW.PistolShellSoundsTable

SWEP.MuzzleEffectAttachment = 1
SWEP.CaseEffectAttachment = 2
-- SWEP.CamAttachment = 3 ---------------------------------------------------------------------------
-- SWEP.TracerNum = 1
-- SWEP.TracerCol = Color(25, 255, 25)
-- SWEP.TracerWidth = 2

-- Fake name --

SWEP.PrintName = "PK5-4"

-- True name --

SWEP.TrueName = "MP5A4"

-- Trivia --

SWEP.Trivia_Class = "Submachine Gun"
SWEP.Trivia_Desc = [[Versatile submachine gun known for its use by high profile police units around the world, most famously by the British SAS during the Iranian embassy siege. While not the most cutting-edge weapon, it remains a classic despite multiple newer alternatives from both HK and its competitors.

If accurate, sophisticated close-combat performance is what you're looking for, no weapon has a better track record.]]
SWEP.Trivia_Manufacturer = "Crowdley & Nelson"
SWEP.Trivia_Calibre = "9x19mm Parabellum"
SWEP.Trivia_Mechanism = "Roller-Delayed Blowback"
SWEP.Trivia_Country = "Germany"
SWEP.Trivia_Year = 1966

-- Weapon slot --

SWEP.Slot = 2

-- Weapon's manufacturer real name --

if GetConVar("arccw_truenames"):GetBool() then
    SWEP.PrintName = SWEP.TrueName
    SWEP.Trivia_Manufacturer = "Heckler & Koch"
end

-- Viewmodel / Worldmodel / FOV --

SWEP.ViewModel = "models/weapons/arccw/c_ur_mp5.mdl"
SWEP.WorldModel = "models/weapons/arccw/c_ur_mp5.mdl"
SWEP.ViewModelFOV = 70
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

-- Damage --

SWEP.Damage = 30 -- 4 shot close range kill (3 on chest)
SWEP.DamageMin = 17 -- 6 shot long range kill
SWEP.RangeMin = 20
SWEP.Range = 100 -- 4 shot until ~50m

SWEP.Penetration = 3
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil
SWEP.MuzzleVelocity = 400
SWEP.PhysBulletMuzzleVelocity = 400

SWEP.BodyDamageMults = ArcCW.UC.BodyDamageMults

-- Mag size --

SWEP.ChamberSize = 1
SWEP.Primary.ClipSize = 30
SWEP.ExtendedClipSize = 40
SWEP.ReducedClipSize = 15

-- Recoil --

SWEP.Recoil = 0.38
SWEP.RecoilSide = 0.25

SWEP.RecoilRise = 0.6
SWEP.RecoilPunch = 1
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 0.6
SWEP.RecoilPunchBack = 1.5

SWEP.Sway = 0.25

-- Firerate / Firemodes --

SWEP.Delay = 60 / 800
SWEP.Num = 1
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = -3,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0,
    },
}

SWEP.ShootPitch = 100
SWEP.ShootVol = 120

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.ReloadInSights = true

-- NPC --

SWEP.NPCWeaponType = "weapon_smg1"
SWEP.NPCWeight = 60

-- Accuracy --

SWEP.AccuracyMOA = 3
SWEP.HipDispersion = 500
SWEP.MoveDispersion = 120
SWEP.JumpDispersion = 1000

SWEP.Primary.Ammo = "pistol"
SWEP.MagID = "mp5"

SWEP.HeatCapacity = 75
SWEP.HeatDissipation = 15
SWEP.HeatDelayTime = 3

SWEP.MalfunctionMean = 200

-- Speed multipliers --

SWEP.SpeedMult = 0.925
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.4
SWEP.ShootSpeedMult = 0.95

-- Length --

SWEP.BarrelLength = 24
SWEP.ExtraSightDist = 5

-- Ironsights / Customization / Poses --

SWEP.HolsterPos = Vector(0.5, -2, 1)
SWEP.HolsterAng = Angle(-8.5, 8, -10)

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.IronSightStruct = {
     Pos = Vector(-3.1, 1.3, 1.45),
     Ang = Angle(-.1, 0, .5),
     Magnification = 1,
     SwitchToSound = "",
     ViewModelFOV = 60,
}

SWEP.ActivePos = Vector(-0.5, 1.5, 1.05)
SWEP.ActiveAng = Angle(0, 0, -1)

SWEP.SprintPos = Vector(-0.5, 3, 1.5)
SWEP.SprintAng = Angle(-12, 15, -15)

SWEP.CustomizePos = Vector(6, -2, -1.5)
SWEP.CustomizeAng = Angle(16, 28, 0)

SWEP.CrouchPos = Vector(-2, 0.5, 0)
SWEP.CrouchAng = Angle(0, 0, -14)

SWEP.BarrelOffsetHip = Vector(4, 0, -4)

SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos        =    Vector(-7, 3.75, -6.9),
    ang        =    Angle(-6, 0, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
    scale = 1
}

-- Firing sounds --
local path = ")^weapons/arccw_ur/mp5/"
local path1 = ")^weapons/arccw_ud/glock/"
local common = ")^/arccw_uc/common/"
SWEP.FirstShootSound = path .. "fire_first.ogg"
SWEP.ShootSound = { path .. "fire_auto_1.ogg", path .. "fire_auto_2.ogg", path .. "fire_auto_3.ogg" }
SWEP.ShootSoundSilenced = path .. "fire_sup.ogg"
SWEP.DistantShootSound = path .. "fire_dist.ogg"
SWEP.DistantShootSoundSilenced = common .. "sup_tail.ogg"

-- Bodygroups --

SWEP.BulletBones = {
    -- [1] = "uzi_b1", [2] = "uzi_b2", [3] = "uzi_b3", [4] = "uzi_b4"
}

SWEP.AttachmentElements = {
    ["ur_mp5_barrel_sd"] = {
        VMBodygroups = {
            {ind = 4, bg = 1},
            {ind = 5, bg = 3},
        },
        AttPosMods = {
            [6] = {
                vpos = Vector(-1, 0.81, 12),
                vang = Angle(90, 0, 180),
            },
            [5] = {
                vpos = Vector(-0.2, 1.6, 10),
                vang = Angle(90, 0, -90),
            }
        },
    },
    ["ur_mp5_barrel_kurz"] = {
        VMBodygroups = {
            {ind = 4, bg = 3},
            {ind = 5, bg = 4},
            {ind = 7, bg = 1},
        },
    },
    ["ur_mp5_barrel_long"] = {
        VMBodygroups = {
            {ind = 4, bg = 2},
        },
        AttPosMods = {[4] = {
            vpos = Vector(0, .75, 18.2),
            vang = Angle(90, 0, -90),
        }}
    },

    ["ur_mp5_rail_fg"] = {
        VMBodygroups = {{ind = 5, bg = 1}},
    },
    ["ur_mp5_ub_classic"] = {
        VMBodygroups = {{ind = 5, bg = 2}},
    },
    ["ur_mp5_ub_wood"] = {
        VMBodygroups = {{ind = 5, bg = 3}}, -- insert wood handguard here
    },

    ["ur_mp5_mag_15"] = {
        VMBodygroups = {{ind = 2, bg = 3}},
    },
    ["ur_mp5_mag_40"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
    },
    ["ur_mp5_mag_50"] = {
        VMBodygroups = {{ind = 2, bg = 3}},
    },
    ["ur_mp5_mag_waffle"] = {
        VMBodygroups = {{ind = 2, bg = 2}},
    },

    ["ur_mp5_rail_optic"] = {
        VMBodygroups = {{ind = 3, bg = 1}},
    },

    ["ur_mp5_clamp"] = {
        VMBodygroups = {{ind = 5, bg = 1}},
    },

    ["receiver_lower"] = {
        VMBodygroups = {{ind = 8, bg = 1}},
    },
    ["receiver_lower_0"] = {
        VMBodygroups = {{ind = 8, bg = 0}},
    },
    ["receiver_upper_0"] = {
        VMBodygroups = {{ind = 7, bg = 0}},
    },

    ["stock_a3"] = {
        VMBodygroups = {
            {ind = 0, bg = 1},
            {ind = 1, bg = 1},
        },
    },
    ["stock_a3_folded"] = {
        VMBodygroups = {
            {ind = 0, bg = 1},
            {ind = 1, bg = 2},
        },
    },
    ["ur_mp5_stock_remove"] = {
        VMBodygroups = {{ind = 0, bg = 2}},
    },
    ["ur_mp5_stock_wood"] = {
        VMBodygroups = {{ind = 0, bg = 4}},
    },
    ["stock_pdw"] = {
        VMBodygroups = {{ind = 0, bg = 5}},
    },
    ["stock_pdw_folded"] = {
        VMBodygroups = {{ind = 0, bg = 6}},
    },
}

SWEP.Hook_ModifyBodygroups = function(wep, data)
    local atts = wep.Attachments
    local vm = data.vm

    local ub = atts[5].Installed

    if ub then
        if atts[2].Installed == "ur_mp5_barrel_sd" then
            vm:SetBodygroup(6,1)
            vm:SetBodygroup(5,3)
        -- elseif !string.StartWith(ub,"ur_mp5_ub_") then
            -- vm:SetBodygroup(6,0)
            -- vm:SetBodygroup(5,1)
        end
    -- else
        -- vm:SetBodygroup(6,0)
    end

    if atts[7].Installed == "ur_mp5_stock_none" and atts[2].Installed == "ur_mp5_barrel_kurz" then
        vm:SetBodygroup(0,7)
    end
end

SWEP.Hook_NameChange = function(wep,name)
    local atts = wep.Attachments
    local barr = string.Replace(atts[2].Installed or "default","ur_mp5_barrel_","")
    local cal = string.Replace(atts[3].Installed or "default","ur_mp5_caliber_","")
    local stock = string.Replace(atts[7].Installed or "default","ur_mp5_stock_","")
    local fakeNames = !GetConVar("arccw_truenames"):GetBool()

    local start = "MP5"
    local mid = "A"
    local num = "4"
    if fakeNames then
        start = "PK5"
        mid = "-"
    end

    if atts[12].Installed == "uc_fg_civvy" then
        if fakeNames then
            return "PK5-CIV"
        else
            if barr == "long" then
                start = "HK94" -- I know how prolific civies can get with their gunbuilds, so the nonsensical names will continue
            else
                return "SP5"
            end
        end
    end

    if cal ~= "default" and cal ~= "noburst" then
        if barr == "sd" then
            num = "SD"
        else
            num = ""
        end
        if cal == "10auto" then
            mid = "/10"
        elseif cal == "40sw" then
            mid = "/40"
        end
    else
        if barr == "kurz" then
            if fakeNames then
                mid = "C"
            else
                mid = "K"
            end
            if stock == "pdw" then
                num = "-PDW"
            elseif cal == "default" then
                if fakeNames then
                    num = "-4"
                else
                    num = "A4"
                end
            else
                num = ""
            end
        else
            if barr == "sd" then
                mid = "SD"
            end
        
            if cal == "noburst" then
                if stock == "default" then
                    num = "2"
                elseif stock == "a3" then
                    num = "3"
                elseif stock == "none" then
                    num = "1"
                end
            else
                if stock == "default" then
                    if barr == "sd" then
                        num = "5"
                    end
                elseif stock == "a3" then
                    if barr == "sd" then
                        num = "6"
                    else
                        num = "5"
                    end
                elseif stock == "none" then
                    if barr == "sd" then
                        num = "4"
                    end
                end
            end
        end
    end

    return start .. mid .. num
end

-- Animations --

SWEP.Hook_Think = ArcCW.UD.ADSReload

SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["idle_empty"] = {
        Source = "idle_empty",
    },
    ["ready"] = {
        Source = "ready",
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.6,
        SoundTable = {
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0.15},
            {s = path .. "chback.ogg",         t = 0.15, c = ci},
            {s = path .. "chamber.ogg",         t = .38, c = ci},
            {s = common .. "rattle2.ogg",         t = 0.75},
        }
    },
    ["draw"] = {
        Source = "draw",
        SoundTable = ArcCW.UD.DrawSounds,
    },
    ["draw_empty"] = {
        Source = "draw_empty",
        SoundTable = ArcCW.UD.DrawSounds,
    },
    ["holster"] = {
        Source = "holster",
        --Time = 0.25,
        SoundTable = ArcCW.UD.HolsterSounds,
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        --Time = 0.25,
        SoundTable = ArcCW.UD.HolsterSounds,
    },
    ["fire"] = {
        Source = "fire",
        Time = 13 / 30,
        ShellEjectAt = 0.03,
    },
    ["fire_empty"] = {
        Source = "fire_empty",
        Time = 13 / 30,
        ShellEjectAt = 0.03,
    },

    ["fix"] = {
        Source = "fix",
        Time = 40 / 30,
        ShellEjectAt = false,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.4,
        SoundTable = {
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0.15},
            {s = path .. "chback.ogg",         t = 0.27, c = ci},
            {s = path .. "chforward.ogg",         t = 0.5, c = ci},
        },
    },
    ["fix_empty"] = {
        Source = "fix_empty",
        Time = 40 / 30,
        ShellEjectAt = false,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.4,
        SoundTable = {
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0.15},
            {s = path .. "chback.ogg",         t = 0.3, c = ci},
            {s = path .. "chforward.ogg",         t = 0.65, c = ci},
        },
    },

    -- 30 Round Reloads --

    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 2,
        MinProgress = 1.2,
        LastClip1OutTime = 2,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.6,
        SoundTable = {
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0},
            {s = path .. "magout.ogg",        t = 0.25, c = ci},
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0.25},
            {s = path .. "magin.ogg",         t = 0.5, c = ci},
            {s = common .. "rattle2.ogg",  t = 1.55},
            {s = common .. "shoulder.ogg",  t = 1.5},
        },
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 90 / 30,
        MinProgress = 2.2,
        LastClip1OutTime = 1.8,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.3,
        LHIKEaseOut = 0.2,
        LHIKOut = 0.55,
        SoundTable = {
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0},
            {s = path .. "chback.ogg",         t = 0.1, c = ci},
            {s = path .. "chlock.ogg",         t = 0.19, c = ci},
            {s = path .. "magout.ogg",        t = .9, c = ci},
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0.25},
            {s = common .. "magdrop_smg.ogg",  t = 1.0},
            {s = path .. "magin.ogg",         t = 1.2, c = ci},
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 1.25},
            {s = path .. "chamber.ogg",         t = 2.13, c = ci},
            {s = common .. "rattle2.ogg",  t = 2.4},
            {s = common .. "shoulder.ogg",  t = 2.6},
        },
    },

    -- 15 Round Reloads --

    ["reload_15"] = {
        Source = "reload",--"reload_15",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 67 / 30,
        MinProgress = 1.2,
        LastClip1OutTime = 67 / 30,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.6,
        SoundTable = {
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0},
            {s = path .. "magout.ogg",        t = 0.25, c = ci},
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0.25},
            {s = path .. "magin.ogg",         t = 0.5, c = ci},
            {s = common .. "rattle2.ogg",  t = 1.8},
            {s = common .. "shoulder.ogg",  t = 1.5},
        },
    },
    ["reload_empty_15"] = {
        Source = "reload_empty",--"reload_empty_15",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 90 / 30,
        MinProgress = 2.2,
        LastClip1OutTime = 1.8,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.3,
        LHIKEaseOut = 0.2,
        LHIKOut = 0.55,
        SoundTable = {
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0},
            {s = path .. "chback.ogg",         t = 0.1, c = ci},
            {s = path .. "chlock.ogg",         t = 0.19, c = ci},
            {s = path .. "magout.ogg",        t = .9, c = ci},
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0.25},
            {s = common .. "magdrop_smg.ogg",  t = 1.0},
            {s = path .. "magin.ogg",         t = 1.2, c = ci},
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 1.25},
            {s = path .. "chamber.ogg",         t = 2.13, c = ci},
            {s = common .. "rattle2.ogg",  t = 2.4},
            {s = common .. "shoulder.ogg",  t = 2.6},
        },
    },

    -- 40 Round Reloads --

    ["reload_40"] = {
        Source = "reload",--"reload_40",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 67 / 30,
        MinProgress = 1.2,
        LastClip1OutTime = 67 / 30,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.6,
        SoundTable = {
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0},
            {s = path .. "magout.ogg",        t = 0.25, c = ci},
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0.25},
            {s = path .. "magin.ogg",         t = 0.5, c = ci},
            {s = common .. "rattle2.ogg",  t = 1.8},
            {s = common .. "shoulder.ogg",  t = 1.5},
        },
    },
    ["reload_empty_40"] = {
        Source = "reload_empty",--"reload_empty_40",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 90 / 30,
        MinProgress = 2.2,
        LastClip1OutTime = 1.8,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.3,
        LHIKEaseOut = 0.2,
        LHIKOut = 0.55,
        SoundTable = {
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0},
            {s = path .. "chback.ogg",         t = 0.1, c = ci},
            {s = path .. "chlock.ogg",         t = 0.19, c = ci},
            {s = path .. "magout.ogg",        t = .9, c = ci},
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0.25},
            {s = common .. "magdrop_smg.ogg",  t = 1.0},
            {s = path .. "magin.ogg",         t = 1.2, c = ci},
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 1.25},
            {s = path .. "chamber.ogg",         t = 2.13, c = ci},
            {s = common .. "rattle2.ogg",  t = 2.4},
            {s = common .. "shoulder.ogg",  t = 2.6},
        },
    },

    -- 100 Round Reloads --

    ["reload_50"] = {
        Source = "reload",--"reload_50",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 67 / 30,
        MinProgress = 1.6,
        LastClip1OutTime = 1,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.4,
        SoundTable = {
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0},
            {s = path .. "magout.ogg",        t = 0.25, c = ci},
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0.25},
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0.75},
            {s = path .. "magin.ogg",         t = 1.15, c = ci},
            {s = common .. "cloth_4.ogg",  t = 1.65},
            {s = common .. "shoulder.ogg",  t = 1.95},
        },
    },
    ["reload_empty_50"] = {
        Source = "reload_empty",--"reload_empty_50",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        -- Time = 90 / 30,
        MinProgress = 2.4,
        LastClip1OutTime = 1.8,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.3,
        LHIKEaseOut = 0.2,
        LHIKOut = 0.55,
        SoundTable = {
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0},
            {s = path .. "magout.ogg",        t = 0.25, c = ci},
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0.25},
            {s = {common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}, t = 0.75},
            {s = common .. "magdrop.ogg",  t = 1.0},
            {s = path .. "magin.ogg",         t = 1.15, c = ci},
            {s = common .. "cloth_4.ogg",  t = 1.65},
            {s = path .. "chback.ogg",         t = 2.25, c = ci},
            {s = path .. "chforward.ogg",         t = 2.1, c = ci},
            {s = common .. "shoulder.ogg",  t = 2.7},
        },
    },
}

SWEP.AutosolveSourceSeq = "idle"

SWEP.Attachments = {
    {
        PrintName = "Optic",
        DefaultAttName = "Iron Sights",
        Slot = {"optic_lp","optic"}, -- ,"optic"
        Bone = "body",
        Offset = {
            vpos = Vector(0, -1, 3),
            vang = Angle(90, 0, -90),
        },
        VMScale = Vector(.9, .9, .9),
        InstalledEles = {"ur_mp5_rail_optic"}
    },
    {
        PrintName = "Barrel",
        DefaultAttName = "9\" Tropical Barrel",
        DefaultAttIcon = Material("entities/att/acwatt_ur_mp5_body.png", "smooth mips"),
        Slot = "ur_mp5_barrel",
        Bone = "body",
        Offset = {
            vpos = Vector(2.6, -3.7, -17.3),
            vang = Angle(90, 0, -90),
        },
    },
    {
        PrintName = "Receiver",
        DefaultAttName = "Navy Receiver",
        DefaultAttIcon = Material("entities/att/acwatt_ur_mp5_caliber.png", "smooth mips"),
        Slot = "ur_mp5_caliber",
        DefaultEles = {"receiver_lower_0"}
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = {"muzzle"},
        Bone = "body",
        Offset = {
            vpos = Vector(0, .75, 14.4),
            vang = Angle(90, 0, -90),
        },
        ExcludeFlags = {"barrel_sd","mp5_kurz"}
    },
    {
        PrintName = "Underbarrel",
        DefaultAttName = "Tropical Handguard",
        Slot = {"foregrip","ur_mp5_hg"},
        Bone = "body",
        Offset = {
            vpos = Vector(0, 1.3, 10),
            vang = Angle(90, 0, -90),
        },
        --VMScale = Vector(.8, .8, .8),
        InstalledEles = {"ur_mp5_rail_fg"},
        GivesFlags = {"mp5_rail"},
        ExcludeFlags = {"mp5_kurz"}
    },
    {
        PrintName = "Tactical",
        Slot = {"tac_pistol"},
        Bone = "body",
        Offset = {
            vpos = Vector(-.61, 0.8, 12),
            vang = Angle(90, 0, 180),
        },
        VMScale = Vector(.8,.8,.8),
        --InstalledEles = {"ur_mp5_clamp"}
        GivesFlags = {"mp5_rail"},
        ExcludeFlags = {"mp5_kurz"}
    },
    {
        PrintName = "Stock",
        Slot = {"ur_mp5_stock"},
        DefaultAttName = "Full Stock",
        DefaultAttIcon = Material("entities/att/acwatt_ur_mp5_stock.png", "smooth mips"),
    },
    {
        PrintName = "Magazine",
        Slot = {"ur_mp5_mag"},
        DefaultAttName = "30-Round Mag",
        DefaultAttIcon = Material("entities/att/acwatt_ur_mp5_mag_32.png", "smooth mips"),
        ExcludeFlags = {"ur_mp5_cal_40sw","ur_mp5_cal_10mm"}
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
        Bone = "Body",
        Offset = {
            vpos = Vector(0.6, .8, 5.5),
            vang = Angle(90, 0, -90),
        },
    },
}

-- SWEP.AttachmentOverrides = {
--     ["uc_grip_handstop"] = {
--         LHIK = false
--     }
-- } -- THIS SHIT DOESN'T WORK