--top
local att = {}
att.name = "bg_ak762x39us"
att.displayName = "7.62x39 US"
att.displayNameShort = "7.62 US"
att.isBG = true

att.statModifiers = {
	RecoilMult = -0.05,
	AimSpreadMult = -0.1,
}


if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/matchgradeammo")

	att.description = {
		[1] = {t = "Better accuracy and recoil.", c = CustomizableWeaponry.textColors.REGULAR},
		[2] = {t = "", c = CustomizableWeaponry.textColors.REGULAR},
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