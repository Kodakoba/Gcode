local att = {}
att.name = "bg_acrrstock"
att.displayName = "Retracted Stock"
att.displayNameShort = "R. Stock"
att.isBG = true
att.SpeedDec = 2

att.statModifiers = {RecoilMult = -0.1,
OverallMouseSensMult = -0.1}

if CLIENT then
	att.displayIcon = surface.GetTextureID("atts/acrrstock")
end

function att:attachFunc()
	self:setBodygroup(self.StockBGs.main, self.StockBGs.retracted)
end

function att:detachFunc()
	self:setBodygroup(self.StockBGs.main, self.StockBGs.regular)
end

CustomizableWeaponry:registerAttachment(att)