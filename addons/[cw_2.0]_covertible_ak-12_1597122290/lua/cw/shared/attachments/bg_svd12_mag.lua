local att = {}
att.name = "bg_svd12rndmag"
att.displayName = "SVD-12 7.62x51 Mag For Snipers"
att.displayNameShort = "SVD-12"
att.isBG = true

att.statModifiers = {
DamageMult = 0.7,
RecoilMult = 0.3,
AimSpreadMult = -0.4,
HipSpreadMult = -0.2,
FireDelayMult = 0.4,
OverallMouseSensMult = -0.05}

if CLIENT then
	att.displayIcon = surface.GetTextureID("entities/bg_sv12_mag")
	att.description = {[1] = {t = "Increases noticeably the effective range.", c = CustomizableWeaponry.textColors.POSITIVE},
	[2] = {t = "Decrease the damage fall.", c = CustomizableWeaponry.textColors.POSITIVE},
	[3] = {t = "Can only be used in semi automatic mode.", c = CustomizableWeaponry.textColors.NEGATIVE},
	[4] = {t = "Decreases mag size to 10 rounds.", c = CustomizableWeaponry.textColors.NEGATIVE}}
end

function att:attachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.round7_62x51)
	self:unloadWeapon()
	self.Primary.ClipSize = 20
	self.Primary.ClipSize_Orig = 20
	self.FireModes = {"semi", "safe"}
	self:SelectFiremode("semi")
	self.Primary.Ammo = "7.62x51MM"
end

function att:detachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.regular)
	self:unloadWeapon()
	self.Primary.ClipSize = self.Primary.ClipSize_ORIG_REAL
	self.Primary.ClipSize_Orig = self.Primary.ClipSize_ORIG_REAL
	self.FireModes = {"auto", "semi", "safe"}
	self:SelectFiremode("auto")
	self.Primary.Ammo = "5.45x39MM"
end

CustomizableWeaponry:registerAttachment(att)