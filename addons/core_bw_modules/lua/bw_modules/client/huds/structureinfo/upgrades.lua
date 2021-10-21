local hud = BaseWars.HUD
local sin = hud.StructureInfo
local anim = sin.Anims

local col = Color(100, 80, 80)

function sin:PaintLevel(cury)
	local ent = self:GetEntity():IsValid() and self:GetEntity()
	local w, h = self:GetSize()

	local shouldnt = ent and not ent.GetLevel
	if shouldnt then return end

	local lv = ent and ent:GetLevel()
	local mx = ent and ent.GetMaxLevel and ent:GetMaxLevel()
	local uc = ent and ent.GetUpgradeCost and ent:GetUpgradeCost()

	self.EntLevel = lv or self.EntLevel
	self.EntMaxLevel = mx or self.EntMaxLevel
	self.EntUpgCost = uc or self.EntUpgCost

	if not self.EntLevel then return end

	local offy = cury

	local _, th = draw.SimpleText(
		Language("Level", self.EntLevel, self.EntMaxLevel),
		"OS20", w / 2, offy, color_white, 1, 5)

	offy = offy + th

	if self.EntUpgCost then
		local _, th = draw.SimpleText(
			Language("UpgCost", self.EntUpgCost),
			"OS20", w / 2, offy, color_white, 1, 5)

		offy = offy + th
	end

	return offy - cury
end

sin.AddPaintOp(8999, "PaintLevel", sin)