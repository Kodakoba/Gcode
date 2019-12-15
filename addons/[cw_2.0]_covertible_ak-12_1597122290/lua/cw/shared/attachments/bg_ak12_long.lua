local att = {}
att.name = "bg_ak12_longbarrel"
att.displayName = "SVD-12 Barrel"
att.displayNameShort = "Long"
att.isBG = true

att.statModifiers = {
DamageMult = 0.5,
FireDelayMult = 0.30,
AimSpreadMult = -0.6,
HipSpreadMult = 0.1,
RecoilMult = -0.30,
OverallMouseSensMult = -0.1}

if CLIENT then
	att.displayIcon = surface.GetTextureID("entities/AK12_Long_Barrel")
end

function att:attachFunc()
	self:setBodygroup(self.BarrelBGs.main, self.BarrelBGs.long)
	self:updateSoundTo("CW_AK74_RPK_FIRE", CustomizableWeaponry.sounds.UNSUPPRESSED)
	self:updateSoundTo("CW_AK74_RPK_FIRE_SUPPRESSED", CustomizableWeaponry.sounds.SUPPRESSED)
end

function att:detachFunc()
	self:setBodygroup(self.BarrelBGs.main, self.BarrelBGs.regular)
	self:restoreSound()
end

CustomizableWeaponry:registerAttachment(att)