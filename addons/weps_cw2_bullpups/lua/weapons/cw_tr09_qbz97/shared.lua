if CustomizableWeaponry then

AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

util.PrecacheModel("models/weapons/therambotnic09/v_cw2_qbz97.mdl")
util.PrecacheModel("models/weapons/therambotnic09/w_cw2_qbz97.mdl")

local USE_OLD_WELEMENTS = true

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "QBZ-97"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1
	
	SWEP.magType = "arMag"
	
	SWEP.IconLetter = "w"
	killicon.Add("cw_tr09_qbz97", "vgui/kills/cw_tr09_qbz97_kill", Color(255, 80, 0, 150))
	SWEP.SelectIcon = surface.GetTextureID("vgui/kills/cw_tr09_qbz97_select")
	
	function SWEP:getMuzzlePosition()
		return self.CW_VM:GetAttachment(self.CW_VM:LookupAttachment(self.MuzzleAttachmentName))
	end
	
	SWEP.MuzzleAttachmentName = "muzzle"
	SWEP.MuzzleEffect = "muzzleflash_6"
	SWEP.PosBasedMuz = true
	SWEP.SnapToGrip = true
	SWEP.ShellScale = 0.7
	SWEP.ShellOffsetMul = 1
	SWEP.ShellPosOffset = {x = 0, y = -2, z = -2}
	SWEP.ForeGripOffsetCycle_Draw = 0
	SWEP.ForeGripOffsetCycle_Reload = 0.65
	SWEP.ForeGripOffsetCycle_Reload_Empty = 0.85
	SWEP.M203OffsetCycle_Reload = 0.85
	SWEP.M203OffsetCycle_Reload_Empty = 0.87
	SWEP.M203OffsetCycle_Draw = 0
	
	SWEP.CustomizePos = Vector(5.5, -1, 0.5)
	SWEP.CustomizeAng = Vector(15, 40, 10)
	
	SWEP.IronsightPos = Vector(-2.6, -3, 0.16)
	SWEP.IronsightAng = Vector(0.1, 0, 0)
		
	SWEP.MicroT1Pos = Vector(-2.605, 0, -0.52)
	SWEP.MicroT1Ang = Vector(0, 0, 0)
	
	SWEP.TR09_CMorePos = Vector(-2.61, -5, -0.66)
	SWEP.TR09_CMoreAng = Vector(0, 0, 0)
	
	SWEP.TR09_HD33Pos = Vector(-2.61, -5, -0.48)
	SWEP.TR09_HD33Ang = Vector(0, 0, 0)
	
	SWEP.TR09_MWRRedDotPos = Vector(-2.62, -5, -0.6)
	SWEP.TR09_MWRRedDotAng = Vector(0, 0, 0)
	
	SWEP.TR09_CoyotePos = Vector(-2.615, -5, -0.52)
	SWEP.TR09_CoyoteAng = Vector(0, 0, 0)
	
	SWEP.TR09_TrijiconPos = Vector(-2.61, -5, -0.53)
	SWEP.TR09_TrijiconAng = Vector(0, 0, 0)
	
	SWEP.EoTechPos = Vector(-2.61, -5, -0.59)
	SWEP.EoTechAng = Vector(0, 0, 0)
	
	SWEP.EoTech553Pos = Vector(-2.61, -5, -0.58)
	SWEP.EoTech553Ang = Vector(0, 0, 0)
	
	SWEP.HoloPos = Vector(-2.6, -4, -0.67)
	SWEP.HoloAng = Vector(0, 0, 0)
	
	SWEP.AimpointPos = Vector(-2.61, -4, -0.57)
	SWEP.AimpointAng = Vector(0, 0, 0)
	
	SWEP.CoD4TascoPos = Vector(-2.63, -4, -0.28)
	SWEP.CoD4TascoAng = Vector(0, 0, 0)
	
	SWEP.FAS2AimpointPos = Vector(-2.6, -4, -0.44)
	SWEP.FAS2AimpointAng = Vector(0, 0, 0)
	
	SWEP.ShortDotPos = Vector(-2.62, -3, -0.56)
	SWEP.ShortDotAng = Vector(0, 0, 0)
	SWEP.SchmidtShortDotAxisAlign = {right = 0, up = 0, forward = 0}
	
	SWEP.ACOGPos = Vector(-2.6, -4, -0.62)
	SWEP.ACOGAng = Vector(0, 0, 0)
	SWEP.ACOGAxisAlign = {right = 0, up = 0, forward = 0}
	
	SWEP.LeupoldPos = Vector(-2.65, -4, -0.56)
	SWEP.LeupoldAng = Vector(0, 0, 0)
	SWEP.LeupoldAxisAlign = {right = 0, up = 0, forward = 0}
	
	SWEP.SprintPos = Vector(2, 0, 0.5)
	SWEP.SprintAng = Vector(-20, 35, -15)
	
	SWEP.M203Pos = Vector(-0.8, -3, 0.8)
	SWEP.M203Ang = Vector(0, 0, 0)
	
	SWEP.AlternativePos = Vector(-0.5, 1, -0.7)
	SWEP.AlternativeAng = Vector(0, 0, 0)
	
	SWEP.BackupSights = {["md_acog"] = {[1] = Vector(-2.6, -5, -1.4), [2] = Vector(-0.05, -0.05, 0)}}
	
	SWEP.M203CameraRotation = {p = -90, y = 0, r = -90}
	SWEP.CustomizationMenuScale = 0.013
	
	SWEP.BaseArm = "L Clavicle"
	SWEP.BaseArmBoneOffset = Vector(-50, 0, 0)
	
	SWEP.BoltBone = "FAM_BOLT"
	SWEP.BoltShootOffset = Vector(0, 1.9, 0)
	SWEP.DontMoveBoltOnHipFire = true
	
	SWEP.AttachmentModelsVM = {
		["md_fas2_leupold"] = {type = "Model", model = "models/v_fas2_leupold.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(-0.04, -2.8, 4.35), angle = Angle(0, -90, 0), size = Vector(1.3, 1.3, 1.3)},
		["md_fas2_leupold_mount"] = {type = "Model", model = "models/v_fas2_leupold_mounts.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(-0.04, -2.8, 4.35), angle = Angle(0, -90, 0), size = Vector(1.3, 1.3, 1.3)},
		["trijicon_rx01"] = {type = "Model", model = "models/attachments/trijicon_rx01.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(0, -2.4, 3.52), angle = Angle(0, -90, 0), size = Vector(0.7, 0.7, 0.7)},
		["cmore_railway"] = {type = "Model", model = "models/attachments/cmore_railway.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(0, -1.6, 3.57), angle = Angle(0, -90, 0), size = Vector(0.9, 0.9, 0.9)},
		["codmwr_red_dot"] = {type = "Model", model = "models/attachments/codmwr_red_dot.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(0, -1.6, 3.41), angle = Angle(0, -90, 0), size = Vector(0.85, 0.85, 0.85)},
		["coyote_reddot"] = {type = "Model", model = "models/attachments/coyote_reddot.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(0, -2.6, 3.43), angle = Angle(0, -90, 0), size = Vector(0.95, 0.95, 0.95)},
		["hd33_sight"] = {type = "Model", model = "models/attachments/hd33.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(0, -1.5, -0.36), angle = Angle(0, -90, 0), size = Vector(0.55, 0.55, 0.55)},
		["qbz97_grippod"] = {type = "Model", model = "models/attachments/grip_pod.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(2.2, -12.5, 3.5), angle = Angle(0, 0, 0), size = Vector(1, 1, 1)},
		["qbz97_foregrip"] = {type = "Model", model = "models/wystan/attachments/foregrip1.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(-0.48, -7.7, -3), angle = Angle(0, 0, 0), size = Vector(0.9, 0.8, 0.8)},
		["harris_bipod"] = {type = "Model", model = "models/attachments/harris_bipod.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(-0.05, 6.4, -1), angle = Angle(0, -90, 0), size = Vector(0.6, 0.6, 0.6)},
		["md_aimpoint"] = {type = "Model", model = "models/wystan/attachments/aimpoint.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(-0.2, -6.9, -1.06), angle = Angle(0, 0, 0), size = Vector(0.8, 0.8, 0.8)},
		["md_cod4_aimpoint_v2"] = {type = "Model", model = "models/v_cod4_aimpoint.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(0, -5.3, 0.85), angle = Angle(0, 90, 0), size = Vector(0.8, 0.8, 0.8)},
		["md_fas2_eotech"] = {type = "Model", model = "models/c_fas2_eotech.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(0.02, 0.72, 3.05), angle = Angle(0, -90, 0), size = Vector(0.85, 0.85, 0.85)},
		["md_fas2_aimpoint"] = {type = "Model", model = "models/c_fas2_aimpoint_rigged.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(0.02, 0.65, 2.83), angle = Angle(0, -90, 0), size = Vector(0.95, 0.95, 0.95)},
		["md_fas2_holo_aim"] = {type = "Model", model = "models/v_holo_sight_orig_hx.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(0, -3.9, -0.15), angle = Angle(0, -90, 0), size = Vector(0.65, 0.65, 0.65)},
		["md_fas2_holo"] = {type = "Model", model = "models/v_holo_sight_kkrc.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(0, -3.9, -0.15), angle = Angle(0, -90, 0), size = Vector(0.65, 0.65, 0.65)},
		["md_eotech"] = {type = "Model", model = "models/wystan/attachments/2otech557sight.mdl", bone = "FAM_MAIN", rel = "", pos = Vector(0.21, -9.8, -4.95), angle = Angle(3, -90, 0), size = Vector(0.75, 0.75, 0.75)},
		["md_saker"] = {type = "Model", model = "models/cw2/attachments/556suppressor.mdl", bone = "FAM_MAIN", pos = Vector(0, -5.2, -2.33), angle = Angle(0, 0, 0), size = Vector(0.9, 0.9, 0.9)},
		["md_microt1"] = {type = "Model", model = "models/cw2/attachments/microt1.mdl", bone = "FAM_MAIN", pos = Vector(0.02, -2.3, 3.6), angle = Angle(0, 180, 0), size = Vector(0.37, 0.37, 0.37)},
		["md_acog"] = {type = "Model", model = "models/wystan/attachments/2cog.mdl", bone = "FAM_MAIN", pos = Vector(-0.25, -6.1, -0.55), angle = Angle(0, 0, 0), size = Vector(0.7, 0.7, 0.7)},
		["md_anpeq15"] = {type = "Model", model = "models/cw2/attachments/anpeq15.mdl", bone = "FAM_MAIN", pos = Vector(-0.6, 2, 0.3), angle = Angle(0, 90, -90), size = Vector(0.6, 0.6, 0.6)},
		["md_schmidt_shortdot"] = {type = "Model", model = "models/cw2/attachments/schmidt.mdl", bone = "FAM_MAIN", pos = Vector(-0.3, -6.5, -1.08), angle = Angle(0, -90, 0), size = Vector(0.8, 0.8, 0.8)},
		["md_m203"] = {type = "Model", model = "models/cw2/attachments/m203.mdl", bone = "FAM_MAIN", pos = Vector(2.12, -7.3, 2.95), angle = Angle(0, -90, 0), size = Vector(0.8, 0.9, 1), animated = true}
	}
	
	SWEP.WElements = {
		["md_fas2_leupold"] = {type = "Model", model = "models/v_fas2_leupold.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.4, 1, -8.55), angle = Angle(0, 0, -180), size = Vector(1.8, 1.8, 1.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_leupold_mount"] = {type = "Model", model = "models/v_fas2_leupold_mounts.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.4, 1, -8.55), angle = Angle(0, 0, -180), size = Vector(1.8, 1.8, 1.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["trijicon_rx01"] = {type = "Model", model = "models/attachments/trijicon_rx01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.2, 1.1, -7.3), angle = Angle(0, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["cmore_railway"] = {type = "Model", model = "models/attachments/cmore_railway.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1.03, -7.43), angle = Angle(0, 0, -180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["codmwr_red_dot"] = {type = "Model", model = "models/attachments/codmwr_red_dot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1.03, -7.2), angle = Angle(0, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["coyote_reddot"] = {type = "Model", model = "models/attachments/coyote_reddot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.05, -7.25), angle = Angle(0, 0, -180), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["hd33_sight"] = {type = "Model", model = "models/attachments/hd33.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.8, 1.05, -2.45), angle = Angle(0, 0, -180), size = Vector(0.7, 0.7, 0.7), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["qbz97_grippod"] = {type = "Model", model = "models/attachments/grip_pod.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-6, 3.45, -7.1), angle = Angle(0, -90, -180), size = Vector(1.1, 1.1, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["qbz97_foregrip"] = {type = "Model", model = "models/wystan/attachments/foregrip1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.3, 0.5, 1), angle = Angle(0, -90, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["harris_bipod"] = {type = "Model", model = "models/attachments/harris_bipod.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.5, 1, -1.5), angle = Angle(0, 0, -180), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_aimpoint"] = {type = "Model", model = "models/wystan/attachments/aimpoint.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-3.1, 0.76, -1.06), angle = Angle(0, -90, -180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_cod4_aimpoint_v2"] = {type = "Model", model = "models/v_cod4_aimpoint.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.25, 1.03, -3.3), angle = Angle(0, -180, -180), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_eotech"] = {type = "Model", model = "models/c_fas2_eotech.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.1, 1.05, -6.76), angle = Angle(0, 0, -180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_aimpoint"] = {type = "Model", model = "models/c_fas2_aimpoint_rigged.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.26, 1.08, -6.42), angle = Angle(0, 0, -180), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_holo_aim"] = {type = "Model", model = "models/v_holo_sight_orig_hx.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1, 1.05, -2.3), angle = Angle(0, 0, -180), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_fas2_holo"] = {type = "Model", model = "models/v_holo_sight_kkrc.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1, 1.05, -2.3), angle = Angle(0, 0, -180), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_eotech"] = {type = "Model", model = "models/wystan/attachments/2otech557sight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-7.8, 1.32, 5.05), angle = Angle(-3, 0, -180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_saker"] = {type = "Model", model = "models/cw2/attachments/556suppressor.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(0.6, 1.05, -6.55), angle = Angle(0, 90, 0), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_microt1"] = {type = "Model", model = "models/cw2/attachments/microt1.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(3.2, 1.03, -7.45), angle = Angle(0, 90, -180), size = Vector(0.45, 0.45, 0.45), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_acog"] = {type = "Model", model = "models/wystan/attachments/2cog.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(-2.6, 0.66, -1.06), angle = Angle(0, -90, -180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_anpeq15"] = {type = "Model", model = "models/cw2/attachments/anpeq15.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(11.2, 0.25, -3.3), angle = Angle(-180, 0, -90), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_schmidt_shortdot"] = {type = "Model", model = "models/cw2/attachments/schmidt.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(-2.65, 0.66, -1.06), angle = Angle(0, 0, -180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
		["md_m203"] = {type = "Model", model = "models/attachments/w_m203.mdl", bone = "ValveBiped.Bip01_R_Hand", pos = Vector(-1.65, 2.75, -5.2), angle = Angle(0, 0, -180), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
	}
	
	SWEP.M203HoldPos = {
		["L Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-10, -15, -5) },
		["L Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 15, 0) },
		["L Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-10, -10, -15) },
		["L Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(3, 0, -1.701), angle = Angle(0, 0, 0) },
		["L Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -10, 0) },
		["L Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -15, 0) },
		["L Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-10, -10, -10) },
		["L Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -10, 0) },
		["L Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-15, -5, -25) },
		["L Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -1.5, 0) }
	}
	
	SWEP.LaserPosAdjust = Vector(1, 0, 0.3)
	SWEP.LaserAngAdjust = Angle(0, 180, 0)
end

SWEP.MuzzleVelocity = 930 -- in meter/s

SWEP.MagBGs = {main = 2, regular = 0, round60 = 1}
SWEP.LuaViewmodelRecoil = false
SWEP.BipodFireAnim = true

function SWEP:IndividualThink()
	self.Animations.draw = "base_draw"
	
	if self.ActiveAttachments.qbz97_foregrip or self.ActiveAttachments.qbz97_grippod then
		self.Animations.draw = "foregrip_draw"
	end
	
	if self.ActiveAttachments.qbz97_foregrip or self.ActiveAttachments.qbz97_grippod then
		self.NormalHoldType = "smg"
	else
		self.NormalHoldType = "ar2"
	end
	
	if self.Animations.draw == "base_draw" or self.Animations.draw == "foregrip_draw" then
		self.DeployTime = 0.4
	end
	
	if self.dt.State == CW_AIMING then
		self.ViewModelMovementScale = 0.3
	else
		self.ViewModelMovementScale = 1
	end
end

//[[The M203 GL seems to be broken...]]
--[[
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
]]

if CustomizableWeaponry_KK_HK416 then
	SWEP.Attachments = {[1] = {header = "Sight", offset = {200, -550}, atts = {"md_microt1", "cmore_railway", "hd33_sight", "codmwr_red_dot", "coyote_reddot", "trijicon_rx01", "md_eotech", "md_fas2_eotech", "md_aimpoint", "md_cod4_aimpoint_v2", "md_fas2_aimpoint", "md_schmidt_shortdot", "md_acog", "md_fas2_leupold"}},
		[2] = {header = "Barrel", offset = {-350, -370}, atts = {"md_saker"}},
		[3] = {header = "Laser", offset = {-350, 50}, atts = {"md_anpeq15"}},
		[4] = {header = "Handguard", offset = {300, 300}, atts = {"qbz97_foregrip", "qbz97_grippod", "harris_bipod"}},
		[5] = {header = "Magazine", offset = {1000, 300}, atts = {"bg_ar1560rndmag"}},
--		["impulse 100"] = {header = "Skins", offset = {850, 300}, atts = {"qbz97_scifi"}},
		["+reload"] = {header = "Ammo", offset = {1000, -100}, atts = {"am_magnum", "am_matchgrade"}}
	}
else
	SWEP.Attachments = {[1] = {header = "Sight", offset = {500, -500}, atts = {"md_microt1", "cmore_railway", "hd33_sight", "codmwr_red_dot", "coyote_reddot", "trijicon_rx01", "md_eotech", "md_aimpoint", "md_schmidt_shortdot", "md_acog"}},
		[2] = {header = "Barrel", offset = {-300, -400}, atts = {"md_saker"}},
		[3] = {header = "Laser", offset = {-300, 50}, atts = {"md_anpeq15"}},
		[4] = {header = "Handguard", offset = {350, 300}, atts = {"qbz97_foregrip", "qbz97_grippod", "harris_bipod"}},
		[5] = {header = "Magazine", offset = {1100, 300}, atts = {"bg_ar1560rndmag"}},
--		["impulse 100"] = {header = "Skins", offset = {750, 300}, atts = {"qbz97_scifi"}},
		["+reload"] = {header = "Ammo", offset = {700, -100}, atts = {"am_magnum", "am_matchgrade"}}
	}
end

SWEP.Animations = {fire = "base_fire",
	reload = "base_reload",
	reload_empty = "base_reloadempty",
	idle = "base_idle",
	draw = "base_ready"}
	
SWEP.Sounds = {base_draw = {{time = 0, sound = "CW_QBZ97_CLOTH"}},

	base_ready = {[1] = {time = 0, sound = "CW_QBZ97_CLOTH"},
	[2] = {time = 0.55, sound = "CW_QBZ97_BOLTBACK"},
	[3] = {time = 0.8, sound = "CW_QBZ97_BOLTRELEASE"},
	[4] = {time = 1.3, sound = "CW_QBZ97_RATTLE"}},

	base_reload = {[1] = {time = 0, sound = "CW_QBZ97_CLOTH"},
	[2] = {time = 0.65, sound = "CW_QBZ97_MAGRELEASE"},
	[3] = {time = 0.8, sound = "CW_QBZ97_MAGOUT"},
	[4] = {time = 2, sound = "CW_QBZ97_MAGIN"},
	[5] = {time = 2.55, sound = "CW_QBZ97_RATTLE"}},
	
	base_reloadempty = {[1] = {time = 0, sound = "CW_QBZ97_CLOTH"},
	[2] = {time = 0.65, sound = "CW_QBZ97_MAGRELEASE"},
	[3] = {time = 0.85, sound = "CW_QBZ97_MAGOUT"},
	[4] = {time = 2.5, sound = "CW_QBZ97_MAGIN"},
	[5] = {time = 3.4, sound = "CW_QBZ97_BOLTBACK"},
	[6] = {time = 3.6, sound = "CW_QBZ97_BOLTRELEASE"},
	[7] = {time = 4, sound = "CW_QBZ97_RATTLE"}},
	
	foregrip_draw = {{time = 0, sound = "CW_QBZ97_CLOTH"}},
	
	foregrip_reload = {[1] = {time = 0, sound = "CW_QBZ97_CLOTH"},
	[2] = {time = 0.65, sound = "CW_QBZ97_MAGRELEASE"},
	[3] = {time = 0.8, sound = "CW_QBZ97_MAGOUT"},
	[4] = {time = 2, sound = "CW_QBZ97_MAGIN"},
	[5] = {time = 2.55, sound = "CW_QBZ97_RATTLE"}},
	
	foregrip_reloadempty = {[1] = {time = 0, sound = "CW_QBZ97_CLOTH"},
	[2] = {time = 0.65, sound = "CW_QBZ97_MAGRELEASE"},
	[3] = {time = 0.85, sound = "CW_QBZ97_MAGOUT"},
	[4] = {time = 2.5, sound = "CW_QBZ97_MAGIN"},
	[5] = {time = 3.4, sound = "CW_QBZ97_BOLTBACK"},
	[6] = {time = 3.6, sound = "CW_QBZ97_BOLTRELEASE"},
	[7] = {time = 4.1, sound = "CW_QBZ97_RATTLE"}}}

SWEP.SpeedDec = 30

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
SWEP.ViewModel		= "models/weapons/therambotnic09/v_cw2_qbz97.mdl"
SWEP.WorldModel		= "models/weapons/therambotnic09/w_cw2_qbz97.mdl"
SWEP.DrawTraditionalWorldModel = false
SWEP.WM = "models/weapons/therambotnic09/w_cw2_qbz97.mdl"
SWEP.WMPos = Vector(-1, -1.5, 0.5)
SWEP.WMAng = Vector(0, 0, 180)

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 150
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "5.56x45MM"

SWEP.FireDelay = 0.0923
SWEP.FireSound = "CW_QBZ97_FIRE"
SWEP.FireSoundSuppressed = "CW_QBZ97_FIRE_SUPPRESSED"
SWEP.Recoil = 0.9

SWEP.HipSpread = 0.045
SWEP.AimSpread = 0.0025
SWEP.VelocitySensitivity = 1.8
SWEP.MaxSpreadInc = 0.04
SWEP.SpreadPerShot = 0.008
SWEP.SpreadCooldown = 0.1
SWEP.Shots = 1
SWEP.Damage = 26
SWEP.DeployTime = 1.5

SWEP.ReloadSpeed = 1.1
SWEP.ReloadTime = 3.2
SWEP.ReloadTime_Empty = 4.5
SWEP.ReloadHalt = 3.2
SWEP.ReloadHalt_Empty = 4.5
SWEP.SnapToIdlePostReload = true

if USE_OLD_WELEMENTS then

if CLIENT then

	CustomizableWeaponry.callbacks:addNew("initialize", "cw_tr09_qbz97", function(wep) -- instead of copy pasting 50+ lines of func, 5 lines can do even more
		if wep and wep:GetClass() == "cw_tr09_qbz97" then
			wep:CreateModels(wep.WElements)
		end
	end)
	
	function SWEP:WElementThink()
		
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
		
		if self.ActiveAttachments.md_anpeq15 then
            self.WElements.md_anpeq15.hide = false
        else
			self.WElements.md_anpeq15.hide = true
		end
		
		if self.ActiveAttachments.qbz97_foregrip then
            self.WElements.qbz97_foregrip.hide = false
        else
			self.WElements.qbz97_foregrip.hide = true
		end
		
		if self.ActiveAttachments.qbz97_grippod then
            self.WElements.qbz97_grippod.hide = false
			if self.dt.BipodDeployed then
				self.WElements.qbz97_grippod.modelEnt:SetBodygroup(1,1)
			else
				self.WElements.qbz97_grippod.modelEnt:SetBodygroup(1,0)
			end
        else
			self.WElements.qbz97_grippod.hide = true
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
		
		if self.ActiveAttachments.md_m203 then
            self.WElements.md_m203.hide = false
        else
			self.WElements.md_m203.hide = true
		end
		
		if self.ActiveAttachments.bg_ar1560rndmag then
			if self.WMEnt then
				self.WMEnt:SetBodygroup(1,1)
			end
		else
			if self.WMEnt then
				self.WMEnt:SetBodygroup(1,0)
			end
		end

		if self.ActiveAttachments.qbz97_scifi then
			if self.WMEnt then
				self.WMEnt:SetSkin(1)
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