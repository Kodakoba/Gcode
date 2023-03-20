SWEP.Base = "arccw_base"
SWEP.Spawnable = true
SWEP.Category = "ArcCW - Urban Coalition"
SWEP.AdminOnly = false
SWEP.UseHands = true

-- Muzzle and shell effects --

SWEP.MuzzleEffect = "muzzleflash_1"
SWEP.ShellModel = "models/weapons/arccw/uc_shells/556x45.mdl"
SWEP.ShellScale = 1
--SWEP.ShellMaterial = "models/weapons/arcticcw/shell_556"
SWEP.ShellPitch = 100

SWEP.MuzzleEffectAttachment = 1
SWEP.CaseEffectAttachment = 2
SWEP.CamAttachment = 3
SWEP.TracerNum = 1
SWEP.TracerCol = Color(25, 255, 25)
SWEP.TracerWidth = 2

-- Fake name --

SWEP.PrintName = "AMCAR"
-- AMCAR stands for (american) Colt Assault Rifle, not Carbine!! ~Fesiug
-- shut up retard ~zenith

-- True name --

SWEP.TrueName = "M16A2"

-- Trivia --
SWEP.Trivia_Class = "Assault Rifle"
SWEP.Trivia_Desc = "Third generation of America's iconic military rifle. Army tests showed that soldiers were more likely to hit a target if they fired multiple shots, but were likely to spray in full-auto and fail to hit anything. As a result, they implemented a ratcheted three-round burst system which limited the maximum burst a soldier could fire to three shots. Well-rounded gun with no major downsides."
SWEP.Trivia_Manufacturer = "Stoner's Legacy Ltd."
SWEP.Trivia_Calibre = "5.56x45mm NATO"
SWEP.Trivia_Mechanism = "Gas-Operated Rotating Bolt"
SWEP.Trivia_Country = "USA"
SWEP.Trivia_Year = 1959

local origDesc = SWEP.Trivia_Desc
local m4Desc = "Carbine variant of the M16 rifle. Originally designed in response to design faults in the CAR-15 family, it eventually replaced the M16 across almost every branch of the Army for its favorably low weight and comparable performance. Well-rounded and light, but can become difficult to control without discipline."
local ncrDesc = "Standard-issue rifle of the New California Republic. Traditionally produced with a semi-automatic receiver, the wooden furniture is easily replaceable and adds additional recoil control for maximum accuracy. Well-rounded gun with no major downsides."
local smgDesc = "Submachine gun based on the M16 rifle. Despite its similar appearance, it uses a different mechanism from its parent rifle. More accurate than other submachine guns due to its rifle frame and closed-bolt mechanism."

-- Weapon slot --

SWEP.Slot = 2

-- Weapon's manufacturer real name --

if GetConVar("arccw_truenames"):GetBool() then
    SWEP.PrintName = SWEP.TrueName
    SWEP.Trivia_Manufacturer = "Colt's Manufacturing Company"
end

-- Viewmodel / Worldmodel / FOV --

SWEP.ViewModel = "models/weapons/arccw/c_ud_m16.mdl"
SWEP.WorldModel = "models/weapons/arccw/c_ud_m16.mdl"
SWEP.ViewModelFOV = 80
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

-- Damage --

SWEP.Damage = 34 -- 3 shot kill
SWEP.DamageMin = 20 -- 5 shot kill
SWEP.RangeMin = 50
SWEP.Range = 350 -- 4 shot until ~250m

SWEP.Penetration = 14
SWEP.DamageType = DMG_BULLET
SWEP.ShootEntity = nil
SWEP.MuzzleVelocity = 960
SWEP.PhysBulletMuzzleVelocity = 960

SWEP.BodyDamageMults = ArcCW.UC.BodyDamageMults

-- Mag size --

SWEP.ChamberSize = 1
SWEP.Primary.ClipSize = 30
SWEP.ExtendedClipSize = 40
SWEP.ReducedClipSize = 20

-- Recoil --

SWEP.Recoil = 0.5
SWEP.RecoilSide = 0.25

SWEP.RecoilRise = 0.1
SWEP.RecoilPunch = 1
SWEP.VisualRecoilMult = 1
SWEP.MaxRecoilBlowback = 1
SWEP.MaxRecoilPunch = 1
SWEP.RecoilPunchBack = 1

SWEP.Sway = 0.5

-- Firerate / Firemodes --

