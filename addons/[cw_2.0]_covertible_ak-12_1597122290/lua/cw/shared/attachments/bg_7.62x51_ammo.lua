local att = {}
att.name = "bg_ak762x51rndammo"
att.displayName = "AK-12 7.62x51 Ammunition"
att.displayNameShort = "7.62x51"
att.isBG = true

att.statModifiers = {
DamageMult = 0.65,
RecoilMult = 0.4,
FireDelayMult = 0.4,
ClipSize = 20,}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/matchgradeammo")

	att.description = {
		[1] = {t = "Chambers the gun with 7.62x51mm sniper ammunition.", c = CustomizableWeaponry.textColors.REGULAR},
		[2] = {t = "Significantly increased damage potential and accuracy at the cost of recoil and clipsize.", c = CustomizableWeaponry.textColors.REGULAR},
		[3] = {t = "", c = CustomizableWeaponry.textColors.REGULAR},
	}

end

function att:attachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.round7_62x39)
	self:unloadWeapon()
	--self.Primary.ClipSize = 30
	--self.Primary.ClipSize_Orig = 30
	self.Primary.Ammo = "7.62x51MM"
end

function att:detachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.regular)
	self:unloadWeapon()
	--self.Primary.ClipSize = self.Primary.ClipSize_ORIG_REAL
	--self.Primary.ClipSize_Orig = self.Primary.ClipSize_ORIG_REAL
	self.Primary.Ammo = "5.45x39MM"
end

CustomizableWeaponry:registerAttachment(att)