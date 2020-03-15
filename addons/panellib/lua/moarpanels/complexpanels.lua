local gu = Material("vgui/gradient-u")
local gd = Material("vgui/gradient-d")
local gr = Material("vgui/gradient-r")
local gl = Material("vgui/gradient-l")


--[[
	FListView
]]
local dlv = {}
function dlv:Init()

	self.BackgroundColor = Color(60, 60, 60)
end

function dlv:PostPaint()

end 

function dlv:PrePaint()

end 

function dlv:Draw(w, h)

	draw.RoundedBox(4, 0, 0, w, h, self.BackgroundColor or Color(60, 60, 60))

end

function dlv:Paint(w, h)

	self:PrePaint(w, h)
	self:Draw(w, h)
	self:PostPaint(w, h)

end 

--Copypasted with minor edits:

function dlv:AddLine( ... )

	self:SetDirty( true )
	self:InvalidateLayout()

	local Line = vgui.Create( "FListView_Line", self.pnlCanvas )
	local ID = table.insert( self.Lines, Line )

	Line:SetListView( self )
	Line:SetID( ID )

	-- This assures that there will be an entry for every column
	for k, v in pairs( self.Columns ) do
		Line:SetColumnText( k, "" )
	end

	for k, v in pairs( {...} ) do
		Line:SetColumnText( k, v )
	end

	-- Make appear at the bottom of the sorted list
	local SortID = table.insert( self.Sorted, Line )

	if ( SortID % 2 == 1 ) then
		Line:SetAltLine( true )
	end

	return Line

end

function dlv:AddColumn( strName, iPosition )

	local pColumn = nil

	if ( self.m_bSortable ) then
		pColumn = vgui.Create( "FListView_Column", self )
	else
		pColumn = vgui.Create( "FListView_ColumnPlain", self )
	end

	pColumn:SetName(strName)
	pColumn:SetZPos( 10 )
	pColumn:SetTall( 36 )
	pColumn:UpdateDraw()

	if ( iPosition ) then

		table.insert( self.Columns, iPosition, pColumn )

		for i = 1, #self.Columns do
			self.Columns[ i ]:SetColumnID( i )
		end

	else

		local ID = table.insert( self.Columns, pColumn )
		pColumn:SetColumnID( ID )

	end

	self:InvalidateLayout()

	return pColumn

end

vgui.Register("FListView", dlv, "DListView")

local flv_c = {}
local flv_l = {}

function flv_c:Init()
	self.Header.Paint = function() 
		return true 
	end

	self.Header:SetText("")
	self:SetText("")

	timer.Simple(0, function()

		if IsValid(self.Header) then 
			self.Header.PrePaint = self.PostPaint
			self.Header.PostPaint = self.PostPaint
			self.Header.Draw = self.Draw 


			self.Header.Paint = function(self, w, h)
				self:PrePaint(w, h)
				self:Draw(w, h)
				self:PostPaint(w, h)
			end

		end

	end)
	self.BackgroundColor = Color(90, 90, 90)
	self.OutlineColor = Color(50, 50, 50)

end
function flv_c:PostPaint()

end 

function flv_c:PrePaint()

end 

function flv_c:SetName(str)

	self.Header.Name = str 

end

function flv_c:Draw(w, h)

	draw.RoundedBox(4, 0, 0, w, h, self.OutlineColor or Color(50, 50, 50))
	draw.RoundedBox(4, 1, 1, w-2, h-2, self.BackgroundColor or Color(90, 90, 90))

	draw.SimpleText(self.Name or "???", "OSB18", w/2, h/2, color_white, 1, 1)

end

function flv_c:SetColor(col, g, b, a)
	if IsColor(col) then 
		self.BackgroundColor = col 
		self.Header.BackgroundColor = col
	return end 

	self.BackgroundColor = Color(col or 70, g or col or 70, b or col or 70, a or 255)
	self.Header.BackgroundColor = Color(col or 70, g or col or 70, b or col or 70, a or 255)
	--self.drawColor = self.Color
end

