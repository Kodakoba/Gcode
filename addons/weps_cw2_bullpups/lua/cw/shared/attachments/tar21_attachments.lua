AddCSLuaFile()

--[[=========================================
	Tan Skin
===========================================]]

local att = {}
att.name = "tar21_tan"
att.displayName = "Tan Skin"
att.displayNameShort = "Tan"
att.isBG = true

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/tar21_tan")
	att.description = {[1] = {t = "Changes the weapon's body to a Tan look.", c = CustomizableWeaponry.textColors.COSMETIC}}
end

function att:attachFunc()
	if SERVER then
		return
	end

	if self.CW_VM then
		self.CW_VM:SetSkin(1)
	end
	if self.WMEnt then
		self.WMEnt:SetSkin(1)
	end
end

function att:detachFunc()
	if SERVER then
		return
	end

	if self.CW_VM then
		self.CW_VM:SetSkin(0)
	end
	if self.WMEnt then
		self.WMEnt:SetSkin(0)
	end
end

CustomizableWeaponry:registerAttachment(att)

--[[=========================================
	(Sci-Fi Skin)
===========================================]]

local att = {}
att.name = "tar21_scifi"
att.displayName = "Insert Company Name Here"
att.displayNameShort = "Sci-Fi"
att.isBG = true

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/tar21_scifi")
	att.description = {[1] = {t = "Changes the gun to a futuristic look.", c = CustomizableWeaponry.textColors.COSMETIC}}
end

function att:attachFunc()
	if SERVER then
		return
	end

	if self.CW_VM then
		self.CW_VM:SetSkin(2)
	end
	if self.WMEnt then
		self.WMEnt:SetSkin(2)
	end
end

function att:detachFunc()
	if SERVER then
		return
	end

	if self.CW_VM then
		self.CW_VM:SetSkin(0)
	end
	if self.WMEnt then
		self.WMEnt:SetSkin(0)
	end
end

CustomizableWeaponry:registerAttachment(att)

--[[=========================================
	MVG - Magpul Vertical Grip
===========================================]]

local att = {}
att.name = "tar21_mvg"
att.displayName = "Magpul Vertical Grip"
att.displayNameShort = "MVG"

att.statModifiers = {VelocitySensitivityMult = -0.3,
DrawSpeedMult = -0.1,
RecoilMult = -0.2,
OverallMouseSensMult = -0.05}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/magpul_grip")
end

function att:attachFunc()
	self.ForegripOverride = true
	self.ForegripParent = "tar21_mvg"
end

function att:detachFunc()
	self.ForegripOverride = false
end

CustomizableWeaponry:registerAttachment(att)

--[[=========================================
	PMAG Gen M3 36-Rounds
===========================================]]

local att = {}
att.name = "tar21_pmag"
att.displayName = "PMAG Gen M3"
att.displayNameShort = "PMAG"
att.isBG = true

att.statModifiers = {ReloadSpeedMult = -0.10,
OverallMouseSensMult = -0.05}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/pmag")
	att.description = {[1] = {t = "Increases the magazine's size to 36 rounds.", c = CustomizableWeaponry.textColors.POSITIVE}}
end

function att:attachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.pmag)
	self:unloadWeapon()
	self.Primary.ClipSize = 36
	self.Primary.ClipSize_Orig = 36
	if self.WMEnt then
		self.WMEnt:SetBodygroup(2,1)
	end
end

function att:detachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.regular)
	self:unloadWeapon()
	self.Primary.ClipSize = self.Primary.ClipSize_ORIG_REAL
	self.Primary.ClipSize_Orig = self.Primary.ClipSize_ORIG_REAL
	if self.WMEnt then
		self.WMEnt:SetBodygroup(2,0)
	end
end

CustomizableWeaponry:registerAttachment(att)