AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "M4 Super 90"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1
	
	SWEP.IconLetter = "k"
	killicon.AddFont("cw_xm1014_official", "CW_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.ForeGripOffsetCycle_Draw = 0
	SWEP.ForeGripOffsetCycle_Reload = 0.9
	SWEP.ForeGripOffsetCycle_Reload_Empty = 0.9

	SWEP.MuzzleEffect = "muzzleflash_m3"
	SWEP.PosBasedMuz = false
	SWEP.SnapToGrip = true
	SWEP.ShellScale = 0.7
	SWEP.ShellOffsetMul = 1
	SWEP.ShellPosOffset = {x = -5, y = 0, z = -5}
	SWEP.Shell = "shotshell"
	SWEP.ShellDelay = 0
	
	SWEP.ForeGripOffsetCycle_Draw = 0
	SWEP.ForeGripOffsetCycle_ReloadStart = 0.9
	SWEP.ForeGripOffsetCycle_ReloadInsert = 2
	SWEP.ForeGripOffsetCycle_ReloadEnd = 0.65
	SWEP.FireMoveMod = 1
	
	SWEP.SightWithRail = true
		
	SWEP.AlternativePos = Vector(-0.32, 1.366, -1.025)
	SWEP.AlternativeAng = Vector(0, 0, 0)

	SWEP.IronsightPos = Vector(-1.581, -0.276, 0.648)
	SWEP.IronsightAng = Vector(0, 0, 0)

	SWEP.MicroT1Pos = Vector(-1.6, 4, -0.132)
	SWEP.MicroT1Ang = Vector(0, 0, 0)
	
	SWEP.EoTechPos = Vector(-1.57, -1.89, -0.449)
	SWEP.EoTechAng = Vector(0, 0, 0)

	SWEP.AimpointPos = Vector(-1.57, 0, -0.2)
	SWEP.AimpointAng = Vector(0, 0, 0)
	
	SWEP.IronSightsPos = Vector(-1.566, -1.89, -0.164)
	SWEP.IronSightsAng = Vector(0, 0, 0)

	SWEP.ShortDotPos = Vector(-1.558, -0.5, -0.152)
	SWEP.ShortDotAng = Vector(0, 0, 0)
	
	SWEP.SprintPos = Vector(1.786, 0, -1)
	SWEP.SprintAng = Vector(-10.778, 27.573, 0)
		
	SWEP.CustomizePos = Vector(7.711, -0.482, -2)
	SWEP.CustomizeAng = Vector(16.364, 40.741, 15.277)
	
	SWEP.M203Pos = Vector(0, -2.481, 0.24)
	SWEP.M203Ang = Vector(0, 0, 0)

	SWEP.SchmidtShortDotAxisAlign = {right = 0, up = 0, forward = 0}

	SWEP.CustomizationMenuScale = 0.014

	SWEP.BaseArm = "arm_controller_01"
	SWEP.BaseArmBoneOffset = Vector(-50, 0, 0)

	SWEP.AttachmentModelsVM = {
		["md_aimpoint"] = {model = "models/wystan/attachments/aimpoint.mdl", bone = "gun_bmp", pos = Vector(-0.147, -7.343, -3.876), angle = Angle(0, 0, 0), size = Vector(0.899, 0.899, 0.899)},
		["md_eotech"] = {model = "models/wystan/attachments/2otech557sight.mdl", bone = "gun_bmp", pos = Vector(0.36, -12.028, -10.054), angle = Angle(3.332, -90, 0), size = Vector(1, 1, 1)},
		["md_microt1"] = {model = "models/cw2/attachments/microt1.mdl", bone = "gun_bmp", pos = Vector(0.067, -1.846, 1.371), angle = Angle(0, 180, 0), size = Vector(0.4, 0.4, 0.4)},
		["md_schmidt_shortdot"] = {model = "models/cw2/attachments/schmidt.mdl", bone = "gun_bmp", pos = Vector(-0.217, -6.74, -3.622), angle = Angle(0, -90, 0), size = Vector(0.85, 0.85, 0.85)},
		["md_anpeq15"] = {model = "models/cw2/attachments/anpeq15.mdl", bone = "gun_bmp", pos = Vector(-0.014, 1.23, 1.141), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5)},
		["md_foregrip"] = {model = "models/wystan/attachments/foregrip1.mdl", bone = "gun_bmp", pos = Vector(-0.327, -6.101, -2.942), angle = Angle(0, 0, 0), size = Vector(0.699, 0.699, 0.699)},
		["md_saker"] = {model = "models/cw2/attachments/556suppressor.mdl", bone = "gun_bmp", pos = Vector(0.072, 2.25, -1.555), angle = Angle(0, 0, 0), size = Vector(0.699, 0.699, 0.699)},
		["md_m203"] = {model = "models/cw2/attachments/m203.mdl", bone = "gun_bmp", pos = Vector(2.15, -9, 1.937), angle = Angle(0, -90, 0), size = Vector(0.899, 0.899, 0.899), animated = true}
	}

	SWEP.M203CameraRotation = {p = -90, y = 0, r = -90}
	SWEP.M203OffsetCycle_Draw = 0
	SWEP.M203OffsetCycle_ReloadStart = 2
	SWEP.M203OffsetCycle_ReloadInsert = 2
	SWEP.M203OffsetCycle_ReloadEnd = 0.65

	SWEP.M203HoldPos = {
		["arm_controller_01"] = {pos = Vector(4, 0.364, -1.849), angle = Angle(0, 0, 0) }
	}

	SWEP.ForeGripHoldPos = {
		["l_ring_low"] = {pos = Vector(0, 0, 0), angle = Angle(23.337, -6.002, -9.679) },
		["l_middle_low"] = {pos = Vector(0, 0, 0), angle = Angle(45.234, 6.203, -11.115) },
		["l_thumb_tip"] = {pos = Vector(0, 0, 0), angle = Angle(23.291, 87.62, 0) },
		["l_index_low"] = {pos = Vector(0, 0, 0), angle = Angle(63.618, 4.782, -2.951) },
		["l_ring_tip"] = {pos = Vector(0, 0, 0), angle = Angle(18.013, -1.573, 6.466) },
		["l_pinky_tip"] = {pos = Vector(0, 0, 0), angle = Angle(17.218, 4.866, 0) },
		["l_thumb_mid"] = {pos = Vector(0, 0, 0), angle = Angle(29.221, 45.523, -10.763) },
		["l_wrist"] = {pos = Vector(0, 0, 0), angle = Angle(17.864, 19.738, 18.639) },
		["l_pinky_low"] = {pos = Vector(0, 0, 0), angle = Angle(9.277, -5.604, -11.158) },
		["l_middle_tip"] = {pos = Vector(0, 0, 0), angle = Angle(2.499, 0, 17.867) },
		["l_pinky_mid"] = {pos = Vector(0, 0, 0), angle = Angle(0, 0, -13.907) },
		["arm_controller_01"] = {pos = Vector(-0.117, 0.386, -0.2), angle = Angle(0, 0, 0) },
		["l_forearm"] = {pos = Vector(0, 0, 0), angle = Angle(-12.186, 10.182, 72.46) },
		["l_thumb_low"] = {pos = Vector(0, 0, 0), angle = Angle(10.918, -2.448, -5.645) }
	}

	SWEP.AttachmentPosDependency = {
		["md_anpeq15"] = {
			md_microt1 = Vector(-0.014, 0.6, 1.141),
			md_aimpoint = Vector(-0.014, 1.1, 1.141),
			["md_schmidt_shortdot"] = Vector(-0.014, 1.4, 2.7)
		},
		
	}
	
	SWEP.LuaVMRecoilAxisMod = {vert = 1.5, hor = 2, roll = 1, forward = 1, pitch = 1}
	
	SWEP.LaserPosAdjust = Vector(0.8, 0, 0)
	SWEP.LaserAngAdjust = Angle(0, 180, 0) 