function flv_c:SetTextColor(col, g, b, a)

	if IsColor(col) then 
		self.TextColor = col 
		self.Header.TextColor = col
	return end 

	self.TextColor = Color(col or 70, g or col or 70, b or col or 70, a or 255)
	self.Header.TextColor = Color(col or 70, g or col or 70, b or col or 70, a or 255)
	--self.drawColor = self.Color
end

function flv_c:UpdateDraw()

	if IsValid(self.Header) then 
		self.Header.PrePaint = self.PostPaint
		self.Header.PostPaint = self.PostPaint
		self.Header.Draw = self.Draw 


		self.Header.Paint = function(self, w, h)
			self:PrePaint(w, h)
			self:Draw(w, h)
			self:PostPaint(w, h)
		end

	end

end

function flv_c:Paint(w, h)

	return true
end 

vgui.Register("FListView_Column", flv_c, "DListView_Column")

function flv_l:Init(w, h)
	local line = self 
	self.Align = {}

	timer.Simple(0, function()
		for k,v in pairs(self.Columns) do 
			local tx = v:GetText()
			v:SetText("")
			function v:Paint(w, h)
				local x, y = 0, 0 
				local ax, ay = 0, 1
				if line.Align and line.Align[k] and line.Align[k] == 0 then 
					x, y = 0, 0 

				elseif (line.Align[k] and line.Align[k] == 1) or not line.Align or not line.Align[k] then 
					x, y = w/2, h/2
					ax, ay = 1, 1 
				end

				local tc = self.TextColor or Color(235, 235, 235)

				v.drawColor = LC(v.drawColor or tc, tc, 35)

				draw.SimpleText(tx, "TW18", x, y, v.drawColor or Color(235, 235, 235), 1, 1)
			end 

		end 

	end)
end

function flv_l:SetTextColor(col, g, b, a)

	if IsColor(col) then 
		self.TextColor = col 
		for k,v in pairs(self.Columns) do 
			v.TextColor = col
		end
	return end 

	self.TextColor = Color(col or 70, g or col or 255, b or col or 255, a or 255)

	for k,v in pairs(self.Columns) do 
		v.TextColor = Color(col or 70, g or col or 255, b or col or 255, a or 255)
	end

end

local dark = {
	hov = Color(80, 80, 80),
	unhov = Color(55, 55, 55),
}

local bright = {
	hov = Color(75, 75, 75),
	unhov = Color(65, 65, 65)
}

function flv_l:Paint(w, h)

	local isdark = self:GetID()%2 == 1


	if self:IsSelected() then 

		for k,v in pairs(self.Columns) do 
			v.TextColor = self.SelectTextColor or Color(70, 180, 255)
		end

		self.BackgroundColor = Color(70, 80, 110)

	elseif self:IsHovered() then 

		for k,v in pairs(self.Columns) do 
			v.TextColor = self.SelectTextColor or Color(255, 255, 255)
		end

		local col = (isdark and dark.hov) or bright.hov

		self.BackgroundColor = col
	else

		for k,v in pairs(self.Columns) do 
			v.TextColor = self.TextColor or Color(235, 235, 235)
		end

		local col = (isdark and dark.unhov) or bright.unhov

		self.BackgroundColor = col
	end

	self.drawColor = LC(self.drawColor or self.BackgroundColor, self.BackgroundColor, 25)

	draw.RoundedBox(4, 0, 0, w, h, self.drawColor)

end
vgui.Register("FListView_Line", flv_l, "DListView_Line")




--[[
	EButton
]]

local ebutton = {}

function ebutton:Init()
	if self.Initted then return end 

	self:SetMinimumSize(60, 30)

	self.FakeH = 30

	self.FakeResize = false
	self.DrawShadow = false 

	self.ExpandTo = 90
			--self.ExpandW = yourval, has to be < than button
	if not self.ExpandPanel then 
		self:CreateExpandPanel(self:GetSize())
	end

	self.ResizeMult = 10
	self.Initted = true

	self.LastOKW = 60
	self.LastOKH = 30
	self.CT = CurTime()
end

