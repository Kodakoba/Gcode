AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

CustomizableWeaponry:registerAmmo("4.6x30MM", "4.6x30MM", 4.6, 30)

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "HK MP7A1"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15
	
	SWEP.IconLetter = "x"
	killicon.AddFont("cw_mp7_official", "CW_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.DrawTraditionalWorldModel = false
	SWEP.WM = "models/cw2/smgs/mp7_world.mdl"
	SWEP.WMPos = Vector(0, -2, -2)
	SWEP.WMAng = Vector(-5, 0, 180)
	 
	SWEP.MuzzleEffect = "muzzleflash_smg"
	SWEP.PosBasedMuz = false
	SWEP.SnapToGrip = true
	SWEP.Shell = "smallshell"
	SWEP.ShellScale = 0.7
	SWEP.ShellOffsetMul = 1
	SWEP.ShellPosOffset = {x = 4, y = -1, z = 3}
	SWEP.ForeGripOffsetCycle_Draw = 0
	SWEP.ForeGripOffsetCycle_Reload = 0.8
	SWEP.ForeGripOffsetCycle_Reload_Empty = 0.87
	
	SWEP.IronsightPos = Vector(-2.168, -1.109, 0.552)
	SWEP.IronsightAng = Vector(0.216, 0, 0)
	
	SWEP.MicroT1Pos = Vector(-2.224, 1.266, 0.246)
	SWEP.MicroT1Ang = Vector(0, -0.232, 0)

	SWEP.EoTechPos = Vector(-2.177, -3.758, -0.16)
	SWEP.EoTechAng = Vector(0, 0, 0)

	SWEP.AimpointPos = Vector(-2.161, -4.607, 0.131)
	SWEP.AimpointAng = Vector(0, 0, 0)
	
	SWEP.ShortDotPos = Vector(-2.155, -4.83, 0.244)
	SWEP.ShortDotAng = Vector(0, 0, 0)
	
	SWEP.ACOGPos = Vector(-2.172, -4.825, -0.005)
	SWEP.ACOGAng = Vector(0, 0, 0)
	
	SWEP.AlternativePos = Vector(0, 1.325, -0.801)
	SWEP.AlternativeAng = Vector(0, 0, 0)
	
	SWEP.BackupSights = {["md_acog"] = {[1] = Vector(-2.165, -4.825, -0.852), [2] = Vector(0, 0, 0)}}
	
	SWEP.AttachmentModelsVM = {
		["md_aimpoint"] = {model = "models/wystan/attachments/aimpoint.mdl", bone = "mp7_main", pos = Vector(-4.927, 2.484, 0.188), angle = Angle(-90, 90, 0), size = Vector(0.8, 0.8, 0.8)},
		["md_eotech"] = {model = "models/wystan/attachments/2otech557sight.mdl", bone = "mp7_main", pos = Vector(-10.389, 9.3, -0.278), angle = Angle(0, 3.332, -90), size = Vector(1, 1, 1)},
		["md_microt1"] = {model = "models/cw2/attachments/microt1.mdl", bone = "mp7_main", pos = Vector(-0.819, -2.135, -0.005), angle = Angle(90, 0, -90), size = Vector(0.349, 0.349, 0.349)},
		["md_anpeq15"] = {model = "models/cw2/attachments/anpeq15.mdl", bone = "mp7_main", pos = Vector(5.162, -0.343, -0.687), angle = Angle(0, 180, 180), size = Vector(0.5, 0.5, 0.5)},
		["md_schmidt_shortdot"] = {model = "models/cw2/attachments/schmidt.mdl", bone = "mp7_main", pos = Vector(-4.719, 2.282, 0.25), angle = Angle(0, 0, -90), size = Vector(0.75, 0.75, 0.75)},
		["md_acog"] = {model = "models/wystan/attachments/2cog.mdl", bone = "mp7_main", pos = Vector(-4.637, 2.27, 0.273), angle = Angle(-90, 0, -90), size = Vector(0.75, 0.75, 0.75)}
	}

	SWEP.LaserPosAdjust = {x = 0, y = 0, z = 0.25}
	SWEP.LaserAngAdjust = {p = 0, y = 180, r = 0}
	
	SWEP.CustomizationMenuScale = 0.015
end

SWEP.SuppressorBGs = {main = 1, suppressed = 0, unsuppressed = 1}

SWEP.MuzzleVelocity = 750 -- in meter/s

SWEP.LuaViewmodelRecoil = true
SWEP.LuaViewmodelRecoilOverride = true

SWEP.Attachments = {
	[1] = {header = "Sight", offset = {1100, -400}, atts = {"md_microt1", "md_eotech", "md_aimpoint", "md_schmidt_shortdot", "md_acog"}},
	[2] = {header = "Barrel", offset = {-200, -400}, atts = {"bg_mp7_unsuppressed"}},
	[3] = {header = "Rail", offset = {-200, 0}, atts = {"md_anpeq15"}},
	["+reload"] = {header = "Ammo", offset = {1100, 35}, atts = {"am_magnum", "am_matchgrade"}}
}

SWEP.Animations = {
	fire = {"base_fire1", "base_fire2"},
	reload = "base_reload",
	reload_empty = "base_reloadempty",
	idle = "base_idle",
	draw = "base_draw"
}
	
SWEP.Sounds = {
	draw = {
		{time = 0, sound = "CW_FOLEY_MEDIUM"}
	},

	base_reload = {
		{time = 0.79, sound = "CW_MP7_OFFICIAL_MAGRELEASE"},
		{time = 0.82, sound = "CW_MP7_OFFICIAL_MAGOUT"},
		{time = 1.11, sound = "CW_FOLEY_MEDIUM"},
		{time = 1.85, sound = "CW_MP7_OFFICIAL_MAGIN"},
	},
	
	base_reloadempty = {
		{time = 0.63, sound = "CW_MP7_OFFICIAL_MAGRELEASE"},
		{time = 0.67, sound = "CW_MP7_OFFICIAL_MAGOUT"},
		{time = 1.3, sound = "CW_FOLEY_MEDIUM"},
		{time = 2, sound = "CW_MP7_OFFICIAL_MAGIN"},
		{time = 3.03, sound = "CW_MP7_OFFICIAL_BOLTBACK"},
		{time = 3.4, sound = "CW_MP7_OFFICIAL_BOLTRELEASE"},
	}
}

SWEP.SpeedDec = 12

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "semi"}
SWEP.Base = "cw_base"
SWEP.Category = "CW 2.0"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/cw2/smgs/mp7.mdl"
SWEP.WorldModel		= "models/cw2/smgs/mp7_world.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 40
SWEP.Primary.DefaultClip	= 40
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "4.6x30MM"

SWEP.FireDelay = 60 / 950
SWEP.FireSound = "CW_MP7_OFFICIAL_FIRE"
SWEP.FireSoundSuppressed = "CW_MP7_OFFICIAL_FIRE_SUPPRESSED"
SWEP.Recoil = 0.55

SWEP.HipSpread = 0.04
SWEP.AimSpread = 0.0075
SWEP.VelocitySensitivity = 1.5
SWEP.MaxSpreadInc = 0.03
SWEP.SpreadPerShot = 0.005
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 18
SWEP.DeployTime = 0.5
SWEP.NearWallDistance = 25

SWEP.SuppressedOnEquip = true

SWEP.ReloadSpeed = 1.3
SWEP.ReloadTime = 2.2
SWEP.ReloadTime_Empty = 3.5
SWEP.ReloadHalt = 2.9
SWEP.ReloadHalt_Empty = 4.5