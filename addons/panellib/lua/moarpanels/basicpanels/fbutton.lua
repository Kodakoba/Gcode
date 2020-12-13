--[[-------------------------------------------------------------------------
-- 	FButton
---------------------------------------------------------------------------]]
local PANEL = {}

local RED = Color(255, 0, 0)
local DIM = Color(30, 30, 30, 210)

local button = {}

local sharedScaleVec = Vector(1, 1)
local sharedTranslVec = Vector(0, 0)
local mx = Matrix()

function button:Init()
	self.Color = Colors.Button:Copy()
	self.drawColor = Colors.Button:Copy()
	self.DisabledColor = Colors.Button:Copy()

	self:SetText("")
	self:SetDoubleClickingEnabled(false)
	self.Font = "OS24"
	self.DrawShadow = true
	self.HovMult = 1.2

	self.Shadow = {
		MaxSpread = 0.6,
		Intensity = 2,

		OnHover = true,	--should the internal shadow logic be applied when the button gets hovered?
		HoverSpeed = 0.3,
		UnhoverSpeed = 0.3,

		HoverEase = 0.1,
		UnhoverEase = 0.1
	}

	self.LabelColor = Color(255, 255, 255)
	self.DisabledLabelColor = Color(255, 255, 255, 150)

	self.RBRadius = 8

	self.HoverColor = nil
	self.HoverColorGenerated = nil
	self.Icon = nil
	self.MxScale = 1
	--[[
	{
		IconURL = "",
		IconName = "",

		IconMat = nil, --you can give it a plain material if you want

		IconColor = color_white,

		IconW = 24,
		IconH = 24,

		IconX = 4,	--offset to the left from the text

		CenterWithText = false 	--if true, will take the icon's width into account as well for centering text
	}
	]]
end

function button:SetIcon(url, name, w, h, col, rot)
	local t = self.Icon or {}
	self.Icon = t

	if IsMaterial(url) then
		t.IconMat = url

		--shift args backwards by 1
		col = h
		h = w
		w = name
	else
		t.IconURL = url
		t.IconName = name
	end


	t.IconW = w
	t.IconH = h

	t.IconColor = col
	t.IconRotation = rot
end

function button:SetColor(col, g, b, a)
	if IsColor(col) then
		self.Color:Set(col)
		if g then 	--if 2nd arg, that means apply now
			self.drawColor = col:Copy()
		end
		return
	end

	local c = self.Color
	c.r = col or 70
	c.g = g or 70
	c.b = b or 70
	c.a = a or 255
end

function button:SetTextColor(col, g, b, a)

	if IsColor(col) then
		self.LabelColor = col
		self.DisabledLabelColor = col:Copy()
		self.DisabledLabelColor.a = 150
		return
	end

	local c = self.LabelColor
	c.r = col or 255
	c.g = g or 255
	c.b = b or 255
	c.a = a or 255

	self.DisabledLabelColor = c:Copy()
	self.DisabledLabelColor.a = 150
end

function button:HoverLogic(dis, w, h)
	local shadow = self.Shadow

	if self:IsDown() then
		local min = math.max(w, h)
		self:To("MxScale", self.MxScaleDown or (1 - math.min(16, min * 0.1) / min), 0.1, 0, 0.3)
	else
		self:To("MxScale", 1, 0.1, 0, 0.3)
	end

	if (self:IsHovered() or self.ForceHovered) and not dis then

		hov = true
		local hm = self.HovMult

		local bg = self.Color

		local fr = math.min(bg.r*hm, 255)
		local fg = math.min(bg.g*hm, 255)
		local fb = math.min(bg.b*hm, 255)


		local hovcol = self.HoverColor or Color(fr, fg, fb)
		self.HoverColor = hovcol


		if self.HoverColorGenerated ~= self.Color then
			self.HoverColor:Set(fr, fg, fb)
			if self.HoverColorGenerated then
				self.HoverColorGenerated:Set(self.Color:Unpack())
			else
				self.HoverColorGenerated = self.Color:Copy()
			end
		end

		LC(self.drawColor, self.HoverColor, 10) --this just looks better, idfk
		--self:LerpColor(self.drawColor, self.HoverColor, 1.1, 0, 0.2)

		if shadow.OnHover then
			local spr = shadow.MaxSpread
			self:MemberLerp(shadow, "Spread", spr, shadow.HoverSpeed, 0, shadow.HoverEase)
		end

		if not self._IsHovered then
			self._IsHovered = true
			self:OnHover()
		end

		self:ThinkHovered()
	else

		local bg = dis and self.DisabledColor or self.Color

		--self:LerpColor(self.drawColor, bg, 0.4, 0, 0.8)
		LC(self.drawColor, bg)

		if shadow.OnHover then
			self:MemberLerp(shadow, "Spread", 0, shadow.UnhoverSpeed, 0, shadow.UnhoverEase)
		end

		if self._IsHovered then
			self._IsHovered = false
			self:OnUnhover()
		end
	end

