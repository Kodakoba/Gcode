local hud = BaseWars.HUD
local sin = hud.StructureInfo
local anim = sin.Anims

local col = Color(100, 80, 80)

function sin:PaintGeneratorOutput(ent, cury)
	local w, h = self:GetSize()
	local offy = cury

	local _, th = draw.SimpleText(
			"+1000pw lol",
			"OS20", w / 2, offy, color_white, 1, 5)
	offy = offy + th

	return offy - cury
end

function sin:PaintPrinterOutput(ent, cury)
	local w, h = self:GetSize()
	local offy = cury

	local _, th = draw.SimpleText(
			"$420/s lol",
			"OS20", w / 2, offy, color_white, 1, 5)
	offy = offy + th

	return offy - cury
end

function sin:PaintOutput(cury)
	local ent = self:GetEntity():IsValid() and self:GetEntity()

	self._EntType = self._EntType or
		(	ent.IsGenerator and "Generator" or
			ent.IsPrinter and "Printer")

	if self._EntType and
		sin["Paint" .. self._EntType .. "Output"] then

		return sin["Paint" .. self._EntType .. "Output"](self, ent, cury)
	end

end

sin.AddPaintOp(8998, "PaintOutput", sin)