function ebutton:CreateExpandPanel(w, h)

	w, h = w or self:GetWide(), h or self:GetTall()

	self.ExpandPanel = vgui.Create("InvisPanel", self)
	self.ExpandPanel:SetPos(0, h)
	self.ExpandPanel:SetSize(self.ExpandW or w, self.ExpandTo or 90)

	function self.ExpandPanel.Paint(me, w, h)
		self.ExpandPaint(me, w, h)
		me:SetSize(self:GetWide(), h)
	end

end

function ebutton:SetExpand(h)
	self.ExpandTo = h
	if IsValid(self.ExpandPanel) then 
		self.ExpandPanel:SetSize(self.ExpandW or self:GetWide(), self.ExpandTo or 90)
	end
end

function ebutton:GetExpand()
	return self.ExpandPanel
end

function ebutton:OnSizeChanged(w, h)
	if not self.ExpandPanel then self:Init(w, h) end 

	if not self.FakeResize then
		if CurTime() - self.CT > 0.1 then return end 	-- this is to prevent fucking dock resize
														-- i honestly dont know where it comes from and how to prevent it
		self.FakeH = h 

		self.ExpandPanel:SetPos(0, self.FakeH)
		self.ExpandPanel:SetSize(self.ExpandW or w, self.ExpandTo)

		return
	end

	self.FakeResize = false 

end

function ebutton:SizeToChildren()
end

function ebutton:SizeToContents()
end

function ebutton:PostPaint(w,h)

end

function ebutton:PrePaint(w,h)

end

function ebutton:ExpandPaint(w,h)
	draw.RoundedBoxEx(4, 0, 0, w, h, Color(35, 35, 35), false, false, true, true)
end

function ebutton:Think()
	local w, h = self:GetSize()
	self.FakeResize = true 
	if self.Expand then 

		self:SetSize(w, L(h, self.FakeH + self.ExpandTo, self.ResizeMult or 20, true))
		self.RBEx = {bl = false, br = false}

	else 

		self:SetSize(w, L(h, self.FakeH, self.ResizeMult or 20, self.FakeH * 0.1))

		if self.FakeH == h then self.RBEx = nil end
	end

end

function ebutton:OnClick()

end

function ebutton:DoClick()
	if self.Expandable == false then return end 
	local should = self:OnClick()
	
	if should ~= false then
		self.Expand = not self.Expand
	end
	
end

function ebutton:Paint(w, h)
	local h2 = self.FakeH

	self:PrePaint(w, h2)
	self:Draw(w, h2)
	self:PostPaint(w, h2)
end

vgui.Register("EButton", ebutton, "FButton")

local wrapped = {}


--[[-------------------------------------------------------------------------
 	FMenu
---------------------------------------------------------------------------]]
local FM = {}
local FMO = {}

function FMO:PerformLayout()

	self:SizeToContents()
	self:SetWide( self:GetWide() + 30 )

	local w = math.max( self:GetParent():GetWide(), self:GetWide() )

	self:SetSize( w, self.DesHeight or 26 )

	if ( IsValid( self.SubMenuArrow ) ) then

		self.SubMenuArrow:SetSize( 15, 15 )
		self.SubMenuArrow:CenterVertical()
		self.SubMenuArrow:AlignRight( 4 )

	end

	DButton.PerformLayout( self )
 	self.DragMouseRelease = function() return false end --Fuck you
end
vgui.Register("FMenuOption", FMO, "DMenuOption")

function FM:Init()
	self:SetSize(128, 1)
	self.Color = Color(10, 10, 10)
	self.Options = {}

	self.Font = "OSB24"
	self.DescriptionFont = "TW24"

	self:SetIsMenu(true)
	self:SetDrawOnTop(true)
	self:SetPos(self:GetParent():ScreenToLocal(gui.MousePos()))
	
	function self:GetDeleteSelf()
		return true 
	end

	RegisterDermaMenuForClose( self )

	timer.Simple(0, function() 
		if not IsValid(self) then return end 
		self:CreateDescription()
	end)

