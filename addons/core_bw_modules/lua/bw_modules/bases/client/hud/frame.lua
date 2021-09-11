local bw = BaseWars.Bases
local nw = bw.NW
local hud = bw.HUD

hud.BorderSize = 2

local frCol = Color(25, 25, 25)
local bgCol = Color(15, 15, 15, 220)

function hud:PaintFrame(cury)
	--print("holy paint", ptr.AppearFrac, ptr.DisappearFrac)
	local borderSize = hud.BorderSize

	self:SetWide(math.max(self:GetWide(), ScrW() * 0.2))

	draw.RoundedBox(8, borderSize - 1, cury + borderSize - 1,
		self:GetWide() - borderSize * 2 + 2, self:GetTall() - borderSize * 2 + 2,
		bgCol)

	draw.BeginMask()

		render.ClearStencilBufferRectangle(0, 0, ScrW(), ScrH(), 1)

	draw.DeMask()

		draw.RoundedStencilBox(8, borderSize, cury + borderSize,
			self:GetWide() - borderSize * 2, self:GetTall() - borderSize * 2,
			color_white)

	draw.DrawOp()

		draw.RoundedBox(8, 0, cury, self:GetWide(), self:GetTall(), frCol)

	draw.FinishMask()

	return borderSize + 1
end

hud.AddPaintOp(9999, "PaintFrame", hud)