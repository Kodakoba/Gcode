AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "ACR"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15
	
	SWEP.SelectIcon = surface.GetTextureID("entities/cw_acr")
	killicon.Add("cw_acr", "weaponicons/acr", Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "muzzleflash_6"
	SWEP.PosBasedMuz = false
	SWEP.SnapToGrip = true
	SWEP.ShellScale = 0.7
	SWEP.ShellOffsetMul = 1
	SWEP.ShellPosOffset = {x = 2, y = -1, z = -3.5}
	SWEP.ForeGripOffsetCycle_Draw = 0
	SWEP.ForeGripOffsetCycle_Reload = 0.5
	SWEP.ForeGripOffsetCycle_Reload_Empty = 0.5
	
	SWEP.CustomizePos = Vector(8.843, -4.824, -1.205)
	SWEP.CustomizeAng = Vector(33.769, 52.06, 26.03)
	
	SWEP.IronsightPos = Vector(-1.786, 0, 0.125)
	SWEP.IronsightAng = Vector(0.1, 0.01, 0)
	
	SWEP.NXSPos = Vector(-1.85, 0, 0.3)
	SWEP.NXSAng = Vector(0.175, -0.27, 0)
	
	SWEP.EoTechPos = Vector(-1.843, 0, -0.151)
	SWEP.EoTechAng = Vector(1.888, -0.205, 0)
	
	SWEP.AimpointPos = Vector(-1.815, 0, 0.215)
	SWEP.AimpointAng = Vector(-0.415, 0, 0)
	
	SWEP.MicroT1Pos = Vector(-1.78, 0, 0.474)
	SWEP.MicroT1Ang = Vector(0, 0.005, 0)
	
	SWEP.ACOGPos = Vector(-1.793, -2.65, 0.25)
	SWEP.ACOGAng = Vector(0.3, -0.225, 0)
	
	SWEP.ShortDotPos = Vector(-1.75, -3, 0.5)
	SWEP.ShortDotAng = Vector(0.2, -0.2, 0)
	
	SWEP.AlternativePos = Vector(-0.32, 0, -0.64)
	SWEP.AlternativeAng = Vector(0, 0, 0)
	
	SWEP.BackupSights = {["md_acog"] = {[1] = Vector(-2.211, -4, -0.95), [2] = Vector(-2, 0, 0)}}

	SWEP.ACOGAxisAlign = {right = -0.5, up = 0, forward = 0}
	SWEP.NXSAlign = {right = 0, up = 0, forward = 0}
	SWEP.SchmidtShortDotAxisAlign = {right = 0, up = 0, forward = 0}
	
	SWEP.BaseArm = "Bip01 L Clavicle"
	SWEP.BaseArmBoneOffset = Vector(-50, 0, 0)
	
	SWEP.AttachmentModelsVM = {
		["md_aimpoint"] = {model = "models/wystan/attachments/aimpoint.mdl", bone = "ACR", pos = Vector(5.8, 4.574, -0.801), adjustment = {min = 5.8, max = 8, axis = "x", inverseOffsetCalc = true}, angle = Angle(90, -90, 0), size = Vector(1, 1, 1)},
		["md_eotech"] = {model = "models/wystan/attachments/2otech557sight.mdl", bone = "ACR", pos = Vector(-12, 9.626, -0.816), adjustment = {min = -12, max = -11, axis = "x", inverseOffsetCalc = true}, angle = Angle(0, 0, -90), size = Vector(1, 1, 1)},
		["md_foregrip"] = {model = "models/wystan/attachments/foregrip1.mdl", bone = "ACR", pos = Vector(7.25, 3.575, -11.75), angle = Angle(0, 0, -90), size = Vector(0.75, 0.75, 0.75)},
		["md_saker"] = {model = "models/cw2/attachments/556suppressor.mdl", bone = "ACR", pos = Vector(-1.5, 0.4, -2.8), angle = Angle(0, 90, 0), size = Vector(0.75, 0.75, 0.75)},
		["md_microt1"] = {model = "models/cw2/attachments/microt1.mdl", bone = "ACR", rel = "", pos = Vector(-2.349, -1.203, -0.581), adjustment = {min = -2.349, max = 1.697, axis = "x", inverseOffsetCalc = true}, angle = Angle(90, -90, 0), size = Vector(0.349, 0.349, 0.349)},
		["md_acog"] = {model = "models/wystan/attachments/2cog.mdl", bone = "ACR", pos = Vector(-5.25, 3, -0.3), angle = Angle(-90, 0, -90), size = Vector(0.715, 0.715, 0.715)},
		["md_anpeq15"] = {model = "models/cw2/attachments/anpeq15.mdl", bone = "ACR", pos = Vector(6.61, -1, -0.45), angle = Angle(180, 0, -90), size = Vector(0.5, 0.5, 0.5)},
		["md_schmidt_shortdot"] = {model = "models/cw2/attachments/schmidt.mdl", bone = "ACR", pos = Vector(-5, 3, -0.35), angle = Angle(0, 0, -90), size = Vector(0.71, 0.71, 0.71)},
		["md_bipod"] = {model = "models/wystan/attachments/bipod.mdl", bone = "ACR", pos = Vector(7.75, 1.75, -0.75), angle = Angle(-90, 0, -90), size = Vector(0.699, 0.699, 0.699)},
		["md_nightforce_nxs"] = {model = "models/cw2/attachments/l96_scope.mdl", bone = "ACR", pos = Vector(-0.25, -2.115, -0.415), angle = Angle(0, 0, -90), size = Vector(1, 1, 1)}
	}

	SWEP.ForeGripHoldPos = {
	["CATRIG.LeftClavicle"] = {pos = Vector(0, 5, 0), angle = Angle(0, 0, 0) },
	["CATRIG.LeftThumb1"] = {pos = Vector(0, 0, 0), angle = Angle(33.303, -37, 0) },
	["CATRIG.LeftThumb2"] = {pos = Vector(0, 0, 0), angle = Angle(0, 9.94, 30) },
	["CATRIG.LeftThumb3"] = {pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	}
	
	SWEP.LaserPosAdjust = Vector(-0.75, -1, 0)
	SWEP.LaserAngAdjust = Angle(0, 180, 0) 
end

SWEP.MuzzleVelocity = 913 -- in meter/s

SWEP.SightBGs = {main = 2, none = 1}
SWEP.StockBGs = {main = 3, regular = 0, retracted = 1}
SWEP.LuaViewmodelRecoil = true

SWEP.Attachments = {[1] = {header = "Sight", offset = {800, -500}, atts = { "md_microt1", "md_eotech", "md_aimpoint", "md_schmidt_shortdot", "md_acog", "md_nightforce_nxs"}},
	[2] = {header = "Barrel", offset = {-400, -300}, atts = {"md_saker"}},
	[3] = {header = "Handguard", offset = {-400, 200}, atts = {"md_foregrip", "md_bipod"}},
	[4] = {header = "Rail", offset = {150, -300}, atts = {"md_anpeq15"}},
	[5] = {header = "Stock", offset = {850, 400}, atts = {"bg_acrrstock"}},
	["+reload"] = {header = "Ammo", offset = {800, 0}, atts = {"am_magnum", "am_matchgrade", "am_68rspc", "am_450bushmaster"}}}

SWEP.Animations = {fire = {"shoot1", "shoot2", "shoot3"},
	reload = "reload_full",
	idle = "idle",
	draw = "draw"}
	
SWEP.Sounds = {draw = {[1] = {time = 0, sound = "CW_ACR_DEPLOY"},
[2] = {time = 1.375, sound = "CW_ACR_SHOULDER"}},

	reload_full = {[1] = {time = 0.7, sound = "CW_ACR_MAGOUT"},
	[2] = {time = 1.21, sound = "CW_ACR_MAGIN"},
	[3] = {time = 2.1, sound = "CW_ACR_SHOULDER"}}}

SWEP.SpeedDec = 20

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "semi"}
SWEP.Base = "cw_base"
SWEP.Category = "CW 2.0"

SWEP.Author			= "Pepaund"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/cw2/rifles/v_acr.mdl"
SWEP.WorldModel		= "models/cw2/rifles/w_acr.mdl"

SWEP.DrawTraditionalWorldModel = false
SWEP.WM = "models/cw2/rifles/w_acr.mdl"
SWEP.WMPos = Vector(0, 0, 0)
SWEP.WMAng = Vector(0, 0, 180)

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.56x45MM"

SWEP.FireDelay = 0.08571428571428571428571428571429
SWEP.FireSound = "CW_ACR_FIRE"
SWEP.FireSoundSuppressed = "CW_AR15_FIRE_SUPPRESSED"
SWEP.Recoil = 1

SWEP.HipSpread = 0.035
SWEP.AimSpread = 0.0025
SWEP.VelocitySensitivity = 1.8
SWEP.MaxSpreadInc = 0.03
SWEP.SpreadPerShot = 0.005
SWEP.SpreadCooldown = 0.125
SWEP.Shots = 1
SWEP.Damage = 28
SWEP.DeployTime = 1.625

SWEP.ReloadSpeed = 1
SWEP.ReloadTime = 2.432
SWEP.ReloadTime_Empty = 2.432
SWEP.ReloadHalt = 2.432
SWEP.ReloadHalt_Empty = 2.432
SWEP.SnapToIdlePostReload = true