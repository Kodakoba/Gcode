/*==========================================================================================
	THIS FILE CONTAINS THE CODE OF EVERY ATTACHMENT THAT IS BEING SHARED BETWEEN THIS PACK!
	(It includes: Sights, Grips and Bipods)
	
	The code for Skins, Magazine Types, and specific weapon attachments are located on their
	respective Lua file.
	
	They look like this: WeaponName_attachments.lua
	(Example: auga3_attachments.lua)
==========================================================================================*/

AddCSLuaFile()

--[[=========================================
	C-More Reflex Sight
===========================================]]

local att = {}
att.name = "cmore_railway"
att.displayName = "C-More Railway Reflex Sight"
att.displayNameShort = "C-More"
att.aimPos = {"TR09_CMorePos", "TR09_CMoreAng"}
att.FOVModifier = 15
att.isSight = true
att.colorType = CustomizableWeaponry.colorableParts.COLOR_TYPE_SIGHT

att.statModifiers = {OverallMouseSensMult = -0.05}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/cmore_railway")
	att.description = {[1] = {t = "Provides a bright reticle to ease aiming.", c = CustomizableWeaponry.textColors.POSITIVE}}
	
	att.reticle = "cw2/reticles/kobra_sight"
	att._reticleSize = 3
	
	function att:drawReticle()
		if not self:isAiming() or not self:isReticleActive() then
			return
		end
		
		diff = self:getDifferenceToAimPos(self.TR09_CMorePos, self.TR09_CMoreAng, att._reticleSize)
		
		-- draw the reticle only when it's close to center of the aiming position
		if diff > 0.9 and diff < 1.1 then
			cam.IgnoreZ(true)
				render.SetMaterial(att._reticle)
				dist = math.Clamp(math.Distance(1, 1, diff, diff), 0, 0.13)
				
				local EA = self:getReticleAngles()
				
				local renderColor = self:getSightColor(att.name)
				renderColor.a = (0.13 - dist) / 0.13 * 255
				
				local pos = EyePos() + EA:Forward() * 100
				
				for i = 1, 2 do
					render.DrawSprite(pos, att._reticleSize, att._reticleSize, renderColor)
				end
			cam.IgnoreZ(false)
		end
	end
end

CustomizableWeaponry:registerAttachment(att)

--[[=========================================
	Truglo Tru-Brite Sight (HD-33)
===========================================]]

local att = {}
att.name = "hd33_sight"
att.displayName = "	Truglo Tru-Brite"
att.displayNameShort = "HD-33"
att.aimPos = {"TR09_HD33Pos", "TR09_HD33Ang"}
att.FOVModifier = 15
att.isSight = true
att.colorType = CustomizableWeaponry.colorableParts.COLOR_TYPE_SIGHT

att.statModifiers = {OverallMouseSensMult = -0.05}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/hd33")
	att.description = {[1] = {t = "Provides a bright reticle to ease aiming.", c = CustomizableWeaponry.textColors.POSITIVE}}
	
	att.reticle = "atts/reticles/circle_dot"
	att._reticleSize = 2.3
	
	function att:drawReticle()
		if not self:isAiming() or not self:isReticleActive() then
			return
		end
		
		diff = self:getDifferenceToAimPos(self.TR09_HD33Pos, self.TR09_HD33Ang, att._reticleSize)
		
		-- draw the reticle only when it's close to center of the aiming position
		if diff > 0.9 and diff < 1.1 then
			cam.IgnoreZ(true)
				render.SetMaterial(att._reticle)
				dist = math.Clamp(math.Distance(1, 1, diff, diff), 0, 0.13)
				
				local EA = self:getReticleAngles()
				
				local renderColor = self:getSightColor(att.name)
				renderColor.a = (0.13 - dist) / 0.13 * 255
				
				local pos = EyePos() + EA:Forward() * 100
				
				for i = 1, 2 do
					render.DrawSprite(pos, att._reticleSize, att._reticleSize, renderColor)
				end
			cam.IgnoreZ(false)
		end
	end
end

CustomizableWeaponry:registerAttachment(att)

--[[=========================================
	COD: MWR Red Dot Sight
===========================================]]

local att = {}
att.name = "codmwr_red_dot"
att.displayName = "Sightmark Sureshot Red Dot Sight"
att.displayNameShort = "Red Dot"
att.aimPos = {"TR09_MWRRedDotPos", "TR09_MWRRedDotAng"}
att.FOVModifier = 15
att.isSight = true
att.colorType = CustomizableWeaponry.colorableParts.COLOR_TYPE_SIGHT

