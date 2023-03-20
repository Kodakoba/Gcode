AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "MP9"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1
	
	SWEP.IconLetter = "d"
	killicon.AddFont("cw_mp9_official", "CW_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "muzzleflash_smg"
	SWEP.PosBasedMuz = false
	SWEP.SnapToGrip = true
	SWEP.ShellScale = 0.7
	SWEP.ShellOffsetMul = 1
	SWEP.Shell = "smallshell"
	SWEP.ShellPosOffset = {x = 0, y = 1, z = -3}
	SWEP.ForeGripOffsetCycle_Draw = 0
	SWEP.ForeGripOffsetCycle_Reload = 0.9
	SWEP.ForeGripOffsetCycle_Reload_Empty = 0.8
	SWEP.FireMoveMod = 1

	SWEP.RVBPitchMod = 0.5
	SWEP.RVBYawMod = 0.5
	SWEP.RVBRollMod = 0.5
	
	SWEP.DrawTraditionalWorldModel = false
	SWEP.WM = "models/weapons/w_ecw_mp9.mdl"
	SWEP.WMPos = Vector(-1, -2.5, -2.5)
	SWEP.WMAng = Vector(0, 0, 180)
	
	SWEP.ShortDotPos = Vector(-2.552, -3.089, -0.245)
	SWEP.ShortDotAng = Vector(0, 0, 4.467)

	SWEP.AimpointPos = Vector(-2.56, -2.451, -0.19)
	SWEP.AimpointAng = Vector(0, 0, 3.93)

	SWEP.MicroT1Pos = Vector(-2.565, 0, -0.132)
	SWEP.MicroT1Ang = Vector(0, 0, 4.467)

	SWEP.IronsightPos = Vector(-2.629, -3.027, 0.501)
	SWEP.IronsightAng = Vector(0, 0, 3.93)

	SWEP.EoTechPos = Vector(-2.53, -3.089, -0.561)
	SWEP.EoTechAng = Vector(0, 0, 5)
	
	SWEP.NXSPos = Vector(-2.592, -1.839, -0.24)
	SWEP.NXSAng = Vector(0, 0, 4)
	
	SWEP.SprintPos = Vector(1.728, 1.843, -0.897)
	SWEP.SprintAng = Vector(-7.685, 21.791, 3.982)

	SWEP.CustomizePos = Vector(8.675, -1.16, -2.61)
	SWEP.CustomizeAng = Vector(24.472, 36.847, 16.979)

	SWEP.SightWithRail = true
	SWEP.SchmidtShortDotAxisAlign = {right = 0, up = 0, forward = 0}
	SWEP.NXSAlign = {right = 0, up = 0, forward = 0}
	
	SWEP.AlternativePos = Vector(-0.657, 2.167, -1.175)
	SWEP.AlternativeAng = Vector(0, 0, 3.982)

	SWEP.DontMoveBoltOnHipFire = true
	
	SWEP.CustomizationMenuScale = 0.01
	
	SWEP.AttachmentModelsVM = {
		["md_aimpoint"] = {model = "models/wystan/attachments/aimpoint.mdl", bone = "gun", pos = Vector(-0.104, -5.553, -2.28), angle = Angle(0, 0, 0), size = Vector(0.8, 0.8, 0.8)},
		["md_eotech"] = {model = "models/wystan/attachments/2otech557sight.mdl", bone = "gun", pos = Vector(0.37, -10.58, -9.006), angle = Angle(3.332, -90, 0), size = Vector(1, 1, 1)},
		["md_microt1"] = {model = "models/cw2/attachments/microt1.mdl", bone = "gun", pos = Vector(0.12, -0.88, 2.403), angle = Angle(0, -180, 0), size = Vector(0.349, 0.349, 0.349)},
		["md_tundra9mm"] = {model = "models/cw2/attachments/556suppressor.mdl", bone = "gun", pos = Vector(0.064, -3.827, -0.19), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5)},
		["md_schmidt_shortdot"] = {model = "models/cw2/attachments/schmidt.mdl", bone = "gun", pos = Vector(-0.169, -5.193, -2.244), angle = Angle(0, -90, 0), size = Vector(0.8, 0.8, 0.8)},
		["md_anpeq15"] = {model = "models/cw2/attachments/anpeq15.mdl", bone = "gun", pos = Vector(-0.668, 3.141, 1.705), angle = Angle(0, 90, -90), size = Vector(0.5, 0.5, 0.5)},
		["md_nightforce_nxs"] = {model = "models/cw2/attachments/l96_scope.mdl", bone = "gun", pos = Vector(0.02, 0.206, 3.239), angle = Angle(0, -90, 0), size = Vector(0.899, 0.899, 0.899)}
	}

	--[[SWEP.AttachmentModelsVM = {
		["md_microt1"] = {model = "models/cw2/attachments/microt1.mdl", bone = "weapon", pos = Vector(0.037, -3.405, -0.942), angle = Angle(180, 0, -90), size = Vector(0.349, 0.349, 0.349), color = Color(255, 255, 255, 0)},
		["md_eotech"] = {model = "models/wystan/attachments/2otech557sight.mdl", bone = "weapon", pos = Vector(0.282, 8.026, -10.797), angle = Angle(93.333, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 0)},
		["md_tundra9mm"] = {model = "models/cw2/attachments/9mmsuppressor.mdl", bone = "weapon", pos = Vector(0.018, -2.564, 6.34), angle = Angle(0, 0, 90), size = Vector(0.55, 0.55, 0.55)}
	}]]

	SWEP.TelescopeSkipRotate = true
	SWEP.LuaVMRecoilAxisMod = {vert = 1.5, hor = 2, roll = 1, forward = 1, pitch = 1}
	
	SWEP.LaserPosAdjust = Vector(0.8, 0, 1)
	SWEP.LaserAngAdjust = Angle(-0.31, 180, 0)
	SWEP.LaserAngAdjustAim = Angle(-0.31, 180, 0)
