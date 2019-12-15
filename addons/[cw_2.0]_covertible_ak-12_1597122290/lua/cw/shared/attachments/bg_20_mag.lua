local att = {}
att.name = "bg_ak12_20rndmag"
att.displayName = "Ak-12 20 Mag"
att.displayNameShort = "20 Mag"
att.isBG = true

att.statModifiers = {
RecoilMult = -0.05,
AimSpreadMult = -0.15,
HipSpreadMult = -0.1,
MaxSpreadIncMult = - 0.1,
OverallMouseSensMult = 0.1}

if CLIENT then
	att.displayIcon = surface.GetTextureID("entities/ak12_20_mag")
	att.description = {[1] = {t = "A Marksman Magazine.", c = CustomizableWeaponry.textColors.POSITIVE},
	[2] = {t = "Decreases mag size to 20 rounds.", c = CustomizableWeaponry.textColors.NEGATIVE}}
end

function att:attachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.round20)
	self:unloadWeapon()
	self.Primary.ClipSize = 20
	self.Primary.ClipSize_Orig = 20
end

function att:detachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.regular)
	self:unloadWeapon()
	self.Primary.ClipSize = self.Primary.ClipSize_ORIG_REAL
	self.Primary.ClipSize_Orig = self.Primary.ClipSize_ORIG_REAL
end

CustomizableWeaponry:registerAttachment(att)