end

function button:SetLabel(txt)
	self.Label = txt
end

function button:ThinkHovered()

end

function button:OnHover()

end

function button:OnUnhover()

end

local function dRB(rad, x, y, w, h, dc, ex)

	if ex then
		local r = ex

		local tl = (r.tl == nil and true) or r.tl
		local tr = (r.tr == nil and true) or r.tr

		local bl = (r.bl == nil and true) or r.bl
		local br = (r.br == nil and true) or r.br

		draw.RoundedBoxEx(rad, x, y, w, h, dc, tl, tr, bl, br)
	else
		draw.RoundedBox(rad, x, y, w, h, dc)
	end

end

-- draw the background
function button:DrawButton(x, y, w, h)

	local rad = self.RBRadius or 8

	local bordercol = self.borderColor or self.Color or RED
	local bg = self.drawColor or self.Color or RED

	local rbinfo = self.RBEx

	local w2, h2 = w, h
	local x2, y2 = x, y

	if self.Border then
		dRB(rad, x, y, w, h, bordercol, rbinfo)
		local bw, bh = self.Border.w or 2, self.Border.h or 2
		w2, h2 = w - bw*2, h - bh*2
		x2, y2 = x + bw, y + bh
	end

	dRB(rad, x2, y2, w2, h2, bg, rbinfo)

end

--draw the text on the button
function button:DrawLabel(x, y, w, h, label)

end

function button:PaintIcon(x, y)
	if not istable(self.Icon) then return end

	local ic = self.Icon

	local iW = ic.IconW or self:GetWide() - (self.RBRadius or 8)
	local iH = ic.IconH or self:GetTall() - (self.RBRadius or 8)

	local ioff = ic.IconX or (self.Label and 4) or 0

	local lblCol = self:GetDisabled() and self.DisabledLabelColor or self.LabelColor

	local col = ic.IconColor or lblCol or color_white
	surface.SetDrawColor(col.r, col.g, col.b, col.a)
	local xoff = (self.Label and 1) or 0.5

	local iX = x
	local iY = y

	--[[if not ic.IconRotation then
		iX = x - iW * xoff - ioff
		iY = self:GetTall() / 2 - iH / 2
	else
		iX = x - ioff
		iY = y
	end]]

	render.PushFilterMin(TEXFILTER.ANISOTROPIC)

		local ok, err = pcall(function()
			if ic.IconMat then
				surface.SetMaterial(ic.IconMat)
				surface.DrawTexturedRect(iX, iY, iW, iH)
			elseif ic.IconURL then
				surface.DrawMaterial(ic.IconURL, ic.IconName, iX, iY, iW, iH, ic.IconRotation)
			end
		end)

	render.PopFilterMin()

	if not ok then
		error(err)
	end
end