SWEP.Delay = 60 / 900
SWEP.Num = 1
SWEP.Firemodes = {
    {
        Mode = -3,
        PostBurstDelay = 0.1,
        RunawayBurst = false, -- https://en.wikipedia.org/wiki/Burst_mode_(weapons)
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.ShootPitch = 100
SWEP.ShootVol = 120
SWEP.ShootPitchVariation = 0

SWEP.ProceduralRegularFire = false
SWEP.ProceduralIronFire = false

SWEP.ReloadInSights = true

-- NPC --

SWEP.NPCWeaponType = "weapon_ar2"
SWEP.NPCWeight = 60

-- Accuracy --

SWEP.AccuracyMOA = 4
SWEP.HipDispersion = 800
SWEP.MoveDispersion = 200
SWEP.JumpDispersion = 1000

SWEP.Primary.Ammo = "smg1"
SWEP.MagID = "m16"

SWEP.HeatCapacity = 150
SWEP.HeatDissipation = 10
SWEP.HeatDelayTime = 3

SWEP.MalfunctionMean = 200
SWEP.MalfunctionTakeRound = false

-- Speed multipliers --

SWEP.SpeedMult = 0.925
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.5
SWEP.ShootSpeedMult = 0.9

-- Length --

SWEP.BarrelLength = 48
SWEP.ExtraSightDist = -5

-- Ironsights / Customization / Poses --

SWEP.HolsterPos = Vector(0.5, -1, 1.2)
SWEP.HolsterAng = Angle(-8.5, 8, -10)

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"

SWEP.IronSightStruct = {
     Pos = Vector(-2.81, 6, 0.85),
     Ang = Angle(0, 0, 0),
     Magnification = 1.1,
     SwitchToSound = "",
}
--[[SWEP.ExtraIrons = {
    {
        Pos = Vector(-3, -1.5, -1),
        Ang = Angle(1.75, 0, -15),
        Magnification = 1,
        ViewModelFOV = 55,
        GlobalAng = true,
        GlobalPos = false,
        CrosshairInSights = true,
    }
}]]

SWEP.ActivePos = Vector(0.33, 0, 1)
SWEP.ActiveAng = Angle(0, 0, -3)

SWEP.CustomizePos = Vector(5, -2, -2)
SWEP.CustomizeAng = Angle(15, 25, 0)

SWEP.CrouchPos = Vector(-2.5, -2, -0.6)
SWEP.CrouchAng = Angle(0, 0, -14)

SWEP.BarrelOffsetHip = Vector(2, 0, -5)

SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos        =    Vector(-8, 4, -7.5),
    ang        =    Angle(-6, 0, 180),
    bone    =    "ValveBiped.Bip01_R_Hand",
}

-- Firing sounds --

local path = ")^weapons/arccw_ud/m16/"
local common = ")^/arccw_uc/common/"
SWEP.FirstShootSound = path .. "first.ogg"
--SWEP.ShootSound = {path .. "fire-01.ogg", path .. "fire-02.ogg", path .. "fire-03.ogg", path .. "fire-04.ogg", path .. "fire-05.ogg", path .. "fire-06.ogg"} -- Maybe Not Placeholder
--SWEP.DistantShootSound = {path .. "fire-dist-01.ogg", path .. "fire-dist-02.ogg", path .. "fire-dist-03.ogg", path .. "fire-dist-04.ogg", path .. "fire-dist-05.ogg", path .. "fire-dist-06.ogg"} -- Maybe Not Placeholder
SWEP.ShootSound = {path .. "auto1.ogg", path .. "auto2.ogg", path .. "auto3.ogg", path .. "auto4.ogg"}
SWEP.DistantShootSound = path .. "dist.ogg"
SWEP.ShootSoundSilenced = path .. "fire_sup.ogg"
SWEP.DistantShootSoundSilenced = common .. "sup_tail.ogg"
SWEP.ShootDrySound = path .. "dryfire.ogg"

SWEP.DistantShootSoundOutdoors = nil
SWEP.DistantShootSoundIndoors = nil
SWEP.DistantShootSoundOutdoorsVolume = 0.2
SWEP.DistantShootSoundIndoorsVolume = 1
SWEP.Hook_AddShootSound = ArcCW.UD.InnyOuty

-- Bodygroups --

SWEP.BulletBones = {
    [2] = "m16_bullets1",    [3] = "m16_bullets2"
}

local BLEN_20 = 3
local BLEN_14 = 2
local BLEN_10 = 1

local BTAG_RIS = 1
local BTAG_NOFS = 2
local BTAG_NOMNT = 4

local len_clamp_lookup = {
    [BLEN_20] = 1,
    [BLEN_14] = 3,
    [BLEN_10] = 2,
}

local barrel_lookup = {
    ["default"]       = {BLEN_20},
    ["tactical_a4"]   = {BLEN_20, BTAG_RIS},
    ["lmg"]           = {BLEN_20},
    ["classic"]       = {BLEN_20},
    ["wood"]          = {BLEN_20},

    ["classic_short"] = {BLEN_14},
    ["tactical"]      = {BLEN_14, BTAG_RIS},
    ["m4"]            = {BLEN_14},
    ["fpw"]           = {BLEN_14, BTAG_NOFS},
    ["adar"]          = {BLEN_14},
    ["wood_short"]    = {BLEN_14},

    ["cqbr"]          = {BLEN_10},
    ["cqbr_ris"]      = {BLEN_10, BTAG_RIS},
    ["sd"]            = {BLEN_10, BTAG_NOFS + BTAG_NOMNT},
    ["ru556"]         = {BLEN_10, BTAG_NOFS + BTAG_NOMNT},
}


local function has_tag(b, t)
    return bit.band(barrel_lookup[b][2] or 0, t) ~= 0
end

local FCG_3BST = 0
local FCG_AUTO = 1
local FCG_SEMI = 2
local FCG_BOLT = 3

local CAL_556 = 0
local CAL_9MM = 1
local CAL_BLK = 2
local CAL_BEO = 3

local receiver_lookup = {
    ["default"]     = {FCG_3BST, CAL_556},
    ["altburst"]    = {FCG_3BST, CAL_556},

    ["auto"]        = {FCG_AUTO, CAL_556},
    ["a1"]          = {FCG_AUTO, CAL_556},
    ["300blk"]      = {FCG_AUTO, CAL_BLK},
    ["9mm"]         = {FCG_AUTO, CAL_9MM},

    ["50beo"]       = {FCG_SEMI, CAL_BEO},
    ["semi"]        = {FCG_SEMI, CAL_556},

    ["cali"]        = {FCG_BOLT, CAL_556},
}

local supp_cal_lookup = {
    [CAL_9MM] = "SSMG",
}

local supp_fcg_lookup = {
    [FCG_AUTO] = "SA",
    [FCG_3BST] = "SB",
    [FCG_SEMI] = "SS",
    [FCG_BOLT] = "SM",
}

SWEP.Hook_NameChange = function(wep, name)
    local trueNames = GetConVar("arccw_truenames"):GetBool()
    local flat = wep.Attachments[1].Installed and !wep:GetBuff_Override("TopMount")

    local hg = string.Replace(wep.Attachments[2].Installed or "default", "ud_m16_barrel_", "")
    local blen = (barrel_lookup[hg] or barrel_lookup["default"])[1]

    local rn = string.Replace(wep.Attachments[4].Installed or "default", "ud_m16_receiver_", "")
    local r_fg, r_cal = unpack(receiver_lookup[rn] or barrel_lookup["default"])

    wep.Trivia_Desc = origDesc
    wep.Trivia_Mechanism = "Gas-Operated Rotating Bolt"
    wep.Trivia_Country = "USA"

    -- service loadouts
    if hg == "wood" or hg == "wood_short" then
        wep.Trivia_Desc = ncrDesc
        wep.Trivia_Country = "New California Republic"
        if r_cal == CAL_9MM then
            return "Service SMG"
        elseif blen == BLEN_14 then
            return "Service Carbine"
        end
        return "Service Rifle"
    end

    if trueNames then
        local model = "M"
        local alt = "16A2"
        local post = ""

        local sil = wep:GetBuff_Override("SDBarrel")
        local silHandled = !sil

        -------------------------------
        -- Caliber Variants
        -------------------------------
        if r_cal == CAL_9MM then
            model = "R0"
            if flat then
                alt = "991"
            else
                alt = "635"
            end
            wep.Trivia_Desc = smgDesc
            wep.Trivia_Mechanism = "Blowback"
        elseif r_cal == CAL_BLK then
            model = "AR"
            alt = "-15"
            post = " .300 BLK"
            wep.Trivia_Desc = "Aftermarket automatic variant of the M16 rifle. The .300 Blackout cartridge has a ballistic performance more akin to the 7.62x39mm Soviet cartridge, with a similarly sized projectile but shorter effective range."
        -------------------------------
        -- Bolt/Semi Variants
        -------------------------------
        elseif r_fg == FCG_BOLT then
            model = "AR"
            alt = "-15"
            post = "GB"
            wep.Trivia_Desc = "AR-15 style rifles are a class of rifles linked to the M16, normally with a semi-automatic fire group for the civilian market. This one, however, has been neutered by authority of the British crown with a manual-action receiver. Bit cringe, innit?"
        elseif r_fg == FCG_SEMI then
            model = "AR"
            alt = "-15"
            wep.Trivia_Desc = "Semi-automatic variant of the M16 series of rifles, produced for the civilian market. Wildly popular in the United States, this rifle can be seen in the hands of hobbyists, hunters and mass shooters alike. Well-rounded gun with no major downsides."
            if r_cal == CAL_BEO then
                post = " .50 Beowulf"
                wep.Trivia_Desc = "Aftermarket semi-automatic variant of the M16 rifle firing an oversized magnum cartridge. Provides extremely high stopping power at close range."
            elseif flat and hg == "adar" then
                model = "ADAR "
                alt = "2-15"
            end
        -------------------------------
        -- Barrel Variants
        -------------------------------
        elseif hg == "m4" or hg == "tactical" then
            if r_fg == FCG_AUTO then
                if !flat then
                    model = "XM"
                    alt = "4"
                else
                    alt = "4A1"
                end
            else
                alt = "4"
                post = " Carbine"
            end
            --post = " Carbine"
            wep.Trivia_Desc = m4Desc
        -------------------------------
        -- Auto/Semi Variants
        -------------------------------
        elseif r_fg == FCG_3BST and !sil then
            if blen == BLEN_10 then
                post = " Commando"
            elseif flat then
                alt = "16A4"
                wep.Trivia_Desc = "Fourth and the most recent generation of the M16 rifle. Notable changes include a flat top and RIS handguard allowing for easy installation of optics and other attachments. Well-rounded gun with no major downsides."
            end
        elseif r_fg == FCG_AUTO then
            model = "M"
            alt = "16A3"
            wep.Trivia_Desc = m4Desc
            if hg == "tactical_a4" and flat then
                model = "R0"
                alt = "901"
            elseif hg == "m605" then
                alt = "605"
            elseif blen == BLEN_10 and !sil then
                if flat then
                    model = "Mk 18"
                    alt = " Mod 0"
                else
                    model = "CAR"
                    alt = "-15"
                end
                if flat then
                    wep.Trivia_Desc = m4Desc
                else
                    wep.Trivia_Desc = "Carbine variant of the M16 rifle, short enough to be classified as a submachine gun. Its features influenced the US Army's interest in the M4 Carbine, which went on to become their new standard rifle. Due to the small barrel, rifles of this family have high maneuverability but poor range compared to their parent platform."
                end
            elseif flat and blen < BLEN_20 then
                alt = "4A1"
            elseif rn == "a1" then
                alt = "16A1"
                wep.Trivia_Desc = "Second generation of America's iconic military rifle. Developed to address problems with the original M16, which suffered notoriously frequent jamming that could get its wielder killed. A well-rounded rifle, but difficult to control without trigger discipline - something the A2 model eventually addressed."
            else
                wep.Trivia_Desc = "Variant of the M16A2 with the original full-automatic trigger group, relegated to niche roles in the US Army. Well-rounded gun with no major downsides."
            end
        end

        if hg == "lmg" and r_fg < FCG_SEMI  then
            --alt = string.Left(alt, #alt == 3 and #alt or 2)
            model = "Colt"
            alt = " LMG"
            wep.Trivia_Desc = "Configuration of the M16 designed for a light machine gun role, used vaguely within the Marine Corps before the adoption of the Minimi. Heavier than the standard platform, but the integral bipod can be deployed onto surfaces for excellent recoil control."
        elseif hg == "fpw" then
            model = "M"
            alt = "231 FPW"
            if r_cal == CAL_9MM then
                post = " 9mm"
            end
        end

        if !silHandled then
            if supp_cal_lookup[r_cal] then
                alt = supp_cal_lookup[r_cal]
                silHandled = true
            end
            if supp_fcg_lookup[r_fg] then
                alt = supp_fcg_lookup[r_fg]
                silHandled = true
            end
            if !silHandled then alt = alt .. "-S" end
        end

        return model .. alt .. post
    else
        -- work on this in a few
        if false then
            return "AMCAR-NG"
        elseif false then
            return "AMSAS-12"
        elseif false then
            return "AMPAW-9"
        elseif false then
            return "UKCAR .223"
        elseif false then
            return "RUCAR 225"
        elseif false then
            return "AMRA1"
        else
            return "AMCAR"
        end
    end
end

SWEP.DefaultBodygroups = "000000000000000"

SWEP.AttachmentElements = {

    ["ud_m16_mag_20"] = {
        VMBodygroups = {{ind = 2, bg = 1}},
    },
    ["ud_m16_mag_40"] = {
        VMBodygroups = {{ind = 2, bg = 2}},
    },
    ["ud_m16_mag_60"] = {
        VMBodygroups = {{ind = 2, bg = 3}},
    },
    ["ud_m16_mag_100"] = {
        VMBodygroups = {{ind = 2, bg = 4}},
    },
    ["ud_m16_9mm_mag"] = {
        VMBodygroups = {{ind = 2, bg = 5}},
    },
    ["ud_m16_9mm_mag_32"] = {
        VMBodygroups = {{ind = 2, bg = 6}},
    },
    ["ud_m16_mag_50beo"] = {
        VMBodygroups = {{ind = 2, bg = 8}},
    },

    ["upper_flat"] = {
        -- handled by code
        --[[]
        VMBodygroups = {
            {ind = 1, bg = 1},
            {ind = 3, bg = 3}
        },
        ]]
    },
    ["upper_classic"] = {
        VMBodygroups = {
            {ind = 1, bg = 3},
        },
    },

    ["stock_231_ex"] = {
        VMBodygroups = {{ind = 7, bg = 1}},
    },
    ["stock_231_in"] = {
        VMBodygroups = {{ind = 7, bg = 2}},
    },
    ["stock_231_tube"] = {
        VMBodygroups = {{ind = 7, bg = 3}},
    },
    ["stock_607_ex"] = {
        VMBodygroups = {{ind = 7, bg = 4}},
    },
    ["stock_607_in"] = {
        VMBodygroups = {{ind = 7, bg = 5}},
    },
    ["stock_608"] = {
        VMBodygroups = {{ind = 7, bg = 6}},
    },
    ["stock_carbine_ex"] = {
        VMBodygroups = {{ind = 7, bg = 7}},
    },
    ["stock_carbine_in"] = {
        VMBodygroups = {{ind = 7, bg = 8}},
    },
    ["stock_wood"] = {
        VMBodygroups = {{ind = 7, bg = 9}},
    },
    ["stock_adar"] = {
        VMBodygroups = {
            {ind = 7, bg = 10},
            {ind = 8, bg = 4}
        },
    },
    ["stock_ru556"] = {
        VMBodygroups = {{ind = 7, bg = 11}},
    },
    ["grip_ergo"] = {
        VMBodygroups = {{ind = 8, bg = 1}},
    },
    ["grip_skel"] = {
        VMBodygroups = {{ind = 8, bg = 2}},
    },
    ["grip_wood"] = {
        VMBodygroups = {{ind = 8, bg = 3}},
    },

    ["gasblock_carbine"] = {
        VMBodygroups = {{ind = 6, bg = 3}},
    },
    ["fs_adar"] = {
        VMBodygroups = {{ind = 6, bg = 4}},
    },

    ["mount_14"] = {
        AttPosMods = {
            [6] = {
                vpos = Vector(0, 0.8, 22),
                vang = Angle(90, 0, -90),
            },
        },
    },
    ["mount_11"] = {
        AttPosMods = {
            [6] = {
                vpos = Vector(1, -0.1, 17.9),
                vang = Angle(90, 0, 0),
            },
        },
    },

    ["barrel_14"] = {
        VMBodygroups = {
            {ind = 4, bg = 1},
            {ind = 6, bg = 2},
        },
        AttPosMods = {
            [3] = {
                vpos = Vector(0, -0.07, 25.4),
                vang = Angle(90, 0, -90),
            },
        }
    },
    ["barrel_11"] = {
        VMBodygroups = {
            {ind = 4, bg = 2},
            {ind = 6, bg = 2},
        },
        AttPosMods = {
            [3] = {
                vpos = Vector(0, -0.07, 21.3),
                vang = Angle(90, 0, -90),
            },
        }
    },
    ["barrel_11_ru556"] = {
        VMBodygroups = {
            {ind = 4, bg = 4},
            {ind = 6, bg = 5},
        },
        AttPosMods = {
            [3] = {
                vpos = Vector(0, -0.07, 21.3),
                vang = Angle(90, 0, -90),
            },
            [6] = {
                vpos = Vector(1.15, 0, 17.9),
                vang = Angle(90, 0, 0),
            },
        }
    },

    ["hg_m16a4_ris"] = {
        VMBodygroups = {
            {ind = 5, bg = 2},
        },
        AttPosMods = {
            [5] = {
                vpos = Vector(-0.1, 1.05, 12),
                vang = Angle(90, 0, -90),
            },
            [6] = {
                vpos = Vector(1.41, -.1, 20),
                vang = Angle(90, 0, 0),
            },
        }
    },
    ["hg_m4a1_ris"] = {
        VMBodygroups = {
            {ind = 5, bg = 5},
        },
        AttPosMods = {
            [5] = {
                vpos = Vector(0, 1.4, 12),
                vang = Angle(90, 0, -90),
            },
            [6] = {
                vpos = Vector(-1.41, -.2, 14),
                vang = Angle(90, 0, 180),
            },
        },
    },
    ["hg_ru556"] = {
        VMBodygroups = {
            {ind = 5, bg = 7},
        },
        AttPosMods = {
            [5] = {
                vpos = Vector(-0.1, 1.05, 12),
                vang = Angle(90, 0, -90),
            },
            [6] = {
                vpos = Vector(1.1, 0, 14),
                vang = Angle(90, 0, 0),
            },
        },
    },
    ["hg_m4a1"] = {
        VMBodygroups = {
            {ind = 5, bg = 4},
        }
    },
    ["hg_cqbr"] = {
        VMBodygroups = {
            {ind = 5, bg = 4},
        },
    },
    ["hg_adar"] = {
        VMBodygroups = {
            {ind = 5, bg = 8},
        },
    },
    ["hg_fpw"] = {
        VMBodygroups = {
            {ind = 5, bg = 6},
            --{ind = 6, bg = 4},
        }
    },
    ["hg_m16a1"] = {
        VMBodygroups = {
            {ind = 5, bg = 1},
        }
    },
    ["hg_m16a1_wood"] = {
        VMBodygroups = {
            {ind = 5, bg = 1},
        },
        VMSkin = 1
    },
    ["hg_m605"] = {
        VMBodygroups = {
            {ind = 5, bg = 1},
            {ind = 4, bg = 1},
        },
        AttPosMods = {
            [3] = {
                vpos = Vector(0, -0.05, 25.58),
                vang = Angle(90, 0, -90),
            },
            [6] = { -- also has no rail
                vpos = Vector(0, 0.9, 22.2),
                vang = Angle(90, 0, -90),
            },
        }
    },
    ["hg_m605_wood"] = {
        VMBodygroups = {
            {ind = 5, bg = 1},
            {ind = 4, bg = 1},
        },
        AttPosMods = {
            [3] = {
                vpos = Vector(0, 0, 25),
                vang = Angle(90, 0, -90),
            },
            [6] = { -- also has no rail
                vpos = Vector(0, 0.8, 22),
                vang = Angle(90, 0, -90),
            },
        },
        VMSkin = 1
    },
    ["hg_lmg"] = {
        VMBodygroups = {
            {ind = 5, bg = 3},
        }
    },
    ["hg_sd"] = {
        VMBodygroups = {
            {ind = 5, bg = 9},
            {ind = 4, bg = 3},
            {ind = 6, bg = 5}
        },
        AttPosMods = { -- no rail, just pretend it's mounted to something
            [6] = {
                vpos = Vector(0, 0.7, 17.5),
                vang = Angle(90, 0, -90),
            },
        }
    },

    ["ud_m16_upper_charm"] = {
        AttPosMods = {
            [1] = {
                vpos = Vector(0, -4, 3),
                vang = Angle(90, 0, -90),
                SlideAmount = {
                    vmin = Vector(0, -4, 3 - 1.5),
                    vmax = Vector(0, -4, 3 + 2.5),
                }
            },
        },
    },
    ["ud_m16_upper_charm2"] = {
        AttPosMods = {
            [1] = {
                vpos = Vector(0, -4.1, 3.5),
                vang = Angle(90, 0, -90),
                SlideAmount = {
                    vmin = Vector(0, -4.1, 3.5 - 2),
                    vmax = Vector(0, -4.1, 3.5 + 1.5),
                }
            },
        },
    },
    ["m16_strap"] = {
        VMBodygroups = {
             {ind = 13, bg = 1},
        },
    },
    ["bravo_dicks_going_fart"] = {
        AttPosMods = {
            [6] = {
                vpos = Vector(0.25, -1.4, 12),
                vang = Angle(90, 0, 90),
            },
        },
    },

    ---- Cut content
    ["hg_stub"] = {
        VMBodygroups = {
            {ind = 5, bg = 7},
        },
        AttPosMods = {
            [3] = {
                vpos = Vector(0, -0.35, 7),
                vang = Angle(90, 0, -90)
            },
            [6] = {
                vpos = Vector(1.1, -0.4, 9),
                vang = Angle(90, 0, 0),
            },
        }
    },
    ["barrel_stub"] = {
        VMBodygroups = {
            {ind = 4, bg = 4},
            {ind = 6, bg = 4},
        }
    },
    ["hg_smg"] = {
        VMBodygroups = {
            {ind = 5, bg = 0},
        }
    },
}

-- Animations --

SWEP.Hook_Think = ArcCW.UD.ADSReload

local rottle = {common .. "cloth_1.ogg", common .. "cloth_2.ogg", common .. "cloth_3.ogg", common .. "cloth_4.ogg", common .. "cloth_6.ogg", common .. "rattle.ogg"}
local ratel = {common .. "rattle1.ogg", common .. "rattle2.ogg", common .. "rattle3.ogg"}

SWEP.Animations = {
    ["ready"] = {
        Source = "fix",
        Time = 45 / 30,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.4,
        SoundTable = {
            {s = common .. "raise.ogg", t = 0},
            {s = common .. "rattle.ogg", t = 0.2},
            {s = path .. "chback.ogg",   t = 0.15},
            {s = common .. "cloth_4.ogg",  t = 0.5},
            {s = path .. "chamber.ogg",  t = 0.5},
        },
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
            {s = common .. "raise.ogg", t = 0},
            {s = common .. "shoulder.ogg", t = 0.15},
            {s = ratel, t = 0.2},
        },
    },
    ["draw_empty"] = {
        Source = "draw_empty",
        Time = 20 / 30,
        SoundTable = {
            {s = common .. "raise.ogg", t = 0},
            {s = common .. "shoulder.ogg", t = 0.15},
            {s = ratel, t = 0.2},
        },
    },
    ["holster"] = {
        Source = "holster",
        SoundTable = {
            {s = ratel, t = 0},
            {s = common .. "cloth_6.ogg", t = 0.2},
        },
    },
    ["holster_empty"] = {
        Source = "holster_empty",
        Time = 20 / 30,
        SoundTable = {
            {s = ratel, t = 0},
            {s = common .. "cloth_6.ogg", t = 0.2},
        },
    },
    ["fire"] = {
        Source = "fire",
        Time = 13 / 30,
        ShellEjectAt = 0.01,
        SoundTable = {{ s = {path .. "mech-01.ogg", path .. "mech-02.ogg", path .. "mech-03.ogg", path .. "mech-04.ogg", path .. "mech-05.ogg", path .. "mech-06.ogg"}, t = 0 }},
    },
    ["fire_empty"] = {
        Source = "fire_empty",
        Time = 13 / 30,
        ShellEjectAt = 0.01,
        SoundTable = {
            {s = path .. "mech_last.ogg", t = 0}, -- Temporary
        },
    },

    ["fire_cycle"] = {
        Source = "fire",
        Time = 13 / 30,
    },

    ["cycle"] = {
        Source = "fix",
        Time = 36 / 30 * 0.7,
        ShellEjectAt = 0.3,
        LHIK = true,
        LHIKIn = 0.3 * 0.7,
        LHIKEaseIn = 0.4 * 0.7,
        LHIKEaseOut = 0.15 * 0.7,
        LHIKOut = 0.4 * 0.7,
        SoundTable = {
            {s = path .. "chback.ogg",   t = 0.05},
            {s = common .. "cloth_4.ogg",  t = 0.2},
            {s = path .. "chamber.ogg",  t = 0.3},
        },
    },

    ["fix"] = {
        Source = "fix",
        Time = 45 / 30,
        ShellEjectAt = false,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.4,
        SoundTable = {
            {s = path .. "chback.ogg",   t = 0.15},
            {s = common .. "cloth_4.ogg",  t = 0.5},
            {s = path .. "chamber.ogg",  t = 0.5},
        },
    },
    ["fix_empty"] = {
        Source = "fix_empty",
        Time = 45 / 30,
        ShellEjectAt = false,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.4,
        SoundTable = {
            {s = path .. "chback.ogg",   t = 0.15},
            {s = common .. "cloth_4.ogg",  t = 0.5},
            {s = path .. "ch_forward_empty.ogg",  t = 0.5},
        },
    },
    ["fix_100"] = {
        Source = "fix_100",
        Time = 50 / 30,
        ShellEjectAt = false,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.4,
        SoundTable = {
            {s = path .. "chback.ogg",   t = 0.25},
            {s = common .. "cloth_4.ogg",  t = 0.75},
            {s = path .. "chamber.ogg",  t = 0.75},
        },
    },
    ["fix_empty_100"] = {
        Source = "fix_empty_100",
        Time = 50 / 30,
        ShellEjectAt = false,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.4,
        SoundTable = {
            {s = path .. "chback.ogg",   t = 0.1},
            {s = common .. "cloth_4.ogg",  t = 0.5},
            {s = path .. "chamber.ogg",  t = 0.5},
        },
    },

    -- 30 Round Reloads --

    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 71 / 30,
        MinProgress = 1.5,
        LastClip1OutTime = 0.9,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.3,
        LHIKOut = 0.5,
        SoundTable = {
            {s = rottle,  t = 0.0},
            {s = ratel, t = 0.25},
            {s = path .. "magout.ogg", 	 t = 0.335},
            {s = ratel, t = 0.5},
            {s = common .. "magpouch.ogg", t = 0.7},
            {s = path .. "magin.ogg",    t = 1.05},
            {s = ratel, t = 1.1},
            {s = rottle,  t = 1.15},
            {s = common .. "grab.ogg", t = 1.81},
            {s = common .. "shoulder.ogg", t = 1.9},
        },
    },
    ["reload_empty"] = {
        Source = "reload_empty",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 79 / 30,
        MinProgress = 2,
        LastClip1OutTime = 0.7,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.3,
        LHIKOut = 0.5,
        SoundTable = {
            {s = rottle,  t = 0.0},
            {s = ratel, t = 0.25},
            {s = path .. "magout.ogg", 	 t = 0.335},
            {s = ratel, t = 0.5},
            {s = common .. "magpouch.ogg", t = 0.6},
            {s = common .. "rifle_magdrop.ogg",  t = 0.8},
            {s = path .. "magin.ogg",    t = 1.05},
            {s = ratel, t = 1.1},
            {s = rottle,  t = 1.39},
            {s = path .. "boltdrop.ogg", t = 1.85},
            {s = ratel, t = 1.9},
            {s = common .. "grab.ogg", t = 2.0},
            {s = common .. "shoulder.ogg", t = 2.15},
        },
    },

    -- 20 Round Reloads --

    ["reload_20"] = {
        Source = "reload_20",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 71 / 30,
        MinProgress = 1.5,
        LastClip1OutTime = 0.9,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.3,
        LHIKOut = 0.5,
        SoundTable = {
            {s = rottle,  t = 0.0},
            {s = path .. "magout.ogg", 	 t = 0.35},
            {s = common .. "magpouch.ogg", t = 0.7},
            {s = rottle,  t = 0.75},
            {s = path .. "magin.ogg",    t = 0.95},
            {s = rottle,  t = 1.1},
            {s = common .. "shoulder.ogg", t = 1.925},
        },
    },
    ["reload_empty_20"] = {
        Source = "reload_empty_20",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 79 / 30,
        MinProgress = 2,
        LastClip1OutTime = 0.7,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.3,
        LHIKOut = 0.5,
        SoundTable = {
            {s = rottle, t = 0.0},
            {s = path .. "magout.ogg", 	 t = 0.2},
            {s = common .. "magpouch.ogg", t = 0.6},
            {s = rottle, t = 0.75},
            {s = common .. "rifle_magdrop.ogg",  t = 0.8},
            {s = path .. "magin.ogg",    t = 0.95},
            {s = rottle, t = 1.39},
            {s = path .. "boltdrop.ogg", t = 1.77},
            {s = common .. "shoulder.ogg", t = 2.13},
        },
    },

    -- 40 Round Reloads --

    ["reload_40"] = {
        Source = "reload_40",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 71 / 30,
        MinProgress = 1.5,
        LastClip1OutTime = 0.9,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.4,
        LHIKOut = 0.6,
        SoundTable = {
            {s = rottle, t = 0.0},
            {s = path .. "magout.ogg", 	 t = 0.35},
            {s = common .. "magpouch.ogg", t = 0.7},
            {s = rottle, t = 0.75},
            {s = path .. "magin.ogg",    t = 1.05},
            {s = rottle, t = 1.1},
            {s = common .. "shoulder.ogg", t = 1.85},
        },
    },
    ["reload_empty_40"] = {
        Source = "reload_empty_40",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 79 / 30,
        MinProgress = 2,
        LastClip1OutTime = 0.7,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.3,
        LHIKOut = 0.5,
        SoundTable = {
            {s = rottle,  t = 0.0},
            {s = path .. "magout.ogg", 	 t = 0.35},
            {s = common .. "magpouch.ogg", t = 0.6},
            {s = rottle,  t = 0.75},
            {s = common .. "rifle_magdrop.ogg",  t = 0.8},
            {s = path .. "magin.ogg",    t = 1.05},
            {s = rottle,  t = 1.475},
            {s = path .. "boltdrop.ogg", t = 1.78},
            {s = common .. "shoulder.ogg", t = 2.2},
        },
    },

    -- 60 Round Reloads --

    ["reload_60"] = {
        Source = "reload_60",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 71 / 30,
        MinProgress = 1.5,
        LastClip1OutTime = 0.9,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.3,
        LHIKOut = 0.5,
        SoundTable = {
            {s = rottle, t = 0.0},
            {s = path .. "magout.ogg", 	 t = 0.35},
            {s = common .. "magpouch.ogg", t = 0.7},
            {s = rottle, t = 0.75},
            {s = path .. "magin.ogg",    t = 1.1},
            {s = rottle, t = 1.1},
            {s = common .. "shoulder.ogg", t = 1.97},
        },
    },
    ["reload_empty_60"] = {
        Source = "reload_empty_60",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 79 / 30,
        MinProgress = 2,
        LastClip1OutTime = 0.7,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.3,
        LHIKOut = 0.5,
        SoundTable = {
            {s = rottle, t = 0.0},
            {s = path .. "magout.ogg", 	 t = 0.35},
            {s = common .. "magpouch.ogg", t = 0.6},
            {s = rottle, t = 0.75},
            {s = common .. "rifle_magdrop.ogg",  t = 0.8},
            {s = path .. "magin.ogg",    t = 1.1},
            {s = rottle, t = 1.475},
            {s = path .. "boltdrop.ogg", t = 1.9},
            {s = common .. "shoulder.ogg", t = 2.2},
        },
    },

    -- 100 Round Reloads --

    ["reload_100"] = {
        Source = "reload_100",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 71 / 30,
        MinProgress = 1.75,
        LastClip1OutTime = 0.9,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.5,
        LHIKEaseOut = 0.4,
        LHIKOut = 0.5,
        SoundTable = {
            {s = rottle, t = 0.0},
            {s = path .. "magout.ogg", 	 t = 0.3},
            {s = rottle, t = 0.75},
            {s = path .. "magin.ogg",    t = 1.05},
            {s = rottle, t = 1.1},
            {s = path .. "magtap.ogg",   t = 1.59},
            {s = common .. "cloth_4.ogg",  t = 1.65},
            {s = common .. "shoulder.ogg", t = 2.05},
        },
    },
    ["reload_empty_100"] = {
        Source = "reload_empty_100",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 90 / 30,
        MinProgress = 2.5,
        LastClip1OutTime = 0.7,
        LHIK = true,
        LHIKIn = 0.3,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.4,
        LHIKOut = 0.5,
        SoundTable = {
            {s = rottle, t = 0.0},
            {s = path .. "magout.ogg", 	 t = 0.3},
            {s = rottle, t = 0.75},
            {s = common .. "magdrop.ogg",  t = 0.65},
            {s = path .. "magin.ogg",    t = 1.05},
            {s = path .. "magtap.ogg",   t = 1.59},
            {s = rottle, t = 1.75},
            {s = path .. "chback.ogg",   t = 2.0},
            {s = common .. "cloth_4.ogg",  t = 2.05},
            {s = path .. "chamber.ogg",  t = 2.22},
            {s = common .. "shoulder.ogg", t = 2.6},
        },
    },

    -- 9mm 32 Round Reloads --

    ["reload_9mm"] = {
        Source = "reload_9mm",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 71 / 30,
        MinProgress = 1.5,
        LastClip1OutTime = 0.9,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.5,
        SoundTable = {
            {s = rottle, t = 0.0},
            {s = common .. "magpouch.ogg", t = 0.15},
            {s = "weapons/arccw_ud/uzi/" .. "magout.ogg", 	 t = 16 / 30},
            {s = rottle, t = 0.75},
            {s = "weapons/arccw_ud/uzi/" .. "magin.ogg",    t = 27 / 30},
            {s = rottle, t = 1.1},
            {s = common .. "magpouchin.ogg", t = 1.55},
            {s = common .. "shoulder.ogg", t = 1.93},
        },
    },
    ["reload_empty_9mm"] = {
        Source = "reload_empty_9mm",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        Time = 79 / 30,
        MinProgress = 2,
        LastClip1OutTime = 0.7,
        LHIK = true,
        LHIKIn = 0.4,
        LHIKEaseIn = 0.4,
        LHIKEaseOut = 0.15,
        LHIKOut = 0.4,
        SoundTable = {
            {s = rottle, t = 0.0},
            {s = "weapons/arccw_ud/uzi/" .. "magout.ogg", 	 t = 0.2},
            {s = common .. "magpouch.ogg", t = 0.65},
            {s = rottle, t = 0.75},
            {s = "weapons/arccw_ud/uzi/" .. "magin.ogg",    t = 0.98},
            {s = rottle, t = 1.39},
            {s = path .. "boltdrop.ogg", t = 56 / 30},
            {s = common .. "shoulder.ogg", t = 2.15},
        },
    },
}

