local att = {}
att.name = "bg_retracted_stock"
att.displayName = "Retracted stock"
att.displayNameShort = "Compact"
att.isBG = true
att.SpeedDec = -5

att.statModifiers = {
AimSpreadMult = -0.1,
RecoilMult = -0.05,
HipSpreadMult = 0.12
}

if CLIENT then
	att.displayIcon = surface.GetTextureID("entities/AK12_Stock")
	att.description = {[1] = {t = "Compact Stock For Close Combats", c = CustomizableWeaponry.textColors.POSITIVE}}
end

function att:attachFunc()
	self:setBodygroup(self.StockBGs.main, self.StockBGs.retractable)
end

function att:detachFunc()
	self:setBodygroup(self.StockBGs.main, self.StockBGs.regular)
end

CustomizableWeaponry:registerAttachment(att)