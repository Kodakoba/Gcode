local PANEL = {}
local BLANK = {}
local BlankFunc = function() end 
local blankfunc = BlankFunc 

local gu = Material("vgui/gradient-u")
local gd = Material("vgui/gradient-d")
local gr = Material("vgui/gradient-r")
local gl = Material("vgui/gradient-l")


function LC(col, dest, vel)
    local v = vel or 10
    if not IsColor(col) or not IsColor(dest) then return end

    col.r = Lerp(FrameTime()*v, col.r, dest.r)
    col.g = Lerp(FrameTime()*v, col.g, dest.g)
    col.b = Lerp(FrameTime()*v, col.b, dest.b)

    if dest.a ~= col.a then
    	col.a = Lerp(FrameTime()*v, col.a, dest.a)
    end

    return col
end

function LCC(col, r, g, b, a, vel)
	local v = vel or 10


    col.r = Lerp(FrameTime()*v, col.r, r)
    col.g = Lerp(FrameTime()*v, col.g, g)
    col.b = Lerp(FrameTime()*v, col.b, b)

    if a and a ~= col.a then
    	col.a = Lerp(FrameTime()*v, col.a, a)
    end

    return col
end

function L(s,d,v,pnl)
    if not v then v = 5 end
    if not s then s = 0 end
    local res = Lerp(FrameTime()*v, s, d)
    if pnl then 
        local choose = (res>s and "ceil") or "floor"
        res = math[choose](res) 
    end
    return res
end

Colors = Colors or {}

--[[-------------------------------------------------------------------------
-- 	FPanel
---------------------------------------------------------------------------]]

local greyed = Color(80, 80, 80)
local btngrey = Color(70, 70, 70)

Colors.Button = btngrey

local close_hov = Color(235, 90, 90)
local close_unhov = Color(205, 50, 50)

local RED = Color(255, 0, 0)
local DIM = Color(30, 30, 30, 210)

function PANEL:Init()

	self:SetSize(128, 128)
	self:Center()
	self:SetTitle("")
	self:ShowCloseButton(false)
	local w,h = self:GetSize()

	local b = vgui.Create("DButton", self)
	self.CloseButton = b 
	b:SetPos(w - 72, 2)
	b:SetSize(64, 24)
	b:SetText("")
	b.Color = Color(205, 50, 50)

	function b:Paint(w,h)
		b.Color = LC(b.Color, (self.PreventClosing and greyed) or (self:IsHovered() and close_hov) or close_unhov, 15)
		draw.RoundedBox(4, 0, 0, w, h, b.Color)
	end

	b.DoClick = function()
		if self.PreventClosing then return end 
		
		if self.OnClose then 
			local ret = self:OnClose()
			if ret==false then return end 
		end

		self:Remove()
	end
	self.m_bCloseButton = b
	self.Width, self.Height = w,h
	self.HeaderSize = 32
	self.BackgroundColor = Color(50, 50, 50)
	self.HeaderColor = Color(40, 40, 40)

	self.DimColor = Color(0, 0, 0, 220)

	self:DockPadding(4, 32, 4, 4)


	self.SizableNum = 3

	self.SizableBoxX = 1
	self.SizableBoxY = 1 	--bottom right, like the default
end


function PANEL:SetColor(r, g, b)

	if IsColor(r) then 
		self.BackgroundColor = r 
		local h, s, v = ColorToHSV(r)
		self.HeaderColor = HSVToColor(h, s*0.9, v*0.8)
	else

		local bgc = self.BackgroundColor
		bgc.r = r
		bgc.g = g
		bgc.b = b 

		local h, s, v = ColorToHSV(bgc)
		self.HeaderColor = HSVToColor(h, s*0.9, v*0.8)

	end

end


function PANEL:SetCloseable(bool,remove)
	self.PreventClosing = not bool --shh
	if remove and IsValid(self.CloseButton) then 
		self.CloseButton:Remove()
	end
end

surface.CreateFont( "PanelLabel", {
	font = "Titillium Web SemiBold",
	size = 30,
	weight = 200,
	antialias = true,
} )
local ceil = math.ceil
function PANEL:OnChangedSize(w,h)

end

function PANEL:GetColor()
	return self.BackgroundColor 
end

function PANEL:OnSizeChanged(w,h)
	if IsValid(self.m_bCloseButton) then 
		self.m_bCloseButton:SetPos(w - 72, 2)
	end
	self.Width = w 
	self.Height = h
	self:OnChangedSize(w,h)

end


local rots = {
	180,
	90,
	0,
	270
}