SWEP.Hook_ModifyBodygroups = function(wep, data)
    local vm = data.vm
    if !IsValid(vm) then return end
    local retro = wep:GetBuff_Override("TopMount")
    local taclaser = wep:GetBuff_Override("TacLaserPos")
    local rs = wep:GetBuff_Override("IronSight")

    local fs = wep.Attachments[14].Installed == "ud_m16_charm_fs"

    local hg = string.Replace(wep.Attachments[2].Installed or "default", "ud_m16_barrel_", "")
    local blen = (barrel_lookup[hg] or barrel_lookup["default"])[1]
    local muzz = wep.Attachments[3].Installed or hg == "sd"

    -- Receiver top and front sight
    if wep.Attachments[1].Installed then
        if retro then
            -- Raised rail (retro)
            vm:SetBodygroup(3, retro)
        else
            -- Flat rail
            vm:SetBodygroup(1, 1)
            vm:SetBodygroup(3, 2)
        end
    else
        -- no rails
        vm:SetBodygroup(3, 0)
    end

    -- .50 Beowulf magazines
    if wep.Attachments[4].Installed == "ud_m16_receiver_50beo" and !wep.Attachments[9].Installed then
        vm:SetBodygroup(2, 8)
    end

    -- Gas block
    if has_tag(hg, BTAG_NOFS) then
        vm:SetBodygroup(6, 5)
    elseif wep.Attachments[1].Installed and !retro and !fs and !rs then
        -- this is handled after elements sets bodygroup so we can do this
        vm:SetBodygroup(6, (vm:GetBodygroup(6) or 0) + 1)
    end

    -- Underbarrel rail
    vm:SetBodygroup(9, (wep.Attachments[5].Installed and !has_tag(hg, BTAG_RIS)) and 1 or 0)

    -- Flip-up sights
    --vm:SetBodygroup(12, flip)

    -- Tactical clamp
    if wep.Attachments[6].Installed and !has_tag(hg, BTAG_RIS) and !has_tag(hg, BTAG_NOMNT) and !taclaser then
        vm:SetBodygroup(10, len_clamp_lookup[blen])
    else
        vm:SetBodygroup(10, 0)
    end

    -- Default flash hider
    if muzz then
        vm:SetBodygroup(11,0)
    else
        if blen == BLEN_10 then
            vm:SetBodygroup(11,3)
        elseif blen == BLEN_14 then
            vm:SetBodygroup(11,2)
        else
            vm:SetBodygroup(11,1)
        end
    end