end
function FMO:Init()
	self.Color = Color(40, 40, 40)
	self.drawColor = Color(40, 40, 40)
	self.HovMult = 1.3
	if self:GetParent().WOverride then 
		local sx, sy = self:GetSize()
		self:SetSize(self:GetParent().WOverride, sy)
	end
end

function FMO:SetColor(col, g, b, a)
	if IsColor(col) then self.Color = col self.drawColor = col:Copy() return end 

	local c = self.Color
	c.r = col or 60
	c.g = g or 60
	c.b = b or 60
	c.a = a or 255
end

function FMO:SetHoverColor(col, g, b, a)
	if IsColor(col) then self.HoverColor = col return end 

	local c = self.HoverColor
	c.r = col or 60
	c.g = g or 60
	c.b = b or 60
	c.a = a or 255
end

function FMO:OnHover()

end
function FMO:OnUnhover()

end

function FMO:PreTextPaint(w, h)
end

function FMO:PostPaint(w, h)
end

function FMO:Paint(w,h)
	self.Text = self.Text or self:GetText()
	self:SetText("")
	local m = self:GetMenu()
	self.Hovered = self:IsHovered() --This is so fucking retarded but menu has issues of registering clicks because of default dlabel behavior
	if self:IsHovered() then 

		local bg = self.Color

		if self.HoverColor then 

			self.drawColor = LC(self.drawColor, self.HoverColor)

		else

			local hm = self.HovMult

			local fr = math.min(bg.r*hm, 255)
			local fg = math.min(bg.g*hm, 255)
			local fb = math.min(bg.b*hm, 255)

			self.drawColor = LCC(self.drawColor, fr, fg, fb)
		end

		if not self.WasHovered then 
			self:OnHover()
			self.WasHovered = true 
		end

		if self.DescPanel then self.DescPanel.Uncover = true end
	else
		local bg = self.Color
		self.drawColor = LC(self.drawColor, bg)
		if self.DescPanel then self.DescPanel.Uncover = false end

		if self.WasHovered then 
			self:OnUnhover()
			self.WasHovered = false 
		end

	end

	surface.SetDrawColor(self.drawColor)
	surface.DrawRect(0,0,w,h)

	self:PreTextPaint(w, h)

	local txo = 8
	if self.Icon then 
		surface.SetMaterial(self.Icon)
		local iw, ih = self.IconW or h-4, self.IconH or h-4
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(2, h/2-ih/2, iw, ih)
		txo = iw + (self.IconPad or 8)
	end

	

	draw.SimpleText(self.Text, self.Font or m.Font, txo, h/2, Color(255,255,255), 0, 1)

	self:PostPaint(w, h) 

end
function FM:PerformLayout()

	local w = self:GetMinimumWidth()

	-- Find the widest one
	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do

		pnl:PerformLayout()
		w = math.max( w, pnl:GetWide() )

	end

	self:SetWide( self.WOverride or w )

	local y = 0 -- for padding

	for k, pnl in pairs( self:GetCanvas():GetChildren() ) do
		
		pnl:SetWide( w )
		pnl:SetPos( 0, pnl.PutMeAtY or y )

		y = y + pnl:GetTall()

	end

	y = math.min( y, self:GetMaxHeight() )

	self:SetTall( y )

	derma.SkinHook( "Layout", "Menu", self )

	DScrollPanel.PerformLayout( self )

end