function PANEL.DrawHeaderPanel(self, w, h)
	self.DraggableH = self.HeaderSize

	local rad = self.RBRadius or 8

	local hc = self.HeaderColor
	local bg = self.BackgroundColor

	local label = self.Label or self.Title or nil

	local icon = (self.Icon and self.Icon.mat) or nil

	local x,y = 0, 0

	if self.Shadow then 
		--surface.DisableClipping(false)
		BSHADOWS.BeginShadow()
		x, y = self:LocalToScreen(0, 0)
	end

	local hh = self.HeaderSize
	local tops = true 

	if hh > 0 then
		draw.RoundedBoxEx(self.HRBRadius or rad, x, y, w, hh, hc, true, true)
		tops = false
	end
	draw.RoundedBoxEx(rad, x, y+hh, w, h-hh, bg, tops, tops, true, true)

	if label then
		local xoff = 12

		if icon and icon.IsError and not icon:IsError() then
			local w2, h2 = self.Icon.w or 16, self.Icon.h or 16
			xoff = xoff + w2 + 6
			surface.SetDrawColor(255,255,255, 255)
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(x+8, y+(hh-h2)/2, w2, h2)

		end

		draw.SimpleText(label, "PanelLabel", x+xoff, y, color_white, 0, 2)
	end

	if self:GetSizable() then 	--i spent like 3 hours on sizable support for FPanels from any corner, holy shit
		local sx, sy, sw, sh = self:GetSizableBounds()

		local nx, ny = x + self.SizableBoxX * self:GetWide(), y + self.SizableBoxY * self:GetTall()
		
		local rot = rots[self.SizableNum]

		local c = math.cos( math.rad( rot ) )
		local s = math.sin( math.rad( rot ) )	--:pensive:

		

		local x0, y0 = sw/2, -sh/2
		local newx = y0 * s - x0 * c
		local newy = y0 * c + x0 * s

		sw, sh = sw - 2, sh - 2

		surface.DisableClipping(true)
		surface.SetDrawColor(Colors.LighterGray)

		surface.DrawMaterial("https://i.imgur.com/v87KhLv.png", "draglines.png", nx + newx, ny + newy, sw - 2, sh - 2, rot)

		surface.DisableClipping(false)
	end

	if self.Shadow then 
		local int = self.Shadow.intensity or 2
		local spr = self.Shadow.spread or 2
		local blur = self.Shadow.blur or 2
		local alpha = self.Shadow.alpha or self.Shadow.opacity or 255

		local color = self.Shadow.color or nil
		local color2 = self.Shadow.color2 or nil

		BSHADOWS.EndShadow(int, spr, blur, alpha, nil, nil, nil, color, color2)
		--surface.DisableClipping(true)
	end



end


--[[

	1		2


	4		3

]]

function PANEL:SetSizablePos(num)

	local XPos = (math.ceil((num - 1) / 2) == 1 and 1) or 0

	local YPos = math.ceil(num / 2) - 1

	self.SizableNum = num 

	self.SizableBoxX = XPos 
	self.SizableBoxY = YPos
end

function PANEL:SetSizableSize(w, h)
	self.SizableW, self.SizableH = w, h
end

function PANEL:GetSizableBounds()
	local boxX, boxY = self.SizableBoxX * self:GetWide(), self.SizableBoxY * self:GetTall()

	local boxW, boxH = 20, 20

	if self.SizableBoxX > 0 then 
		boxX = boxX - boxW 
	end

	if self.SizableBoxY > 0 then 
		boxY = boxY - boxH 
	end

	return boxX, boxY, boxW, boxH
end

function PANEL:GetSizableSize()
	return self.SizableW, self.SizableH
end

local cursors = {
	[0] = {[0] = "sizenwse", [1] = "sizenesw"},
	[1] = {[0] = "sizenesw", [1] = "sizenwse"}
}

