AddCSLuaFile()

--[[=========================================
	Black Skin
===========================================]]

local att = {}
att.name = "qbz97_black"
att.displayName = "Recent Black"
att.displayNameShort = "Black"
att.isBG = true
 
if CLIENT then
    att.displayIcon = surface.GetTextureID("atts/qbz97_black")
    att.description = {[1] = {t = "A clean, semi-recent black look for your gun.", c = CustomizableWeaponry.textColors.COSMETIC}}
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
	Futuristic.O! (Sci-Fi Skin)
===========================================]]

local att = {}
att.name = "qbz97_scifi"
att.displayName = "Futuristic.O!"
att.displayNameShort = "Sci-Fi"
att.isBG = true
 
if CLIENT then
    att.displayIcon = surface.GetTextureID("atts/qbz97_scifi")
    att.description = {[1] = {t = "Changes your gun to a Futuristic look.", c = CustomizableWeaponry.textColors.COSMETIC}}
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
	Foregrip
===========================================]]

local att = {}
att.name = "qbz97_foregrip"
att.displayName = "Foregrip"
att.displayNameShort = "Foregrip"
 
att.statModifiers = {VelocitySensitivityMult = -0.3,
DrawSpeedMult = -0.1,
RecoilMult = -0.2}
 
if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/foregrip")
end

function att:attachFunc()
	self.Animations = {fire = "foregrip_fire",
	reload = "foregrip_reload",
	reload_empty = "foregrip_reloadempty",
	idle = "foregrip_idle",
	draw = "foregrip_draw"}
	self:sendWeaponAnim("idle")
end
 
function att:detachFunc()
	self.Animations = {fire = "base_fire",
	reload = "base_reload",
	reload_empty = "base_reloadempty",
	idle = "base_idle",
	draw = "base_ready"}
	self:sendWeaponAnim("idle")
end
 
CustomizableWeaponry:registerAttachment(att)

--[[=========================================
	Grip Pod (QBZ-97)
===========================================]]

local att = {}
att.name = "qbz97_grippod"
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
	self.Animations = {fire = "foregrip_fire",
	reload = "foregrip_reload",
	reload_empty = "foregrip_reloadempty",
	idle = "foregrip_idle",
	draw = "foregrip_draw"}
	self:sendWeaponAnim("idle")
end

function att:detachFunc()
	self.BipodInstalled = false
	self.Animations = {fire = "base_fire",
	reload = "base_reload",
	reload_empty = "base_reloadempty",
	idle = "base_idle",
	draw = "base_ready"}
	self:sendWeaponAnim("idle")
end

function att:elementRender()
	local is = self.dt.BipodDeployed	
	local was = self.BipodWasDeployed
	
	if is != was then
		if is then
			self.AttachmentModelsVM.qbz97_grippod.ent:SetBodygroup(1,1)
		else
			self.AttachmentModelsVM.qbz97_grippod.ent:SetBodygroup(1,0)
		end	
	end
	
	self.BipodWasDeployed = is
end

CustomizableWeaponry:registerAttachment(att)