local PANEL = {}
MoarPanelsLoaded = true
local function LC(col, dest, vel)
	local v = 10
	if not IsColor(col) or not IsColor(dest) then return end
	if isnumber(vel) then v = vel end
	local r = Lerp(FrameTime()*v, col.r, dest.r)
	local g = Lerp(FrameTime()*v, col.g, dest.g)
	local b = Lerp(FrameTime()*v, col.b, dest.b)
	return Color(r,g,b)
end

local function L(s,d,v,pnl)
    if not v then v = 5 end
    if not s then s = 0 end
    local res = Lerp(FrameTime()*v, s, d)
    if pnl then 
        local choose = res>s and "ceil" or "floor"
        res = math[choose](res) 
    end
    return res
end

MoarPanelsMats = {--MoarPanelsMats or {


}
local spinner = Material("hdl/spinner.png")

local _ = spinner:IsError() and hdl.DownloadFile("https://i.imgur.com/KHvsQ4u.png", "spinner.png", function(fn) spinner = Material(fn) end)

local circles = {}

local function BenchPoly(...)	--shh
	draw.NoTexture()
	surface.DrawPoly(...)
end

local ipairs = ipairs 

local sin = math.sin 
local cos = math.cos
local mrad = math.rad 

function draw.DrawCircle(x, y, rad, seg)
	local circ = {}
	

	if circles[seg] then 
		local st = circles[seg]

		for k,w in ipairs(st) do 	--CURSED VAR NAME
			circ[k] = {
				x = w.x*rad + x, --XwX
				y = w.y*rad + y, --YwY
				u = w.u,		 --UwU
				v = w.v 	 --VwV
			}
		end
		
		BenchPoly(circ)
	else 

		for i=1, seg do 

			local a = mrad( ( i / seg ) * -360 )

			local s = sin(a)
			local c = cos(a)
			circ[i] = {
				x = s,
				y = c,
				u = s/2 + 0.5,
				v = c/2 + 0.5
			}
		end

		local a = mrad(0)

		local s = sin(a)
		local c = cos(a)

		circ[#circ+1] = {
			x = s,
			y = c,
			u = s/2 + 0.5,
			v = c/2 + 0.5
		}

		circles[seg] = circ

		local c2 = {}
		for k,w in ipairs(circ) do 	--CURSED VAR NAME
			c2[k] = {
				x = w.x*rad + x, --XwX
				y = w.y*rad + y, --YwY
				u = w.u,		 --UwU
				["v"] = w.v 	 --VwV
			}
		end

		BenchPoly(circ)
	end
end

function surface.DrawMaterial(url, name, x, y, w, h, rot)
	local mat = MoarPanelsMats[name]
	if not name then error("no name! disaster averting") return end
	if not mat then 
		MoarPanelsMats[name] = {}
		MoarPanelsMats[name].mat = Material(name, "smooth")
		
		if MoarPanelsMats[name].mat:IsError() or (MoarPanelsMats[name].failed and (MoarPanelsMats[name].failed~=url)) then 
			MoarPanelsMats[name].downloading = true

			hdl.DownloadFile(url, name or "unnamed", function(fn)
				MoarPanelsMats[name].downloading = false 
				MoarPanelsMats[name].mat = Material(fn, "smooth")
			end, function(...)
				print("Failed to download! URL:", url, "\nError:", ...)
				MoarPanelsMats[name].mat = Material("materials/icon16/cancel.png")
				MoarPanelsMats[name].failed = url
				MoarPanelsMats[name].downloading = false
			end)

		end
		mat = MoarPanelsMats[name]
	end

	if mat.downloading or mat.mat:IsError() then 
		surface.SetMaterial(spinner)
		surface.DrawTexturedRectRotated(x+w/2, y+h/2, w, h, (CurTime()*-480)%360)
		return
	end

	surface.SetMaterial(mat.mat)
	if rot then 
		surface.DrawTexturedRectRotated(x, y, w, h, rot)
	else 
		surface.DrawTexturedRect(x, y, w, h)
	end

end

local META = FindMetaTable("Panel")

function META:GetCenter(xfrac, yfrac)
	xfrac = xfrac or 0.5 
	yfrac = yfrac or 0.5 

	local w,h = self:GetParent():GetSize()

	local x = w * xfrac 
	local y = h * yfrac 

	local w,h = self:GetSize()

	x = x - w/2 
	y = y - h/2 

	return x, y
end

function META:PopIn(dur, del, func)
	self:SetAlpha(0)
	self:AlphaTo(255, dur or 0.1, del or 0, (isfunction(func) and func) or function() end)
end

function META:PopOut(dur, del, rem)
	local func = (not rem and function(_, self) if IsValid(self) then self:Remove() end end) or rem
	self:AlphaTo(0, dur or 0.1, del or 0, func)
end

local gu = Material("vgui/gradient-u")
local gd = Material("vgui/gradient-d")
local gr = Material("vgui/gradient-r")
local gl = Material("vgui/gradient-l")

function META:DrawGradientBorder(w, h, gw, gh)
	surface.SetMaterial(gu)
	surface.DrawTexturedRect(0, 0, w, gh)

	surface.SetMaterial(gd)
	surface.DrawTexturedRect(0, h - gh, w, gh)

	surface.SetMaterial(gr)
	surface.DrawTexturedRect(w - gw, 0, gw, h)

	surface.SetMaterial(gl)
	surface.DrawTexturedRect(0, 0, gw, h)
end

--[[-------------------------------------------------------------------------
-- 	FPanel
---------------------------------------------------------------------------]]


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
		b.Color = LC(b.Color, (self.PreventClosing and Color(80, 80, 80)) or (self:IsHovered() and Color(235, 90, 90)) or Color(205, 50, 50), 15)
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

	self:DockPadding(4, 32, 4, 4)
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


function PANEL.DrawHeaderPanel(self, w, h)

	local rad = self.RBRadius or 8
	local hc = self.HeaderColor or Color(255, 40, 40)
	local bg = self.BackgroundColor or Color(255, 50, 50)

	local label = self.Label or nil

	local icon = (self.Icon and self.Icon.mat) or nil

	local x,y = 0, 0

	if self.Shadow then 
		--surface.DisableClipping(false)
		BSHADOWS.BeginShadow()
		x, y = self:GetPos()
	end

	local hh = self.HeaderSize
	draw.RoundedBoxEx(rad, x, y, w, hh, hc, true, true)
	draw.RoundedBoxEx(rad, x, y+hh, w, h-hh, bg, false, false, true, true)

	if label then
		local xoff = 16

		if icon and icon.IsError and not icon:IsError() then
			local w2, h2 = self.Icon.w or 16, self.Icon.h or 16
			xoff = xoff + w2 + 6
			surface.SetDrawColor(255,255,255, 255)
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(x+8, y+(hh-h2)/2, w2, h2)

		end

		draw.SimpleText(label, "PanelLabel", x+xoff, y, Color(255,255,255), 0, 2)
	end

	if self.Shadow then 
		local int = self.Shadow.intensity or 2
		local spr = self.Shadow.spread or 2
		local blur = self.Shadow.blur or 2
		local alpha = self.Shadow.alpha or self.Shadow.opacity or 255
		local color = self.Shadow.color or nil

		BSHADOWS.EndShadow(int, spr, blur, alpha, nil, nil, nil, color)
		--surface.DisableClipping(true)
	end

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
		draw.RoundedBox(rad, 0, 0, w, h, Color(0, 0, 0, self.DimAlpha or 220))
	end

end
vgui.Register("FFrame", PANEL, "DFrame")

--[[-------------------------------------------------------------------------
-- 	FButton
---------------------------------------------------------------------------]]

local button = {}

function button:Init()
	self.Color = Color(70, 70, 70)
	self.drawColor = self.Color
	self:SetText("")
	self.ShadowMaxSpread = 0.6
	self.ShadowIntensity = 2
	self.Font = "PanelLabel"
	self.DrawShadow = true
	self.HovMult = 1.2
	self.Disabled = false

	self.LabelColor = Color(255, 255, 255)
	self.RBRadius = 8
end

function button:SetColor(col, g, b, a)
	if IsColor(col) then self.Color = col self.drawColor = self.Color return end 
	self.Color = Color(col or 70, g or col or 70, b or col or 70, a or 255)
	--self.drawColor = self.Color
end
function button:SetLabel(txt)
	self.Label = txt
end

function button:OnHover()

end

function button:Draw(w, h)

	local rad = self.RBRadius or 8
	local bg = self.drawColor or self.Color
	self.drawColor = self.drawColor or bg --real consistent lowerCamelCase, me
	local hov = false 
	
	local x, y = 0, 0

	if self:IsHovered() then

		local ok = self:OnHover() 
		if ok~=false then
			hov = true 
			local hovmult = self.HovMult 

			local bg = self.Color or Color(70,70,70)
			local fr = bg.r*hovmult
			local fg = bg.g*hovmult
			local fb = bg.b*hovmult
			self.drawColor = LC(self.drawColor, Color(fr,fg,fb))
			self.ShadowSpread = L(self.ShadowSpread, self.ShadowMaxSpread, 20)
		end

		

	else
		local bg = self.Color or Color(70,70,70)
		self.drawColor = LC(self.drawColor, bg)
		self.ShadowSpread = L(self.ShadowSpread, 0, 50)
	end

	local spr = self.ShadowSpread or 0

	if self.DrawShadow and spr>0.01 then 
		BSHADOWS.BeginShadow()
		x, y = self:LocalToScreen(0,0)
	end

	local label = self.Label or nil

	if self.RBEx then 
		local r = self.RBEx

		local tl = (r.tl==nil and true) or r.tl
		local tr = (r.tr==nil and true) or r.tr

		local bl = (r.bl==nil and true) or r.bl
		local br = (r.br==nil and true) or r.br

		draw.RoundedBoxEx(rad, x, y, w, h, self.drawColor or self.Color or Color(255,0,0), tl, tr, bl, br)
	else
		draw.RoundedBox(rad, x, y, w, h, self.drawColor or self.Color or Color(255,0,0))
	end

	

	if self.DrawShadow and spr>0.01 then 
		local int = self.ShadowIntensity
		BSHADOWS.EndShadow(int, spr, 2)
	end

	
	

	if label then 
		local label = tostring(label)
		if label:find("\n") then
			draw.DrawText(label, self.Font, w/2, self.TextY or h/2, self.LabelColor, 1)
		else
			draw.SimpleText(label,self.Font, w/2, h/2, self.LabelColor, 1, 1)
		end
	end

end

function button:PostPaint(w,h)

end

function button:PrePaint(w,h)

end
function button:PaintOver(w, h)
	if self.Dim then 
		draw.RoundedBox(self.RBRadius, 0, 0, w, h, Color(30, 30, 30, 180))
	end
end
function button:Paint(w, h)
	self:PrePaint(w,h)
	self:Draw(w, h)
	self:PostPaint(w,h)
end

vgui.Register("FButton", button, "DButton")



--[[-------------------------------------------------------------------------
-- 	TabbedFrame

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
end

function TabbedPanel:AddTab(name, onopen, onclose)

	local tab = vgui.Create("DButton", self)

	self.Tabs[name] = tab

	local i = (self.Tabs and table.Count(self.Tabs)+1) or 1

	surface.SetFont("PanelLabel")
	local tx, ty = surface.GetTextSize(name or "")
	local x = (self.TabX or 0)

	tab:SetPos(x, 32)
	tab:SetSize(tx+24, 26)
	tab:SetText("")

	self.TabX = x + tx + 32

	self.OpenTabs[name] = onopen
	self.CloseTabs[name] = onclose

	function tab.Paint(me,w,h)
		draw.SimpleText(name, self.TabFont, w/2, h/2 - 1, color_white, 1, 1)

		if self.ActiveTab==name then 
			me.SelW = L(me.SelW, w, 20)
		else 
			me.SelW = L(me.SelW, 0, 40)
		end

		surface.SetDrawColor(40, 140, 220)
		surface.DrawRect(w/2 - me.SelW/2, h-3, me.SelW, 3)
	end

	function tab.DoClick()
		local curtab = self.ActiveTab
		if curtab==name then return end
		if isfunction(self.OpenTabs[name]) then 

			if curtab~="" and isfunction(self.CloseTabs[curtab]) then 	--if there was a tab open and close func is valid

				self.CloseTabs[curtab](self.OpenTabs[name])				--do that
			end 

			self.OpenTabs[name]()	--otherwise just run the open func

		end

		self.ActiveTab = name --and finish it off
	end

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
	return w, h - 26 - self.HeaderSize
end

function TabbedPanel:GetWorkY()
	return 26+self.HeaderSize
end

function TabbedPanel:AlignPanel(pnl)
	pnl:SetSize(self:GetWorkSize())
	pnl:SetPos(0, self:GetWorkY())
end

function TabbedPanel:Paint(w,h)
	self:DrawHeaderPanel(w, h)
	surface.SetDrawColor(self.TabColor)
	surface.DrawRect(0, 32, w, 26)
end
vgui.Register("TabbedFrame", TabbedPanel, "FFrame")

local InvisPanel = {}
InvisPanel.Paint = function() end --shh


vgui.Register("InvisPanel", InvisPanel, "EditablePanel") --08.05 : changed from DPanel to EditablePanel
vgui.Register("InvisFrame", InvisPanel, "EditablePanel")
--[[-------------------------------------------------------------------------
-- 	FCategoryPanel (not finished)
---------------------------------------------------------------------------]]
local FCP = {}
function FCP:Init()

end

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

	local grip = scroll.btnGrip
	local up = scroll.btnUp 
	local down = scroll.btnDown

	function grip:Paint(w,h)
		draw.RoundedBox(4,0,0,w,h,Color(60,60,60))
	end

	function up:Paint(w,h)
		
	end

	function down:Paint(w,h)
		
	end

	self.GradBorder = false 

	self.BorderColor = Color(30, 30, 30)

	self.BorderTH = 4
	self.BorderBH = 4

	self.BorderW = 6

	self.Expand = false
	self.ExpandTH = 0
	self.ExpandBH = 0

	self.ExpandW = 6

	self.BackgroundColor = Color(45, 45, 45)
	self.ScrollPower = 1
end


function FScrollPanel:Draw(w, h)
	surface.SetDrawColor(self.BackgroundColor)
	local ebh, eth = 0, 0
	local bth, bbh = 0, 0

	local expw = 0

	if self.Expand then 
		expw, ebh, eth = self.ExpandW, self.ExpandBH, self.ExpandTH
		bth, bbh = self.BorderTH, self.BorderBH 

		surface.DisableClipping(true)
	end

	surface.DrawRect(-expw, -eth, w + expw*2, h + ebh*2)

	if self.Expand then 
		surface.DisableClipping(false)
	end
	
	
end

function FScrollPanel:Paint(w, h)
	self:Draw(w,h)
end

function FScrollPanel:PaintOver(w,h) 
	if not self.GradBorder then return end 

	local ebh, eth = 0, 0
	local bth, bbh = 0, 0

	local expw = 0
	
	expw, ebh, eth = self.ExpandW, self.ExpandBH, self.ExpandTH
	bth, bbh = self.BorderTH, self.BorderBH 

	surface.DisableClipping(true)

		surface.SetDrawColor(self.BorderColor)
		
		surface.SetMaterial(gu)
		surface.DrawTexturedRect(0, -eth, w, self.BorderTH)

		surface.SetMaterial(gd)
		surface.DrawTexturedRect(0, h - self.BorderBH + ebh, w, self.BorderBH)

		surface.SetMaterial(gr)
		surface.DrawTexturedRect(w - self.BorderW, 0, self.BorderW, h)

		surface.SetMaterial(gl)
		surface.DrawTexturedRect(0, 0, self.BorderW, h)

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

---------------------------------------------------------------------------]]

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
	timer.Simple(0, function()
		if not IsValid(self) or self.FullInitted then return end
		self:FullInit()
	end)

	self.HOffset = 0

	self.ToX = nil 
	self.ToY = nil 

	self.Intensity = 20
	self.Speed = 10
	self.Color = Color(40, 40, 40)
	self.TextColor = Color(255,255,255)
	self:SetDrawOnTop(true)

	self.HOverride = nil 

	self.FormattedText = {}
	self.DoneText = {}

	self.Middle = 0.5

	self.XAlign = 0
	self.YAlign = 0
	self.wwrapped = {}
end


function Cloud:SetLabel(txt)
	self.Label = txt
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

local wwrapped = {}

function Cloud:PostPaint()

end

function Cloud:PrePaint()

end

function Cloud:Paint()

	if not self.FullInitted then return end 

	
	self:PrePaint()

	local cw = self.MaxW or 192


	local lab = self.wwrapped[self.Label] or string.WordWrap(self.Label, cw - 16, self.Font)
	self.wwrapped[self.Label] = lab 

	surface.SetFont(self.Font)

	if not lab:find('\n') then 
		cw = (surface.GetTextSize(lab))+16
	end

	

	local ch = 0
	local tx, ty = surface.GetTextSize("l") --highest letter, usually

	if not self.HOverride then 

		local _, amt = string.gsub(lab, "\n", "")
		ch = ty * (amt+1)

	else 
		ch=self.HOverride 
	end

	
	local xoff = self.XShit or 4
	local yoff = self.YShit or 0

	local finX = 0
	local finY = 0

	local aY = math.Clamp(self.YAlign, 0, 2)

	

	local frmtd = false 

	local boxh = ch + 4

	surface.SetFont(self.DescFont)

	for k,v in SortedPairs(self.DoneText) do 
		boxh = boxh + v.YOff
		frmtd = true 

		if not v.Text:find('\n') then 
			cw = math.max(cw, surface.GetTextSize(v.Text) + 16)
		end

	end

	

	if frmtd then 
		boxh = boxh + 8
	end

	finY = yoff + boxh*(aY-1)

	surface.DisableClipping(true)

		draw.RoundedBox(4, xoff - cw*self.Middle, finY, cw, boxh, self.Color)
		draw.DrawText(lab, self.Font, xoff + 8 - cw*self.Middle,  finY + 4, self.TextColor, 0)

		local offy = finY + ch + 4

		for k,v in SortedPairs(self.DoneText) do 
			draw.DrawText(v.Text, self.DescFont, xoff + 8 - cw*self.Middle,  offy, v.Color, 0)
			offy = offy + v.YOff
		end

	surface.DisableClipping(false)

	self:PostPaint()
end

function Cloud:AddFormattedText(txt, col, font, overy, num) --if you're updating the text, for example, you can use "num" to position it where you want it

	local nd = string.WordWrap(txt, (self.MaxW or 192) - 16, (font or self.Font))
	local yo = 0
	if not overy then 
		surface.SetFont((font or self.Font))
		local _, chary = surface.GetTextSize("l")

		local _,amt = nd:gsub("\n", "")
		yo = (chary + 4 + chary*amt)
	else 
		yo = overy 
	end
	

	self.DoneText[(num or #self.DoneText+1)] = {Text = nd, Color = col, YOff = yo}
	return #self.DoneText

end

function Cloud:ClearFormattedText()

	table.Empty(self.DoneText)

end


function Cloud:SetAbsPos(x, y)
	local sx, sy = self:ScreenToLocal(x, y)--self:GetParent():ScreenToLocal(x,y)

	self.XShit = sx
	self.YShit = sy

end

function Cloud:Think()

	if self.Active then 
		
		self:SetAlpha(L(self:GetAlpha(), 255, self.Speed, true))

	else 
		
		self:SetAlpha(L(self:GetAlpha(), 0, self.Speed, true))

	end

end

function Cloud:FullInit()

	self.FullInitted = true

end

function Cloud:Popup(bool)

	self.Active = bool

end

vgui.Register("Cloud", Cloud, "InvisPanel")

--[[-------------------------------------------------------------------------
--  FTextEntry
---------------------------------------------------------------------------]]

local TE = {}

function TE:Init()
	self:SetPlaceholderText("Some text")
	self:SetSize(256, 28)
	self:SetFont("A24")
	self:SetEditable(true)
	self:SetKeyBoardInputEnabled(true)
	self:AllowInput(true)

	self.BGColor = Color(40, 40, 40)
	self.TextColor = Color(255, 255, 255)
	self.HTextColor = Color(255, 255, 255)
	self.CursorColor = Color(255, 255, 255)
	self.RBRadius = 2
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
	self.Color = Color(50, 50, 50)
	self.Options = {}

	self.Font = "TWB24"
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
	if IsColor(col) then self.Color = col self.drawColor = self.Color return end 
	self.Color = Color(col or 60, g or col or 60, b or col or 60, a or 255)
end

function FMO:SetHoverColor(col, g, b, a)
	if IsColor(col) then self.HoverColor = col return end 
	self.HoverColor = Color(col or 60, g or col or 60, b or col or 60, a or 255)
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
	self.Hovered = self:IsHovered() --This is so fucking retarded but menu has issues of registering clicks because of defulat dlabel behavior
	if self:IsHovered() then 

		local bg = self.Color or Color(60,60,60)

		if self.HoverColor then 

			self.drawColor = LC(self.drawColor, self.HoverColor)

		else

			local hm = self.HovMult
			local fr = bg.r*hm
			local fg = bg.g*hm
			local fb = bg.b*hm


			self.drawColor = LC(self.drawColor, Color(fr,fg,fb))
		end

		if not self.WasHovered then 
			self:OnHover()
			self.WasHovered = true 
		end

		if self.DescPanel then self.DescPanel.Uncover = true end
	else
		local bg = self.Color or Color(60,60,60)
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
		surface.SetDrawColor(Color(255,255,255))
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
local wrapped = {}

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
	Combo Box
---------------------------------------------------------------------------]]
local FCB = {}

function FCB:Init()
	self:SetSize(160, 24)
	self.Color = Color(50, 50, 50)

	self.Options = {}

	self:SetValue("")
	self.Font = "TWB24"
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
		self.Data[ i ] = data --this data shit is useless
	end
	
	if ( icon ) then
		self.ChoiceIcons[ i ] = icon
	end

	if ( select ) then

		self:ChooseOption( value, i )

	end

	if oncreate then 

		self.OnCreateFuncs[i] = oncreate

	end

	return i

end

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

	if ( self:GetSortItems() ) then
		local sorted = {}

		for k, v in pairs( self.Choices ) do
			local val = tostring( v )
			if ( string.len( val ) > 1 && !tonumber( val ) && val:StartWith( "#" ) ) then val = language.GetPhrase( val:sub( 2 ) ) end
			table.insert( sorted, { id = k, data = v, label = val } )
		end

		for k, v in SortedPairsByMemberValue( sorted, "label" ) do
			local option = self.Menu:AddOption( v.data, function() self:ChooseOption( v.data, v.id ) end )
			option.DesHeight = 32
			if ( self.ChoiceIcons[ v.id ] ) then
				option.Icon = self.ChoiceIcons[ v.id ] 
				option.IconW = 24
				option.IconH = 24
				option.IconPad = 10
				option.Font = "TW24"
			end

			if self.OnCreateFuncs[v.id] then 

				self.OnCreateFuncs[v.id](self, option)
			
			end

		end
	else
		for k, v in pairs( self.Choices ) do
			local option = self.Menu:AddOption( v, function() self:ChooseOption( v, k ) end )
			if ( self.ChoiceIcons[ k ] ) then
				option.Icon =  self.ChoiceIcons[ k ] 
			end
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
	m:MoveTo(x, y, 0.4, 0, 0.3)

	m:AlphaTo(255, 0.1)

end

function FCB:SetColor(col, g, b, a)
	if IsColor(col) then self.Color = col self.drawColor = self.Color return end 
	self.Color = Color(col or 60, g or col or 60, b or col or 60, a or 255)
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

	--draw.SimpleText(self.Text, self.Font, txo, h/2, Color(255,255,255), 0, 1)
end

vgui.Register("FComboBox", FCB, "DComboBox")
--[[
	Icon

	Icon.Rotation = num
	Icon.Icon = mat
]]
local I = {}

function I:Init(w,h)
	self.Icon = Material("__error")	--haha, classic
	self.Rotation = 0
end

function I:Paint(w,h)
	local mat = self.Icon 
	local rot = self.Rotation 
	surface.DrawTexturedRectRotated(w/2,h/2,w,h,self.Rotation)
end

vgui.Register("Icon", I, "InvisPanel")



--[[
	EButton
]]

local ebutton = {}

function ebutton:Init()
	if self.Initted then return end 

	self:SetMinimumSize(60, 30)

	self.FakeW = 60 
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
	end

end

function ebutton:SetExpand(h)
	self.ExpandTo = h
end

function ebutton:GetExpand()
	return self.ExpandPanel
end

function ebutton:OnSizeChanged(w, h)
	if not self.ExpandPanel then self:Init(w, h) end 

	if not self.FakeResize then
		if CurTime() - self.CT > 0.1 then return end 	-- this is to prevent fucking dock resize
														-- i honestly dont know where the fuck it comes from and how to prevent it
		self.FakeW = w
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

		self:SetSize(w, L(h, self.FakeH + self.ExpandTo, self.ResizeMult or 10, true))
		self.RBEx = {bl = false, br = false}

	else 

		self:SetSize(w, L(h, self.FakeH, self.ResizeMult or 10, true))

		if self.FakeH == h then self.RBEx = nil end
	end

end

function ebutton:DoClick()
	self.Expand = not self.Expand
end

function ebutton:Paint(w, h)
	local w2, h2 = self.FakeW, self.FakeH
	self:PrePaint(w2,h2)
	self:Draw(w2, h2)
	self:PostPaint(w2, h2)
end

vgui.Register("EButton", ebutton, "FButton")

if true then return end 

DemoFrame = DemoFrame or nil
if IsValid(DemoFrame) then DemoFrame:Remove() end 

local fr = vgui.Create("FFrame")
DemoFrame = fr

fr:SetSize(600, 400)
fr:Center()

fr:MakePopup()
fr:SetTitle("Demo Frame")

local b = vgui.Create("FButton", fr)
b:SetSize(120, 60)
b:Center()
b.DoClick = function()
	fr:Flash()
end