function PANEL:Think()

	local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
	local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

	local screenX, screenY = self:LocalToScreen( 0, 0 )

	if ( self.Dragging ) then

		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if ( self:GetScreenLock() ) then

			x = math.Clamp( x, 0, ScrW() - self:GetWide() )
			y = math.Clamp( y, 0, ScrH() - self:GetTall() )

		end

		self:SetPos( x, y )

	end

	local boxX, boxY = self.SizableBoxX * self:GetWide(), self.SizableBoxY * self:GetTall()
	local boxW, boxH = 20, 20

	if self.SizableBoxX > 0 then 
		boxX = boxX - boxW 
	end

	if self.SizableBoxY > 0 then 
		boxY = boxY - boxH 
	end

	local sbX, sbY = self:LocalToScreen(boxX, boxY)
	local mX, mY = self:ScreenToLocal(mousex, mousey)

	self:On("Think")

	if ( self.Sizing ) then

		local otherX, otherY = bit.band(self.SizableBoxX + 1, 1), bit.band(self.SizableBoxY + 1, 1) 

		local mulX, mulY = -self.SizableBoxX, -self.SizableBoxY

		local anchorX, anchorY = self:GetWide() * otherX, self:GetTall() * otherY 
		anchorX, anchorY = self:LocalToScreen(anchorX, anchorY)

		local x = mousex - self.Sizing[1]
		local y = mousey - self.Sizing[2]

		if self.SizableBoxX > 0 then 
			x = self.Sizing[1] - mousex
		end

		if self.SizableBoxY > 0 then 
			y = mousey - self.Sizing[2]
		end

		local px, py = self:GetPos()

		

		local oldsizeX, oldsizeY = self:GetSize()
		local newsizeX, newsizeY = 0, 0

		if self.SizableBoxY == 0 then 
			newsizeY = self:GetTall() - mY
		else 
			newsizeY = mY
		end

		if self.SizableBoxX == 0 then 
			newsizeX = self:GetWide() - mX
		else 
			newsizeX = mX
		end

		if ( newsizeX < self.m_iMinWidth ) then newsizeX = self.m_iMinWidth elseif ( newsizeX > ScrW() - px && self:GetScreenLock() ) then newsizeX = ScrW() - px end
		if ( newsizeY < self.m_iMinHeight ) then newsizeY = self.m_iMinHeight elseif ( newsizeY > ScrH() - py && self:GetScreenLock() ) then newsizeY = ScrH() - py end

		local sizediffX, sizediffY = newsizeX - oldsizeX, newsizeY - oldsizeY

		self:SetSize(newsizeX, newsizeY)

		if self.SizableBoxY == 0 then --size handle is at the top; need to shift downwards
			self.Y = self.Y - sizediffY
		end

		if self.SizableBoxX == 0 then --size handle is on the left; need to shift to the left (yes thank you XY)
			self.X = self.X - sizediffX
		end

		self:SetCursor(cursors[self.SizableBoxX][self.SizableBoxY])
		return

	end

	
	

	if ( self.Hovered && self.m_bSizable && math.PointIn2DBox(mX, mY, boxX, boxY, boxW, boxH) ) then

		self:SetCursor(cursors[self.SizableBoxX][self.SizableBoxY])
		return
	end

	if ( self.Hovered && self:GetDraggable() && mousey < ( screenY + 24 ) ) then
		self:SetCursor( "sizeall" )
		return
	end

	self:SetCursor( "arrow" )

	-- Don't allow the frame to go higher than 0
	if ( self.y < 0 ) then
		self:SetPos( self.x, 0 )
	end



end

function PANEL:OnMousePressed()

	local screenX, screenY = self:LocalToScreen( 0, 0 )
	if not self:GetSizable() then return end --w/e

	local boxX, boxY = self.SizableBoxX * self:GetWide(), self.SizableBoxY * self:GetTall()

	local boxW, boxH = 20, 20

	if self.SizableBoxX > 0 then 
		boxX = boxX - boxW 
	end

	if self.SizableBoxY > 0 then 
		boxY = boxY - boxH 
	end

	local mX, mY = gui.MouseX(), gui.MouseY()
	mX, mY = self:ScreenToLocal(mX, mY)

	if math.PointIn2DBox(mX, mY, boxX, boxY, boxW, boxH) then
		self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
		self:MouseCapture( true )
		self:Emit("OnResize")
		return
	end

	if ( self:GetDraggable() && gui.MouseY() < ( screenY + 24 ) ) then
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
		self:Emit("OnDrag")
		return
	end

	self:Emit("OnMousePressed")
end

function PANEL:OnMouseReleased()

	self.Dragging = nil
	self.Sizing = nil
	self:MouseCapture( false )
	self:Emit("OnMouseReleased")
end

PANEL.Draw = PANEL.DrawHeaderPanel

function PANEL:PostPaint(w,h)

end

function PANEL:PrePaint(w,h)

end

function PANEL:Paint(w, h)
	self:PrePaint(w, h)
	self:DrawHeaderPanel(w, h)
	self:PostPaint(w, h)
end

function PANEL:PaintOver(w,h)

	if self.Dim then 
		local rad = self.RBRadius or 8

		self.DimColor.a = self.DimAlpha or 220

		draw.RoundedBox(rad, 0, 0, w, h, self.DimColor)
	end

end
vgui.Register("FFrame", PANEL, "DFrame")

--[[-------------------------------------------------------------------------
-- 	FButton
---------------------------------------------------------------------------]]

local button = {}

function button:Init()
	self.Color = Color(70, 70, 70)
	self.drawColor = Color(70, 70, 70)

	self:SetText("")

	self.Font = "PanelLabel"
	self.DrawShadow = true
	self.HovMult = 1.2

	self.Shadow = {
		MaxSpread = 0.6,
		Intensity = 2,
		OnHover = true,	--should the internal shadow logic be applied when the button gets hovered?
	}

	self.LabelColor = Color(255, 255, 255)
	self.RBRadius = 8
end

function button:SetColor(col, g, b, a)
	if IsColor(col) then 
		self.Color = col 
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

