local att = {}
att.name = "bg_ak12_nostock"
att.displayName = "No stock"
att.displayNameShort = "None"
att.isBG = true
att.SpeedDec = -10

att.statModifiers = {DrawSpeedMult = 0.2,
OverallMouseSensMult = 0.45,
RecoilMult = 0.45}

if CLIENT then
	att.displayIcon = surface.GetTextureID("entities/bg_ak12_no_stock")
end

function att:attachFunc()
	self:setBodygroup(self.StockBGs.main, self.StockBGs.none)
end

function att:detachFunc()
	self:setBodygroup(self.StockBGs.main, self.StockBGs.regular)
end

CustomizableWeaponry:registerAttachment(att)