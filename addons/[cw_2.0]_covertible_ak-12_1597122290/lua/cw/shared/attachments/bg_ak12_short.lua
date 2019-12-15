local att = {}
att.name = "bg_ak12_ubarrel"
att.displayName = "Shortened barrel"
att.displayNameShort = "Short"
att.isBG = true
att.categoryFactors = {cqc = 3}
att.SpeedDec = -3

att.statModifiers = {
RecoilMult = 0.15,
AimSpreadMult = 0.25,
HipSpreadMult = -0.55,
OverallMouseSensMult = 0.25,
DrawSpeedMult = 0.2,
MaxSpreadIncMult = -0.8,
DamageMult = -0.05,
FireDelayMult = -0.15}

if CLIENT then
	att.displayIcon = surface.GetTextureID("entities/bg_ak12_short")
end

function att:attachFunc()
	self:setBodygroup(self.BarrelBGs.main, self.BarrelBGs.short)
	self:setupCurrentIronsights(self.ShortenedPos, self.ShortenedAng)
	
	if not self:isAttachmentActive("sights") then
		self:updateIronsights("Shortened")
	end
end

function att:detachFunc()
	self:setBodygroup(self.BarrelBGs.main, self.BarrelBGs.regular)
	self:restoreSound()
	self:revertToOriginalIronsights()
end

CustomizableWeaponry:registerAttachment(att)