att.statModifiers = {OverallMouseSensMult = -0.05}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/codmwr_red_dot")
	att.description = {[1] = {t = "Provides a bright reticle to ease aiming.", c = CustomizableWeaponry.textColors.POSITIVE}}

	att.reticle = "cw2/reticles/aim_reticule"
	att._reticleSize = 0.6

	function att:drawReticle()
		if not self:isAiming() or not self:isReticleActive() then
			return
		end

		diff = self:getDifferenceToAimPos(self.TR09_MWRRedDotPos, self.TR09_MWRRedDotAng, att._reticleSize)

		-- draw the reticle only when it's close to center of the aiming position
		if diff > 0.9 and diff < 1.1 then
			cam.IgnoreZ(true)
				render.SetMaterial(att._reticle)
				dist = math.Clamp(math.Distance(1, 1, diff, diff), 0, 0.13)

				local EA = self:getReticleAngles()

				local renderColor = self:getSightColor(att.name)
				renderColor.a = (0.13 - dist) / 0.13 * 255

				local pos = EyePos() + EA:Forward() * 100

				for i = 1, 2 do
					render.DrawSprite(pos, att._reticleSize, att._reticleSize, renderColor)
				end
			cam.IgnoreZ(false)
		end
	end
end

CustomizableWeaponry:registerAttachment(att)

--[[=========================================
	Coyote Red Dot Sight
===========================================]]

local att = {}
att.name = "coyote_reddot"
att.displayName = "Coyote Red Dot Sight"
att.displayNameShort = "Coyote"
att.aimPos = {"TR09_CoyotePos", "TR09_CoyoteAng"}
att.FOVModifier = 15
att.isSight = true
att.colorType = CustomizableWeaponry.colorableParts.COLOR_TYPE_SIGHT

att.statModifiers = {OverallMouseSensMult = -0.05}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/coyote_reddot")
	att.description = {[1] = {t = "Provides a bright reticle to ease aiming.", c = CustomizableWeaponry.textColors.POSITIVE}}
	
	att.reticle = "cw2/reticles/aim_reticule"
	att._reticleSize = 0.6
	
	function att:drawReticle()
		if not self:isAiming() or not self:isReticleActive() then
			return
		end
		
		diff = self:getDifferenceToAimPos(self.TR09_CoyotePos, self.TR09_CoyoteAng, att._reticleSize)
		
		-- draw the reticle only when it's close to center of the aiming position
		if diff > 0.9 and diff < 1.1 then
			cam.IgnoreZ(true)
				render.SetMaterial(att._reticle)
				dist = math.Clamp(math.Distance(1, 1, diff, diff), 0, 0.13)
				
				local EA = self:getReticleAngles()
				
				local renderColor = self:getSightColor(att.name)
				renderColor.a = (0.13 - dist) / 0.13 * 255
				
				local pos = EyePos() + EA:Forward() * 100
				
				for i = 1, 2 do
					render.DrawSprite(pos, att._reticleSize, att._reticleSize, renderColor)
				end
			cam.IgnoreZ(false)
		end
	end
end

CustomizableWeaponry:registerAttachment(att)

--[[=========================================
	Trijicon RX01 Reflex Sight
===========================================]]

local att = {}
att.name = "trijicon_rx01"
att.displayName = "Trijicon RX01 Reflex Sight"
att.displayNameShort = "Trijicon"
att.aimPos = {"TR09_TrijiconPos", "TR09_TrijiconAng"}
att.FOVModifier = 15
att.isSight = true
att.colorType = CustomizableWeaponry.colorableParts.COLOR_TYPE_SIGHT

att.statModifiers = {OverallMouseSensMult = -0.05}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/trijicon_rx01")
	att.description = {[1] = {t = "Provides a bright reticle to ease aiming.", c = CustomizableWeaponry.textColors.POSITIVE}}
	
	att.reticle = "cw2/reticles/aim_reticule"
	att._reticleSize = 0.5
	
	function att:drawReticle()
		if not self:isAiming() or not self:isReticleActive() then
			return
		end
		
		diff = self:getDifferenceToAimPos(self.TR09_TrijiconPos, self.TR09_TrijiconAng, att._reticleSize)
		
		-- draw the reticle only when it's close to center of the aiming position
		if diff > 0.9 and diff < 1.1 then
			cam.IgnoreZ(true)
				render.SetMaterial(att._reticle)
				dist = math.Clamp(math.Distance(1, 1, diff, diff), 0, 0.13)
				
				local EA = self:getReticleAngles()
				
				local renderColor = self:getSightColor(att.name)
				renderColor.a = (0.13 - dist) / 0.13 * 255
				
				local pos = EyePos() + EA:Forward() * 100
				
				for i = 1, 2 do
					render.DrawSprite(pos, att._reticleSize, att._reticleSize, renderColor)
				end
			cam.IgnoreZ(false)
		end
	end
