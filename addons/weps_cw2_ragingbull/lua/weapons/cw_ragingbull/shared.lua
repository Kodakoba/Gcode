AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Taurus Raging Bull"
	SWEP.CSMuzzleFlashes = true

	SWEP.IconLetter = "i"
	killicon.Add("cw_ragingbull", "vgui/kills/cw_ragingbull", Color(255, 80, 0, 150))
	SWEP.SelectIcon = surface.GetTextureID("vgui/kills/cw_ragingbull")
	
	SWEP.MuzzleEffect = "muzzleflash_6"
	SWEP.PosBasedMuz = true
	SWEP.MuzzlePosMod = {x = 0, y = 0, z = 0}
	SWEP.NoShells = true
	
	//Hk pack attachments
	SWEP.CoD4ReflexPos = Vector(2.769, -2, -0.2)
	SWEP.CoD4ReflexAng = Vector(0, 0, 0)
	
	SWEP.CoD4TascoPos = Vector(2.78, -2, 0.31)
	SWEP.CoD4TascoAng = Vector(0, 0, 0)
	
	SWEP.FAS2AimpointPos = Vector(2.789, -2, 0)
	SWEP.FAS2AimpointAng = Vector(0, 0, 0)
	
	SWEP.LeupoldPos = Vector(2.769, -2, -0.08)
	SWEP.LeupoldAng = Vector(0, 0, 0)
	SWEP.LeupoldAxisAlign = {right = 0, up = 0, forward = 0}
	
	SWEP.HoloPos = Vector(2.768, -2, -0.28)
	SWEP.HoloAng = Vector(0, 0, 0)
	
	SWEP.ACOGPos = Vector(2.769, -2, -0.151)
	SWEP.ACOGAng = Vector(0, 0, 0)
	
	SWEP.CoD4ACOGPos = Vector(2.769, -2, -0.151)
	SWEP.CoD4ACOGAng = Vector(0, 0, 0)
	
	SWEP.CoD4ACOGAxisAlign = {right = -0.1, up = 180, forward = 0}
	
	//aTTACHMENTS THAT COME WITH THE PACK
	SWEP.AimpointPos = Vector(2.785, 0, -0.151)
	SWEP.AimpointAng = Vector(0, 0, 0)
	
	SWEP.EoTechPos = Vector(2.75, -2.222, -0.45)
	SWEP.EoTechAng = Vector(0, 0, 0)
	
	SWEP.MicroT1Pos = Vector(2.799, -2.222, -0.071)
	SWEP.MicroT1Ang = Vector(0, 0, 0)
	
	SWEP.SprintPos = Vector(-0.721, -4.222, -2.481)
	SWEP.SprintAng = Vector(36.583, 0, 0)

	SWEP.CustomizePos = Vector(-2.04, -3.016, -0.281)
	SWEP.CustomizeAng = Vector(21.106, -35.176, -6.332)

	SWEP.IronsightPos = Vector(2.769, -2.222, 0.8)
	SWEP.IronsightAng = Vector(0, 0, 0)

	SWEP.SprintPos = Vector(0.256, 0.01, 1.2)
	SWEP.SprintAng = Vector(-17.778, 0, 0)
	
	SWEP.AlternativePos = Vector(-0.281, 1.325, -0.52)
	SWEP.AlternativeAng = Vector(0, 0, 0)
	
	SWEP.DeltaPos = Vector(2.78, -2.222, 0.259)
	SWEP.DeltaAng = Vector(0, 0, 0)
	
	SWEP.CantedPos = Vector(3.509, -2, 0.439)
	SWEP.CantedAng = Vector(0.119, -0.141, 45)
	
	SWEP.RscopePos = Vector(2.75, -2.613, 0.18)
	SWEP.RscopeAng = Vector(0, 0, 0)
	SWEP.BFRIFLEAxisAlign = {right = 0, up = 0, forward = 0}
	
	//SWEP.MW3SPos = Vector(2.759, -2, -0.201)
	//SWEP.MW3SAng = Vector(0, 0, 0)
	//SWEP.MW3SAxisAlign = {right = 0, up = 0, forward = 0}
	
	SWEP.CoyotePos = Vector(2.785, -2, 0)
	SWEP.CoyoteAng = Vector(0, 0, 0)

	SWEP.BFReflexPos  = Vector(2.77, -2, 0.039)
	SWEP.BFReflexAng  = Vector(0, 0, 0)

	SWEP.SightWithRail = true
	
	SWEP.ViewModelMovementScale = 0.8
	SWEP.FullAimViewmodelRecoil = true
	SWEP.HUD_MagText = "CYLINDER: "
	
	SWEP.BoltBone = "mchammer"
	SWEP.BoltShootOffset = Vector(0, -0.5, 1)
	SWEP.HoldBoltWhileEmpty = false
	SWEP.DontHoldWhenReloading = true
	
	SWEP.LuaVMRecoilAxisMod = {vert = 1, hor = 1.5, roll = 3, forward = 1, pitch = 4}
	SWEP.DisableSprintViewSimulation = true
	
	SWEP.AttachmentModelsVM = {
		["md_couldbewhat"] = { type = "Model", model = "models/rageattachments/cantedsightrear.mdl", bone = "Body", rel = "", pos = Vector(0.05, 1.389, -0.801), angle = Angle(-90, -90, 0), size = Vector(0.6, 0.6, 0.6)},
		["md_cantedsights"] = { type = "Model", model = "models/rageattachments/cantedsightfront.mdl", bone = "Body", rel = "", pos = Vector(0, 1.419, -5.2), angle = Angle(-90, -90, 0), size = Vector(0.6, 0.6, 0.6)},

		["md_fas2_leupold"] = { type = "Model", model = "models/v_fas2_leupold.mdl", bone = "Body", rel = "", pos = Vector(0, 2.45, -1.101), angle = Angle(-90, -90, 0), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255)},
		["md_fas2_leupold_mount"] = { type = "Model", model = "models/v_fas2_leupold_mounts.mdl", bone = "Body", rel = "", pos = Vector(0, 2.4, -0.801), angle = Angle(-90, -90, 0), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255)},
		["md_fas2_holo"] = { type = "Model", model = "models/v_holo_sight_kkrc.mdl", bone = "Body", rel = "", pos = Vector(0, -1.65, 0.449), angle = Angle(-90, -90, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255)},
		["md_fas2_holo_aim"] = { type = "Model", model = "models/v_holo_sight_orig_hx.mdl", bone = "Body", rel = "", pos = Vector(0, -1.65, 0.449), angle = Angle(-90, -90, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255)},
		["md_cod4_acog_v2"] = { type = "Model", model = "models/v_cod4_acog.mdl", bone = "Body", rel = "", pos = Vector(0, -0.9, 0.8), angle = Angle(90, 90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255)},
		["md_fas2_aimpoint"] = { type = "Model", model = "models/c_fas2_aimpoint_rigged.mdl", bone = "Body", rel = "", pos = Vector(0, 1, -4.676), angle = Angle(-90, -90, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255)},
		["md_cod4_aimpoint_v2"] = { type = "Model", model = "models/v_cod4_aimpoint.mdl", bone = "Body", rel = "", pos = Vector(0, -0.301, 0.518), angle = Angle(90, 90, 0), size = Vector(0.579, 0.579, 0.579), color = Color(255, 255, 255, 255)},
		["md_cod4_reflex"] = { type = "Model", model = "models/v_cod4_reflex.mdl", bone = "Body", rel = "", pos = Vector(0, -1.201, 1.557), angle = Angle(90, 90, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255)},
		["md_bfreflex"] = { type = "Model", model = "models/rageattachments/usareddot.mdl", bone = "Body", rel = "", pos = Vector(-0.051, 1.299, -2), angle = Angle(-90, -90, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255)},
		["md_cyotesight"] = { type = "Model", model = "models/rageattachments/cyotesight.mdl", bone = "Body", rel = "", pos = Vector(0, 1.399, -2), angle = Angle(-90, -90, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255)},
		//["md_mw3scope"] = { type = "Model", model = "models/rageattachments/v_msrscope.mdl", bone = "Body", rel = "", pos = Vector(0.1, 1, -2.5), angle = Angle(-90, -90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255)},
		["md_bfriflescope"] = { type = "Model", model = "models/rageattachments/sniperscopesv.mdl", bone = "Body", rel = "", pos = Vector(0, 1.5, -1.558), angle = Angle(0, -180, -90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255)},
		["md_deltasight"] = { type = "Model", model = "models/rageattachments/deltasight.mdl", bone = "Body", rel = "", pos = Vector(0, 1.25, -1.558), angle = Angle(-90, -180, -90), size = Vector(0.898, 0.898, 0.898), color = Color(255, 255, 255, 255)},
		["md_aimpoint"] = { type = "Model", model = "models/wystan/attachments/aimpoint.mdl", bone = "Body", rel = "", pos = Vector(-0.201, -2.901, 2.596), angle = Angle(0, 0, 90), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255)},
		["md_eotech"] = { type = "Model", model = "models/wystan/attachments/2otech557sight.mdl", bone = "Body", rel = "", pos = Vector(0.3, -9.051, 8.8), angle = Angle(-90, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255)},
		["md_microt1"] = { type = "Model", model = "models/cw2/attachments/microt1.mdl", bone = "Body", rel = "", pos = Vector(0, 1.75, -2), angle = Angle(-180, 0, 90), size = Vector(0.349, 0.349, 0.349), color = Color(255, 255, 255, 255)},
		["md_rail"] = { type = "Model", model = "models/weapons/raging/ragerail/box01.mdl", bone = "Body", rel = "", pos = Vector(0, 1.399, -2.901), angle = Angle(-90, -90, 0), size = Vector(0.119, 0.085, 0.079), color = Color(255, 255, 255, 255)},
		["md_lasersight"] = { type = "Model", model = "models/rageattachments/pistoltribeam.mdl", bone = "Body", rel = "", pos = Vector(0, -0.7, -3.25), angle = Angle(-90, -90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255)}
	}
	
	SWEP.CompM4SBoneMod = {}
	
	SWEP.LaserPosAdjust = Vector(0, -3, -0.1)
	SWEP.LaserAngAdjust = Angle(0, 0, 0) 
