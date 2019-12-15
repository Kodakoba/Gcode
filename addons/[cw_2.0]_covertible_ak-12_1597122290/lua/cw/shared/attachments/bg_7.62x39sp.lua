--top
local att = {}
att.name = "bg_ak762x39bp"
att.displayName = "7.62x39 BP"
att.displayNameShort = "7.62 BP"
att.isBG = true

att.statModifiers = {
	DamageMult = 0.3,
	RecoilMult = 0.2,
	AimSpreadMult = 0.1,
	HipSpreadMult = 0.3,
}


if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/matchgradeammo")

	att.description = {
		[1] = {t = "Bullets designed for maximum armor penetration and stopping power.", c = CustomizableWeaponry.textColors.REGULAR},
		[2] = {t = "Increased damage potential at the cost of recoil and accuracy.", c = CustomizableWeaponry.textColors.REGULAR},
		[3] = {t = "", c = CustomizableWeaponry.textColors.REGULAR},
	}

end

function att:attachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.round7_62x39)
	self:unloadWeapon()
end

function att:detachFunc()
	self:setBodygroup(self.MagBGs.main, self.MagBGs.regular)
	self:unloadWeapon()
end

CustomizableWeaponry:registerAttachment(att)