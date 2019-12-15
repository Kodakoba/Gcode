--top
local att = {}
att.name = "bg_ak762x39hp"
att.displayName = "7.62x39 HP"
att.displayNameShort = "7.62 HP"
att.isBG = true

att.statModifiers = {
	DamageMult = -0.05,
	RecoilMult = -0.2,
	AimSpreadMult = -0.2,
	HipSpreadMult = -0.05,
}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/matchgradeammo")

	att.description = {
		[1] = {t = "Slightly decreased damage but easier recoil control and better accuracy.", c = CustomizableWeaponry.textColors.REGULAR},
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