end

SWEP.ShootWhileProne = true
SWEP.MuzzleVelocity = 400 -- in meter/s

SWEP.BarrelBGs = {main = 2, extended = 1, regular = 0}
SWEP.StockBGs = {main = 1, unfolded = 1, folded = 0}
SWEP.RailBGs = {main = 3, on = 1, off = 0}
SWEP.LuaViewmodelRecoil = true
SWEP.LuaViewmodelRecoilOverride = true

SWEP.Attachments = {[1] = {header = "Sight", offset = {600, -300},  atts = {"md_microt1", "md_eotech", "md_aimpoint", "md_schmidt_shortdot", "md_nightforce_nxs"}},
	[2] = {header = "Barrel", offset = {-600, -300},  atts = {"md_tundra9mm"}},
	[3] = {header = "Rail", offset = {600, 150},  atts = {"md_anpeq15"}},
	["+reload"] = {header = "Ammo", offset = {-600, 200}, atts = {"am_magnum", "am_matchgrade", "am_ultramegamatchammo"}}}

SWEP.Animations = {fire = {"fire1", "fire2"},
	reload = "reload",
	idle = "idle",
	draw = "draw"}
	
SWEP.Sounds = {
	draw = {
		{time = 0, sound = "CW_FOLEY_MEDIUM"}
	},

	reload = {
		{time = 0.58, sound = "CW_MP9_MAG_OUT"},
		{time = 0.95, sound = "CW_FOLEY_LIGHT"},
		{time = 1.4, sound = "CW_MP9_MAG_IN"},
		{time = 1.9, sound = "CW_FOLEY_LIGHT"}
	}
}

SWEP.SpeedDec = 12

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "revolver"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"auto", "semi", "safe"}
SWEP.Base = "cw_base"
SWEP.Category = "CW 2.0"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_ecw_mp9.mdl"
SWEP.WorldModel		= "models/weapons/w_ecw_mp9.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "9x19MM"

SWEP.Chamberable = true

SWEP.FireDelay = 60 / 900
SWEP.FireSound = "CW_MP9_FIRE"
SWEP.FireSoundSuppressed = "CW_MAC11_FIRE_SUPPRESSED"
SWEP.Recoil = 0.65

SWEP.HipSpread = 0.036
SWEP.AimSpread = 0.012
SWEP.VelocitySensitivity = 1.35
SWEP.MaxSpreadInc = 0.033
SWEP.SpreadPerShot = 0.005
SWEP.SpreadCooldown = 0.09
SWEP.Shots = 1
SWEP.Damage = 19
SWEP.DeployTime = 0.6
SWEP.NearWallDistance = 20

SWEP.ReloadSpeed = 1
SWEP.ReloadTime = 2.4
SWEP.ReloadTime_Empty = 2.4
SWEP.ReloadHalt = 2.4
SWEP.ReloadHalt_Empty = 2.4

SWEP.SnapToIdlePostReload = true

function SWEP:getTelescopeAngles()
	local ang = self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()
	ang.r = self.BlendAng.z - self.AimAng.z
	return ang
end