end

SWEP.BarrelBGs = {main = 1, regular = 1, long = 2, short = 0}
SWEP.LuaViewmodelRecoil = false
SWEP.CanRestOnObjects = false

if CustomizableWeaponry_KK_HK416 and CustomizableWeaponry_Fluffy_Zorua then
	SWEP.Attachments = {
		[1] = {header = "Sight", offset = {-450, -400},  atts = {"md_cod4_reflex", "md_deltasight", "md_microt1", "md_bfreflex", "md_cyotesight", "md_eotech", "md_aimpoint", "md_cod4_aimpoint_v2", "md_fas2_aimpoint", "md_cod4_acog_v2", "md_fas2_holo", "md_fas2_leupold", "md_bfriflescope" }},
		[2] = {header = "Barrel", offset = {-450, 150}, atts = {"md_lasersight"}},
		[3] = {header = "Canted Sights", offset = {0, 150}, atts = {"md_cantedsights"}, dependencies = {md_deltasight = true, md_cod4_reflex = true, md_microt1 = true, md_bfreflex = true, md_cyotesight = true, md_cod4_aimpoint_v2 = true, md_aimpoint = true, md_bfriflescope = true, md_fas2_leupold = true, md_cod4_acog = true, md_fas2_holo = true}},
		["+reload"] = {header = "Ammo", offset = {-450, 600}, atts = {"am_matchgrade"}},
		["impulse 100"] = {header = "Skins", offset = {800, 300}, atts = {"bg_wsraging_paint1", "bg_wsraging_paint2"}},
		["+attack2"] = {header = "Perks", offset = {800, -100}, atts = {"pk_sleightofhand", "pk_light"}}
	}