function button:HoverLogic()
	local shadow = self.Shadow

	if self:IsHovered() or self.ForceHovered then

		hov = true 
		local hm = self.HovMult 

		local bg = self.Color

		local fr = math.min(bg.r*hm, 255)
		local fg = math.min(bg.g*hm, 255)
		local fb = math.min(bg.b*hm, 255)

		LCC(self.drawColor, fr, fg, fb)

		if shadow.OnHover then shadow.Spread = L(shadow.Spread, shadow.MaxSpread, 20) end

		if not self._IsHovered then 
			self._IsHovered = true 
			self:OnHover()
		end

		self:ThinkHovered()
	else

		local bg = self.Color
		self.Color = bg

		LC(self.drawColor, bg)

		if shadow.OnHover then shadow.Spread = L(shadow.Spread, 0, 50) end 

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

		local tl = (r.tl==nil and true) or r.tl
		local tr = (r.tr==nil and true) or r.tr

		local bl = (r.bl==nil and true) or r.bl
		local br = (r.br==nil and true) or r.br

		draw.RoundedBoxEx(rad, x, y, w, h, dc, tl, tr, bl, br)
	else
		draw.RoundedBox(rad, x, y, w, h, dc)
	end

end



function button:Draw(w, h)

	local rad = self.RBRadius or 8
	local bg = self.drawColor or self.Color

	local shadow = self.Shadow 

	self.drawColor = self.drawColor

	local hov = false 
	
	local x, y = 0, 0

	self:HoverLogic()

	local spr = shadow.Spread or 0

	if not self.NoDraw then
		if (self.DrawShadow and spr>0.01) or self.AlwaysDrawShadow then 
			BSHADOWS.BeginShadow()
			x, y = self:LocalToScreen(0,0)
		end

		local label = self.Label or nil

		local w2, h2 = w, h 
		local x2, y2 = x, y

		if self.Border then 
			dRB(rad, x, y, w, h, self.borderColor or self.Color or RED, self.RBEx)
			local bw, bh = self.Border.w or 2, self.Border.h or 2
			w2, h2 = w - bw*2, h - bh*2
			x2, y2 = x + bw, y + bh
		end

		dRB(rad, x2, y2, w2, h2, self.drawColor or self.Color or RED, self.RBEx)


		

		if (self.DrawShadow and spr>0.01) or self.AlwaysDrawShadow then 
			local int = shadow.Intensity
			local blur = shadow.Blur

			if self.AlwaysDrawShadow then
				int = 3
				spr = 1
				blur = 1
			end

			BSHADOWS.EndShadow(int, spr, blur or 2, self.Shadow.Alpha, self.Shadow.Dir, self.Shadow.Distance, nil, self.Shadow.Color)
		end

		
		

		if label then 
			local label = tostring(label)
			if label:find("\n") then
				draw.DrawText(label, self.Font, self.TextX or w/2, self.TextY or h/2, self.LabelColor,  self.TextAX or 1)
			else
				draw.SimpleText(label,self.Font, self.TextX or w/2, self.TextY or h/2, self.LabelColor, self.TextAX or 1,  self.TextAY or 1)
			end
		end
	end

end

function button:PostPaint(w,h)

end

function button:PrePaint(w,h)

end
function button:PaintOver(w, h)

	if self.Dim then 
		draw.RoundedBox(self.RBRadius, 0, 0, w, h, DIM)
	end

end

function button:Paint(w, h)
	self:PrePaint(w,h)
	self:Draw(w, h)
	self:PostPaint(w,h)
end

vgui.Register("FButton", button, "DButton")



--[[-------------------------------------------------------------------------
-- 	TabbedPanel/Frame

	TabbedPanel:AddTab(name, onopen, onclose)
	TabbedPanel:SelectTab(name)
	TabbedPanel:GetWorkSize()
	TabbedPanel:GetWorkY()
	TabbedPanel:AlignPanel(pnl)

---------------------------------------------------------------------------]]

local TabbedPanel = {}

function TabbedPanel:Init()

	self.ActiveTab = ""
	self.OpenTabs = {}
	self.CloseTabs = {}
	self.TabColor = Color(54, 54, 54)
	self.TabFont = "OS24"
	self.Tabs = {}

	self.TabSize = 26

	self:DockPadding(4, 26 + self.HeaderSize, 4, 4)
end

function TabbedPanel:SetTabSize(size)
	self.TabSize = size
	local l, t, r, b = self:GetDockPadding()
	self:DockPadding(l, size + self.HeaderSize, r, b)
end

