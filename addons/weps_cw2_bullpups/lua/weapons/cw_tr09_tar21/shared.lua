if CustomizableWeaponry then

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

util.PrecacheModel("models/weapons/therambotnic09/v_cw2_tar21.mdl")
util.PrecacheModel("models/weapons/therambotnic09/w_cw2_tar21.mdl")

local USE_OLD_WELEMENTS = true

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "IMI Tavor TAR-21"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1

	SWEP.magType = "smgMag"

	function SWEP:IndividualThink()
		if self.dt.State == CW_AIMING then
			self.ViewModelMovementScale = 0.3
		else
			self.ViewModelMovementScale = 1
		end
	end

	SWEP.IconLetter = "d"
	killicon.Add("cw_tr09_tar21", "vgui/kills/cw_tr09_tar21_kill", Color(255, 80, 0, 150))
	SWEP.SelectIcon = surface.GetTextureID("vgui/kills/cw_tr09_tar21_select")

	SWEP.MuzzleEffect = "muzzleflash_OTS"
	SWEP.PosBasedMuz = true
	SWEP.SnapToGrip = true
	SWEP.ShellScale = 0.6
	SWEP.ShellOffsetMul = 1
	SWEP.ShellPosOffset = {x = 4, y = 0, z = -3}
	SWEP.ForeGripOffsetCycle_Draw = 0.6
	SWEP.ForeGripOffsetCycle_Reload = 0.62
	SWEP.ForeGripOffsetCycle_Reload_Empty = 0.85

	SWEP.CustomizePos = Vector(5, 0, -1)
	SWEP.CustomizeAng = Vector(25, 40, 15)

	SWEP.IronsightPos = Vector(-1.825, -2, 0.18)
	SWEP.IronsightAng = Vector(0.6, 0, 0)
	SWEP.FOVPerShot = 0.3

	SWEP.MicroT1Pos = Vector(-1.84, 3, 0.07)
	SWEP.MicroT1Ang = Vector(1, 0, 0)

	SWEP.TR09_CMorePos = Vector(-1.83, -3, 0.15)
	SWEP.TR09_CMoreAng = Vector(0, 0, 0)
	
	SWEP.TR09_HD33Pos = Vector(-1.85, -3, 0.25)
	SWEP.TR09_HD33Ang = Vector(0, 0, 0)
	
	SWEP.TR09_MWRRedDotPos = Vector(-1.84, -3, 0.11)
	SWEP.TR09_MWRRedDotAng = Vector(1, 0, 0)
	
	SWEP.TR09_CoyotePos = Vector(-1.84, -3, 0.28)
	SWEP.TR09_CoyoteAng = Vector(0, 0, 0)
	
	SWEP.TR09_TrijiconPos = Vector(-1.845, -3, 0.12)
	SWEP.TR09_TrijiconAng = Vector(0, 0, 0)
	
	SWEP.EoTechPos = Vector(-1.855, -2, -0.12)
	SWEP.EoTechAng = Vector(0, 0, 0)
	
	SWEP.EoTech553Pos = Vector(-1.85, -2, -0.025)
	SWEP.EoTech553Ang = Vector(0, 0, 0)
	
	SWEP.HoloPos = Vector(-1.83, -2, 0.02)
	SWEP.HoloAng = Vector(1, 0, 0)
	
	SWEP.AimpointPos = Vector(-1.86, -2, 0.04)
	SWEP.AimpointAng = Vector(1, 0, 0)
		
	SWEP.FAS2AimpointPos = Vector(-1.82, -3, 0.185)
	SWEP.FAS2AimpointAng = Vector(1, 0, 0)
	
	SWEP.ACOG_FixedPos = Vector(-1.83, -2, -0.13)
	SWEP.ACOG_FixedAng = Vector(0.5, 0, 0)
	SWEP.ACOG_FixedAxisAlign = {right = 0, up = 0, forward = 0}
	
	SWEP.SprintPos = Vector(2, 1, -0.5)
	SWEP.SprintAng = Vector(-15, 35, -15)
	
	SWEP.AlternativePos = Vector(-0.5, 1, -0.5)
	SWEP.AlternativeAng = Vector(0, 0, 0)
	
	SWEP.BackupSights = {["acog_fixed"] = {[1] = Vector(-1.84, -3, -1.06), [2] = Vector(1, 0, 0)}}
	
	SWEP.M203CameraRotation = {p = -90, y = 0, r = -90}

	SWEP.BoltBone = "Charging Handle"
	SWEP.BoltShootOffset = Vector(-2.83, 0, 0)
	SWEP.SightWithRail = true
	SWEP.DontMoveBoltOnHipFire = false
	SWEP.CustomizationMenuScale = 0.0095

	SWEP.AttachmentModelsVM = {
	    ["md_rail"] = {type = "Model", model = "models/wystan/attachments/rail.mdl", bone = "Receiver", pos = Vector(0.235, -0.8, 0.6), angle = Angle(-90, 0, -90), size = Vector(1, 1, 1)},
		["md_aimpoint"] = {type = "Model", model = "models/wystan/attachments/aimpoint.mdl", bone = "Receiver", pos = Vector(0.22, 1.86, 5.8), angle = Angle(0, 180, 90), size = Vector(0.8, 0.8, 0.8)},
		["md_eotech"] = {type = "Model", model = "models/wystan/attachments/2otech557sight.mdl", bone = "Receiver", pos = Vector(-0.27, 8.6, 11.1), angle = Angle(-87, 90, 0), size = Vector(1, 1, 1)},
		["md_anpeq15"] = {type = "Model", model = "models/cw2/attachments/anpeq15.mdl", bone = "Receiver", pos = Vector(0.5, -1.6, -2.5), angle = Angle(90, -180, 0), size = Vector(0.4, 0.4, 0.4)},
		["md_microt1"] = {type = "Model", model = "models/cw2/attachments/microt1.mdl", bone = "Receiver", pos = Vector(-0.01, -2.79,  1.2), angle = Angle(-180, 180, 90), size = Vector(0.34, 0.34, 0.34)},
		["trijicon_rx01"] = {type = "Model", model = "models/attachments/trijicon_rx01.mdl", bone = "Receiver", rel = "", pos = Vector(0.02, -2.7, 1.2), angle = Angle(-90, 0, -90), size = Vector(0.8, 0.8, 0.8)},
		["cmore_railway"] = {type = "Model", model = "models/attachments/cmore_railway.mdl", bone = "Receiver", rel = "", pos = Vector(0, -2.75, 1.1), angle = Angle(-90, 0, -90), size = Vector(0.85, 0.85, 0.85)},
		["codmwr_red_dot"] = {type = "Model", model = "models/attachments/codmwr_red_dot.mdl", bone = "Receiver", rel = "", pos = Vector(0, -2.58, 0.6), angle = Angle(-90, -90, 180), size = Vector(0.8, 0.8, 0.8)},
		["coyote_reddot"] = {type = "Model", model = "models/attachments/coyote_reddot.mdl", bone = "Receiver", rel = "", pos = Vector(0, -2.62, 1.5), angle = Angle(-90, 0, -90), size = Vector(0.9, 0.9, 0.9)},
		["hd33_sight"] = {type = "Model", model = "models/attachments/hd33.mdl", bone = "Receiver", rel = "", pos = Vector(0, 1.18, 0.5), angle = Angle(-90, 0, -90), size = Vector(0.55, 0.55, 0.55)},
		["md_fas2_eotech"] = {type = "Model", model = "models/c_fas2_eotech.mdl", bone = "Receiver", rel = "", pos = Vector(-0.01, -2.19, -2.5), angle = Angle(-90, 90, 0), size = Vector(1, 1, 1)},
		["md_fas2_aimpoint"] = {type = "Model", model = "models/c_fas2_aimpoint_rigged.mdl", bone = "Receiver", rel = "", pos = Vector(-0.02, -1.95, -1.85), angle = Angle(-90, 180, 90), size = Vector(1, 1, 1)},
		["md_fas2_holo_aim"] = {type = "Model", model = "models/v_holo_sight_orig_hx.mdl", bone = "Receiver", rel = "", pos = Vector(0, 0.68, 2.82), angle = Angle(-90, 90, 0), size = Vector(0.6, 0.6, 0.6)},
		["md_fas2_holo"] = {type = "Model", model = "models/v_holo_sight_kkrc.mdl", bone = "Receiver", rel = "", pos = Vector(0, 0.68, 2.82), angle = Angle(-90, 90, 0), size = Vector(0.6, 0.6, 0.6)},
		["md_saker"] = {type = "Model", model = "models/cw2/attachments/556suppressor.mdl", bone = "Receiver", pos = Vector(0, -3, 5.15), angle = Angle(0, 0, 90), size = Vector(0.6, 0.6, 0.6)},
		["tar21_mvg"] = {type = "Model", model = "models/attachments/magpulgrip.mdl", bone = "Receiver", pos = Vector(-0.392, -3.997, -1.839), angle = Angle(0, 0, 0), size = Vector(0.75, 0.75, 0.75)},
		["acog_fixed"] = {type = "Model", model = "models/wystan/attachments/2cog.mdl", bone = "Receiver", pos = Vector(0.3, 1.9, 5), angle = Angle(-180, 0, -90), size = Vector(0.8, 0.8, 0.8)}
	}
	
	SWEP.WElements = {
	    ["md_rail"] = {type = "Model", model = "models/wystan/attachments/rail.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(6.4, 0.25, -3.2), angle = Angle(0, 0, 180), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_aimpoint"] = {type = "Model", model = "models/wystan/attachments/aimpoint.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(0.5, 0.25, 0.57), angle = Angle(0, -90, 180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_eotech"] = {type = "Model", model = "models/wystan/attachments/2otech557sight.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(-9, 0.95, 11.25), angle = Angle(-3, 0, 180), size = Vector(1.5, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_anpeq15"] = {type = "Model", model = "models/cw2/attachments/anpeq15.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(11.5, -0.35, -3), angle = Angle(-180, 0, -90), size = Vector(0.7, 0.7, 0.7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_microt1"] = {type = "Model", model = "models/cw2/attachments/microt1.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(6.75, 0.57, -5.75), angle = Angle(180, -90, 0), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["trijicon_rx01"] = {type = "Model", model = "models/attachments/trijicon_rx01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.2, 0.55, -5.7), angle = Angle(0, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["cmore_railway"] = {type = "Model", model = "models/attachments/cmore_railway.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.4, 0.55, -5.72), angle = Angle(0, 0, 180), size = Vector(1.05, 1.05, 1.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["codmwr_red_dot"] = {type = "Model", model = "models/attachments/codmwr_red_dot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 0.53, -5.52), angle = Angle(0, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["coyote_reddot"] = {type = "Model", model = "models/attachments/coyote_reddot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6, 0.55, -5.55), angle = Angle(0, 0, 180), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["hd33_sight"] = {type = "Model", model = "models/attachments/hd33.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.7, 0.55, -0.7), angle = Angle(0, 0, 180), size = Vector(0.7, 0.7, 0.7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_eotech"] = {type = "Model", model = "models/c_fas2_eotech.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.5, 0.57, -5), angle = Angle(0, 0, 180), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_aimpoint"] = {type = "Model", model = "models/c_fas2_aimpoint_rigged.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.75, 0.57, -4.7), angle = Angle(0, 0, 180), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_holo_aim"] = {type = "Model", model = "models/v_holo_sight_orig_hx.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.9, 0.55, -1.15), angle = Angle(0, 0, 180), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_holo"] = {type = "Model", model = "models/v_holo_sight_kkrc.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.9, 0.55, -1.15), angle = Angle(0, 0, 180), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_saker"] = {type = "Model", model = "models/cw2/attachments/556suppressor.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(2.5, 0.55, -5.6), angle = Angle(0, 90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["tar21_mvg"] = {type = "Model", model = "models/attachments/magpulgrip.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(-0.392, -3.997, -1.839), angle = Angle(0, 0, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["acog_fixed"] = {type = "Model", model = "models/wystan/attachments/2cog.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(1.4, 0.18, 0.08), angle = Angle(0, -90, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
	}
	
--[[
	SWEP.ForegripOverridePos = {
		["tar21_mvg"] = {
			["l_ring_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -9.273, 31.198) },
			["l_middle_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10.807, 4.173, 56.374) },
			["l_upperarm"] = { scale = Vector(1, 1, 1), pos = Vector(0.9, -0.22, -1.6), angle = Angle(0, 0, 0) },
			["l_armtwist_4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10, 0, 0) },
			["l_armtwist_3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10, 0, 0) },
			["l_middle_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 32.676) },
			["l_armtwist_2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10, 0, 0) },
			["l_index_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(12.616, -4.147, 23.656) },
			["l_thumb_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -9.815, 38.255) },
			["l_wrist"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(50.317, 27.833, 3.444) },
			["l_ring_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 4.52, 6.515) },
			["l_thumb_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -20, -10.261) },
			["l_pinky_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-10.341, 8.996, 61.457) },
			["l_pinky_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -13.86, 31.634) },
			["l_ring_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -23.821) },
			["l_middle_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 5.791, 8.321) },
			["l_thumb_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -76.631, 0) },
			["l_index_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 9.673) },
			["l_armtwist_1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(30, 0, 0) },
			["l_index_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.409, -5.075, 53.347) }
		}
	}
	
	]]--
	
	SWEP.LaserPosAdjust = Vector(0.5, 0, 0)
	SWEP.LaserAngAdjust = Angle(0, 180, 0)
	
end

SWEP.SightBGs = {main = 1, none = 1}
SWEP.MagBGs = {main = 2, regular = 0, pmag = 1}
SWEP.LuaViewmodelRecoil = false

if CustomizableWeaponry_KK_HK416 then
	SWEP.Attachments = {[1] = {header = "Sight", offset = {400, -400}, atts = {"md_microt1", "cmore_railway", "hd33_sight", "codmwr_red_dot", "coyote_reddot", "trijicon_rx01", "md_eotech", "md_fas2_eotech", "md_aimpoint", "md_fas2_aimpoint", "acog_fixed"}},
		[2] = {header = "Barrel", offset = {-400, -200}, atts = {"md_saker"}},
		[3] = {header = "Laser", offset = {-400, 250}, atts = {"md_anpeq15"}},
--		[4] = {header = "Foregrip", offset = {-450, 300}, atts = {"tar21_mvg"}},
		[4] = {header = "Magazine", offset = {1000, 500}, atts = {"tar21_pmag"}},
		["impulse 100"] = {header = "Skin", offset = {300, 350}, atts = {"tar21_tan"}},
		["+reload"] = {header = "Ammo", offset = {1000, 100}, atts = {"am_magnum", "am_matchgrade"}}
	}
else
	SWEP.Attachments = {[1] = {header = "Sight", offset = {400, -400}, atts = {"md_microt1", "cmore_railway", "hd33_sight", "codmwr_red_dot", "coyote_reddot", "trijicon_rx01", "md_eotech", "md_aimpoint", "acog_fixed"}},
		[2] = {header = "Barrel", offset = {-300, -200}, atts = {"md_saker"}},
		[3] = {header = "Laser", offset = {-300, 250}, atts = {"md_anpeq15"}},
--		[4] = {header = "Foregrip", offset = {-450, 300}, atts = {"tar21_mvg"}},
		[4] = {header = "Magazine", offset = {1100, 500}, atts = {"tar21_pmag"}},
		["impulse 100"] = {header = "Skin", offset = {400, 350}, atts = {"tar21_tan"}},
		["+reload"] = {header = "Ammo", offset = {1100, 100}, atts = {"am_magnum", "am_matchgrade"}}
	}
end

SWEP.Animations = {fire = {"shoot1", "shoot2", "shoot3"},
	reload = "reload",
	idle = "idle",
	draw = "draw"}
	
SWEP.Sounds = {draw = {{time = 0, sound = "CW_TAR21_CLOTH"},
	{time = 0.2, sound = "CW_TAR21_BOLTPULL"},
	{time = 0.4, sound = "CW_TAR21_BOLTRELEASE"}},

	reload = {{time = 0.35, sound = "CW_TAR21_MAGRELEASE"},
	{time = 0.4, sound = "CW_TAR21_MAGOUT"},
	{time = 1, sound = "CW_TAR21_MAGDRAW"},
	{time = 1.75, sound = "CW_TAR21_MAGIN"},
	{time = 2.5, sound = "CW_TAR21_BOLTPULL"},
	{time = 2.7, sound = "CW_TAR21_BOLTRELEASE"}}}

SWEP.SpeedDec = 20

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "semi"}
SWEP.Base = "cw_base"
SWEP.Category = "CW 2.0 - TheRambotnic09"

SWEP.Author			= "TheRambotnic09" // This was actually Dzembi's weapon. Consider this as an "improvement" of his original addon.
SWEP.Contact		= "Via Steam: http://steamcommunity.com/id/therambotniczeronove/"
SWEP.Purpose		= "To kill bad guys. Duh!"
SWEP.Instructions	= "Press your primary PEW-PEW key to kill the bad guys."

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/therambotnic09/v_cw2_tar21.mdl"
SWEP.WorldModel		= "models/weapons/therambotnic09/w_cw2_tar21.mdl"
SWEP.DrawTraditionalWorldModel = false
SWEP.WM = "models/weapons/therambotnic09/w_cw2_tar21.mdl"
SWEP.WMPos = Vector(-0.5, -1, 0)
SWEP.WMAng = Vector(0, 0, -180)

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 150
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.56x45MM"

SWEP.FireDelay = 0.0667
SWEP.FireSound = "CW_TAR21_FIRE"
SWEP.FireSoundSuppressed = "CW_TAR21_SUPPRESSED"
SWEP.Recoil = 0.75

SWEP.HipSpread = 0.05
SWEP.AimSpread = 0.0025
SWEP.VelocitySensitivity = 1.8
SWEP.MaxSpreadInc = 0.05
SWEP.SpreadPerShot = 0.008
SWEP.SpreadCooldown = 0.1
SWEP.Shots = 1
SWEP.Damage = 25
SWEP.DeployTime = 0.8

SWEP.ReloadSpeed = 1
SWEP.ReloadTime = 2.2
SWEP.ReloadTime_Empty = 3.3
SWEP.ReloadHalt = 2.2
SWEP.ReloadHalt_Empty = 3.3
SWEP.SnapToIdlePostReload = true

if USE_OLD_WELEMENTS then

if CLIENT then

	CustomizableWeaponry.callbacks:addNew("initialize", "cw_tr09_tar21", function(wep) -- instead of copy pasting 50+ lines of func, 5 lines can do even more
		if wep and wep:GetClass() == "cw_tr09_tar21" then
			wep:CreateModels(wep.WElements)
		end
	end)
	
	function SWEP:WElementThink()
	
		if (self.ActiveAttachments.md_microt1 or self.ActiveAttachments.cmore_railway or self.ActiveAttachments.hd33_sight or self.ActiveAttachments.codmwr_red_dot
		or self.ActiveAttachments.coyote_reddot or self.ActiveAttachments.trijicon_rx01 or self.ActiveAttachments.md_eotech or self.ActiveAttachments.md_fas2_eotech
		or self.ActiveAttachments.md_fas2_holo or self.ActiveAttachments.md_aimpoint or self.ActiveAttachments.md_fas2_aimpoint or self.ActiveAttachments.acog_fixed) then
			self.WElements.md_rail.hide = false
			if self.WMEnt then
				self.WMEnt:SetBodygroup(1,1)
			end
		else
			self.WElements.md_rail.hide = true
			if self.WMEnt then
				self.WMEnt:SetBodygroup(1,0)
			end
		end
		
		if self.ActiveAttachments.md_microt1 then
			self.WElements.md_microt1.hide = false
		else
			self.WElements.md_microt1.hide = true
		end
		
		if self.ActiveAttachments.cmore_railway then
			self.WElements.cmore_railway.hide = false
		else
			self.WElements.cmore_railway.hide = true
		end
		
		if self.ActiveAttachments.hd33_sight then
			self.WElements.hd33_sight.hide = false
		else
			self.WElements.hd33_sight.hide = true
		end
		
		if self.ActiveAttachments.codmwr_red_dot then
            self.WElements.codmwr_red_dot.hide = false
        else
			self.WElements.codmwr_red_dot.hide = true
		end
		
		if self.ActiveAttachments.coyote_reddot then
			self.WElements.coyote_reddot.hide = false
		else
			self.WElements.coyote_reddot.hide = true
		end
		
		if self.ActiveAttachments.trijicon_rx01 then
			self.WElements.trijicon_rx01.hide = false
		else
			self.WElements.trijicon_rx01.hide = true
		end
		
		if self.ActiveAttachments.md_eotech then
            self.WElements.md_eotech.hide = false
        else
			self.WElements.md_eotech.hide = true
		end
		
		if self.ActiveAttachments.md_fas2_eotech then
            self.WElements.md_fas2_eotech.hide = false
        else
			self.WElements.md_fas2_eotech.hide = true
		end
		
		if self.ActiveAttachments.md_fas2_holo then
            self.WElements.md_fas2_holo.hide = false
			self.WElements.md_fas2_holo_aim.hide = false
        else
			self.WElements.md_fas2_holo.hide = true
			self.WElements.md_fas2_holo_aim.hide = true
		end
		
		if self.ActiveAttachments.md_aimpoint then
            self.WElements.md_aimpoint.hide = false
        else
			self.WElements.md_aimpoint.hide = true
		end
		
		if self.ActiveAttachments.md_fas2_aimpoint then
            self.WElements.md_fas2_aimpoint.hide = false
        else
			self.WElements.md_fas2_aimpoint.hide = true
		end
		
		if self.ActiveAttachments.acog_fixed then
            self.WElements.acog_fixed.hide = false
        else
			self.WElements.acog_fixed.hide = true
		end
		
		if self.ActiveAttachments.md_saker then
            self.WElements.md_saker.hide = false
        else
			self.WElements.md_saker.hide = true
		end
		
		if self.ActiveAttachments.md_anpeq15 then
            self.WElements.md_anpeq15.hide = false
        else
			self.WElements.md_anpeq15.hide = true
		end
		
		if self.ActiveAttachments.tar21_mvg then
            self.WElements.tar21_mvg.hide = false
        else
			self.WElements.tar21_mvg.hide = true
		end
		
		if self.ActiveAttachments.tar21_pmag then
			if self.WMEnt then
				self.WMEnt:SetBodygroup(2,1)
			end
		else
			if self.WMEnt then
				self.WMEnt:SetBodygroup(2,0)
			end
		end
		
		if self.ActiveAttachments.tar21_tan then
			if self.WMEnt then
				self.WMEnt:SetSkin(1)
			end
		elseif self.ActiveAttachments.tar21_scifi then
			if self.WMEnt then
				self.WMEnt:SetSkin(2)
			end
		else
			if self.WMEnt then
				self.WMEnt:SetSkin(0)
			end
		end

	end
 
	local Vec0, Ang0 = Vector(0, 0, 0), Angle(0, 0, 0)
	local TargetPos, TargetAng, cos1, sin1, tan, ws, rs, mod, EA, delta, sin2, mul, vm, muz, muz2, tr, att
	local td = {}
	local LerpVector, LerpAngle, Lerp = LerpVector, LerpAngle, Lerp

	local reg = debug.getregistry()
	local GetVelocity = reg.Entity.GetVelocity
	local Length = reg.Vector.Length
	local Right = reg.Angle.Right
	local Up = reg.Angle.Up
	local Forward = reg.Angle.Forward
	local RotateAroundAxis = reg.Angle.RotateAroundAxis
	local GetBonePosition = reg.Entity.GetBonePosition

	local ManipulateBonePosition, ManipulateBoneAngles = reg.Entity.ManipulateBonePosition, reg.Entity.ManipulateBoneAngles
			
	local wm, pos, ang
	SWEP.wRenderOrder = nil

	function SWEP:DrawWorldModel()
		if self.dt.Safe then
			if self.CHoldType != self.RunHoldType then
				self:SetHoldType(self.RunHoldType)
				self.CHoldType = self.RunHoldType
			end
		else
			if self.dt.State == CW_RUNNING or self.dt.State == CW_ACTION then
				if self.CHoldType != self.RunHoldType then
					self:SetHoldType(self.RunHoldType)
					self.CHoldType = self.RunHoldType
				end
			else
				if self.CHoldType != self.NormalHoldType then
					self:SetHoldType(self.NormalHoldType)
					self.CHoldType = self.NormalHoldType
				end
			end
		end
					
				if self.DrawTraditionalWorldModel then
					self:DrawModel()
				else
					wm = self.WMEnt
					
					if IsValid(wm) then
						if IsValid(self.Owner) then
							pos, ang = GetBonePosition(self.Owner, self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
							
							if pos and ang then
								RotateAroundAxis(ang, Right(ang), self.WMAng[1])
								RotateAroundAxis(ang, Up(ang), self.WMAng[2])
								RotateAroundAxis(ang, Forward(ang), self.WMAng[3])

								pos = pos + self.WMPos[1] * Right(ang) 
								pos = pos + self.WMPos[2] * Forward(ang)
								pos = pos + self.WMPos[3] * Up(ang)
								
								wm:SetRenderOrigin(pos)
								wm:SetRenderAngles(ang)
								wm:DrawModel()
							end
						else
							wm:SetRenderOrigin(self:GetPos())
							wm:SetRenderAngles(self:GetAngles())
							wm:DrawModel()
							wm:DrawShadow()
						end
					else
						self:DrawModel()
					end
				end
				
				self:WElementThink()
				
				if (!self.WElements) then return end
				
				if (!self.wRenderOrder) then
					self.wRenderOrder = {}

					for k, v in pairs( self.WElements ) do
						if (v.type == "Model") then
							table.insert(self.wRenderOrder, 1, k)
						elseif (v.type == "Sprite" or v.type == "Quad") then
							table.insert(self.wRenderOrder, k)
						end
					end
				end
				
				if (IsValid(self.Owner)) then
					bone_ent = self.Owner
				else
					-- when the weapon is dropped
					bone_ent = self
				end
				
				for k, name in pairs( self.wRenderOrder ) do
				
					local v = self.WElements[name]
					if (!v) then self.wRenderOrder = nil break end
					if (v.hide) then continue end
					
					local pos, ang
					
					if (v.bone) then
						pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
					else
						pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
					end
					
					if (!pos) then continue end
					
					local model = v.modelEnt
					local sprite = v.spriteMaterial
					
					if (v.type == "Model" and IsValid(model)) then

						if IsValid(self.Owner) then
							model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
							ang:RotateAroundAxis(ang:Up(), v.angle.y)
							ang:RotateAroundAxis(ang:Right(), v.angle.p)
							ang:RotateAroundAxis(ang:Forward(), v.angle.r)
						else
							model:SetPos(pos + ang:Forward() * v.pos_dropped.x + ang:Right() * v.pos_dropped.y + ang:Up() * v.pos_dropped.z )
							ang:RotateAroundAxis(ang:Up(), v.angle_dropped.y)
							ang:RotateAroundAxis(ang:Right(), v.angle_dropped.p)
							ang:RotateAroundAxis(ang:Forward(), v.angle_dropped.r)
						end
						
						model:SetAngles(ang)
						local matrix = Matrix()
						matrix:Scale(v.size)
						model:EnableMatrix( "RenderMultiply", matrix )
						
						if (v.material == "") then
							model:SetMaterial("")
						elseif (model:GetMaterial() != v.material) then
							model:SetMaterial( v.material )
						end
						
						if (v.skin and v.skin != model:GetSkin()) then
							model:SetSkin(v.skin)
						end
						
						if (v.bodygroup) then
							for k, v in pairs( v.bodygroup ) do
								if (model:GetBodygroup(k) != v) then
									model:SetBodygroup(k, v)
								end
							end
						end
						
						if (v.surpresslightning) then
							render.SuppressEngineLighting(true)
						end
						
						render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
						render.SetBlend(v.color.a/255)
						model:DrawModel()
						render.SetBlend(1)
						render.SetColorModulation(1, 1, 1)
						
						if (v.surpresslightning) then
							render.SuppressEngineLighting(false)
						end
					end
				end
			end
		
			function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
				
				local bone, pos, ang
				if (tab.rel and tab.rel != "") then
					
					local v = basetab[tab.rel]
					
					if (!v) then return end
					
					-- Technically, if there exists an element with the same name as a bone
					-- you can get in an infinite loop. Let's just hope nobody's that stupid.
					pos, ang = self:GetBoneOrientation( basetab, v, ent )
					
					if (!pos) then return end
					
					pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
					ang:RotateAroundAxis(ang:Up(), v.angle.y)
					ang:RotateAroundAxis(ang:Right(), v.angle.p)
					ang:RotateAroundAxis(ang:Forward(), v.angle.r)
						
				else
				
					bone = ent:LookupBone(bone_override or tab.bone)

					if (!bone) then return end
					
					pos, ang = Vector(0,0,0), Angle(0,0,0)
					local m = ent:GetBoneMatrix(bone)
					if (m) then
						pos, ang = m:GetTranslation(), m:GetAngles()
					end
					
					if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
						ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
						ang.r = -ang.r -- Fixes mirrored models
					end
				
				end
				
				return pos, ang
			end

			function SWEP:CreateModels( tab )

				if (!tab) then return end

				-- Create the clientside models here because Garry says we cannot do it in the render hook 
				for k, v in pairs( tab ) do
					if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
							string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
						
						v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
						if (IsValid(v.modelEnt)) then
							v.modelEnt:SetPos(self:GetPos())
							v.modelEnt:SetAngles(self:GetAngles())
							v.modelEnt:SetParent(self)
							v.modelEnt:SetNoDraw(true)
							v.createdModel = v.model
						else
							v.modelEnt = nil
						end
						
					elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
						and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
						
						local name = v.sprite.."-"
						local params = { ["$basetexture"] = v.sprite }
						-- make sure we create a unique name based on the selected options
						local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
						for i, j in pairs( tocheck ) do
							if (v[j]) then
								params["$"..j] = 1
								name = name.."1"
							else
								name = name.."0"
							end
						end

						v.createdSprite = v.sprite
						v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
						
					end
				end
				
			end
			
			/**************************
				Global utility code
			**************************/

			// Fully copies the table, meaning all tables inside this table are copied too and so on (Normal table. Copy copies only their reference).
			// Does not copy entities of course.
			// WARNING: do not use on tables that contain themselves somewhere down the line or you will get an infinite loop
			function table.FullCopy( tab )

				if (!tab) then return nil end
				
				local res = {}
				for k, v in pairs( tab ) do
					if (type(v) == "table") then
						res[k] = table.FullCopy(v) -- recursion ho!
					elseif (type(v) == "Vector") then
						res[k] = Vector(v.x, v.y, v.z)
					elseif (type(v) == "Angle") then
						res[k] = Angle(v.p, v.y, v.r)
					else
						res[k] = v
					end
				end
				
				return res
			end
		end
	end
end