elseif CustomizableWeaponry_KK_HK416 then
	SWEP.Attachments = {
		[1] = {header = "Sight", offset = {-450, -400},  atts = {"md_cod4_reflex", "md_microt1", "md_eotech", "md_aimpoint", "md_cod4_aimpoint_v2", "md_fas2_aimpoint", "md_cod4_acog_v2", "md_fas2_holo", "md_fas2_leupold"}},
		["+reload"] = {header = "Ammo", offset = {-450, 600}, atts = {"am_matchgrade"}},
		["impulse 100"] = {header = "Skins", offset = {800, 300}, atts = {"bg_wsraging_paint1", "bg_wsraging_paint2"}}
	}
elseif CustomizableWeaponry_Fluffy_Zorua then
	SWEP.Attachments = {
		[1] = {header = "Sight", offset = {-450, -400},  atts = {"md_deltasight", "md_microt1", "md_bfreflex", "md_cyotesight", "md_eotech", "md_aimpoint", "md_bfriflescope"}},
		[2] = {header = "Barrel", offset = {-450, 150}, atts = {"md_lasersight"}},
		[3] = {header = "Canted Sights", offset = {0, 150}, atts = {"md_cantedsights"}, dependencies = {md_deltasight = true, md_microt1 = true, md_bfreflex = true, md_cyotesight = true, md_aimpoint = true, md_bfriflescope = true}},
		["+reload"] = {header = "Ammo", offset = {-450, 600}, atts = {"am_matchgrade"}},
		["impulse 100"] = {header = "Skin", offset = {800, 300}, atts = {"bg_wsraging_paint1", "bg_wsraging_paint2"}},
		["+attack2"] = {header = "Perks", offset = {800, 100}, atts = {"pk_sleightofhand", "pk_light"}}
	}
