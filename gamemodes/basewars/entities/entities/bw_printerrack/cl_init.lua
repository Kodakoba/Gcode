AddCSLuaFile()
include("shared.lua")


function ENT:CLInit()

	if not self.FontColor then self.FontColor = color_white:Copy() end
	if not self.BackColor then self.BackColor = color_black:Copy() end

	self.Printers = Networkable(("PrinterRack:%d"):format(self:EntIndex())):Bond(self)
	self.PowerRequired = 5
end

local fontName = "BaseWars.MoneyPrinter"



local WasPowered

local wpad = 32


local yoff = 90
local barH = 32

function ParsePrintersOut(str)
	local t = string.Explode(" ", str) or {}

	for k,v in pairs(t) do
		t[k] = tonumber(v)
	end

	return t
end


function ENT:GetMiscPos()

	local pos = self:GetPos()
	local ang = self:GetAngles()
	--Vector (17.3935546875, -11.271484375, -1.4185791015625)
	pos = pos + ang:Up() * 76.5
	pos = pos + ang:Forward() * -19.2
	pos = pos + ang:Right() * 17.6

	ang:RotateAroundAxis(ang:Forward(), 90)

	--ang:RotateAroundAxis(ang:Forward(), 90)
	return pos, ang, 0.05

end

local scaleH = { --bool = scaled down or not
	[false] = 72,
	[true] = 56
}

local function CreateFrame(ent)

	local f =  vgui.Create("FFrame")
	f:SetPos(0,0)
	f:SetSize(750, 1500)
	f:SetDraggable(false)

	f.Buttons = {}
	f:SetCloseable(false, true)
	f.HeaderSize = 48

	f:DockPadding(16, 64, 16, 16)
	f.ScaleDown = ScrH() < 800

	local col = vgui.Create("FButton", f)

	f:On("Think", function(self)
		if not IsValid(ent) then self:Remove() return end --bruh
	end)

	function f:PostPaint(w,h)
		
		
		--self:DrawHeaderPanel(w,h)

		draw.SimpleText("Printer Rack", "OSB28", w/2, 24, color_white, 1, 1)
		self.ScaleDown = ScrH() < 800

		local desH = scaleH[self.ScaleDown]

		for k,v in pairs(self.Buttons) do
			if v:GetTall() ~= desH and v.ExpandFrac == 0 then
				v:SetTall(desH)
			end
		end

		col:SetTall(desH * 1.5)
	end
	ent.Frame = f

	col:SetSize(450, 120)
	col:DockMargin(150, 24, 150, 24)
	col:Dock(TOP)
	col:SetZPos(32766)

	local color = Color(90, 180, 90)
	function col:Think()
		if not IsValid(ent) then return end
		if ent:CPPIGetOwner() ~= LocalPlayer() then
			self:SetColor(Colors.Button)
		else
			self:SetColor(color)
		end
	end

	function col:DoClick()
		net.Start("PrinterRack")
			net.WriteEntity(ent)
			net.WriteUInt(1, 2)
		net.SendToServer()
	end

	col.Label = "Collect"
	col.Font = "OSB48"
	col.DrawShadow = false
	return f
end