end

SWEP.Attachments = {
    {
        PrintName = "Optic",
        DefaultAttName = "Iron Sights",
        InstalledEles = {"upper_flat"},
        Slot = {"optic","optic_sniper","ud_m16_rs"},
        Bone = "m16_parent",
        Offset = {
            vpos = Vector(0, -1.75, 3),
            vang = Angle(90, 0, -90),
        },
        VMScale = Vector(1.1, 1.1, 1.1),
        WMScale = Vector(1.1, 1.1, 1.1),
        ExtraSightDist = 4,
        SlideAmount = {
            vmin = Vector(0, -1.75, 3 - 2),
            vmax = Vector(0, -1.75, 3 + 2),
        },
    },
    {
        PrintName = "Barrel",
        DefaultAttName = "20\" Standard Barrel",
        DefaultAttIcon = Material("entities/att/acwatt_ud_m16_barrel_default.png", "smooth mips"),
        Slot = "ud_m16_barrel",
        Bone = "m16_parent",
        Offset = {
            vpos = Vector(2.8, -4.2, -11.5),
            vang = Angle(90, 0, -90),
        },
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard Muzzle",
        Slot = {"muzzle"},
        Bone = "m16_parent",
        VMScale = Vector(1.25, 1.25, 1.25),
        WMScale = VMScale,
        Offset = {
            vpos = Vector(0.025, -0.05, 30.85),
            vang = Angle(90, 0, -90),
        },
        ExcludeFlags = {"sd", "m16_stub"},
    },
    {
        PrintName = "Receiver",
        DefaultAttName = "Standard Receiver",
        DefaultAttIcon = Material("entities/att/acwatt_ud_m16_receiver_default.png", "smooth mips"),
        Slot = {"ud_m16_receiver"},
        Bone = "m16_parent",
        Offset = {
            vpos = Vector(2.8, -4.2, -11.5),
            vang = Angle(90, 0, -90),
        },
    },
    {
        PrintName = "Underbarrel",
        Slot = {"foregrip","ubgl"},
        Bone = "m16_parent",
        Offset = {
            vpos = Vector(0, 1.25, 12),
            vang = Angle(90, 0, -90),
        },
        InstalledEles = {"rail_fg"},
        ExcludeFlags = {"m16_lmg", "m16_stub"},
        SlideAmount = {
            vmin = Vector(0, 1.25, 15.5),
            vmax = Vector(0, 1.25, 9),
        },
    },
    {
        PrintName = "Tactical",
        Slot = {"tac"},
        Bone = "m16_parent",
        Offset = {
            vpos = Vector(0, 0.8, 27),
            vang = Angle(90, 0, -90),
        },
        GivesFlags = {"tac"},
        --InstalledEles = {"ud_m16_clamp_fullsize"}
    },
    {
        PrintName = "Grip Type",
        Slot = {"ud_m16_grip"},
        DefaultAttName = "Standard Grip",
        DefaultAttIcon = Material("entities/att/acwatt_ud_m16_grip_default.png", "smooth mips"),
        ExcludeFlags = {"m16_adar"}
    },
    {
        PrintName = "Stock",
        Slot = {"ud_m16_stock"},
        DefaultAttName = "Full Stock",
        DefaultAttIcon = Material("entities/att/acwatt_ud_m16_stock_default.png", "smooth mips"),
    },
    {
        PrintName = "Magazine",
        Slot = {"ud_m16_mag"},
        DefaultAttName = "30-Round Mag",
        DefaultAttIcon = Material("entities/att/acwatt_ud_m16_mag_30.png", "smooth mips"),
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
        Slot = {"charm", "fml_charm", "ud_m16_charm"},
        FreeSlot = true,
        Bone = "m16_parent",
        Offset = {
            vpos = Vector(0.6, 1, 5),
            vang = Angle(90, 0, -90),
        },
    },
}