function TabbedPanel:AddTab(name, onopen, onclose)

	local tab = vgui.Create("DButton", self)

	self.Tabs[name] = tab

	local i = (self.Tabs and table.Count(self.Tabs)+1) or 1

	surface.SetFont(self.TabFont)
	local tx, ty = surface.GetTextSize(name or "")
	local x = (self.TabX or 0)

	tab:SetPos(x, self.HeaderSize)
	tab:SetSize(tx+24, self.TabSize)
	tab:SetText("")

	self.TabX = x + tx + 24

	self.OpenTabs[name] = onopen
	self.CloseTabs[name] = onclose
	tab.Col = Color(255, 255, 255)
	tab.GCol = Color(255, 255, 255)
	tab.Hov = 0
	function tab.Paint(me,w,h)
		me.Col = LC(me.Col, (self.ActiveTab == name and Color(70, 170, 255) ) or color_white, 15)
		draw.SimpleText(name, self.TabFont, w/2, h/2 - 1, me.Col, 1, 1)

		if me:IsHovered() then 
			me.Hov = L(me.Hov, 35, 15)
		else 
			me.Hov = L(me.Hov, 0, 15)
		end 
		if me.Hov > 1 then 
			surface.SetDrawColor(Color(255, 255, 255, me.Hov))
			self:DrawGradientBorder(w, h, 2, 3)
		end
	end

	function tab.DoClick()
		local curtab = self.ActiveTab 	--tab name, not button
		if curtab == name then return end

		local tabbtn = self.Tabs[curtab]

		if isfunction(self.OpenTabs[name]) then 

			if curtab~="" then 	--if there was a tab open,

				if isfunction(self.CloseTabs[curtab])  then --if there's a close function registered,
					self.CloseTabs[curtab](self.OpenTabs[name])				--exec that
				end

				if tabbtn.ReturnedPanel then --if there's a panel registered for auto-close,
					local pnl = tabbtn.ReturnedPanel
					local _ = (pnl.TabClose and pnl:TabClose()) or (pnl.__InstaRemove and pnl:Remove()) or pnl:PopOut()	--ambiguous syntax (function call x new statement) near '('
																														--that's a new one lol
				end
			end 

			local pnl, instaremove = self.OpenTabs[name]()	--otherwise just run the open func

			if ispanel(pnl) then --if open func returned a panel then assume they want to auto-close it when tab switches
				pnl.__InstaRemove = instaremove
				tab.ReturnedPanel = pnl
			end
		end

		self.WentFrom = (self.Tabs[curtab] and self.Tabs[curtab].X) or 0
		self.ActiveTab = name

	end

	self:DockPadding(4, 30 + self.HeaderSize, 4, 4)

	return tab
end

function TabbedPanel:SelectTab(name, dontanim)
	if not self.Tabs[name] then error("Tried opening a non-existent tab!") return end 
	self.OpenTabs[name]()
	self.ActiveTab = name
	if not dontanim then
		self.Tabs[name].SelW = self.Tabs[name]:GetWide()+20
	end

end

function TabbedPanel:GetWorkSize()
	local w,h = self:GetSize()
	return w, h - self.TabSize - self.HeaderSize
end

function TabbedPanel:GetWorkY()
	return self.TabSize + self.HeaderSize
end

function TabbedPanel:AlignPanel(pnl)
	pnl:SetSize(self:GetWorkSize())
	pnl:SetPos(0, self:GetWorkY())
end

function TabbedPanel:Paint(w,h)

	self:PrePaint(w, h)

	self:DrawHeaderPanel(w, h)

	surface.SetDrawColor(self.TabColor)
	surface.DrawRect(0, self.HeaderSize, w, self.TabSize)

	local sel = self.Tabs[self.ActiveTab]

	if sel then
		local x, tw = sel.X, sel:GetWide()

		local dist = math.max(self.SelX or 0, x) - math.min(self.SelX or 0, x)
		
		local origdist = math.max(self.WentFrom or 0, self.SelX or 0) - math.min(self.WentFrom or 0, self.SelX or 0)

		local far = dist/origdist > 0.6

		self.SelW = L(self.SelW, (far and tw*0.8) or tw, 15, true)

		self.SelX = L(self.SelX, x, 15)

		surface.SetDrawColor(40, 140, 220)
		surface.DrawRect(self.SelX, self.HeaderSize + self.TabSize - 3, self.SelW, 3)
	end

	self:PostPaint(w, h)
end

vgui.Register("TabbedFrame", TabbedPanel, "FFrame")
vgui.Register("TabbedPanel", BLANK, "TabbedFrame")

local InvisPanel = {}
InvisPanel.Paint = function() end --shh


vgui.Register("InvisPanel", InvisPanel, "EditablePanel") --08.05 : changed from DPanel to EditablePanel
vgui.Register("InvisFrame", InvisPanel, "EditablePanel")

local FakePanel = {}
function FakePanel:Paint(w, h)

end

vgui.Register("FakeFrame", FakePanel, "DFrame")

--[[-------------------------------------------------------------------------
--  FScrollPanel
---------------------------------------------------------------------------]]

local FScrollPanel = {}