end

CustomizableWeaponry:registerAttachment(att)

--[[=========================================
	Default CW 2.0 ACOG Scope (FIXED)
===========================================]]

local att = {}
att.name = "acog_fixed"
att.displayName = "Trijicon ACOG"
att.displayNameShort = "ACOG"
att.aimPos = {"ACOG_FixedPos", "ACOG_FixedAng"}
att.FOVModifier = 15
att.isSight = true

att.statModifiers = {OverallMouseSensMult = -0.1}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/acog")
	att.description = {[1] = {t = "Provides 4x magnification.", c = CustomizableWeaponry.textColors.POSITIVE},
	[2] = {t = "Narrow scope reduces awareness.", c = CustomizableWeaponry.textColors.NEGATIVE},
	[3] = {t = "Can be disorienting at close range.", c = CustomizableWeaponry.textColors.NEGATIVE},
	[4] = {t = "Double tap your 'use' key, to use the backup sights.", c = CustomizableWeaponry.textColors.REGULAR}}

	local old, x, y, ang
	local reticle = surface.GetTextureID("cw2/reticles/reticle_chevron")
	
	att.zoomTextures = {[1] = {tex = reticle, offset = {0, 1}}}
	
	local lens = surface.GetTextureID("cw2/gui/lense")
	local lensMat = Material("cw2/gui/lense")
	local cd, alpha = {}, 0.5
	local Ini = true
	
	-- render target var setup
	cd.x = 0
	cd.y = 0
	cd.w = 512
	cd.h = 512
	cd.fov = 4.5
	cd.drawviewmodel = false
	cd.drawhud = false
	cd.dopostprocess = false
	
	function att:drawRenderTarget()
		local complexTelescopics = self:canUseComplexTelescopics()
		
		-- if we don't have complex telescopics enabled, don't do anything complex, and just set the texture of the lens to a fallback 'lens' texture
		if not complexTelescopics then
			self.TSGlass:SetTexture("$basetexture", lensMat:GetTexture("$basetexture"))
			return
		end
		
		if self:canSeeThroughTelescopics(att.aimPos[1]) then
			alpha = math.Approach(alpha, 0, FrameTime() * 5)
		else
			alpha = math.Approach(alpha, 1, FrameTime() * 5)
		end
		
		x, y = ScrW(), ScrH()
		old = render.GetRenderTarget()
	
		ang = LocalPlayer():EyeAngles() + LocalPlayer():GetPunchAngle() -- Fixes reticle bug (Thanks to whoever fixed it!)
		//ang = self:getTelescopeAngles() [[ THE BROKEN CODE ]]
		
		if self.ViewModelFlip then
			ang.r = -self.BlendAng.z
		else
			ang.r = self.BlendAng.z
		end
		
		if not self.freeAimOn then
			ang:RotateAroundAxis(ang:Right(), self.ACOG_FixedAxisAlign.right)
			ang:RotateAroundAxis(ang:Up(), self.ACOG_FixedAxisAlign.up)
			ang:RotateAroundAxis(ang:Forward(), self.ACOG_FixedAxisAlign.forward)
		end
		
		local size = self:getRenderTargetSize()
		
		cd.w = size
		cd.h = size
		cd.angles = ang
		cd.origin = self.Owner:GetShootPos()
		render.SetRenderTarget(self.ScopeRT)
		render.SetViewPort(0, 0, size, size)
			if alpha < 1 or Ini then
				render.RenderView(cd)
				Ini = false
			end
			
			ang = self.Owner:EyeAngles()
			ang.p = ang.p + self.BlendAng.x
			ang.y = ang.y + self.BlendAng.y
			ang.r = ang.r + self.BlendAng.z
			ang = -ang:Forward()
			
			local light = render.ComputeLighting(self.Owner:GetShootPos(), ang)
			
			cam.Start2D()
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetTexture(reticle)
				surface.DrawTexturedRect(0, 0, size, size)
				
				surface.SetDrawColor(150 * light[1], 150 * light[2], 150 * light[3], 255 * alpha)
				surface.SetTexture(lens)
				surface.DrawTexturedRectRotated(size * 0.5, size * 0.5, size, size, 90)
			cam.End2D()
		render.SetViewPort(0, 0, x, y)
		render.SetRenderTarget(old)
		
		if self.TSGlass then
			self.TSGlass:SetTexture("$basetexture", self.ScopeRT)
		end
	end