function FM:CreateDescription()
	local f = vgui.Create("DPanel", self)
	f:SetSize(250, 1)
	self.DescPanel = f
	f.desc = "fuk"
	local m = self

	function f:Paint(w,h)

		if not wrapped[self.desc] or wrapped[self.desc].font ~= m.DescriptionFont then 
			wrapped[self.desc] = {txt = string.WordWrap(self.desc, w-12, m.DescriptionFont), font = m.DescriptionFont}
		end

		surface.DisableClipping(true)
			surface.SetDrawColor(Color(40,40,40))
			surface.DrawRect(0,0,w,h)

			surface.SetFont(m.DescriptionFont)
			local tx, ty = surface.GetTextSize("l") --highest letter, usually
			local _, amt = string.gsub(wrapped[self.desc].txt, "\n", "")
			local lx, ly = self:LocalToScreen(0,0)
			render.SetScissorRect(lx,ly,lx+w,ly+h,true)
				self.DescY = 24 + ty * amt + 4
				draw.DrawText(wrapped[self.desc].txt, m.DescriptionFont, 8, 2, Color(255,255,255), 0)
			render.SetScissorRect(0,0,0,0,false)

		surface.DisableClipping(false)
	end

	function f:Think()

		local hov = false 
		
		for k,v in pairs(m:GetCanvas():GetChildren()) do 
			if v==self then continue end

			if v.Description and v:IsHovered() then 
				hov = true
				self.desc = v.Description
			end

		end
		if self:IsHovered() then -- use last description
			hov = true 
		end
		if hov then 
			self:SetTall(L(self:GetTall(), self.DescY or 50, 15, true))
		else 
			self:SetTall(L(self:GetTall(), 0, 15, true))
		end
		
	end

	self:AddPanel(f)


end

function FM:AddOption( strText, funcFunction )

	local pnl = vgui.Create( "FMenuOption", self )
	pnl:SetMenu( self )
	pnl:SetText( strText )
	pnl.DesHeight = 28

	if ( funcFunction ) then pnl.DoClick = funcFunction end

	self:AddPanel( pnl )
	
	return pnl

end

function FM:Paint(w,h)
	surface.DisableClipping(true)
	draw.RoundedBox(4, -2, -2, w+4, h+4, self.Color)
	local sx, sy = self:LocalToScreen(0, 0)
	if sy+h > ScrH() then 
		self:SetPos(sx, L(self.Y, ScrH() - h - 12, 15, true))
	end
	surface.DisableClipping(false)
end

vgui.Register("FMenu", FM, "DMenu")