end

SWEP.MuzzleVelocity = 381 -- in meter/s

SWEP.ADSFireAnim = false
SWEP.LuaViewmodelRecoil = true
SWEP.LuaViewmodelRecoilOverride = true

SWEP.Attachments = {[1] = {header = "Sight", offset = {800, -450}, atts = {"md_microt1", "md_eotech", "md_aimpoint", "md_schmidt_shortdot"}},
	[2] = {header = "Barrel", offset = {-200, -250}, atts = {"md_saker"}},
	[3] = {header = "Rail", offset = {-200, 200}, atts = {"md_anpeq15"}},
	[4] = {header = "Fore-end", offset = {800, 0}, atts = {"md_foregrip", "md_m203"}},
	["+reload"] = {header = "Ammo", offset = {800, 450}, atts = {"am_slugrounds", "am_flechetterounds"}}}

SWEP.AttachmentDependencies = {["md_anpeq15"] = {"md_microt1", "md_aimpoint", "md_schmidt_shortdot"}} -- this is on a PER ATTACHMENT basis, NOTE: the exclusions and dependencies in the Attachments table is PER CATEGORY

SWEP.Animations = {fire = {"shoot1", "shoot2"},
	reload_start = "start_reload",
	insert = "insert",
	reload_end = "after_reload",
	idle = "idle",
	draw = "draw"}
	
SWEP.Sounds = {
	start_reload = {
		{time = 0.1, sound = "CW_FOLEY_LIGHT"}
	},

	insert = {
		{time = 0.17, sound = "CW_M4SUPER90_INSERT"},
		{time = 0.38, sound = "CW_FOLEY_LIGHT"}
	},
	
	after_reload = {{time = 0.35, sound = "CW_M4SUPER90_BOLT"},
	{time = 0.6, sound = "CW_FOLEY_LIGHT"}},
	
	draw = {{time = 0, sound = "CW_FOLEY_MEDIUM"}}
}

SWEP.SpeedDec = 25

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "shotgun"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"pump"}
SWEP.Base = "cw_base"
SWEP.Category = "CW 2.0"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/cw2/shotguns/m4super90.mdl"
SWEP.WorldModel		= "models/weapons/w_shot_xm1014.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "12 Gauge"

SWEP.Chamberable = false

SWEP.FireDelay = 0.2
SWEP.FireSound = "CW_M4SUPER90_FIRE"
SWEP.FireSoundSuppressed = "CW_DEAGLE_FIRE_SUPPRESSED"
SWEP.Recoil = 2.5

SWEP.HipSpread = 0.05
SWEP.AimSpread = 0.008
SWEP.VelocitySensitivity = 1.9
SWEP.MaxSpreadInc = 0.06
SWEP.ClumpSpread = 0.017
SWEP.SpreadPerShot = 0.013
SWEP.SpreadCooldown = 0.3
SWEP.Shots = 12
SWEP.Damage = 8
SWEP.DeployTime = 0.8
SWEP.RecoilToSpread = 1.6 -- should actually be called SpreadToRecoil, but whatever

SWEP.ReloadStartTime = 0.3
SWEP.InsertShellTime = 0.6
SWEP.ReloadFinishWait = 1
SWEP.PumpMidReloadWait = 0.6
SWEP.ShotgunReload = true