local bw = BaseWars.Bases
local nw = bw.NW
local hud = bw.HUD

hud.BorderSize = 2

local frCol = Color(25, 25, 25)
local bgCol = Color(15, 15, 15, 220)

local frShad = BSHADOWS.GenerateCache("BW_BaseFrame", 512, 256)
frShad:SetGenerator(function(self, w, h)
	draw.RoundedBox(8, 0, 0, w, h, color_white)
end)

frShad:CacheShadow(4, 6, 4)

function hud:PaintFrame(cury)
	--print("holy paint", ptr.AppearFrac, ptr.DisappearFrac)
	local hd = 28 * DarkHUD.Scale

	cam.PushModelMatrix(self.Matrix) -- why
	self:SetWide(math.max(self:GetWide(), ScrW() * 0.15))

	surface.SetDrawColor(255, 255, 255)

	DisableClipping(true)
		frShad:Paint(0, cury, self:GetWide(), self:GetTall())
	DisableClipping(false)

	draw.RoundedBoxEx(8, 0, cury, self:GetWide(), hd, Colors.FrameHeader, true, true)
	draw.RoundedBoxEx(8, 0, cury + hd, self:GetWide(), self:GetTall() - hd, Colors.FrameBody,
		false, false, true, true)

	cam.PopModelMatrix(self.Matrix)

	--[[local borderSize = hud.BorderSize

	self:SetWide(math.max(self:GetWide(), ScrW() * 0.1))

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

	draw.FinishMask()]]

	return hd
end

hud.AddPaintOp(9999, "PaintFrame", hud)