function FScrollPanel:Init()
	local scroll = self.VBar


	function scroll:Paint(w,h)
		draw.RoundedBox(4,0,0,w,h,Color(30,30,30))
		if self.ToWheel ~= 0 then 

			local wheel = L(self.ToWheel, 0, 25)
			self:OnMouseWheeled( wheel )
			self.ToWheel = wheel

		end
	end

	scroll:SetWide(10)

	local grip = scroll.btnGrip
	local up = scroll.btnUp 
	local down = scroll.btnDown

	function grip:Paint(w,h)
		draw.RoundedBox(4,0,0,w,h,Color(60,60,60))
	end

	function up:Paint(w,h)
		draw.RoundedBoxEx(4, 0, 0, w, h, Color(80,80,80), true, true)
	end

	function down:Paint(w,h)
		draw.RoundedBoxEx(4, 0, 0, w, h, Color(80,80,80), false, false, true, true)
	end
 	
 	self.Shadow = false --if used as a stand-alone panel 

	self.GradBorder = false 

	self.BorderColor = Color(20, 20, 20)
	self.RBRadius = 0

	self.BorderTH = 4
	self.BorderBH = 4
	self.BorderL = 4 
	self.BorderR = 4

	self.BorderW = 6

	self.Expand = false
	self.ExpandTH = 0
	self.ExpandBH = 0

	self.ExpandW = 6

	self.BackgroundColor = Color(40, 40, 40)
	self.ScrollPower = 1
end


function FScrollPanel:Draw(w, h)
	local ebh, eth = 0, 0

	local expw = 0
	local x, y = 0, 0

	if self.Shadow then 
		BSHADOWS.BeginShadow()
		x, y = self:LocalToScreen(0, 0)
	end

	if self.Expand then 
		expw, ebh, eth = self.ExpandW, self.ExpandBH, self.ExpandTH

		surface.DisableClipping(true)
	end

	draw.RoundedBox(self.RBRadius or 0, x - expw, y - eth, w + expw*2, h + ebh*2, self.BackgroundColor)

	if self.Expand then 
		surface.DisableClipping(false)
	end
	
	if self.Shadow then 

		local int = 2
		local spr = 2 
		local blur = 2 
		local alpha = 255
		local color

		if istable(self.Shadow) then
			int = self.Shadow.intensity or 2
			spr = self.Shadow.spread or 2
			blur = self.Shadow.blur or 2
			alpha = self.Shadow.alpha or self.Shadow.opacity or 255
			color = self.Shadow.color or nil
		end

		BSHADOWS.EndShadow(int, spr, blur, alpha, nil, nil, nil, color)
	end
	
end

function FScrollPanel:PostPaint(w, h)
end

function FScrollPanel:PrePaint(w, h)
end

function FScrollPanel:Paint(w, h)
	self:PrePaint(w, h)
	self:Draw(w,h)
	self:PostPaint(w, h)
end

function FScrollPanel:PaintOver(w,h) 
	if not self.GradBorder then return end 

	local ebh, eth = self.ExpandBH, self.ExpandTH

	local bth, bbh = self.BorderTH, self.BorderBH
	local bl, br = self.BorderL, self.BorderR

	local expw = self.ExpandW

	surface.DisableClipping(true)

		surface.SetDrawColor(self.BorderColor)
		
		surface.SetMaterial(gu)
		surface.DrawTexturedRect(0, -eth, w, self.BorderTH)

		surface.SetMaterial(gd)
		surface.DrawTexturedRect(0, h - self.BorderBH + ebh, w, self.BorderBH)

		surface.SetMaterial(gr)
		surface.DrawTexturedRect(w - self.BorderR, 0, self.BorderR, h)

		surface.SetMaterial(gl)
		surface.DrawTexturedRect(0, 0, self.BorderL, h)

	surface.DisableClipping(false)


end
function FScrollPanel:OnMouseWheeled( dlta )
	local scroll = self.VBar
	scroll.ToWheel = (scroll.ToWheel or 0) + (dlta / 2 * self.ScrollPower)

end

vgui.Register("FScrollPanel", FScrollPanel, "DScrollPanel")

--[[-------------------------------------------------------------------------
--  FCheckBox
---------------------------------------------------------------------------]]

local CB = {}

function CB:Init()
	self.Color = Color(35, 35, 35)
	self.CheckedColor = Color(55, 160, 255)
	self.Font = "TWB24"
	self.DescriptionFont = "TW24"
	self:SetSize(32, 32)
	self.DescPanel = nil
end

function CB:SetLabel(txt)

	self.Label = txt

end

function CB:Paint(w,h)

	local ch = self:GetChecked()
	draw.RoundedBox(4, 0, 0, w, h, self.Color)

	if ch then 
		draw.RoundedBox(4, 4, 4, w-8, h-8, self.CheckedColor)
	end
	surface.DisableClipping(true)
		if self.Label then 
			draw.DrawText(self.Label, self.Font, 36, 2, color_white, 0, 1)
		end
	surface.DisableClipping(false)

	local chX, chY = self:LocalToScreen(0, 0)

	if self:IsHovered() and self.Description and not IsValid(self.DescPanel) then 
		local d = vgui.Create("InvisPanel", self)
		d:SetSize(32, 32)
		d:SetPos(0, h-1)
		d:SetAlpha(0)
		d:SetMouseInputEnabled(false)

		surface.SetFont(self.DescriptionFont)
		local tX, tY = surface.GetTextSize(self.Description)
		local cw = math.max(100, tX+12)
		local ch = tY+8

		d:MoveTo(0, 0, 0.2, 0, 0.7)
		d:AlphaTo(255,0.2, 0)

		function d.Paint(me, w,h)

			if not IsValid(self) then me:Remove() return end
			surface.DisableClipping(true)


				draw.RoundedBox(4, -cw/2 + w/2, -40, cw, ch, Color(25, 25, 25))
				draw.SimpleText(self.Description, self.DescriptionFont, w/2, ch/2 - 40, ColorAlpha(color_white, me:GetAlpha()*0.7), 1, 1)


			surface.DisableClipping(false)
		end
		self.DescPanel = d
	elseif IsValid(self.DescPanel) and not self:IsHovered() then 
		self.DescPanel:MoveTo(0, 32, 0.2, 0, 0.7, function(tbl, self) if IsValid(self) then self:Remove() end end)
		self.DescPanel:AlphaTo(0,0.1, 0,function(tbl, self) if IsValid(self) then self:Remove() end end)
	end