end

function att:attachFunc()
	self.OverrideAimMouseSens = 0.25
	self.SimpleTelescopicsFOV = 70
	self.AimViewModelFOV = 50
	self.BlurOnAim = true
	self.ZoomTextures = att.zoomTextures
end

function att:detachFunc()
	self.OverrideAimMouseSens = nil
	self.SimpleTelescopicsFOV = nil
	self.AimViewModelFOV = self.AimViewModelFOV_Orig
	self.BlurOnAim = false
end

CustomizableWeaponry:registerAttachment(att)

--[[=========================================
	AFG - Angled Foregrip
===========================================]]

local att = {}
att.name = "angled_foregrip"
att.displayName = "Angled Foregrip"
att.displayNameShort = "AFG"

att.statModifiers = {VelocitySensitivityMult = -0.3,
OverallMouseSensMult = -0.1,
HipSpreadMult = -0.15,
RecoilMult = -0.1}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/angled_foregrip")
end

function att:attachFunc()
	self.ForegripOverride = true
	self.ForegripParent = "angled_foregrip"
end

function att:detachFunc()
	self.ForegripOverride = false
end

CustomizableWeaponry:registerAttachment(att)

--[[=========================================
	Grip Pod System
===========================================]]

local att = {}
att.name = "grip_pod"
att.displayName = "Grip Pod System"
att.displayNameShort = "Grip Pod"

att.statModifiers = {VelocitySensitivityMult = -0.3,
OverallMouseSensMult = -0.1,
HipSpreadMult = -0.15,
RecoilMult = -0.2}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/grip_pod")
	att.description = {[1] = {t = "WHEN DEPLOYED: Decreases recoil by 70%", c = CustomizableWeaponry.textColors.VPOSITIVE}}
end

function att:attachFunc()
	self.BipodInstalled = true
	self.BipodWasDeployed = false
	self.ForegripOverride = true
	self.ForegripParent = "grip_pod"
end

function att:detachFunc()
	self.BipodInstalled = false
	self.ForegripOverride = false
end

function att:elementRender()
	local is = self.dt.BipodDeployed	
	local was = self.BipodWasDeployed
	
	if is != was then
		if is then
			self.AttachmentModelsVM.grip_pod.ent:SetBodygroup(1,1)
		else
			self.AttachmentModelsVM.grip_pod.ent:SetBodygroup(1,0)
		end	
	end
	
	self.BipodWasDeployed = is
end

CustomizableWeaponry:registerAttachment(att)

--[[=========================================
	Deployable Bipod
===========================================]]
//Stolen from Knife Kitty's HK416 (Sorry buddy! :P)

local att = {}
att.name = "harris_bipod" //md_hk416_bipod
att.displayName = "Deployable Bipod"
att.displayNameShort = "Bipod"

att.statModifiers = {OverallMouseSensMult = -0.1,
DrawSpeedMult = -0.1}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/harris_bipod")
	att.description = {[1] = {t = "When deployed:", c = CustomizableWeaponry.textColors.REGULAR},
	[2] = {t = "Decreases recoil by 70%", c = CustomizableWeaponry.textColors.POSITIVE},
	[3] = {t = "Greatly increases hip fire accuracy", c = CustomizableWeaponry.textColors.VPOSITIVE}}
end

function att:attachFunc()
	self.BipodInstalled = true
	self.BipodWasDeployed = false
end

function att:detachFunc()
	self.BipodInstalled = false
end

function att:elementRender()
	local is = self.dt.BipodDeployed	
	local was = self.BipodWasDeployed
	
	if is != was then
		if is then
			self.AttachmentModelsVM.harris_bipod.ent:SetBodygroup(1,1)
			self:EmitSound("CW_HarrisBipod_Down")
		else
			self.AttachmentModelsVM.harris_bipod.ent:SetBodygroup(1,0)
			self:EmitSound("CW_HarrisBipod_Up")
		end	
	end
	
	self.BipodWasDeployed = is
end

CustomizableWeaponry:registerAttachment(att)

CustomizableWeaponry:addReloadSound("CW_HarrisBipod_Down", {"weapons/harris_bipod/harrisbipod_down1.wav", "weapons/harris_bipod/harrisbipod_down2.wav"})
CustomizableWeaponry:addReloadSound("CW_HarrisBipod_Up", {"weapons/harris_bipod/harrisbipod_up1.wav", "weapons/harris_bipod/harrisbipod_up2.wav"})