if CustomizableWeaponry then

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

util.PrecacheModel("models/weapons/therambotnic09/v_cw2_auga3.mdl")
util.PrecacheModel("models/weapons/therambotnic09/w_cw2_auga3.mdl")

local USE_OLD_WELEMENTS = true

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Steyr AUG A3"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1
	
	SWEP.magType = "arMag"
	
	SWEP.IconLetter = "w"
	killicon.Add("cw_tr09_auga3", "vgui/kills/cw_tr09_auga3_kill", Color(255, 80, 0, 150))
	SWEP.SelectIcon = surface.GetTextureID("vgui/kills/cw_tr09_auga3_select")
	
	SWEP.MuzzleEffect = "muzzleflash_6"
	SWEP.PosBasedMuz = true
	SWEP.SnapToGrip = true
	SWEP.ShellScale = 0.6
	SWEP.ShellOffsetMul = 1
	SWEP.ShellPosOffset = {x = 0, y = 0, z = -3}
	SWEP.ForeGripOffsetCycle_Draw = 0.5
	SWEP.ForeGripOffsetCycle_Reload = 0.85
	SWEP.ForeGripOffsetCycle_Reload_Empty = 0.85
	SWEP.M203OffsetCycle_Reload = 0.8
	SWEP.M203OffsetCycle_Reload_Empty = 0.87
	SWEP.M203OffsetCycle_Draw = 0
	
	SWEP.CustomizePos = Vector(6, -1, 0)
	SWEP.CustomizeAng = Vector(23, 40, 20)
	
	SWEP.IronsightPos = Vector(-3, -2, 0.1)
	SWEP.IronsightAng = Vector(-0.17, 0.1, 0)
	SWEP.FOVPerShot = 0.3
	
	SWEP.MicroT1Pos = Vector(-3.03, 2, 0.34)
	SWEP.MicroT1Ang = Vector(0, 0, 0)
		
	SWEP.TR09_CMorePos = Vector(-3.015, -3, 0.22)
	SWEP.TR09_CMoreAng = Vector(0, 0, 0)
	
	SWEP.TR09_HD33Pos = Vector(-3.02, -3, 0.33)
	SWEP.TR09_HD33Ang = Vector(0, 0, 0)
	
	SWEP.TR09_MWRRedDotPos = Vector(-3.01, -2, 0.275)
	SWEP.TR09_MWRRedDotAng = Vector(0, 0, 0)
	
	SWEP.TR09_CoyotePos = Vector(-3.02, -3, 0.32)
	SWEP.TR09_CoyoteAng = Vector(0, 0, 0)
	
	SWEP.TR09_TrijiconPos = Vector(-3.02, -3, 0.17)
	SWEP.TR09_TrijiconAng = Vector(0, 0, 0)
	
	SWEP.EoTechPos = Vector(-3.02, -2, 0.07)
	SWEP.EoTechAng = Vector(0, 0, 0)
		
	SWEP.EoTech553Pos = Vector(-3.02, -3, 0.05)
	SWEP.EoTech553Ang = Vector(0, 0, 0)
	
	SWEP.HoloPos = Vector(-3.01, -3, 0.16)
	SWEP.HoloAng = Vector(0, 0, 0)
	
	SWEP.AimpointPos = Vector(-3.04, -3, 0.17)
	SWEP.AimpointAng = Vector(0, 0, 0)
	
	SWEP.CoD4TascoPos = Vector(-3.03, -3, 0.595)
	SWEP.CoD4TascoAng = Vector(0, 0, 0)
	
	SWEP.FAS2AimpointPos = Vector(-3, -3, 0.37)
	SWEP.FAS2AimpointAng = Vector(0, 0, 0)
	
	SWEP.ShortDotPos = Vector(-2.985, -3, 0.33)
	SWEP.ShortDotAng = Vector(0, 0, 0)
	SWEP.SchmidtShortDotAxisAlign = {right = 0, up = 0.2, forward = 0}
	
	SWEP.ACOGPos = Vector(-3.005, -3, 0.04)
	SWEP.ACOGAng = Vector(0, 0, 0)
	SWEP.ACOGAxisAlign = {right = 0, up = 0.25, forward = 0}
	
	SWEP.LeupoldPos = Vector(-3.025, -3, 0.175)
	SWEP.LeupoldAng = Vector(0, 0, 0)
	SWEP.LeupoldAxisAlign = {right = 0, up = 0, forward = 0}
	
	SWEP.BackupReflexPos = Vector(-4.58, -5, 1.73)
	SWEP.BackupReflexAng = Vector(0, 0, -45)
	
	-- /*Knife Kitty's Magnifier Scope Aim Position Code*\ --
	SWEP.MagnifierPos = Vector(-3, -3, 0.15)
	SWEP.MagnifierAng = Vector(0, 0, 0)
	SWEP.MagnifierScopeAxisAlign = {right = 0, up = 0, forward = 0}
	
	SWEP.EoTechPos_mag3x = Vector(-3.02, -2, 0.07)
	SWEP.EoTechAng_mag3x = Vector(0, 0, 0)
	
	SWEP.EoTech553Pos_mag3x = Vector(-3.02, -3, 0.05)
	SWEP.EoTech553Ang_mag3x = Vector(0, 0, 0)
	
	SWEP.HoloPos_mag3x = Vector(-3.01, -3, 0.16)
	SWEP.HoloAng_mag3x = Vector(0, 0, 0)
	
	SWEP.AimpointPos_mag3x = Vector(-3.04, -3, 0.17)
	SWEP.AimpointAng_mag3x = Vector(0, 0, 0)
	
	SWEP.FAS2AimpointPos_mag3x = Vector(-3.01, -3, 0.35)
	SWEP.FAS2AimpointAng_mag3x = Vector(0, 0, 0)
	--[[==================================================]]--
	
	SWEP.M203Pos = Vector(-1.5, -3, 0.8)
	SWEP.M203Ang = Vector(0, 0, 0)
	
	SWEP.SprintPos = Vector(2, -1, 0)
	SWEP.SprintAng = Vector(-20, 35, -15)

	SWEP.AlternativePos = Vector(-0.5, 1, -0.5)
	SWEP.AlternativeAng = Vector(0, 0, 0)
	
	SWEP.BackupSights = {["md_acog"] = {[1] = Vector(-2.995, -4, -0.86), [2] = Vector(0, 0.2, 0)}}

	SWEP.M203CameraRotation = {p = -90, y = 0, r = -90}
	
	SWEP.BaseArm = "l_upperarm"
	SWEP.BaseArmBoneOffset = Vector(-50, 0, 0)
	SWEP.CustomizationMenuScale = 0.0105
	
	SWEP.AttachmentModelsVM = {
		["md_magnifier_scope"] = {type = "Model", model = "models/c_magnifier_scope.mdl", bone = "body", rel = "", pos = Vector(0.01, 6.5, -1), angle = Angle(0, -90, 0), size = Vector(1, 1, 1)},
		["md_backup_reflex_rail"] = {type = "Model", model = "models/c_angled_rails.mdl", bone = "body", rel = "", pos = Vector(-0.4, 8.5, -2.03), angle = Angle(180, -90, 90), size = Vector(1, 1, 1)},
		["md_backup_reflex"] = {type = "Model", model = "models/c_docter.mdl", bone = "body", rel = "", pos = Vector(-1.05, 9.25, -1.6), angle = Angle(0, -90, 45), size = Vector(0.7, 0.7, 0.7)},
		["md_fas2_leupold"] = {type = "Model", model = "models/v_fas2_leupold.mdl", bone = "body", rel = "", pos = Vector(-0.03, 0.75, 0.44), angle = Angle(0, -90, 0), size = Vector(1.4, 1.4, 1.4)},
		["md_fas2_leupold_mount"] = {type = "Model", model = "models/v_fas2_leupold_mounts.mdl", bone = "body", rel = "", pos = Vector(-0.03, 0.75, 0.44), angle = Angle(0, -90, 0), size = Vector(1.4, 1.4, 1.4)},
		["md_schmidt_shortdot"] = {type = "Model", model = "models/cw2/attachments/schmidt.mdl", bone = "body", rel = "", pos = Vector(-0.26, -2.3, -4.8), angle = Angle(0, -90, 0), size = Vector(0.75, 0.75, 0.75)},
		["md_acog"] = {type = "Model", model = "models/wystan/attachments/2cog.mdl", bone = "body", pos = Vector(-0.3, -2.6, -5.1), angle = Angle(0, 0, 0), size = Vector(0.8, 0.8, 0.8)},
		["md_aimpoint"] = {type = "Model", model = "models/wystan/attachments/aimpoint.mdl", bone = "body", rel = "", pos = Vector(-0.23, -4, -5.32), angle = Angle(0, 0, 0), size = Vector(0.85, 0.85, 0.85)},
		["md_eotech"] = {type = "Model", model = "models/wystan/attachments/2otech557sight.mdl", bone = "body", rel = "", pos = Vector(0.25, -8.2, -10.66), angle = Angle(3, -90, 0), size = Vector(0.9, 0.9, 0.9)},
		["md_foregrip"] = {type = "Model", model = "models/wystan/attachments/foregrip1.mdl", bone = "body", rel = "", pos = Vector(-0.34, -0.5, -4.98), angle = Angle(0, 0, 0), size = Vector(0.6, 0.65, 0.7)},
		["md_saker"] = {type = "Model", model = "models/cw2/attachments/556suppressor.mdl", bone = "body", pos = Vector(-0.02, 0.85, -4.08), angle = Angle(0, 0, 0), size = Vector(0.7, 0.7, 0.7)},
		["md_fas2_eotech"] = {type = "Model", model = "models/c_fas2_eotech.mdl", bone = "body", rel = "", pos = Vector(0.02, 4.5, -1), angle = Angle(0, -90, 0), size = Vector(1, 1, 1)},
		["md_fas2_aimpoint"] = {type = "Model", model = "models/c_fas2_aimpoint_rigged.mdl", bone = "body", rel = "", pos = Vector(0.02, 4.3, -1.23), angle = Angle(0, -90, 0), size = Vector(1, 1, 1)},
		["md_fas2_holo_aim"] = {type = "Model", model = "models/v_holo_sight_orig_hx.mdl", bone = "body", rel = "", pos = Vector(0, -1, -4.15), angle = Angle(0, -90, 0), size = Vector(0.65, 0.65, 0.65)},
		["md_fas2_holo"] = {type = "Model", model = "models/v_holo_sight_kkrc.mdl", bone = "body", rel = "", pos = Vector(0, -1, -4.15), angle = Angle(0, -90, 0), size = Vector(0.65, 0.65, 0.65)},
		["md_cod4_aimpoint_v2"] = {type = "Model", model = "models/v_cod4_aimpoint.mdl", bone = "body", rel = "", pos = Vector(0, -2.2, -3.2), angle = Angle(0, 90, 0), size = Vector(0.8, 0.8, 0.8)},
		["angled_foregrip"] = {type = "Model", model = "models/attachments/angled_foregrip.mdl", bone = "body", rel = "", pos = Vector(1.81, -3.7, 0.6), angle = Angle(0, 0, 0), size = Vector(0.8, 0.9, 0.8)},
		["trijicon_rx01"] = {type = "Model", model = "models/attachments/trijicon_rx01.mdl", bone = "body", rel = "", pos = Vector(-0.01, 1.1, -0.48), angle = Angle(0, -90, 0), size = Vector(0.8, 0.8, 0.8)},
		["cmore_railway"] = {type = "Model", model = "models/attachments/cmore_railway.mdl", bone = "body", rel = "", pos = Vector(0, 1.3, -0.44), angle = Angle(0, -90, 0), size = Vector(0.85, 0.85, 0.85)},
		["codmwr_red_dot"] = {type = "Model", model = "models/attachments/codmwr_red_dot.mdl", bone = "body", rel = "", pos = Vector(0, 1.4, -0.61), angle = Angle(0, -90, 0), size = Vector(0.82, 0.82, 0.82)},
		["coyote_reddot"] = {type = "Model", model = "models/attachments/coyote_reddot.mdl", bone = "body", rel = "", pos = Vector(0, 1.15, -0.59), angle = Angle(0, -90, 0), size = Vector(0.95, 0.95, 0.95)},
		["hd33_sight"] = {type = "Model", model = "models/attachments/hd33.mdl", bone = "body", rel = "", pos = Vector(0, 2.1, -4.36), angle = Angle(0, -90, 0), size = Vector(0.55, 0.55, 0.55)},
		["grip_pod"] = {type = "Model", model = "models/attachments/grip_pod.mdl", bone = "body", rel = "", pos = Vector(1.5, -4.5, 0.6), angle = Angle(0, 0, 0), size = Vector(0.7, 0.8, 0.85)},
		["md_microt1"] = {type = "Model", model = "models/cw2/attachments/microt1.mdl", bone = "body", pos = Vector(0, 1.1, -0.4), angle = Angle(0, -180, 0), size = Vector(0.35, 0.35, 0.35)},
		["md_anpeq15"] = {type = "Model", model = "models/cw2/attachments/anpeq15.mdl", bone = "body", pos = Vector(0.8, 10.45, -1.9), angle = Angle(-180, -90, -90), size = Vector(0.5, 0.5, 0.5)},
		["harris_bipod"] = {type = "Model", model = "models/attachments/harris_bipod.mdl", bone = "body", rel = "", pos = Vector(0.02, 9.2, -3.25), angle = Angle(0, -90, 0), size = Vector(0.55, 0.55, 0.55)},
		["md_m203"] = {type = "Model", model = "models/cw2/attachments/m203.mdl", bone = "body", pos = Vector(1.65, -3.6, -0.7), angle = Angle(0, -90, 0), size = Vector(0.7, 0.7, 0.7), animated = true}
	}
	
	SWEP.WElements = {
		["md_magnifier_scope"] = {type = "Model", model = "models/c_magnifier_scope.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.3, 0.85, -4.95), angle = Angle(0, 0, 180), size = Vector(1.6, 1.6, 1.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_backup_reflex_rail"] = {type = "Model", model = "models/c_angled_rails.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17, 0.250, -3.600), angle = Angle(-180, 0, -90), size = Vector(1.4, 1.4, 1.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_backup_reflex"] = {type = "Model", model = "models/c_docter.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.2, -0.72, -4.2), angle = Angle(0, 0, -135), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_leupold"] = {type = "Model", model = "models/v_fas2_leupold.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.3, 0.8, -7.2), angle = Angle(0, 0, -180), size = Vector(2.1, 2.1, 2.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_leupold_mount"] = {type = "Model", model = "models/v_fas2_leupold_mounts.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.3, 0.8, -7.2), angle = Angle(0, 0, -180), size = Vector(2.1, 2.1, 2.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_schmidt_shortdot"] = {type = "Model", model = "models/cw2/attachments/schmidt.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.6, 0.42, 0.53), angle = Angle(0, 0, -180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_acog"] = {type = "Model", model = "models/wystan/attachments/2cog.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(-2.23, 0.42, 0.53), angle = Angle(0, -90, -180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_aimpoint"] = {type = "Model", model = "models/wystan/attachments/aimpoint.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-3.2, 0.5, 1.07), angle = Angle(0, -90, -180), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_eotech"] = {type = "Model", model = "models/wystan/attachments/2otech557sight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-9.7, 1.2, 8.9), angle = Angle(-3, 0, -180), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_foregrip"] = {type = "Model", model = "models/wystan/attachments/foregrip1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(24.7, 1.1, -0.4), angle = Angle(0, 90, 180), size = Vector(0.7, 0.7, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_saker"] = {type = "Model", model = "models/cw2/attachments/556suppressor.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(2.8, 0.75, -6.55), angle = Angle(0, 90, 0), size = Vector(0.95, 0.95, 0.95), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_eotech"] = {type = "Model", model = "models/c_fas2_eotech.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.8, 0.82, -5.03), angle = Angle(0, 0, -180), size = Vector(1.5, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_aimpoint"] = {type = "Model", model = "models/c_fas2_aimpoint_rigged.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.9, 0.82, -4.7), angle = Angle(0, 0, -180), size = Vector(1.5, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_holo_aim"] = {type = "Model", model = "models/v_holo_sight_orig_hx.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.9, 0.82, -0.73), angle = Angle(0, 0, -180), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_holo"] = {type = "Model", model = "models/v_holo_sight_kkrc.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.9, 0.82, -0.73), angle = Angle(0, 0, -180), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["angled_foregrip"] = {type = "Model", model = "models/attachments/angled_foregrip.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-3.4, 3.25, -7.2), angle = Angle(0, -90, 180), size = Vector(1.1, 1.2, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["trijicon_rx01"] = {type = "Model", model = "models/attachments/trijicon_rx01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.9, 0.78, -5.8), angle = Angle(0, 0, -180), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["cmore_railway"] = {type = "Model", model = "models/attachments/cmore_railway.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.9, 0.82, -5.85), angle = Angle(180, -180, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["codmwr_red_dot"] = {type = "Model", model = "models/attachments/codmwr_red_dot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.6, 0.8, -5.6), angle = Angle(0, 0, -180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["coyote_reddot"] = {type = "Model", model = "models/attachments/coyote_reddot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.9, 0.8, -5.65), angle = Angle(0, 0, -180), size = Vector(1.4, 1.4, 1.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["hd33_sight"] = {type = "Model", model = "models/attachments/hd33.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.7, 0.8, -0.16), angle = Angle(180, -180, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["grip_pod"] = {type = "Model", model = "models/attachments/grip_pod.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.46, 2.5, -6.35), angle = Angle(0, -90, 180), size = Vector(0.8, 0.8, 0.95), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_cod4_aimpoint_v2"] = {type = "Model", model = "models/v_cod4_aimpoint.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.6, 0.82, -2.05), angle = Angle(0, -180, -180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_microt1"] = {type = "Model", model = "models/cw2/attachments/microt1.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(3.3, 0.82, -5.92), angle = Angle(180, -90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_anpeq15"] = {type = "Model", model = "models/cw2/attachments/anpeq15.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(17, 1.8, -3.9), angle = Angle(180, 0, 90), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["harris_bipod"] = {type = "Model", model = "models/attachments/harris_bipod.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17, 0.8, -2), angle = Angle(0, 0, -180), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_m203"] = {type = "Model", model = "models/attachments/w_m203.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(-1.65, 2.75, -5.2), angle = Angle(0, 0, -180), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
	}

	SWEP.M203HoldPos = {
		["l_ring_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-40, 7, -15) },
		["l_middle_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-50, 20, -20) },
		["l_upperarm"] = { scale = Vector(1, 1, 1), pos = Vector(3.2, 0.899, -0.25), angle = Angle(0, 0, 0) },
		["l_ring_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5, -5, 0) },
		["l_index_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-10, -10, 0) },
		["l_thumb_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(25, -7, 0) },
		["l_wrist"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(15, 0, -60) },
		["l_index_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-7, 0, 0) },
		["l_ring_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-65, 0, 0) },
		["l_thumb_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -20, 0) },
		["l_middle_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-35, 0, 0) },
		["l_middle_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5, -10, 0) },
		["l_pinky_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-45, 0, 0) },
		["l_pinky_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-15, 0, 0) },
		["l_armtwist_1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -50) },
		["l_pinky_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-20, 0, 0) },
		["l_index_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-60, 10, -10) }
	}

	SWEP.ForeGripHoldPos = {
		["l_ring_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -10) },
		["l_middle_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -15) },
		["l_upperarm"] = { scale = Vector(1, 1, 1), pos = Vector(1.5, -0.08, -1.701), angle = Angle(0, 0, 0) },
		["l_ring_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(20, 0, -5) },
		["l_middle_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(50, 0, 0) },
		["l_thumb_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(35, 20, 0) },
		["l_wrist"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5, -15, 45) },
		["l_pinky_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(55, 0, 0) },
		["l_thumb_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 85, 0) },
		["l_index_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5, 0, 0) },
		["l_ring_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(60, 0, 0) },
		["l_thumb_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-35, 30, 0) },
		["l_index_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(30, 0, 0) },
		["l_middle_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(25, 0, 0) },
		["l_pinky_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 5, -7) },
		["l_index_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(25, -5, -15) },
		["l_pinky_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10, 0, -10) },
		["l_forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-10, 10, -15) },
		["l_armtwist_1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 40) }
	}
	
	SWEP.ForegripOverridePos = {
		["angled_foregrip"] = {
			["l_ring_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-45, -3, -15) },
			["l_middle_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-60, 5, -20) },
			["l_upperarm"] = { scale = Vector(1, 1, 1), pos = Vector(4.3, 0.5, 0.449), angle = Angle(3.2, 0, 0) },
			["l_ring_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5, -5, 0) },
			["l_middle_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-35, 0, 0) },
			["l_index_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-10, -10, -30) },
			["l_thumb_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5, -3, 0) },
			["l_wrist"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(20, -7, -35) },
			["l_armtwist_1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -35) },
			["l_ring_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-65, 0, 0) },
			["l_pinky_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-45, 0, 0) },
			["l_index_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10, 0, 0) },
			["l_pinky_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-10, -15, 0) },
			["l_middle_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5, -10, 0) },
			["l_index_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-70, 10, -10) },
			["l_pinky_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-20, 0, 0) },
			["l_thumb_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -20, 0) }},
			
		["grip_pod"] = {
			["l_ring_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -10) },
			["l_middle_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -15) },
			["l_upperarm"] = { scale = Vector(1, 1, 1), pos = Vector(1.5, -0.08, -1.701), angle = Angle(0, 0, 0) },
			["l_ring_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(20, 0, -5) },
			["l_middle_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(50, 0, 0) },
			["l_thumb_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(35, 20, 0) },
			["l_wrist"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5, -15, 45) },
			["l_pinky_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(55, 0, 0) },
			["l_thumb_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 85, 0) },
			["l_index_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-5, 0, 0) },
			["l_ring_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(60, 0, 0) },
			["l_thumb_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-35, 30, 0) },
			["l_index_tip"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(30, 0, 0) },
			["l_middle_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(25, 0, 0) },
			["l_pinky_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 5, -7) },
			["l_index_low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(25, -5, -15) },
			["l_pinky_mid"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10, 0, -10) },
			["l_forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-10, 10, -15) },
			["l_armtwist_1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 40) }
		}
	}
	
	SWEP.LaserPosAdjust = Vector(0, 0, 0)
	SWEP.LaserAngAdjust = Angle(0, 180, 0) 
end

SWEP.MuzzleVelocity = 970 -- in meter/s

//lua_run Entity(1):GetViewModel():SetBodygroup(BG, Subcategory)

SWEP.SightBGs = {main = 2, regular = 0, none = 1}
SWEP.MagBGs = {main = 3, regular = 0, extmag = 1}
SWEP.BarrelBGs = {main = 4, regular = 0, long = 1}
SWEP.SilencerBGs = {main = 5, none = 0, sil = 1, long_sil = 2}
SWEP.LuaViewmodelRecoil = true
SWEP.BipodFireAnim = true

function SWEP:IndividualThink()
	self.Animations.draw = "draw"

	if self.Animations.draw == "draw" then
		self.DeployTime = 0.5
		self.ForeGripOffsetCycle_Draw = 0
	end

	if self.dt.State == CW_AIMING then
		self.ViewModelMovementScale = 0.3
	else
		self.ViewModelMovementScale = 1
	end
	
	if self.ActiveAttachments.md_foregrip or self.ActiveAttachments.grip_pod then
		self.NormalHoldType = "smg"
	else
		self.NormalHoldType = "ar2"
	end
	
	if self.ActiveAttachments.auga3_silencer then
		if self.ActiveAttachments.auga3_longbarrel then
			self:setBodygroup(self.SilencerBGs.main, self.SilencerBGs.long_sil)
		else
			self:setBodygroup(self.SilencerBGs.main, self.SilencerBGs.sil)
		end
	end
end

function SWEP:fireAnimFunc()
	local cyc = 0
	local clip = self:Clip1()
		
	if self:isAiming() or self.ActiveAttachments.md_m203 then
		cyc = 1
	end
		
	if clip > 1 then
		self:sendWeaponAnim("fire",1,cyc)
	end
end

SWEP.AttachmentDependencies = {
	["md_magnifier_scope"] = {"md_eotech", "md_fas2_eotech", "md_fas2_holo", "md_aimpoint", "md_fas2_aimpoint"}
}

SWEP.AttachmentPosDependency = {
	["md_saker"] = {["auga3_longbarrel"] = Vector(-0.02, 4.3, -4.08)},
	["md_eotech"] = {["md_magnifier_scope"] = Vector(0.25, -6.1, -10.66)},
	["md_fas2_eotech"] = {["md_magnifier_scope"] = Vector(0.02, 6.8, -1)},
	["md_fas2_holo"] = {["md_magnifier_scope"] = Vector(0, 1.6, -4.15)},
	["md_aimpoint"] = {["md_magnifier_scope"] = Vector(-0.23, -1.1, -5.32)},
	["md_fas2_aimpoint"] = {["md_magnifier_scope"] = Vector(0.02, 6.7, -1.2)},
}

SWEP.AttachmentExclusions = {
	["md_backup_reflex"] = {"md_microt1", "md_fas2_holo", "md_acog"}
}

if CustomizableWeaponry_KK_HK416 then
	SWEP.Attachments = {[1] = {header = "Sight", offset = {500, -400}, atts = {"md_microt1", "cmore_railway", "hd33_sight", "codmwr_red_dot", "coyote_reddot", "trijicon_rx01", "md_eotech", "md_fas2_eotech", "md_aimpoint", "md_cod4_aimpoint_v2", "md_fas2_aimpoint", "md_schmidt_shortdot", "md_acog", "md_fas2_leupold"}},
		[2] = {header = "Suppressor", offset = {-550, -400}, atts = {"md_saker", "auga3_silencer"}},
		[3] = {header = "Laser", offset = {-550, 20}, atts = {"md_anpeq15"}},
		[4] = {header = "Handguard", offset = {-550, 450}, atts = {"md_foregrip", "grip_pod", "angled_foregrip", "md_m203", "harris_bipod"}},
		[5] = {header = "Hybrid Sights", offset = {300, 100}, atts = {"md_backup_reflex", "md_magnifier_scope"}},
		[6] = {header = "Barrel", offset = {-100, -400}, atts = {"auga3_longbarrel"}},
		[7] = {header = "Magazine", offset = {1200, 600}, atts = {"auga3_extmag"}},
		[8] = {header = "Reloading Method", offset = {1800, 100}, atts = {"auga3_clatch"}},
		["impulse 100"] = {header = "Skins", offset = {450, 600}, atts = {"auga3_white", "auga3_tan", "auga3_green"}},
		["+reload"] = {header = "Ammo", offset = {1200, 100}, atts = {"am_magnum", "am_matchgrade"}}
	}
else
	SWEP.Attachments = {[1] = {header = "Sight", offset = {650, -400}, atts = {"md_microt1", "cmore_railway", "hd33_sight", "codmwr_red_dot", "coyote_reddot", "trijicon_rx01", "md_eotech", "md_aimpoint", "md_schmidt_shortdot", "md_acog"}},
		[2] = {header = "Suppressor", offset = {-450, -400}, atts = {"md_saker", "auga3_silencer"}},
		[3] = {header = "Laser", offset = {-450, 20}, atts = {"md_anpeq15"}},
		[4] = {header = "Handguard", offset = {-450, 450}, atts = {"md_foregrip", "grip_pod", "angled_foregrip", "md_m203", "harris_bipod"}},
		[5] = {header = "Barrel", offset = {50, -400}, atts = {"auga3_longbarrel"}},
		[6] = {header = "Magazine", offset = {1200, 600}, atts = {"auga3_extmag"}},
		[7] = {header = "Reloading Method", offset = {1200, 100}, atts = {"auga3_clatch"}},
		["impulse 100"] = {header = "Skins", offset = {450, 600}, atts = {"auga3_white", "auga3_tan", "auga3_green"}},
		["+reload"] = {header = "Ammo", offset = {650, 100}, atts = {"am_magnum", "am_matchgrade"}}
	}
end
	
SWEP.Animations = {fire = {"shoot1", "shoot2", "shoot3"},
	reload = "reload",
	reload_empty = "reload_empty",
	idle = "idle",
	draw = "first_draw"}
	
SWEP.Sounds = {first_draw = {[1] = {time = 0, sound = "CW_AUGA3_DEPLOY"},
	[2] = {time = 0.4, sound = "CW_AUGA3_BOLTPULL"},
	[3] = {time = 0.55, sound = "CW_AUGA3_BOLTRELEASE"}},
	
	draw = {{time = 0, sound = "CW_AUGA3_CLOTH"}},

	reload = {[1] = {time = 0.5, sound = "CW_AUGA3_MAGRELEASE"},
	[2] = {time = 1.07, sound = "CW_AUGA3_MAGOUT"},
	[3] = {time = 1.6, sound = "CW_AUGA3_MAGDROP"},
	[4] = {time = 2.3, sound = "CW_AUGA3_MAGIN"},
	[5] = {time = 2.8, sound = "CW_AUGA3_MAGHIT"},
	[6] = {time = 3.2, sound = "CW_AUGA3_CLOTH"}},
	
	reload_boltclatch = {[1] = {time = 0.5, sound = "CW_AUGA3_MAGRELEASE"},
	[2] = {time = 1.07, sound = "CW_AUGA3_MAGOUT"},
	[3] = {time = 1.6, sound = "CW_AUGA3_MAGDROP"},
	[4] = {time = 2.3, sound = "CW_AUGA3_MAGIN"},
	[5] = {time = 2.8, sound = "CW_AUGA3_MAGHIT"},
	[6] = {time = 3.6, sound = "CW_AUGA3_BOLTRELEASE"}},
	
	reload_empty = {[1] = {time = 0.5, sound = "CW_AUGA3_MAGRELEASE"},
	[2] = {time = 1.07, sound = "CW_AUGA3_MAGOUT"},
	[3] = {time = 1.6, sound = "CW_AUGA3_MAGDROP"},
	[4] = {time = 2.3, sound = "CW_AUGA3_MAGIN"},
	[5] = {time = 2.8, sound = "CW_AUGA3_MAGHIT"},
	[6] = {time = 3.4, sound = "CW_AUGA3_BOLTPULL"},
	[7] = {time = 3.7, sound = "CW_AUGA3_BOLTRELEASE"}}}

SWEP.SpeedDec = 30
SWEP.MoveType = 0

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "3burst", "semi"}
SWEP.Base = "cw_base"
SWEP.Category = "CW 2.0 - TheRambotnic09"

SWEP.Author			= "TheRambotnic09"
SWEP.Contact		= "Via Steam: http://steamcommunity.com/id/therambotniczeronove/"
SWEP.Purpose		= "To kill bad guys. Duh!"
SWEP.Instructions	= "Press your primary PEW-PEW key to kill the bad guys."

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/therambotnic09/v_cw2_auga3.mdl"
SWEP.WorldModel		= "models/weapons/therambotnic09/w_cw2_auga3.mdl"
SWEP.DrawTraditionalWorldModel = false
SWEP.WM = "models/weapons/therambotnic09/w_cw2_auga3.mdl"
SWEP.WMPos = Vector(-0.5, -5, -1)
SWEP.WMAng = Vector(0, 0, 180)

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 150
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.56x45MM"

SWEP.FireDelay = 0.08
SWEP.FireSound = "CW_AUGA3_FIRE"
SWEP.FireSoundSuppressed = "CW_AUGA3_FIRE_SUPPRESSED"
SWEP.Recoil = 0.9

SWEP.HipSpread = 0.045
SWEP.AimSpread = 0.0025
SWEP.VelocitySensitivity = 1.8
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.1
SWEP.Shots = 1
SWEP.Damage = 28
SWEP.DeployTime = 1.1

SWEP.ReloadSpeed = 1
SWEP.ReloadTime = 3.8
SWEP.ReloadHalt = 3.8
SWEP.ReloadTime_Empty = 4.7
SWEP.ReloadHalt_Empty = 4.7
SWEP.SnapToIdlePostReload = true

if USE_OLD_WELEMENTS then

if CLIENT then

	CustomizableWeaponry.callbacks:addNew("initialize", "cw_tr09_auga3", function(wep) -- instead of copy pasting 50+ lines of func, 5 lines can do even more
		if wep and wep:GetClass() == "cw_tr09_auga3" then
			wep:CreateModels(wep.WElements)
		end
	end)
	
	function SWEP:WElementThink()
		
		if (self.ActiveAttachments.md_microt1 or self.ActiveAttachments.cmore_railway or self.ActiveAttachments.hd33_sight or self.ActiveAttachments.codmwr_red_dot
		or self.ActiveAttachments.coyote_reddot or self.ActiveAttachments.trijicon_rx01 or self.ActiveAttachments.md_eotech or self.ActiveAttachments.md_fas2_eotech
		or self.ActiveAttachments.md_fas2_holo or self.ActiveAttachments.md_aimpoint or self.ActiveAttachments.md_cod4_aimpoint_v2 or self.ActiveAttachments.md_fas2_aimpoint
		or self.ActiveAttachments.md_schmidt_shortdot or self.ActiveAttachments.md_acog or self.ActiveAttachments.md_fas2_leupold) then
			if self.WMEnt then
				self.WMEnt:SetBodygroup(1,1)
			end
		else
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
		
		if self.ActiveAttachments.md_cod4_aimpoint_v2 then
            self.WElements.md_cod4_aimpoint_v2.hide = false
        else
			self.WElements.md_cod4_aimpoint_v2.hide = true
		end
		
		if self.ActiveAttachments.md_fas2_aimpoint then
            self.WElements.md_fas2_aimpoint.hide = false
        else
			self.WElements.md_fas2_aimpoint.hide = true
		end
		
		if self.ActiveAttachments.md_schmidt_shortdot then
            self.WElements.md_schmidt_shortdot.hide = false
        else
			self.WElements.md_schmidt_shortdot.hide = true
		end
		
		if self.ActiveAttachments.md_acog then
            self.WElements.md_acog.hide = false
        else
			self.WElements.md_acog.hide = true
		end
		
		if self.ActiveAttachments.md_fas2_leupold then
            self.WElements.md_fas2_leupold.hide = false
			self.WElements.md_fas2_leupold_mount.hide = false
        else
			self.WElements.md_fas2_leupold.hide = true
			self.WElements.md_fas2_leupold_mount.hide = true
		end
		
		if self.ActiveAttachments.md_saker then
            self.WElements.md_saker.hide = false
        else
			self.WElements.md_saker.hide = true
		end
		
		if self.ActiveAttachments.md_backup_reflex then
            self.WElements.md_backup_reflex.hide = false
			self.WElements.md_backup_reflex_rail.hide = false
        else
			self.WElements.md_backup_reflex.hide = true
			self.WElements.md_backup_reflex_rail.hide = true
		end
		
		local att_magnifier = {}
		att_magnifier.aimPos = {"MagnifierPos", "MagnifierAng"}
		local isScopePos = (self.AimPos == self[att_magnifier.aimPos[1]] and self.AimAng == self[att_magnifier.aimPos[2]])
		if self.ActiveAttachments.md_magnifier_scope then
			if isScopePos then
				self.WElements.md_magnifier_scope.modelEnt:ManipulateBoneAngles(self.WElements.md_magnifier_scope.modelEnt:LookupBone("scope"), Angle(0, 0, 0))
				self.WElements.md_magnifier_scope.modelEnt:ManipulateBoneAngles(self.WElements.md_magnifier_scope.modelEnt:LookupBone("lock"), Angle(0, 0, 0))
			elseif !isScopePos then
				self.WElements.md_magnifier_scope.modelEnt:ManipulateBoneAngles(self.WElements.md_magnifier_scope.modelEnt:LookupBone("scope"), Angle(self.MagnifierFoldAngle or -95, 0, 0))
				self.WElements.md_magnifier_scope.modelEnt:ManipulateBoneAngles(self.WElements.md_magnifier_scope.modelEnt:LookupBone("lock"), Angle(-33.2, 0, 0))
			end
            self.WElements.md_magnifier_scope.hide = false
        else
			self.WElements.md_magnifier_scope.hide = true
		end
		
		if self.ActiveAttachments.md_magnifier_scope then
			if self.ActiveAttachments.md_eotech then
				self.WElements.md_eotech.hide = false
				self.WElements.md_eotech.pos = Vector(-6.6, 1.2, 8.9)
			end
			if self.ActiveAttachments.md_fas2_eotech then
				self.WElements.md_fas2_eotech.hide = false
				self.WElements.md_fas2_eotech.pos = Vector(12.2, 0.82, -5.03)
			end
			if self.ActiveAttachments.md_fas2_holo then
				self.WElements.md_fas2_holo.hide = false
				self.WElements.md_fas2_holo.pos = Vector(4.2, 0.82, -0.73)
				self.WElements.md_fas2_holo_aim.pos = Vector(4.2, 0.82, -0.73)
			end
			if self.ActiveAttachments.md_aimpoint then
				self.WElements.md_aimpoint.hide = false
				self.WElements.md_aimpoint.pos = Vector(0.6, 0.5, 1.07)
			end
			if self.ActiveAttachments.md_fas2_aimpoint then
				self.WElements.md_fas2_aimpoint.hide = false
				self.WElements.md_fas2_aimpoint.pos = Vector(12, 0.82, -4.7)
			end
			
        else
		
			if self.ActiveAttachments.md_eotech then
				self.WElements.md_eotech.hide = false
				self.WElements.md_eotech.pos = Vector(-9.7, 1.2, 8.9)
			end
			if self.ActiveAttachments.md_fas2_eotech then
				self.WElements.md_fas2_eotech.hide = false
				self.WElements.md_fas2_eotech.pos = Vector(8.8, 0.82, -5.03)
			end
			if self.ActiveAttachments.md_fas2_holo then
				self.WElements.md_fas2_holo.hide = false
				self.WElements.md_fas2_holo.pos = Vector(0.9, 0.82, -0.73)
				self.WElements.md_fas2_holo_aim.pos = Vector(0.9, 0.82, -0.73)
			end
			if self.ActiveAttachments.md_aimpoint then
				self.WElements.md_aimpoint.hide = false
				self.WElements.md_aimpoint.pos = Vector(-3.2, 0.5, 1.07)
			end
			if self.ActiveAttachments.md_fas2_aimpoint then
				self.WElements.md_fas2_aimpoint.hide = false
				self.WElements.md_fas2_aimpoint.pos = Vector(8.9, 0.82, -4.7)
			end
		end
		
		if self.ActiveAttachments.auga3_silencer then
			if self.WMEnt then
				self.WMEnt:SetBodygroup(4,1)
			end
        else
			if self.WMEnt then
				self.WMEnt:SetBodygroup(4,0)
			end
		end
		
		if self.ActiveAttachments.auga3_longbarrel then
			if self.ActiveAttachments.auga3_silencer then
				if self.WMEnt then
					self.WMEnt:SetBodygroup(4,2)
				end
			end
			if self.ActiveAttachments.md_saker then
				self.WElements.md_saker.hide = false
				self.WElements.md_saker.pos = Vector(7.5, 0.75, -6.55)
			end
        else
			if self.ActiveAttachments.auga3_silencer then
				if self.WMEnt then
					self.WMEnt:SetBodygroup(4,1)
				end
			end
			if self.ActiveAttachments.md_saker then
				self.WElements.md_saker.hide = false
				self.WElements.md_saker.pos = Vector(2.8, 0.75, -6.55)
			end
		end
		
		if self.ActiveAttachments.md_anpeq15 then
            self.WElements.md_anpeq15.hide = false
        else
			self.WElements.md_anpeq15.hide = true
		end
		
		if self.ActiveAttachments.md_foregrip then
            self.WElements.md_foregrip.hide = false
        else
			self.WElements.md_foregrip.hide = true
		end
		
		if self.ActiveAttachments.grip_pod then
            self.WElements.grip_pod.hide = false
			if self.dt.BipodDeployed then
				self.WElements.grip_pod.modelEnt:SetBodygroup(1,1)
			else
				self.WElements.grip_pod.modelEnt:SetBodygroup(1,0)
			end
        else
			self.WElements.grip_pod.hide = true
		end
		
		if self.ActiveAttachments.angled_foregrip then
            self.WElements.angled_foregrip.hide = false
        else
			self.WElements.angled_foregrip.hide = true
		end
		
		if self.ActiveAttachments.md_m203 then
            self.WElements.md_m203.hide = false
        else
			self.WElements.md_m203.hide = true
		end
		
		if self.ActiveAttachments.harris_bipod then
            self.WElements.harris_bipod.hide = false
			if self.dt.BipodDeployed then
				self.WElements.harris_bipod.modelEnt:SetBodygroup(1,1)
			else
				self.WElements.harris_bipod.modelEnt:SetBodygroup(1,0)
			end
        else
			self.WElements.harris_bipod.hide = true
		end
		
		if self.ActiveAttachments.auga3_extmag then
			if self.WMEnt then
				self.WMEnt:SetBodygroup(2,1)
			end
        else
			if self.WMEnt then
				self.WMEnt:SetBodygroup(2,0)
			end
		end
		
		if self.ActiveAttachments.auga3_longbarrel then
			if self.WMEnt then
				self.WMEnt:SetBodygroup(3,1)
			end
        else
			if self.WMEnt then
				self.WMEnt:SetBodygroup(3,0)
			end
		end

		if self.ActiveAttachments.auga3_white then
			if self.WMEnt then
				self.WMEnt:SetSkin(1)
			end
		elseif self.ActiveAttachments.auga3_tan then
			if self.WMEnt then
				self.WMEnt:SetSkin(2)
			end
		elseif self.ActiveAttachments.auga3_green then
			if self.WMEnt then
				self.WMEnt:SetSkin(3)
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