local att = {}
att.name = "bg_ak12_50rndmag"
att.displayName = "Ak-12 50 Mag"
att.displayNameShort = "50 Mag"
att.isBG = true

att.statModifiers = {
ReloadSpeedMult = -0.1,
OverallMouseSensMult = -0.1}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/ar1560rndmag")
	att.description = {[1] = {t = "Increases mag size to 50 rounds.", c = CustomizableWeaponry.textColors.POSITIVE}}
end

function att:attachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.round60)
	self:unloadWeapon()
	self.Primary.ClipSize = 50
	self.Primary.ClipSize_Orig = 50
    self.Animations = {fire = {"shoot3"},
	   reload = "reload_unsil",
	   idle = "idle",
	   draw = "draw"}
	self:sendWeaponAnim("idle")
    self.ReloadTime = 2.9
    self.ReloadHalt = 2.9
end

function att:detachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.regular)
	self:unloadWeapon()
	self.Primary.ClipSize = self.Primary.ClipSize_ORIG_REAL
	self.Primary.ClipSize_Orig = self.Primary.ClipSize_ORIG_REAL
    self.Animations = {fire = {"shoot3"},
	   reload = "reload",
	   reload_empty = "reload_unsil",
	   idle = "idle",
	   draw = "draw"}
	self:sendWeaponAnim("idle")
    self.ReloadTime = 2.6
    self.ReloadHalt = 2.6
end

CustomizableWeaponry:registerAttachment(att)