end
function CB:Changed(var)

end
function CB:OnChange(var)
	if self.Sound then 
		local snd = self.Sound[var] or self.Sound[tonumber(var)] or (isstring(self.Sound) and self.Sound) or ""
		if snd~="" and isstring(snd) then 
			surface.PlaySound(snd)
		end
	end
	self:Changed(var)
end

vgui.Register("FCheckBox", CB, "DCheckBox")

--[[-------------------------------------------------------------------------
--  FTextEntry
---------------------------------------------------------------------------]]

local TE = {}

function TE:Init()
	--self:SetPlaceholderText("Some text")
	self:SetSize(256, 36)
	self:SetFont("A24")
	self:SetEditable(true)
	self:SetKeyBoardInputEnabled(true)
	self:AllowInput(true)

	self.BGColor = Color(40, 40, 40)
	self.TextColor = Color(255, 255, 255)
	self.HTextColor = Color(255, 255, 255)
	self.CursorColor = Color(255, 255, 255)

	self.RBRadius = 6

	self.GradBorder = true 

end

function TE:SetColor(col)

	if not IsColor(col) then error('FTextEntry: SetColor arg must be a color!') return end
	self.BGColor = col

end

function TE:SetTextColor(col)

	if not IsColor(col) then error('FTextEntry: SetTextcolor must be a color!') return end
	self.TextColor = col

end
function TE:SetHighlightedColor(col)

	if not IsColor(col) then error('FTextEntry: SetHighlightedColor must be a color!') return end
	self.HTextColor = col

end
function TE:SetCursorColor(col)

	if not IsColor(col) then error('FTextEntry: SetCursorColor must be a color!') return end
	self.CursorColor = col

end

function TE:Paint(w,h)

	surface.DisableClipping(false)

	if self.Ex then 
		local e = self.Ex
		draw.RoundedBoxEx(self.RBRadius, 0, 0, w, h, self.BGColor, e.tl, e.tr, e.bl, e.br)
	else
		draw.RoundedBox(self.RBRadius, 0, 0, w, h, self.BGColor)
	end

	if self.GradBorder then 
		surface.SetDrawColor(Color(10, 10, 10, 180))
		self:DrawGradientBorder(w, h, 3, 3)
	end 

	self:DrawTextEntryText(self.TextColor, self.HTextColor, self.CursorColor)

	if self:GetPlaceholderText() and #self:GetText() == 0 then 
		draw.SimpleText(self:GetPlaceholderText(), self:GetFont(), 4, h/2, ColorAlpha(self.TextColor, 75), 0, 1)
	end

end
function TE:AllowInput(val)
	if self.MaxChars and self.MaxChars~=0 and #self:GetValue() > self.MaxChars then return true end

end
function TE:SetMaxChars(num)
	self.MaxChars = num 
end
vgui.Register("FTextEntry", TE, "DTextEntry") 


--[[-------------------------------------------------------------------------
	Combo Box
---------------------------------------------------------------------------]]
local FCB = {}

function FCB:Init()
	self:SetSize(160, 24)

	self.Color = Color(70, 70, 70)


	self.Options = {}

	self:SetValue("")

	self.Font = "TWB24"
	self:SetFont(self.Font)

	self:SetTextColor(color_white)

	self.OptionsFont = "TW24"

	self.OnCreateFuncs = {}
	self.Text = "self.Text = ???"

end

function FCB:SetDefaultValue(num)
	self:ChooseOption(num)
end

function FCB:AddChoice( value, data, select, icon, oncreate )

	local i = table.insert( self.Choices, value )

	if ( data ) then
		self.Data[ i ] = data
	end
	
	if ( icon ) then
		self.ChoiceIcons[ i ] = (isstring(icon) and Material(icon)) or (IsMaterial(icon) and icon) or nil
	end

	if ( select ) then

		self:ChooseOption( value, i )

	end

	if oncreate then 

		self.OnCreateFuncs[i] = oncreate

	end

	return i

end


