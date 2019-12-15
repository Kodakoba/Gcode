local att = {}
att.name = "bg_ak762x39rndammo"
att.displayName = "AK-12 7.62x39 Ammunition"
att.displayNameShort = "7.62x39"
att.isBG = true

att.statModifiers = {
DamageMult = 0.25,
RecoilMult = 0.2,
FireDelayMult = 0.1,
OverallMouseSensMult = -0.05,
ClipSize = 20,}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/matchgradeammo")

	att.description = {
		[1] = {t = "Chambers the gun with 7.62x39mm ammunition.", c = CustomizableWeaponry.textColors.REGULAR},
		[2] = {t = "Increased damage potential at the cost of recoil.", c = CustomizableWeaponry.textColors.REGULAR},
		[3] = {t = "", c = CustomizableWeaponry.textColors.REGULAR},
	}

end

function att:attachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.round7_62x39)
	self:unloadWeapon()
	--self.Primary.ClipSize = 30
	--self.Primary.ClipSize_Orig = 30
	self.Primary.Ammo = "7.62x39MM"
end

function att:detachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.regular)
	self:unloadWeapon()
	--self.Primary.ClipSize = self.Primary.ClipSize_ORIG_REAL
	--self.Primary.ClipSize_Orig = self.Primary.ClipSize_ORIG_REAL
	self.Primary.Ammo = "5.45x39MM"
end

CustomizableWeaponry:registerAttachment(att)