local AYToTextY = {
	[0] = 4,
	[1] = 1,
	[2] = 5
}
--mostly shadow logic and caller for Draw* functions
function button:Draw(w, h)

	local shadow = self.Shadow
	local disabled = self:GetDisabled()

	self.drawColor = self.drawColor

	local x, y = 0, 0

	self:HoverLogic(disabled, w, h)

	local spr = shadow.Spread or 0
	local label = self.Label or nil

	if not self.NoDraw then

		if (self.DrawShadow and spr > 0) or self.AlwaysDrawShadow then
			BSHADOWS.BeginShadow()
			x, y = self:LocalToScreen(0,0)

			if self.ActiveMatrix then
				cam.PushModelMatrix(self.ActiveMatrix, true)
			end

		end


			self:DrawButton(x, y, w, h)

		if (self.DrawShadow and spr > 0) or self.AlwaysDrawShadow then
			local int = shadow.Intensity
			local blur = shadow.Blur
			local a = shadow.Alpha or 255

			if self.AlwaysDrawShadow then
				--int = 3
				spr = math.max(shadow.MinSpread or 0.3, spr)
				--blur = 1
			end

			if self.MxScale < 1 then
				spr = spr * (1 / self.MxScale ^ 6)
			end
			if spr < 0.2 then
				a = a * (spr / 0.2)
			end

			if self.ActiveMatrix then
				cam.PopModelMatrix()
			end

			BSHADOWS.EndShadow(int, spr, blur or 2, a, shadow.Dir, shadow.Distance, nil, shadow.Color, shadow.Color2)


		end

	end

	if not self.NoDrawText and label then

		label = tostring(label)

		local tx = self.TextX or w / 2
		local ty = self.TextY or h / 2

		local ax = self.TextAX or 1
		local ay = self.TextAY or 1
		local realAY = AYToTextY[ay] or 1
		local ic = self.Icon

		local lblCol = disabled and self.DisabledLabelColor or self.LabelColor
		local newlines = amtNewlines(label)

		local iW = ic and ic.IconW or 0
		local iH = ic and ic.IconH or 0
		local iconX = ic and (ic.IconX or 4) or 0

		if newlines > 0 then
			surface.SetFont(self.Font)
			surface.SetTextColor(lblCol:Unpack())

			local lines = newlines + 1
			local lH, lY

			local tWMax = 0

			for s, num in eachNewline(label) do
				s = s:gsub("^%s+", "")
				local tW, tH = surface.GetTextSize(s)
				tWMax = math.max(tWMax, tW)
				tH = self.TextHeight or tH

				if not lH then
					lH = tH * lines
					lY = ty - lH * (ay / 2)
				end

				surface.SetTextPos(tx - tW * (ax / 2) + (iW + iconX) / 2, lY + tH * (num - 1))
				surface.DrawText(s)
			end

			local iX = math.Round(tx - (iW + iconX) / 2 - tWMax * (ax / 2))
			local iY = math.Round(lY + lH / 2 - iH / 2)

			--White()
			--surface.DrawOutlinedRect(iX, iY, tWMax + iW + iconX, 32)

			self:PaintIcon(iX, iY)
			--local tw = draw.DrawText(label, self.Font, tx, ty, lblCol, ax)
		else

			surface.SetFont(self.Font)
			local tW, tH = surface.GetTextSize(label)
						-- 			shhh
			local fullW = iW + (iconX * 2) + tW

			local iX = math.Round(tx - fullW * (ax / 2))
			local iY = math.Round(ty - iH * (ay / 2))

			self:PaintIcon(iX, iY)

			local tX = math.Round(iX + iconX + iW)
			local tY = math.Round(ty - tH * (ay / 2))

			surface.SetTextPos(tX, tY)
			surface.SetTextColor(lblCol:Unpack())
			surface.DrawText(label)
		end
		return
	end

	self:PaintIcon(w/2, h/2)

end

function button:PostPaint(w,h)

end

function button:PrePaint(w,h)

end


fbuttonLeakingMatrices = 0	--failsafe

local function popMatrix(self, w, h)
	local scale = self.MxScale

	if scale ~= 1 then
		cam.PopModelMatrix()
		self.ActiveMatrix = nil
		mx:Reset()

		fbuttonLeakingMatrices = fbuttonLeakingMatrices - 1
		draw.DisableFilters(true)
	end
end

function button:ApplyMatrix()
	if self.ActiveMatrix then
		cam.PushModelMatrix(self.ActiveMatrix, true)
	end
end

function button:PopMatrix()
	if self.ActiveMatrix then
		cam.PopModelMatrix()
	end
end


function button:PaintOver(w, h)

	if self.Dim then
		draw.RoundedBox(self.RBRadius, 0, 0, w, h, DIM)
	end

	popMatrix(self, w, h)
end


function button:Paint(w, h)
	local scale = self.MxScale

	if scale ~= 1 then
		sharedScaleVec[1] = scale
		sharedScaleVec[2] = scale

		local x, y = self:LocalToScreen(0, 0)
		sharedTranslVec[1], sharedTranslVec[2] = x + w/2, y + h/2

		mx:Translate(sharedTranslVec)
			mx:SetScale(sharedScaleVec)
		mx:Translate(-sharedTranslVec)
		draw.EnableFilters(true)
		cam.PushModelMatrix(mx, true)

		self.ActiveMatrix = mx

		fbuttonLeakingMatrices = fbuttonLeakingMatrices + 1
	end

	self:PrePaint(w,h)
	self:Draw(w, h)
	self:PostPaint(w,h)

end

vgui.Register("FButton", button, "DButton")


hook.Add("PostRender", "UnleakMatrices", function()
	if fbuttonLeakingMatrices > 0 then
		local amt = fbuttonLeakingMatrices
		for i=1, amt do
			cam.PopModelMatrix()
			--render.PopFilterMin()
			draw.DisableFilters(true, true)
		end

		leakingMatrices = 0

		errorf("nice matrix leak: leaked %d matrices", amt)
	end
end)