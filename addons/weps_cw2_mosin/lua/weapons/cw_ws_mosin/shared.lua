AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")
//SCK name: mosin
if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Mosin–Nagant"
	SWEP.CSMuzzleFlashes = true
	SWEP.ViewModelMovementScale = 1.15
	
	SWEP.IconLetter = "i"
	killicon.Add("cw_ws_mosin", "vgui/kills/cw_ws_mosin", Color(255, 80, 0, 150))
	SWEP.SelectIcon = surface.GetTextureID("vgui/kills/cw_ws_mosin")
	
	SWEP.MuzzleEffect = "muzzleflash_SR25"
	SWEP.MuzzleAttachmentName = "muzzle"
	SWEP.PosBasedMuz = true
	SWEP.SnapToGrip = true
	SWEP.ShellScale = 0.7
	SWEP.ShellOffsetMul = 2
	SWEP.ShellPosOffset = {x = 0, y = -200, z = 0}
	SWEP.ForeGripOffsetCycle_Draw = 0
	SWEP.ForeGripOffsetCycle_Reload = 0.9
	SWEP.ForeGripOffsetCycle_Reload_Empty = 0.8
	SWEP.FireMoveMod = 0.6
	
	SWEP.IronsightPos = Vector(-2.816, 0, 1.48)
	SWEP.IronsightAng = Vector(0, 0, 0)

	SWEP.CoD4ReflexPos = Vector(-2.815, 0, 0.034)
	SWEP.CoD4ReflexAng = Vector(0, 0, 0)

	SWEP.EoTech552Pos = Vector(-2.805, 0, -0.55)
	SWEP.EoTech552Ang = Vector(0, 0, 0)
	
	SWEP.EoTechPos = Vector(-2.77, 0, -0.331)
	SWEP.EoTechAng = Vector(0, 0, 0)

	SWEP.EoTech553Pos = Vector(-2.74, 0, -0.16)
	SWEP.EoTech553Ang = Vector(0, 0, 0)	
	
	SWEP.AimpointPos = Vector(-2.85, 0, -0.07)
	SWEP.AimpointAng = Vector(0, 0, 0)
	
	SWEP.CoD4TascoPos = Vector(-2.83, 0, 0.439)
	SWEP.CoD4TascoAng = Vector(0, 0, 0)
	
	SWEP.FAS2AimpointPos = Vector(-2.81, 0, -0.048)
	SWEP.FAS2AimpointAng = Vector(0, 0, 0)

	SWEP.MicroT1Pos = Vector(-2.85, 0, -0.04)
	SWEP.MicroT1Ang = Vector(0, 0, 0)
	
	SWEP.ACOGPos = Vector(-2.84, 0, -0.44)
	SWEP.ACOGAng = Vector(0, 0, 0)
	
	//SWEP.SprintPos = Vector(0, 0, 0)
	//SWEP.SprintAng = Vector(0, 0, 0)
	SWEP.SprintPos = Vector(3.029, -0.805, -2.201)
	SWEP.SprintAng = Vector(-4.926, 38.693, -18.292)

	SWEP.WS_FoldSightPos = Vector(-2.87, 0, 0.4)
	SWEP.WS_FoldSightAng = Vector(-1.981, -0.201, 0)
	
	SWEP.LeupoldPos = Vector(-2.8, 0, -0.22)
	SWEP.LeupoldAng = Vector(0, 0, 0)
	SWEP.LeupoldAxisAlign = {right = 0, up = 0, forward = 0}
	
	//Magnifer scopes
	SWEP.MagnifierPos = Vector(-2.82, 0, -0.5)
	SWEP.MagnifierAng = Vector(0, 0, 0)
	SWEP.MagnifierScopeAxisAlign = {right = 0, up = 0, forward = 0}
	
	SWEP.CoD4ReflexPos_mag3x = Vector(-2.82, 0, -0.38)
	SWEP.CoD4ReflexAng_mag3x = Vector(0, 0, 0)
	
	SWEP.EoTech552Pos_mag3x = Vector(-2.805, 0, -0.5)
	SWEP.EoTech552Ang_mag3x = Vector(0, 0, 0)
	
	SWEP.EoTech553Pos_mag3x = Vector(-2.84, 0, -0.25)
	SWEP.EoTech553Ang_mag3x = Vector(0, 0, 0)
	
	SWEP.CoD4TascoPos_mag3x = Vector(-2.83, 0, -0.10)
	SWEP.CoD4TascoAng_mag3x = Vector(0, 0, 0)
	
	SWEP.FAS2AimpointPos_mag3x = Vector(-2.84, 0, -0.37)
	SWEP.FAS2AimpointAng_mag3x = Vector(0, 0, 0)
	
	SWEP.HoloPos_mag3x = Vector(-2.8, 0, -0.43)
	SWEP.HoloAng_mag3x = Vector(0, 0, 0)
	
	
	SWEP.WS_EoTech557Pos = Vector(-2.82, 0, -0.078)
	SWEP.WS_EoTech557Ang = Vector(0, 0, 0)
	
	SWEP.WS_HOLOSIGHTPos = Vector(-3.161, 0, -0.601)
	SWEP.WS_HOLOSIGHTAng = Vector(-1.721, -0.76, 0)
	
	SWEP.WS_DocterPos = Vector(-2.805, 0, 0.479)
	SWEP.WS_DocterAng = Vector(0, 0, 0)
	
	SWEP.WS_CMOREPos = Vector(-2.83, 0, -0.24)
	SWEP.WS_CMOREAng = Vector(0, 0, 0)
	
	SWEP.HoloPos = Vector(-2.806, 0, -0.44)
	SWEP.HoloAng = Vector(0, 0, 0)

	SWEP.WS_BarskaPos = Vector(-2.825, 0, -0.22)
	SWEP.WS_BarskaAng = Vector(0, 0, 0)
	
	SWEP.WS_ELCANPos  = Vector(-2.8, 0, -0.721)
	SWEP.WS_ELCANAng = Vector(0 ,0 , 0)
	SWEP.WS_ELCANAxisAlign = {right = 0, up = 0, forward = 0} 
	
	SWEP.WS_LeupoldPos  = Vector(-2.8, 0, -0.08)
	SWEP.WS_LeupoldAng = Vector(0 ,0 , 0)
	SWEP.WS_LeupoldAxisAlign = {right = 1.45, up = 0.91, forward = 0} 
	
	SWEP.WS_ACOGPos  = Vector(-2.82, 0, -0.08)
	SWEP.WS_ACOGAng = Vector(0 ,0 , 0)
	SWEP.WS_ACOGAxisAlign = {right = 0, up = 0, forward = -135} 

	SWEP.CoD4ACOGPos = Vector(-2.82, 0, -0.071)
	SWEP.CoD4ACOGAng = Vector(0, 0, 0)
	SWEP.CoD4ACOGAxisAlign = {right = 0, up = 0, forward = 0}
	
	SWEP.ShortDotPos = Vector(-2.81, 0, 0.039)
	SWEP.ShortDotAng = Vector(0, 0, 0)
	SWEP.SchmidtShortDotAxisAlign = {right = 0, up = 0, forward = 0}

	SWEP.WS_AWPPos  = Vector(-2.8, 0, -0.201)
	SWEP.WS_AWPAng = Vector(0 ,0, 0)
	SWEP.WS_AWPAxisAlign = {right = 0.8, up = -0.53, forward = 0}
	
	SWEP.WS_AimpointSPos  = Vector(-2.8, 0, -0.201)
	SWEP.WS_AimpointSAng = Vector(0 ,-0.1 , 0)
	SWEP.WS_AimpointSAxisAlign = {right = 0.002, up = 0.002, forward = 190} //-170 //190
	
	SWEP.PSOPos = Vector(-2.721, 0, 0.079)
	SWEP.PSOAng = Vector(0, 0, 0)
	SWEP.PSO1AxisAlign = {right = 0, up = 0, forward = 0}
	
	SWEP.CustomizePos = Vector(5.519, 0, -1.601)
	SWEP.CustomizeAng = Vector(21.106, 25.326, 10.553)

	SWEP.BackupSights = {
	["md_acog"] = {[1] = Vector(-2.82, 0, -1.68), [2] = Vector(0, 0, 0)}, 
	["md_ws_acog"] = {[1] = Vector(-2.813, 0, -1.121), [2] = Vector(-0.5, 0, 0)}
	}

	SWEP.SightWithRail = true
	SWEP.ACOGAxisAlign = {right = 0, up = 0, forward = 0}
	SWEP.CoD4ACOGAxisAlign = {right = 0, up = 180, forward = 0}
	
	SWEP.AlternativePos = Vector(0.319, 1.325, -1.04)
	SWEP.AlternativeAng = Vector(0, 0, 0)

	//SWEP.DisableSprintViewSimulation = true

	SWEP.AttachmentModelsVM = {
		["md_magnifier_scope"] = { type = "Model", model = "models/c_magnifier_scope.mdl", bone = "A_Optic", rel = "", pos = Vector(-0.03, -0.65, 5), angle = Angle(90, 90, 0), size = Vector(1.5, 1.5, 1.5)},
		["larue_mount"] = { type = "Model", model = "models/c_larue_kkhx.mdl", bone = "A_Optic", rel = "", pos = Vector(-0.26, 0, 2.5), angle = Angle(90, 90, 0), size = Vector(1.2, 1.2, 1.2)},
		["md_ws_waaimpoint"] = { type = "Model", model = "models/attachments/ws_wascope_sg550.mdl", bone = "A_Optic", rel = "", pos = Vector(0.259, -4.651, -8.832), angle = Angle(-180, 0, 90), size = Vector(0.8, 0.8, 0.8), adjustment = {min = -10.2, max = -7, axis = "z", inverse = false, inverseOffsetCalc = true}},
		["md_ws_awp_scope"] = { type = "Model", model = "models/attachments/ws_scope_awp.mdl", bone = "A_Optic", rel = "", pos = Vector(-1.75, -7.301, -12.7), angle = Angle(90, 90, 0), size = Vector(1.5, 1.5, 1.5)},
		["md_pso1"] = { type = "Model", model = "models/cw2/attachments/pso.mdl", bone = "A_Optic", rel = "", pos = Vector(0, -3.25, -2.597), angle = Angle(0, 0, 90), size = Vector(0.8, 0.8, 0.8)},
		["md_schmidt_shortdot"] = { type = "Model", model = "models/cw2/attachments/schmidt.mdl", bone = "A_Optic", rel = "", pos = Vector(0.349, -5.75, -6.753), angle = Angle(90, 90, 0), size = Vector(1, 1, 1), adjustment = {min = -8.2, max = -3, axis = "z", inverse = false, inverseOffsetCalc = true}},
		["md_fas2_holo"] = { type = "Model", model = "models/v_holo_sight_kkrc.mdl", bone = "A_Optic", rel = "", pos = Vector(0, -5.6, -4), angle = Angle(90, 90, 0), size = Vector(1, 1, 1)},
		["md_fas2_holo_aim"] = { type = "Model", model = "models/v_holo_sight_orig_hx.mdl", bone = "A_Optic", rel = "", pos = Vector(0, -5.6, -4), angle = Angle(90, 90, 0), size = Vector(1, 1, 1)},	
		["md_cod4_acog_v2"] = { type = "Model", model = "models/v_cod4_acog.mdl", bone = "A_Optic", rel = "", pos = Vector(0, -3.1, -4.676), angle = Angle(-90, -90, 0), size = Vector(1, 1, 1), adjustment = {min = -6, max = -3, axis = "z", inverse = false, inverseOffsetCalc = true}},
		["md_acog"] = { type = "Model", model = "models/wystan/attachments/2cog.mdl", bone = "A_Optic", rel = "", pos = Vector(0.4, -6.301, -7.792), angle = Angle(0, 180, -90), size = Vector(1.1, 1.1, 1.1), adjustment = {min = -9, max = -6, axis = "z", inverse = false, inverseOffsetCalc = true}},
		["md_ws_acog"] = { type = "Model", model = "models/attachments/White_Snow/ws_acog.mdl", bone = "A_Optic", rel = "", pos = Vector(2.38, 2.099, -15.065), angle = Angle(0, -180, -90), size = Vector(1.2, 1.2, 1.2), adjustment = {min = -16.6, max = -13, axis = "z", inverse = false, inverseOffsetCalc = true}},
		["md_ws_leupold"] = { type = "Model", model = "models/attachments/White_Snow/ws_leupold.mdl", bone = "A_Optic", rel = "", pos = Vector(1.2, -6.2, -7.792), angle = Angle(90, 90, 0), size = Vector(1, 1, 1), adjustment = {min = -8.8, max = -4.7, axis = "z", inverse = false, inverseOffsetCalc = true}},
		["md_ws_elcan"] = { type = "Model", model = "models/attachments/ws_elcan.mdl", bone = "A_Optic", rel = "", pos = Vector(0.15, -5, -8.5), angle = Angle(90, 0, 90), size = Vector(1, 1, 1)},
		["md_fas2_aimpoint"] = { type = "Model", model = "models/c_fas2_aimpoint_rigged.mdl", bone = "A_Optic", rel = "", pos = Vector(-0.03, -0.95, 2.596), angle = Angle(90, 0, 90), size = Vector(1.399, 1.399, 1.399)},
		["md_cod4_aimpoint_v2"] = { type = "Model", model = "models/v_cod4_aimpoint.mdl", bone = "A_Optic", rel = "", pos = Vector(0, -3.401, -5.301), angle = Angle(-90, 0, 90), size = Vector(1, 1, 1)},
		["md_aimpoint"] = { type = "Model", model = "models/wystan/attachments/aimpoint.mdl", bone = "A_Optic", rel = "", pos = Vector(0.3, -6.301, -7.792), angle = Angle(-180, 0, 90), size = Vector(1.1, 1.1, 1.1), adjustment = {min = -9, max = -5, axis = "z", inverse = false, inverseOffsetCalc = true}},
		["md_fas2_eotech"] = { type = "Model", model = "models/c_fas2_eotech.mdl", bone = "A_Optic", rel = "", pos = Vector(-0.091, -0.561, 2.596), angle = Angle(90, 90, 0), size = Vector(1.2, 1.2, 1.2)},
		["md_fas2_eotech_stencil"] = { type = "Model", model = "models/c_fas2_eotech_stencil.mdl", bone = "A_Optic", rel = "", pos = Vector(-0.091, -0.561, 2.596), angle = Angle(90, 90, 0), size = Vector(1.2, 1.2, 1.2)},
		["md_cod4_eotech_v2"] = { type = "Model", model = "models/v_cod4_eotech.mdl", bone = "A_Optic", rel = "", pos = Vector(0, -4, -5.901), angle = Angle(-90, -90, 0), size = Vector(1.2, 1.2, 1.2)},
		["md_ws_eotech557"] = { type = "Model", model = "models/attachments/ws_eotech557.mdl", bone = "A_Optic", rel = "", pos = Vector(0.899, -5.5, -8.5), angle = Angle(90, 90, 0), size = Vector(1, 1, 1), adjustment = {min = -9.9, max = -6.5, axis = "z", inverse = false, inverseOffsetCalc = true}},
		["md_eotech"] = { type = "Model", model = "models/wystan/attachments/2otech557sight.mdl", bone = "A_Optic", rel = "", pos = Vector(-0.401, -12.851, -14.027), angle = Angle(90, 90, 0), size = Vector(1.2, 1.2, 1.2), adjustment = {min = -15.4, max = -12, axis = "z", inverse = false, inverseOffsetCalc = true}},
		["md_ws_barska"] = { type = "Model", model = "models/attachments/White_Snow/ws_barska.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0.159, 0), angle = Angle(0, -180, -90), size = Vector(0.25, 0.25, 0.25), adjustment = {min = -2.8, max = 2.5, axis = "z", inverse = false, inverseOffsetCalc = true}},
		["md_cod4_reflex"] = { type = "Model", model = "models/v_cod4_reflex.mdl", bone = "A_Optic", rel = "", pos = Vector(-0, -3.34, -5.5), angle = Angle(-90, 0, 90), size = Vector(1, 1, 1)},
		["md_ws_c_more"] = { type = "Model", model = "models/attachments/White_Snow/ws_c_more.mdl", bone = "A_Optic", rel = "", pos = Vector(0.1, 0.1, -0.401), angle = Angle(180, 0, 90), size = Vector(0.349, 0.349, 0.349), color = Color(255, 255, 255, 255), adjustment = {min = -1.3, max = 1.2, axis = "z", inverse = false, inverseOffsetCalc = true}},
		["md_microt1"] = { type = "Model", model = "models/cw2/attachments/microt1.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0.15, 0), angle = Angle(0, 0, 90), size = Vector(0.5, 0.5, 0.5), adjustment = {min = -2.8, max = 2.5, axis = "z", inverse = false, inverseOffsetCalc = true}},
		["md_ws_holosights"] = { type = "Model", model = "models/attachments/White_Snow/ws_holofront.mdl", bone = "A_Optic", rel = "", pos = Vector(0, -17.601, 51.429), angle = Angle(-90, 0, 90), size = Vector(2.5, 2.5, 2.5)},
		["md_ws_holosights2"] = { type = "Model", model = "models/attachments/White_Snow/ws_holorear.mdl", bone = "A_Optic", rel = "", pos = Vector(0, -14, -21.299), angle = Angle(90, 0, 90), size = Vector(2, 2, 2)},
		["md_rail"] = { type = "Model", model = "models/attachments/mosin/a_modkit_mosin.mdl", bone = "A_Modkit", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, -90, 0), size = Vector(1, 1, 1)},
		["md_ws_docter"] = { type = "Model", model = "models/attachments/White_Snow/ws_docterdick.mdl", bone = "A_Optic", rel = "", pos = Vector(-0.151, 0.2, -0.519), angle = Angle(180, 0, 90), size = Vector(1, 1, 1), adjustment = {min = -2.9, max = 2.1, axis = "z", inverse = false, inverseOffsetCalc = true}},
		["md_ws_foldsight"] = { type = "Model", model = "models/attachments/White_Snow/ws_foldrear.mdl", bone = "A_Optic", rel = "", pos = Vector(0, -3.3, 1.557), angle = Angle(-90, -90, 0), size = Vector(7, 7, 7)},
		["md_ws_foldsight2"] = { type = "Model", model = "models/attachments/white_snow/ws_ncstar_front.mdl", bone = "A_Optic", rel = "", pos = Vector(-0.101, -0.5, 0.518), angle = Angle(-180, 0, 90), size = Vector(0.699, 0.699, 0.699)},
		["md_ws_scifi_silencer"] = { type = "Model", model = "models/attachments/White_Snow/ws_scifi_silencer.mdl", bone = "A_Suppressor", rel = "", pos = Vector(-2.701, -34, -5.715), angle = Angle(0, 0, 0), size = Vector(1, 1, 1)},
		["md_ws_pistollaser"] = { type = "Model", model = "models/attachments/white_snow/ws_pistollaser.mdl", bone = "A_LaserFlashlight", rel = "", pos = Vector(-7.792, -0.801, 3.4), angle = Angle(0, 0, 180), size = Vector(1, 1, 1)},
		["md_ws_mosinbipod"] = { type = "Model", model = "models/attachments/mosin/ws_bipod_mosin.mdl", bone = "A_Bipod", rel = "", pos = Vector(0, -11, 0), angle = Angle(0, 0, -90), size = Vector(1, 1, 1)},
		["md_fas2_leupold"] = { type = "Model", model = "models/v_fas2_leupold.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 1.299, -2.451), angle = Angle(90, -90, 180), size = Vector(2, 2, 2)},
		["md_fas2_leupold_mount"] = { type = "Model", model = "models/v_fas2_leupold_mounts.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 1.2, -3), angle = Angle(90, 90, 0), size = Vector(2, 2, 2)},
		["md_saker"] = { type = "Model", model = "models/cw2/attachments/556suppressor.mdl", bone = "A_Suppressor", rel = "", pos = Vector(-0.75, 12.987, -2), angle = Angle(20, -180, 0), size = Vector(0.75, 0.75, 0.75)},
	}
	
	//Thanks to Knife Kitty
	SWEP.CompM4SBoneMod = {
		["ard"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(31.445, 0, 0) }
	}
	
	function SWEP:getMuzzlePosition()
		return self.CW_VM:GetAttachment(self.CW_VM:LookupAttachment(self.MuzzleAttachmentName))
	end

	function SWEP:RenderTargetFunc()
	/*
	local is = self:isRunning() -- smart Kitty is smart
	local was = self.wasRunning -- realy smart

	if self.Owner:GetNetworkedBool("CW_QA_Pressed")==false then

	if not was and is then 
	self:sendWeaponAnim("sprinting", 1)
	self.ViewModelMovementScale = 0
	end
	self.wasRunning = is -- dont delete anything

	if was and not is then
	self:sendWeaponAnim("sprint_end", 1)
	self.ViewModelMovementScale = 1.75
	end

	end
	*/
	
	local fagal = self.AttachmentModelsVM.md_ws_c_more.ent
	fagal:SetSkin(1)
	
		if self.ActiveAttachments.md_magnifier_scope then
				if self.ActiveAttachments.md_cod4_reflex then
					self.AttachmentModelsVM.larue_mount.active = true
				end
					if self.ActiveAttachments.md_fas2_aimpoint then
					self.AttachmentModelsVM.larue_mount.active = true
				end
				if self.ActiveAttachments.md_cod4_aimpoint_v2 then
					self.AttachmentModelsVM.larue_mount.active = true
					self.AttachmentModelsVM.md_cod4_aimpoint_v2.ent:SetBodygroup(1,1)
				end	
			else
				self.AttachmentModelsVM.larue_mount.active = false
				self.AttachmentModelsVM.md_cod4_aimpoint_v2.ent:SetBodygroup(1,0)
			end		
	
	
	end
	
	SWEP.AttachmentPosDependency = {
		["md_fas2_aimpoint"] = {
			["md_magnifier_scope"] = Vector(0, -0.65, 5.5),
		},
		["md_fas2_eotech"] = {
			["md_magnifier_scope"] = Vector(0, -0.5, 5)
		},
		["md_cod4_reflex"] = {
			["md_magnifier_scope"] = Vector(0, -2.968, -2.6),
		},
		["md_cod4_aimpoint_v2"] = {
			["md_magnifier_scope"] = Vector(0, -2.9, -3),
		},		
		["md_cod4_eotech_v2"] = {
			["md_magnifier_scope"] = Vector(0, -4, -5),
		},
		["md_fas2_holo"] = {
			["md_magnifier_scope"] = Vector(0, -5.6, -2.8),
		},
	}
	
	SWEP.CompM4SBoneMod = {}

	SWEP.LuaVMRecoilAxisMod = {vert = 0.5, hor = 1, roll = 1, forward = 0.5, pitch = 0.5}
	SWEP.LaserPosAdjust = Vector(0, 0, 0)
	SWEP.LaserAngAdjust = Angle(0, 179.5, 0) 
	
	SWEP.WS_PistolLaserPosAdjust = Vector(0, 0, 0)
	SWEP.WS_PistolLaserAngAdjust = Angle(0, 0, 0) 
end

SWEP.SightBGs		= {main = 2, carryhandle = 0, foldsight = 2, none = 1, foldfold = 3}
SWEP.ForegripBGs	= {main = 3, regular = 0, covered = 1}
SWEP.MagBGs			= {main = 4, regular = 0, round34 = 1, round100 = 2, round100_empty = 3, none = 4, regular_empty = 5, round34_empty = 6}
SWEP.StockBGs		= {main = 5, regular = 0, heavy = 1, none = 2}
SWEP.SilencerBGs	= {main = 6, off = 0, on = 1, long_off = 2, long_on = 3}
SWEP.LuaViewmodelRecoil = false

SWEP.AttachmentDependencies = {
	["md_magnifier_scope"] = {"md_cod4_reflex","md_cod4_eotech_v2","md_cod4_aimpoint_v2","md_fas2_eotech","md_fas2_aimpoint","md_fas2_holo"}
}

if CustomizableWeaponry_WS_Pack and CustomizableWeaponry_KK_HK416 then
	SWEP.Attachments = {
		[1] = {header = "Sight", offset = {-750, -300},  atts = {"md_ws_foldsight", "md_ws_docter", "md_ws_holosights", "md_microt1", "md_ws_c_more", "md_cod4_reflex", "md_ws_barska", "md_eotech", "md_ws_eotech557", "md_cod4_eotech_v2", "md_fas2_eotech", "md_aimpoint", "md_cod4_aimpoint_v2", "md_fas2_aimpoint", "md_ws_elcan", "md_ws_leupold", "md_acog", "md_ws_acog","md_cod4_acog_v2", "md_fas2_holo", "md_schmidt_shortdot", "md_pso1", "md_fas2_leupold", "md_ws_awp_scope", "md_ws_waaimpoint"}},
		[2] = {header = "Barrel", offset = {-500, 150},  atts = {"md_saker", "md_ws_scifi_silencer"}},
		[3] = {header = "Frame", offset = {-500, 550}, atts = {"md_ws_mosinbipod"}},
		[4] = {header = "Frame", offset = {-500, 1100}, atts = {"md_ws_pistollaser"}},
		[5] = {header = "Hybrid Sights", offset = {300, 1100}, atts = {"md_magnifier_scope"}},
		//["+attack2"] = {header = "Perks", offset = {1300, 100}, atts = {"pk_sleightofhand", "pk_light"}},
		["impulse 100"] = {header = "Skin", offset = {100, 550}, atts = {"skin_ws_mosinblack", "skin_ws_mosinclean"}},
		["+reload"] = {header = "Ammo", offset = {800, 150}, atts = {"am_magnum", "am_matchgrade"}}
	}
elseif CustomizableWeaponry_WS_Pack then
	SWEP.Attachments = {
		[1] = {header = "Sight", offset = {-500, -300},  atts = {"md_ws_foldsight", "md_ws_docter", "md_ws_holosights", "md_microt1", "md_ws_c_more", "md_ws_barska", "md_eotech", "md_ws_eotech557", "md_aimpoint", "md_ws_elcan", "md_ws_leupold", "md_acog", "md_ws_acog", "md_schmidt_shortdot", "md_pso1", "md_ws_awp_scope", "md_ws_waaimpoint"}},
		[2] = {header = "Barrel", offset = {-500, 150},  atts = {"md_saker", "md_ws_scifi_silencer"}},
		[3] = {header = "Frame", offset = {-500, 550}, atts = {"md_ws_mosinbipod"}},
		[4] = {header = "Frame", offset = {-500, 1100}, atts = {"md_ws_pistollaser"}},
		["impulse 100"] = {header = "Skin", offset = {100, 550}, atts = {"skin_ws_mosinblack", "skin_ws_mosinclean"}},
		["+reload"] = {header = "Ammo", offset = {800, 150}, atts = {"am_magnum", "am_matchgrade"}}
	}
elseif CustomizableWeaponry_KK_HK416 then
	SWEP.Attachments = {
		[1] = {header = "Sight", offset = {-500, -300},  atts = {"md_microt1", "md_cod4_reflex", "md_eotech", "md_cod4_eotech_v2", "md_fas2_eotech", "md_aimpoint", "md_cod4_aimpoint_v2", "md_fas2_aimpoint", "md_acog", "md_cod4_acog_v2", "md_fas2_holo", "md_schmidt_shortdot", "md_pso1", "md_fas2_leupold"}},
		[2] = {header = "Barrel", offset = {-500, 150},  atts = {"md_saker"}},
		[3] = {header = "Frame", offset = {-500, 550}, atts = {"md_ws_mosinbipod"}},
		[4] = {header = "Hybrid Sights", offset = {300, 1100}, atts = {"md_magnifier_scope"}},
		["impulse 100"] = {header = "Skin", offset = {100, 550}, atts = {"skin_ws_mosinblack", "skin_ws_mosinclean"}},
		["+reload"] = {header = "Ammo", offset = {800, 150}, atts = {"am_magnum", "am_matchgrade"}}
	}
else
	SWEP.Attachments = {
		[1] = {header = "Sight", offset = {-500, -300},  atts = {"md_microt1", "md_eotech", "md_aimpoint", "md_acog", "md_schmidt_shortdot", "md_pso1"}},
		[2] = {header = "Barrel", offset = {-500, 150},  atts = {"md_saker"}},
		[3] = {header = "Frame", offset = {-500, 550}, atts = {"md_ws_mosinbipod"}},
		["impulse 100"] = {header = "Skin", offset = {100, 550}, atts = {"skin_ws_mosinblack", "skin_ws_mosinclean"}},
		["+reload"] = {header = "Ammo", offset = {800, 150}, atts = {"am_magnum", "am_matchgrade"}}
	}
end

SWEP.Animations = {
	fire = {"base_fire_end"}, //base_fire_start
	reload_start = "reload_start",
	insert = "reload_insert",
	reload_end = "reload_end",
	idle = "reload_end", //base_idle
	//sprinting = "base_sprint",
	//sprint_end = "base_idle",
	draw = "base_draw"}
	
SWEP.Sounds = {
	
	reload_start = {[1] = {time = 0, sound = "CW_WS_MOSIN_BOLTBACK"}},
	reload_insert = {[1] = {time = 0, sound = "CW_WS_MOSIN_INSERT"}},
	reload_end = {[1] = {time = 0, sound = "CW_WS_MOSIN_BOLTFORWORD"}},

	base_fire_end = {
	[1] = {time = 0.05, sound = "CW_WS_MOSIN_BOLTBACK"},
	[2] = {time = 0.50, sound = "CW_WS_MOSIN_BOLTFORWORD"}}}
	

SWEP.SpeedDec = 35

SWEP.ADSFireAnim = true
SWEP.BipodFireAnim = true
SWEP.AimBreathingIntensity = 1
SWEP.AimBreathingEnabled = true

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"bolt"}
SWEP.Base = "cw_base"
SWEP.Category = "CW 2.0 White Snow"

SWEP.Author			= "White Snow"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/ws mosin/v_ws_mosin.mdl"
SWEP.WorldModel		= "models/weapons/ws mosin/w_ws_mosin.mdl"
SWEP.DrawTraditionalWorldModel = false
SWEP.WM = "models/weapons/ws mosin/w_ws_mosin.mdl"
SWEP.WMPos = Vector(-1, 5, 1)
SWEP.WMAng = Vector(-3,1,180)

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 5
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "7.62x54mmR"

SWEP.FireDelay = 1.45
SWEP.FireSound = "CW_WS_MOSIN_FIRE"
SWEP.FireSoundSuppressed = "CW_WS_MOSIN_SUB"
SWEP.Recoil = 2.5
SWEP.AimViewModelFOV = 50
SWEP.CustomizationMenuScale = 0.018
SWEP.ForceBackToHipAfterAimedShot = true
SWEP.GlobalDelayOnShoot = 1.1

SWEP.HipSpread = 0.03	//0.02
SWEP.AimSpread = 0.003 	//0.002
SWEP.VelocitySensitivity = 1.8
SWEP.MaxSpreadInc = 0.01
SWEP.SpreadPerShot = 0.005
SWEP.SpreadCooldown = 0.10
SWEP.Shots = 1
SWEP.Damage = 100
SWEP.DeployTime = 1

SWEP.ReloadSpeed = 1
SWEP.ReloadTime = 2
SWEP.ReloadTime_Empty = 2
SWEP.ReloadHalt = 1
SWEP.ReloadHalt_Empty = 1

SWEP.ReloadStartTime = 0.5
SWEP.InsertShellTime = 0.7
SWEP.ReloadFinishWait = 0.6
SWEP.ShotgunReload = true

SWEP.Chamberable = false