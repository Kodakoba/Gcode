--[[-------------------------------------------------------------------------
--  Pop-up Cloud (It's crappy)

	Cloud:SetLabel(txt)
	Cloud.SetText = Cloud.SetLabel

	Cloud:SetColor(col, g, b, a)
	Cloud:SetTextColor(col, g, b, a)

	Cloud:AddFormattedText(txt, col, font, overy, num, align)	

		--	num: index for tbl(can replace texts);
			overy = y offset for the next text (yes, next, not prev) (leave nil to default)
			align = 1/2 - 1 for mid, 2 for right
	
	Cloud:AddSeparator(col, offx, offy, num)
	Cloud:ClearFormattedText()

	Cloud:SetAbsPos(x, y)
	Cloud:SetRelPos(x, y)

	Cloud:FullInit()
	Cloud:Popup(bool)

	Cloud:Bond(pnl) 	--if the panel is gone, so is the cloud

	Stuff you can modify:

		Cloud.Font
		Cloud.DescFont

		Cloud.Label
		Cloud.HOffset
		Cloud.Speed -- popup speed
		Cloud.Color
		Cloud.TextColor

		Cloud.AlignLabel = 1/2 -- 1 for middle, 2 for right

		Cloud.Middle 	-- 0-1 (or less/more for full zane)

		Cloud.YAlign	-- like text aligns, except the cloud aligns there : 0/1/2
						-- by default it's 2 which means align by bottom (because it's a cloud)

		Cloud.ToX = 0	-- by how much XY cloud will move when it's popped up
		Cloud.ToY = 0	-- use these to make s w e e t pop-in animations

		Cloud.Shadow = {}

		Cloud.Min/MaxW

---------------------------------------------------------------------------]]

CLOUDS = CLOUDS or {}

function CLOUDS:RemoveAll()
	for k,v in ipairs(self) do
		if IsValid(v) then v:Remove() end
		self[k] = nil
	end
end

local Cloud = {}