else
	SWEP.Attachments = {
		[1] = {header = "Sight", offset = {-450, -400},  atts = {"md_microt1", "md_eotech", "md_aimpoint"}},
		["+reload"] = {header = "Ammo", offset = {-450, 600}, atts = {"am_matchgrade"}},
		["impulse 100"] = {header = "Skins", offset = {800, 300}, atts = {"bg_wsraging_paint1", "bg_wsraging_paint2"}}
	}
end

SWEP.Animations = {fire = {"shoot1", "shoot2"},
	reload = "reload",
	//idle = "idle",
	draw = "draw"}
	
SWEP.Sounds = {draw = {{time = 0, sound = "CW_WSRAGEINGBULL_DRAW"}},

	reload = {[1] = {time = 0.2, sound = "CW_WSRAGEINGBULL_RELOAD"}}}

SWEP.SpeedDec = 10

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.NormalHoldType = "revolver"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"double"}
SWEP.Base = "cw_base"
SWEP.Category = "CW 2.0 White Snow"

SWEP.Author			= "White Snow"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= true
SWEP.ViewModel		= "models/weapons/raging/v_pist_raging.mdl"
SWEP.WorldModel		= "models/weapons/raging/w_pist_raging.mdl"
SWEP.ADSFireAnim = false
SWEP.DrawTraditionalWorldModel = false
SWEP.WM = "models/weapons/raging/w_pist_raging.mdl"
SWEP.WMPos = Vector(-1, -1, -0.2)
SWEP.WMAng = Vector(-3,1,180)
SWEP.CustomizationMenuScale = 0.005
	
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 6
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ".44 Magnum"

SWEP.FireDelay = 0.2
SWEP.FireSound = "CW_WSRAGEINGBULL_FIRE"
SWEP.Recoil = 2.6

SWEP.HipSpread = 0.029
SWEP.AimSpread = 0.01
SWEP.VelocitySensitivity = 1.2
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.02
SWEP.SpreadCooldown = 0.25
SWEP.Shots = 1
SWEP.Damage = 60
SWEP.DeployTime = 1
SWEP.Chamberable = false

SWEP.ReloadSpeed = 1
SWEP.ReloadTime = 1.6
SWEP.ReloadHalt = 2.7

SWEP.ReloadTime_Empty = 1.6
SWEP.ReloadHalt_Empty = 2.7