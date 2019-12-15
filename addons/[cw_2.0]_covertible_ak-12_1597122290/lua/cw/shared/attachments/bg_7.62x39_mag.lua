local att = {}
att.name = "bg_ak762x39rndmag"
att.displayName = "Ak-12 7.62x39 Mag"
att.displayNameShort = "7.62 Mag"
att.isBG = true

att.statModifiers = {
DamageMult = 0.25,
RecoilMult = 0.2,
FireDelayMult = 0.1,
OverallMouseSensMult = -0.05}

if CLIENT then
	att.displayIcon = surface.GetTextureID("entities/ak12_762")
	att.description = {[1] = {t = "Increase the effective range.", c = CustomizableWeaponry.textColors.POSITIVE},
    [2] = {t = "Decrease the damage fall.", c = CustomizableWeaponry.textColors.POSITIVE}}
end

function att:attachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.round7_62x39)
	self:unloadWeapon()
	self.Primary.ClipSize = 30
	self.Primary.ClipSize_Orig = 30
	self.Primary.Ammo = "7.62x39MM"
end

function att:detachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.regular)
	self:unloadWeapon()
	self.Primary.ClipSize = self.Primary.ClipSize_ORIG_REAL
	self.Primary.ClipSize_Orig = self.Primary.ClipSize_ORIG_REAL
	self.Primary.Ammo = "5.45x39MM"
end

CustomizableWeaponry:registerAttachment(att)