function Cloud:Init()

	self.Font = "OS24"
	self.DescFont = "OSL18"
	self:SetSize(2,2)
	self:SetPos(2,2)

	self:SetAlpha(0)
	self.Frac = 0 --don't make it disappear instantly

	self:SetMouseInputEnabled(false)

	self.Label = "No label!"
	self.LabelWidth = 64

	timer.Simple(0, function()
		if not IsValid(self) or self.FullInitted then return end
		self:FullInit()
	end)

	self.HOffset = 0

	self.ToX = 0
	self.ToY = 0

	self.AppearTime = 0.2
	self.DisappearTime = 0.2

	self.AppearEase = 0.4
	self.DisappearEase = 0.2
	--self.Speed = 25

	self.Color = Color(40, 40, 40)
	self.TextColor = color_white:Copy()
	self:SetDrawOnTop(true)

	self.HOverride = nil

	self.FormattedText = {}
	self.DoneText = {}
	self.LatestKey = nil

	self.Middle = 0.5

	self.YAlign = 2

	self.wwrapped = {}

	self.Separators = {}
	self.SepH = 0

	self.MinW = 0
	self.MaxW = 192

	self._MaxWidth = 0 --internal; the maximum registered width

	self.Shadow = {}
	self.DrawShadow = true

	CLOUDS[#CLOUDS + 1] = self
end

function Cloud:OnRemove()
	self:Emit("Remove")
end

function Cloud:GetCurWidth()
	return math.min(math.max(self._MaxWidth, self.LabelWidth + 16, self.MinW), self.MaxW)
end

function Cloud:MoveAbove(pnl, px)
	local x, y = pnl:LocalToScreen(pnl:GetWide() / 2, 0)

	self:SetAbsPos(x, y - (px or 8))
end

function Cloud:SetLabel(txt)
	self.Label = tostring(txt)

	surface.SetFont(self.Font)
	local w = (surface.GetTextSize(self.Label))

	if w > self.MaxW then -- uh oh time to wordwrap
		local wrapped = string.WordWrap2(self.Label, self.MaxW)
		local maxW = 0
		for s, line in eachNewline(wrapped) do
			maxW = math.max(maxW, (surface.GetTextSize(s)))
		end

		w = maxW
	end

	self.LabelWidth = w

end

Cloud.SetText = Cloud.SetLabel

function Cloud:SetColor(col, g, b, a)
	if IsColor(col) then self.Color = col return end
	self.Color = Color(col or 70, g or col or 70, b or col or 70, a or 255)
end

function Cloud:SetTextColor(col, g, b, a)
	if IsColor(col) then self.TextColor = col return end
	self.TextColor = Color(col or 70, g or col or 70, b or col or 70, a or 255)
end

function Cloud:SetFont(font)
	self.Font = font

	surface.SetFont(self.Font)
	self.LabelWidth = (surface.GetTextSize(self.Label))

end

function Cloud:PostPaint()

end

function Cloud:PrePaint()

end

function Cloud:Paint()

	if not self.FullInitted then return end
	if self.Bonded and (not self.Bonded:IsValid() or not self.Bonded:IsVisible()) then self:Remove() return end

	local prevent = self:PrePaint()
	if prevent == true then return end

	if self:GetAlpha() <= 1 then return end

	if self.LastThink ~= FrameNumber() then
		-- dumb issue where a hidden panel can paint but not think
		self:Think()
		if not self:IsValid() then return end -- could've been removed in those thinks
		self:AnimationThinkInternal()
		if not self:IsValid() then return end
	end

	local cw = math.min(math.max(self._MaxWidth, self.LabelWidth + 16, self.MinW), self.MaxW)

	local lab = self.wwrapped[self.Label] or string.WordWrap2(self.Label, cw, self.Font)

	self.wwrapped[self.Label] = lab

	surface.SetFont(self.Font)

	local ch = 0

	local tw, th = surface.GetTextSize(lab)

	ch = self.HOverride or th

	local xoff = (self.OffsetX or 4) + self.ToX * self.Frac
	local yoff = (self.OffsetY or 0) + self.ToY * self.Frac

	local finY = 0

	local aY = -math.Clamp(self.YAlign, 0, 2) / 2

	local boxh = ch + 4 + self.SepH

	local lasttext = ""

	local doneText = self.DoneText
	local doneLen = #doneText

	for k = 1, doneLen do
		local v = doneText[k]

		if istable(v) then
			if not v.Continuation then
				lasttext = v.Text
			else
				lasttext = lasttext .. v.Text
			end

			boxh = boxh + v.YOff

			if v.Font then
				surface.SetFont(v.Font)
			else
				surface.SetFont(self.DescFont)
			end

		elseif ispanel(v) then
			boxh = boxh + v:GetTall()
		end

	end

	finY = yoff + boxh * aY

	local oldX, oldY = xoff, finY

	DisableClipping(true)

		if self.Shadow and self.DrawShadow then
			BSHADOWS.BeginShadow()
			xoff, finY = self:LocalToScreen(xoff, finY)
		end

		-- the box of the cloud
		local X = xoff - cw*self.Middle
		local Y = finY

		draw.RoundedBox(4, X, Y, cw, boxh, self.Color)

		if self.Shadow then
			local int = self.Shadow.intensity or 3
			local spr = self.Shadow.spread or 1
			local blur = self.Shadow.blur or 1
			local alpha = self.Shadow.alpha or self.Shadow.opacity or 255
			local color = self.Shadow.color or nil

			BSHADOWS.EndShadow(int, spr, blur, alpha, 0, 1, nil, color)

			xoff, finY = oldX, oldY

			X = xoff - cw*self.Middle
			Y = finY
		end

		-- draw the label
		local labX = X + 8

		if self.AlignLabel == 1 then
			labX = X + cw / 2
		elseif self.AlignLabel == 2 then
			labX = X + cw - 8
		end

		draw.DrawText(lab, self.Font, labX, Y + 2, self.TextColor, self.AlignLabel)

		local offy = finY + ch + 2

		-- there's a separator at index 0 which means
		-- right after the label, not after a formatted text

		if self.Separators[0] then
			local sep = self.Separators[0]

			surface.SetDrawColor(sep.col)

			local sx = sep.offx
			local sy = sep.offy

			surface.DrawLine(X + sx, offy + sy, X + cw - sx, offy + sy)
			offy = offy + sy*2
		end

		-- now draw all the formatted text

		for k = 1, doneLen do--,v in ipairs(self.DoneText) do
			local v = doneText[k]

			if ispanel(v) then
				if not v.NoCloudFit and v:GetWide() ~= cw then v:SetWide(cw) end
				local scrX, scrY = self:LocalToScreen(X, offy)
				v:PaintAt(scrX + v.X, scrY)
				offy = offy + v:GetTall()
			else

				local font = v.Font or self.DescFont
				local tx = xoff + (v.X or 8) - cw*self.Middle
				-- text first
				if v.Align == 1 then
					tx = X + cw / 2
				elseif v.Align == 2 then
					tx = X + cw - 8
				end

				draw.DrawText(v.Text, font, tx, offy, v.Color, v.Align or 0)

				offy = offy + v.YOff

				-- check if that text had a separator after it
				if self.Separators[k] then
					local sep = self.Separators[k]

					surface.SetDrawColor(sep.col)

					local sx = sep.offx
					local sy = sep.offy

					surface.DrawLine(X + sx, offy + sy, X + cw - sx, offy + sy)
					offy = offy + sy*2
				end

			end
		end

	DisableClipping(false)

	self:PostPaint()
end

function Cloud:AddFormattedText(txt, col, font, overy, num, align) --if you're updating the text, for example, you can use "num" to position it where you want it

	local wid = (self.MaxW or self._MaxWidth or self.MinW)
	local nd = string.WordWrap2(txt, wid, font or self.Font)

	local yo = 0


	surface.SetFont(font or self.DescFont)

	local wid, chary = surface.GetTextSize(nd)
	self._MaxWidth = math.Clamp(wid + 16, math.max(self.MinW, self._MaxWidth), self.MaxW)

	--overy allows you to override the Y offset

	yo = overy or chary

	local key = #self.DoneText + 1
	local tbl

	if num then
		for k,v in pairs(self.DoneText) do
			if v.prio == num then
				key = k
				tbl = v
				break
			end
		end
	end

	tbl = tbl or {}

	tbl.Text = nd
	tbl.Color = col
	tbl.YOff = yo
	tbl.Font = font
	tbl.prio = num

	if yo == 0 then --different colors but same string, happens
		tbl.Continuation = true
	end

	tbl.X = 8
	tbl.Align = align

	self.DoneText[key] = tbl

	table.sort(self.DoneText, function(a, b)
		local p1, p2 = a.prio, b.prio

		return (p1 and not p2) or (p1 and p2 and p1 < p2)
	end)

	self.LatestKey = key

	return #self.DoneText, tbl

end

function Cloud:AddSeparator(col, offx, offy, num)
	offx = offx or 4
	offy = offy or 2

	self.Separators[num or #self.DoneText] = {col = col or Color(70, 70, 70), offx = offx, offy = offy}
	self.SepH = self.SepH + offy * 2
end

function Cloud:ClearFormattedText()
	table.Empty(self.DoneText)
end

function Cloud:AddPanel(p, num)

	self._MaxWidth = math.Clamp(p:GetWide() + 16, math.max(self.MinW, self._MaxWidth), self.MaxW)
	p.IgnoreVisibility = true
	self.DoneText[num or (#self.DoneText + 1)] = p
end

function Cloud:SetAbsPos(x, y)
	-- does not work properly
	print("reminder: Cloud:SetAbsPos does not work properly")
	local sx, sy = self:ScreenToLocal(x, y)

	self.OffsetX = sx
	self.OffsetY = sy
end

function Cloud:SetRelPos(x, y)
	local myx, myy = self:GetPos()

	local sx = x and x - myx
	local sy = y and y - myy

	self.OffsetX = sx or self.OffsetX
	self.OffsetY = sy or self.OffsetY

end

function Cloud:Think()
	self.LastThink = FrameNumber()

	if self.Active then
		self:To("Frac", 1, self.AppearTime, 0, self.AppearEase)
		self.Frac = math.max(self.Frac, 0.01) --prevent disappearing for this frame
	else
		self:To("Frac", 0, self.DisappearTime, 0, self.DisappearEase)
	end

	if self.Frac == 0 and self.RemoveWhenDone then
		self:Remove()
		return
	end

	self:SetAlpha(self.Frac * 255)
end

function Cloud:FullInit()

	self.FullInitted = true

end

function Cloud:Popup(bool)

	self.Active = (bool == nil and true) or bool

end

function Cloud:Bond--[[age]](pnl)
	self.Bonded = pnl
end

vgui.Register("Cloud", Cloud, "Panel")