function ENT:Draw()

	self:DrawModel()

	local dist = LocalPlayer():GetPos():DistToSqr(self:GetPos())
	if dist > 65536 then return end

	local pos, ang, scale = self:GetMiscPos()

	if not IsValid(self.Frame) then
		CreateFrame(self)
	end
	local f = self.Frame

	local pr = self:GetPrinters()
	local t = self.Printers.Networked--ParsePrintersOut(pr)

	local i = 0

	local rack = self

	for entKey, entID in ipairs(t) do

		if IsValid(f.Buttons[k]) then continue end

		local ent = Entity(entID)

		if not IsValid(ent) then continue end

		f.Buttons[entKey] = vgui.Create("EButton", f)
		local fr = f.Buttons[entKey]
		fr:SetDoubleClickingEnabled(false)
		--fr:SetPos(50, -100 + f.HeaderSize + 16 + 100*i)
		local frH = scaleH[f.ScaleDown]

		fr:SetSize(375, frH)
		fr:Dock(TOP)
		fr:DockMargin(8, 4, 8, 0)
		fr.Border = {w = 2, h = 2}
		fr.borderColor = ent.FontColor or Color(255, 0, 0)
		fr.ID = entKey

		function fr:IsHovered()
			return self.Hovered and not (self.Eject.Hovered or self.Upgrade.Hovered)
		end
		local dc = fr.DoClick

		function fr:DoClick()
			if not self:IsHovered() then return end

			for k,v in pairs(f.Buttons) do
				if v == self then continue end

				v:RetractBtn()
			end

			dc(self)
		end

		function fr:PostPaint(w, h)
			if not IsValid(ent) or rack.Printers:GetNetworked()[entKey] ~= entID then self:Remove() print("invalid or not self lolno") return end

			local txt = (ent.PrintName .. " Lv. " .. ((ent.GetLevel and ent:GetLevel()) or "-2.147b")) or " ??? "

			draw.SimpleText(txt, "BS36", 12, h/2, color_white, 0, 1)


			if ent.GetPrintAmount then
				local amt = ("$%s/s."):format(BaseWars.NumberFormat(ent:GetPrintAmount()))
				draw.SimpleText(amt, "BS24", w - 8, h/2, color_white, 2, 1)
			end
		end

		function fr.ExpandPanel:Paint(w, h)  

							-- V only because 3d2d panels act wonky with clipping
			fr:ExpandPaint(w, fr:GetTall() - fr.FakeH)

			-- somehow makes upgrade/eject buttons clip properly??
			-- i ain't askin
			self:NoClipping(true)
		end

		function fr.ExpandPanel:PaintOver()
			self:NoClipping(false)
		end

		fr.Eject = vgui.Create("FButton", fr.ExpandPanel)
		local b = fr.Eject

		b:Dock(FILL)
		b:DockMargin(400, 16, 100, 16)

		b:InvalidateParent(true)

		b:SetLabel("Eject")
		b.Font = "OS32"
		--b:SetPaintedManually(true)

		b.DoClick = function(s)
			print("doclick called")
			net.Start("PrinterRack")
				net.WriteEntity(self)
				net.WriteUInt(0, 2) -- = eject
				net.WriteUInt(entKey, 8)
			net.SendToServer()

		end
		b:SetColor(90, 90, 90)
		b.DrawShadow = false

		function b:PostPaint(w, h)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawMaterial("https://i.imgur.com/8xUwtGR.png", "eject.png", 18, 13, 32, 32)
		end

		function b:IsHovered()
			return self.Hovered
		end

		fr.Upgrade = vgui.Create("FButton", fr.ExpandPanel)
		local b2 = fr.Upgrade

		b2:SetPos(100, 16)
		b2:SetSize(236, b:GetTall())

		b2:SetLabel("Upgrade")
		b2.Font = "OS32"
		--b:SetPaintedManually(true)

		b2:SetDoubleClickingEnabled(false)
		b2.TextAX = 0
		b2.TextX = 18 + 32 + 8

		function b2:PostPaint(w, h)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawMaterial("https://i.imgur.com/6CyUc0d.png", "upgrade.png", 18, 13, 32, 32)

			local lc = self.LabelColor

			if self:IsHovered() then
				lc.a = L(lc.a, 0, 30, true)
			else
				lc.a = L(lc.a, 255, 30, true)
			end

			local cost = BaseWars.NumberFormat(ent:GetUpgradeValue() * ent:GetLevel())
			draw.SimpleText("$" .. cost, "OS36", 18 + 32 + 8, h/2, ColorAlpha(color_white, 255 - lc.a), 0, 1)

		end


		function b2:PrePaint(w, h)

		end

		--[[local m1 = false

		-function b:OnMousePressed()
			if not m1 then
				self:DoClick()
			end
			m1 = true
		end

		function b:OnMouseReleased()
			m1 = false
		end]]

		b2.DoClick = function(self)
			net.Start("BW.Upgrade")
				net.WriteEntity(ent)
			net.SendToServer()
		end

		b2:SetColor(90, 90, 90)

		function b2:IsHovered()
			return self.Hovered
		end
		b2.DrawShadow = false

	end

	for k,v in pairs(f.Buttons) do
		if not IsValid(v) then f.Buttons[k] = nil continue end
		if t[v.ID]==0 then v:PopOut() f.Buttons[k] = nil continue end
	end

	vgui.Start3D2D( pos, ang, scale )
		self.Frame:Paint3D2D()
	vgui.End3D2D()

end