local AlphabetSort = function(self)

	local sorted = {}
	local i = 0

	for k, v in pairs(self.Choices) do
		i = i + 1
		local val = tostring( v )

		if #val > 1 and val[1] == "#" then 
			val = language.GetPhrase(val:sub(2)) 
		end

		sorted[i] = { id = k, data = v, label = val }
	end

	table.sort(sorted, function(a, b)
		return a.label < b.label
	end)

	return ipairs(sorted)
end

local FuckingGarry = function(self)
	local omg = {}
	local i = 0

	for k,v in pairs(self.Choices) do 
		i = i + 1
		omg[i] = {id = k, data = v, label = v}
	end

	return ipairs(omg)
end

function FCB:SetChoiceIcon(key, icon)
	self.ChoiceIcons[key] = (isstring(icon) and Material(icon)) or (IsMaterial(icon) and icon) or nil
end

FCB.SetChoiceMaterial = FCB.SetChoiceIcon 

function FCB:OpenMenu( pControlOpener )

	if ( pControlOpener && pControlOpener == self.TextEntry ) then
		return
	end

	if ( #self.Choices == 0 ) then return end


	if ( IsValid( self.Menu ) ) then
		self.Menu:Remove()
		self.Menu = nil
	end

	self.Menu = vgui.Create("FMenu", self)
	local m = self.Menu 
	m:SetAlpha(0)

	local alphasort = self:GetSortItems()
	local iter = (alphasort and AlphabetSort or FuckingGarry)

	for k, v in iter(self) do

		local option = self.Menu:AddOption( v.data, function() self:ChooseOption( v.data, v.id ) end )
		option.DesHeight = 32

		if ( self.ChoiceIcons[ v.id ] ) then
			option.Icon = self.ChoiceIcons[ v.id ] 
			option.IconW = 24
			option.IconH = 24
			option.IconPad = 4
			option.Font = "TW24"
		end

		if self.OnCreateFuncs[v.id] then
			self.OnCreateFuncs[v.id](self, option)
		end

	end
	

	local x, y = self:LocalToScreen( 0, self:GetTall() )

	--self.Menu:SetMinimumWidth( self:GetWide() )
	m:SetSize(self:GetSize())
	m.Font = self.OptionsFont
	m.WOverride = (self:GetSize())

	local sx, sy = self.Menu:GetSize()

	self.Menu:Open( x, y - sy, nil, self )
	m:SetPos(x, y-8)
	m:MoveBy(0, 8, 0.2, 0, 0.3)

	m:AlphaTo(255, 0.1)

end

function FCB:SetColor(col, g, b, a)
	if IsColor(col) then self.Color = col self.drawColor = self.Color return end 

	local c = self.Color
	c.r = col or 60
	c.g = g or 60
	c.b = b or 60
	c.a = a or 255
end

function FCB:Paint(w,h)

	draw.RoundedBox(2, 0, 0, w, h, self.Color)
	local txo = 8

	if self.Icon then 
		surface.SetMaterial(self.Icon)
		local iw, ih = self.IconW or h-4, self.IconH or h-4
		surface.SetDrawColor(Color(255,255,255))
		surface.DrawTexturedRect(2, h/2-ih/2, iw, ih)
		txo = iw + self.IconPad or 8
	end

end

vgui.Register("FComboBox", FCB, "DComboBox")

--[[
	Icon

	Icon.Rotation = num
	Icon.Icon = mat
]]
local I = {}

function I:Init(w,h)
	self.Icon = Material("__error")
	self.Rotation = 0
end

function I:Paint(w,h)
	local mat = self.Icon 
	local rot = self.Rotation 
	surface.DrawTexturedRectRotated(w/2,h/2,w,h,self.Rotation)
end

vgui.Register("Icon", I, "InvisPanel")


local testing = false 
if not testing then return end 


if IsValid(TestingFrame1) then TestingFrame1:Remove() end 
if IsValid(TestingFrame2) then TestingFrame2:Remove() end 
if IsValid(TestingFrame3) then TestingFrame3:Remove() end 
if IsValid(TestingFrame4) then TestingFrame4:Remove() end 

TestingFrame1 = vgui.Create("FFrame")

local f = TestingFrame1
f:SetSize(200, 100)
f:Center()
f:MakePopup()

f:SetSizable(true)

f:SetSizablePos(1)

TestingFrame2 = vgui.Create("FFrame")

local f2 = TestingFrame2
f2:SetSize(200, 100)
f2:Center()
f2:MakePopup()
f2:MoveRightOf(f, 8)

f2:SetSizable(true)
f2:SetSizablePos(2)

TestingFrame3 = vgui.Create("FFrame")

local f3 = TestingFrame3
f3:SetSize(200, 100)
f3:Center()
f3:MakePopup()
f3:MoveBelow(f2, 8)

f3:SetSizable(true)
f3:SetSizablePos(3)

TestingFrame4 = vgui.Create("FFrame")

local f4 = TestingFrame4
f4:SetSize(200, 100)
f4:MoveLeftOf(f3, 8)
f4:MakePopup()

f4:SetSizable(true)
f4:SetSizablePos(4)