--[[-------------------------------------------------------------------------
--  Pop-up Cloud (It's crappy)

	Cloud:SetLabel(txt)
	Cloud.SetText = Cloud.SetLabel

	Cloud:SetColor(col, g, b, a)
	Cloud:SetTextColor(col, g, b, a)

	Cloud:AddFormattedText(txt, col, font, overy, num)	--num: index for tbl(can replace texts); overy = y offset(leave nil to default)
	Cloud:ClearFormattedText()

	Cloud:SetAbsPos(x, y)

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
	
		Cloud.Middle 	-- 0-1 (or less/more for full zane)

		Cloud.YAlign	--like text aligns, except the cloud aligns there : 0/1/2
						--by default it's 2 which means align by bottom (because it's a cloud)

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
	self.Color = Color(35, 35, 35)
	self.Font = "OS24"
	self.DescFont = "OSL18"
	self:SetSize(2,2)
	self:SetPos(2,2)
	self:SetAlpha(0)
	self:SetMouseInputEnabled(false)

	self.Label = "No label!"
	self.LabelWidth = 64

	timer.Simple(0, function()
		if not IsValid(self) or self.FullInitted then return end
		self:FullInit()
	end)

	self.HOffset = 0

	self.ToX = nil 
	self.ToY = nil 

	self.Speed = 25

	self.Color = Color(40, 40, 40)
	self.TextColor = Color(255,255,255)
	self:SetDrawOnTop(true)

	self.HOverride = nil 

	self.FormattedText = {}
	self.DoneText = {}
	self.LatestKey = nil 

	self.Middle = 0.5

	self.YAlign = 2

	self.wwrapped = {}

	self.Seperators = {}
	self.SepH = 0

	self.MinW = 0
	self.MaxW = 192

	self.MaxWidth = 0 --internal; the maximum registered width

	self.Shadow = {}
	self.DrawShadow = true

	CLOUDS[#CLOUDS + 1] = self
end

function Cloud:MoveAbove(pnl, px)
	local x, y = pnl:LocalToScreen(pnl:GetWide() / 2, 0)

	self:SetAbsPos(x, y - (px or 8))
end

function Cloud:SetLabel(txt)
	self.Label = txt

	surface.SetFont(self.Font)
	self.LabelWidth = (surface.GetTextSize(txt))

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

local wwrapped = {}

function Cloud:PostPaint()

end

function Cloud:PrePaint()

end
local max = math.max 

function Cloud:Paint()

	if not self.FullInitted then return end 
	if self.Bonded and not IsValid(self.Bonded) then self:Remove() return end 

	local prevent = self:PrePaint()
	if prevent==true then return end 

	if self:GetAlpha() <= 1 then return end 

	local cw = math.min(math.max(self.MaxWidth, self.LabelWidth + 16, self.MinW), self.MaxW)

	local lab = self.wwrapped[self.Label] or string.WordWrap(self.Label, cw, self.Font)

	self.wwrapped[self.Label] = lab 

	surface.SetFont(self.Font)

	local ch = 0

	local tw, th = surface.GetTextSize(lab)

	ch = self.HOverride or th
	
	local xoff = self.OffsetX or 4
	local yoff = self.OffsetY or 0

	local finX = 0
	local finY = 0

	local aY = -math.Clamp(self.YAlign, 0, 2) / 2

	local frmtd = false 

	local boxh = ch + 4 + self.SepH

	local lasttext = ""

	for k,v in ipairs(self.DoneText) do 
		if not v.Continuation then 
			lasttext = v.Text 
		else 
			lasttext = lasttext .. v.Text 
		end

		boxh = boxh + v.YOff
		frmtd = true 
		
		if v.Font then 
			surface.SetFont(v.Font)
		else 
			surface.SetFont(self.DescFont)
		end

		if not self.DoneText[k + 1] then 
			boxh = boxh + 4 
		end
	end

	finY = yoff + boxh * aY

	local oldX, oldY = xoff, finY 

	surface.DisableClipping(true)

		if self.Shadow and self.DrawShadow then 
			--surface.DisableClipping(false)
			BSHADOWS.BeginShadow()
			xoff, finY = self:LocalToScreen(xoff, finY)--self:GetPos()
		end

		draw.RoundedBox(4, xoff - cw*self.Middle, finY, cw, boxh, self.Color)

		if self.Shadow then 
			local int = self.Shadow.intensity or 3
			local spr = self.Shadow.spread or 1
			local blur = self.Shadow.blur or 1
			local alpha = self.Shadow.alpha or self.Shadow.opacity or 255
			local color = self.Shadow.color or nil

			BSHADOWS.EndShadow(int, spr, blur, alpha, 0, 1, nil, color)

			xoff, finY = oldX, oldY
		end

		draw.DrawText(lab, self.Font, xoff + 8 - cw*self.Middle,  finY + 2, self.TextColor, 0)

		local offy = finY + ch + 4

		for k,v in ipairs(self.DoneText) do 

			local font = v.Font or self.DescFont
			local tx = xoff + 8 - cw*self.Middle

			draw.DrawText(v.Text, font, xoff + 8 - cw*self.Middle,  offy, v.Color, 0)

			offy = offy + v.YOff

			if self.Seperators[k] then 
				local sep = self.Seperators[k]

				surface.SetDrawColor(sep.col)

				local sx = sep.offx
				local sy = sep.offy

				surface.DrawLine(xoff - cw*self.Middle + sx, offy + sy, (xoff - cw*self.Middle) + cw - sx, offy + sy)
				offy = offy + sy*2
			end
		end

	surface.DisableClipping(false)

	self:PostPaint()
end

function Cloud:AddFormattedText(txt, col, font, overy, num) --if you're updating the text, for example, you can use "num" to position it where you want it

	local wid = (self.MaxW or self.MaxWidth or self.MinW) - 16

	local nd = string.WordWrap2(txt, wid, font or self.Font)

	local yo = 0
	

	surface.SetFont(font or self.DescFont)

	local wid, chary = surface.GetTextSize(nd)
	self.MaxWidth = math.Clamp(wid + 16, math.max(self.MinW, self.MaxWidth), self.MaxW)

	--overy allows you to override the Y offset
	print("chary is", chary)
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
		tbl = tbl or {}
	else 
		tbl = {}
	end

	tbl.Text = nd
	tbl.Color = col
	tbl.YOff = yo
	tbl.Font = font 
	tbl.prio = num

	if yo == 0 then --different colors but same string, happens
		tbl.Continuation = true 
	end


	self.DoneText[key] = tbl

	table.sort(self.DoneText, function(a, b)
		local p1, p2 = a.prio, b.prio

		return (p1 and not p2) or (p1 and p2 and p1 < p2)
	end)

	self.LatestKey = key

	return #self.DoneText, tbl

end

function Cloud:AddSeperator(col, offx, offy, num)
	offx = offx or 4 
	offy = offy or 2 

	self.Seperators[#self.DoneText] = {col = col or Color(70, 70, 70), offx = offx, offy = offy}
	self.SepH = self.SepH + offy*2
end

function Cloud:ClearFormattedText()

	table.Empty(self.DoneText)

end


function Cloud:SetAbsPos(x, y)
	local sx, sy = self:ScreenToLocal(x, y)--self:GetParent():ScreenToLocal(x,y)

	self.OffsetX = sx
	self.OffsetY = sy

end

function Cloud:SetRelPos(x, y)
	local myx, myy = self:GetPos() 
	local sx, sy = x - myx, y - myy

	self.OffsetX = sx
	self.OffsetY = sy

end

function Cloud:Think()

	if self.Active then 
		
		self:SetAlpha(L(self:GetAlpha(), 255, self.Speed, true))

	else 
		self:SetAlpha(L(self:GetAlpha(), 0, self.Speed, true))
		if self:GetAlpha() == 0 and self.RemoveWhenDone then self:Remove() return end
	end

end

function Cloud:FullInit()

	self.FullInitted = true

end

function Cloud:Popup(bool)

	self.Active = bool

end

function Cloud:Bond--[[age]](pnl)
	self.Bonded = pnl
end

vgui.Register("Cloud", Cloud, "Panel")

--[[

FIconLayout
	this barely works; don't use it
]]
local FIC = {}

function FIC:Init()

	self.PadX = 4
	self.PadY = 8 

	self.MarginX = 4
	self.MarginY = 8

	self.CenterX = true 
	self.CenterNotFull = false 

	self.CenterY = false 

	self.CurX = 0
	self.CurY = 0

	self.AutoMove = false --May be performance-expensive; automatically move icons if they change width
	self.AutoMoveRow = false --Same but also change rows 

	self.Column = 0
	self.Row = 0

	self.YDiff = nil --change this if necessary

	self.MaxH = 0
	self.MaxW = 0

	self.PostInitted = false

	self.Rows = {}

	self.CurRow = 1
	self.CurColumn = 1

	self.Color = Color(40, 40, 40)
	self.drawColor = self.Color:Copy()

end

function FIC:SetColor(col, g, b, a)
	if IsColor(col) then self.Color = col return end 

	local c = self.Color
	c.r = col or 70
	c.g = g or 70
	c.b = b or 70
	c.a = a or 255
end

function FIC:Paint(w, h)

	if not self.PostInitted then 
		self.PostInitted = true 

		self.CurX = self.PadX
		self.CurY = self.PadY
	end

	draw.RoundedBox(8, 0, 0, w, h, self.Color)
	
end


function FIC:UpdateSize(p, currow, w, h)

	if self.CurX + w + self.MarginX > self:GetWide() - self.PadX*2 then 
		self.CurX = self.PadX
		self.CurY = self.CurY + h + self.MarginY

		self.CurRow = self.CurRow + 1 

		self:AutoCenter()

		self.Rows[self.CurRow] = {}
		if self.CenterX then 
			self:AutoCenter()
		end
		return
	end

	

	if self.AutoMove then
		self.CurX = self.PadX
		for k,v in ValidIPairs(currow) do 
			v.X = self.CurX 

			self.CurX = self.CurX + self.MarginX + v:GetWide()
		end

	else 
		self.CurX = self.CurX - p:GetWide() + w
	end

	if self.CenterNotFull then 
		self:AutoCenter()
	end
end

function FIC:AutoCenter(w, h)	--w, h = workaround for panel not updating GetWide

	for num, row in pairs(self.Rows) do 
		
		local pnlsw = 0

		for k, pnl in ValidIPairs(row) do 
			pnlsw = pnlsw + (w or pnl:GetWide())
		end

		pnlsw = pnlsw + (#GetValids(row) - 1) * self.MarginX 
		local pad = (self:GetWide() - pnlsw)/2
		local lastX = pad

		for k, pnl in ValidIPairs(row) do 
			pnl.X = lastX
			lastX = lastX + (w or pnl:GetWide()) + self.MarginX
		end

	end

end

function FIC:Add(name)

	if not self.PostInitted then 
		self.PostInitted = true 

		self.CurX = self.PadX
		self.CurY = self.PadY
	end

	local currow = self.Rows[self.CurRow]
	local rownum = self.CurRow 

	if not currow then 
		self.Rows[self.CurRow] = {}
		currow = self.Rows[self.CurRow]
	end

	local p

	if isstring(name) then
		p = vgui.Create(name, self)
	elseif ispanel(name) then
		p = name 
		p:SetParent(self)
	end

	p:SetPos(self.CurX, self.CurY)

	local lw, lh = p:GetSize()

	self.CurX = self.CurX + self.MarginX + lw

	self.MaxH = math.max(self.MaxH, lh)
	self.MaxW = math.max(self.MaxW, lw)

	currow[#currow + 1] = p

	function p.OnSizeChanged(p, w, h)
		self.MaxH = math.max(self.MaxH, h)
		self.MaxW = math.max(self.MaxW, w)

		self.CurX = self.CurX + w - lw 

		lw, lh = w, h

		self:UpdateSize(p, currow, w, h)
	end

	return p
end

vgui.Register("FIconLayout", FIC, "Panel")


local Testing = false

if not Testing then return end 

if IsValid(TestFrame) then 
	TestFrame:Remove()
end

TestFrame = vgui.Create("FFrame")
local f = TestFrame 

f:SetSize(750, 600)
f:Center()

f:MakePopup()
f.Shadow = {}

local scr = vgui.Create("FScrollPanel", f)
scr:SetSize(500, 400)
scr:Center()

local p = math.PointIn2DBox


local tx = vgui.Create("CH_Text", scr)
tx:SetSize(scr:GetWide(), 120)
tx:Dock(TOP)

tx:AddText("Stick your finger in my ass")
tx:AddText(" ya", Color(255, 230, 230))
tx:AddText(" fucking", Color(255, 180, 180))
local btn = tx:AddClickableText(" SLAVE", Color(255, 120, 120), "OS24")
local i = "fuck "

function btn:DoClick()
	self:SetText(" clicked dicknigga aeiou " .. i)
	i = i .. "fuck "
end


function btn:Paint(x, y, w, h)
	draw.RoundedBox(4, x, y, w, h, Color(50, 150, 250, 100))
end

tx:AddText(" help", Color(255, 120, 120), "OS24")

local btn2 = tx:AddClickableText(" wow another clickable!!!", Color(40, 140, 250), "OS24")

local randoms = {
	"i dont do much",
	"i just pick random phrases from a table",
	"i can also repeat myself sometimes",
	"but thats ok",
	"im made for just testing after all",
	"so how was your day?",
	"cuz i spent all day ruining my eyesight in front of a computer."
}
function btn2:DoClick()
	self:SetText(table.Random(randoms))
end

function btn2:Paint(x, y, w, h)
	draw.RoundedBox(4, x, y, w, h, Color(150, 50, 50, 100))
end

--[[
local cloud = vgui.Create("Cloud", f)
cloud:AddFormattedText("poop", Color(50, 150, 250), "OS24")
cloud:AddFormattedText(" stink", Color(255, 255, 255), "OS24", 0)

cloud:AddSeperator()

cloud:AddFormattedText("gay", Color(255, 255, 255), "OS24")

function ics:Think()

	if self:IsHovered() then 
		cloud:Popup(true)
		cloud:SetAbsPos(gui.MouseX(), gui.MouseY())
	end

end
]]