local hud = BaseWars.HUD
local sin = hud.StructureInfo

local frCol = Color(25, 25, 25)
local bgCol = Color(15, 15, 15, 220)
local anim = sin.Anims

function sin:PaintFrame(cury)
	local hd = 18

	BSHADOWS.BeginShadow()
	cam.PushModelMatrix(self.Matrix) -- why
	self:SetWide(math.max(self:GetWide(), ScrW() * 0.15))

	draw.RoundedBoxEx(8, 0, cury, self:GetWide(), hd, Colors.FrameHeader, true, true)
	draw.RoundedBoxEx(8, 0, cury + hd, self:GetWide(), self:GetTall(), Colors.FrameBody,
		false, false, true, true)

	BSHADOWS.EndShadow(2, 1, 1)
	cam.PopModelMatrix(self.Matrix)

	return hd + 2
end

local HPBG = Color(75, 75, 75)
local HPFG = Color(200, 75, 75)

function sin:PaintName(cury)
	local ent = self:GetEntity()
	local w, h = self:GetSize()

	local offy = cury
	local tw, th = draw.SimpleText(ent.PrintName or ent:GetClass(), "OSB24",
		self:GetWide() / 2, cury, color_white, 1, 5)

	offy = offy + th + 4

	-- health
	local hpFr = math.min(ent:Health() / ent:GetMaxHealth(), 1)
	self.HPFrac = self.HPFrac or hpFr
	anim:MemberLerp(self, "HPFrac", hpFr, 0.3, 0, 0.3)
	hpFr = self.HPFrac

	draw.RoundedBox(6, 8, offy, w - 16, 14, HPBG)
	draw.RoundedBox(6, 8, offy, (w - 16) * hpFr, 14, HPFG)

	local tx = Language("Health", EntHP, EntMaxHP)

	self:SizeTo(math.max(self:GetWide(), tw), -1, 0.3, 0, 0.3)
	return offy - cury + 4
end

sin.AddPaintOp(9999, "PaintFrame", sin)
sin.AddPaintOp(9998, "PaintName", sin)