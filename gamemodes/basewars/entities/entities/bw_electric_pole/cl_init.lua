include("shared.lua")
AddCSLuaFile("shared.lua")



PowerPoles = PowerPoles or {}
local poles = PowerPoles

function ENT:OnConnectionChange(id, old, new)
	local me = BWEnts[self]

	if not IsValid(new) then
		new = nil
	end

	local key = (id < 9 and "Generators") or (id < 24 and "Electronics") or "Grid"
	me[key][id + 1] = new

	if id < 24 and id >= 9 and IsValid(new) then
		me.ThrowLightning[new] = {t = CurTime(), start = self:GetPos(), ["end"] = new:GetPos(), dist = self:GetPos():Distance(new:GetPos())}
	end

end

local blue = Color(40, 120, 250)
local green = Color(80, 200, 80)

local curtip = ""
local popup = false
local hovd

local hovTall = 400
local unhovTall = 200

function ENT:CreateBaseScroll(pnl, name, icon)

	local scr = vgui.Create("FScrollPanel", pnl)
	scr:SetSize(300, unhovTall)

	local ent = self

	self.Scrolls[scr] = true

	scr:SetMouseInputEnabled(true)

	scr.GradBorder = true
	scr.BackgroundColor = Color(60, 60, 60)
	scr:GetCanvas():DockPadding(0, 8, 0, 8)
	scr.Shadow = {intensity = 3, blur = 1}

	scr.AlphaOverride = true

	scr:SetAlpha(0)
	scr.Alpha = 120

	local wasHov = false
	function scr:PostPaint(w, h)
		surface.DisableClipping(true)

			BSHADOWS.BeginShadow()

				local x, y = self:LocalToScreen(0, 0)

				local tw, th = draw.SimpleText(name, "OSB36", x + w/2, y - 18, color_white, 1, 1)

				surface.SetDrawColor(255, 255, 255)

				surface.DrawMaterial(icon.url, icon.name, x + w/2 - tw/2 - 36, y-18 - 16, 32, 32)

			BSHADOWS.EndShadow(3, 2, 1, 255)

		surface.DisableClipping(false)

		local x, y = self:LocalToScreen(0, 0)
		local is_hov = math.PointIn2DBox(gui.MouseX(), gui.MouseY(), x, y, w, h) --bweh

		if is_hov and not wasHov then
			wasHov = true
			ent.Focus = self
			
			self:OnHover()
		elseif not is_hov and wasHov then
			wasHov = false
			ent.Focus = Either(ent.Focus == self, nil, ent.Focus)

			self:OnUnhover()
		end

		if ent.Focus == self then
			self:To("Alpha", 255, 0.3, 0, 0.3)
		else
			self:To("Alpha", 120, 0.3, 0, 0.3)
		end

		local a = self.Alpha

		if not self.AlphaOverride then self:SetAlpha(a) end
	end

	local curSizeAnim

	function scr:OnHover()
		if curSizeAnim then curSizeAnim:Stop() end
		curSizeAnim = self:SizeTo(self:GetWide(), hovTall, 0.3, 0, 0.3)
		curSizeAnim:On("Think", function(_, fr)
			self.SizeFrac = fr
		end)
	end

	function scr:OnUnhover()
		if curSizeAnim then curSizeAnim:Stop() end
		curSizeAnim = self:SizeTo(self:GetWide(), unhovTall, 0.3, 0, 0.3)
		curSizeAnim:On("Think", function(_, fr)
			self.SizeFrac = 1 - fr
		end)
	end

	return scr
end

function ENT:CreateGeneratorsScroll(pnl, me)

	local scr = self:CreateBaseScroll(pnl, "Generators", {
		url = "https://i.imgur.com/poRxTau.png",
		name = "electricity.png"
	})

	scr.X = pnl:GetWide() / 2 - scr:GetWide() - 8
	scr.Y = pnl.CircleY - scr:GetTall() / 2

	local grid = self:GetGrid()
	local total = 0

	for k,v in ValidPairs(grid.Generators) do
		local f = scr:Add("InvisPanel")
		f:Dock(TOP)
		f:DockMargin(0, 0, 0, 8)
		f:SetTall(64)

		total = total + v.PowerGenerated

		local name = v.PrintName or "wtf"
		local gens = "+" .. (v.PowerGenerated or -1337) .. "PW"

		function f:Paint(w, h)
			surface.SetDrawColor(40, 40, 40)
			surface.DrawRect(0, 0, w, h)


			surface.SetDrawColor(30, 30, 30)
			self:DrawGradientBorder(w, h, 4, 4)

			draw.SimpleText(name, "OSB24", 64 + (w - 64) / 2, 4, color_white, 1, 5)

			draw.SimpleText("Generates: " .. gens, "TWB24", 80, h/2 + 12, green, 0, 1)

			--draw.SimpleText("Stored: " .. v:GetPower() .. "PW", "TWB24", w/2 + 56, h/2 + 12, blue, 0, 1)

		end

		local gen = vgui.Create("ModelImage", f)
		gen:Dock(LEFT)
		gen:DockMargin(8, 8, 8, 8)
		gen:SetSize(48, 48)

		gen:SetModel(v:GetModel())

		local disc = vgui.Create("FButton", f)
		disc:Dock(RIGHT)
		disc:SetSize(24, 56)
		disc:DockMargin(8, 4, 4, 4)

		function disc:PostPaint(w, h)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawMaterial("https://i.imgur.com/6nOrAAO.png", "disconnecttall.png", 4, 0, w-8, h)
		end

		function disc:OnHover()
			popup = true
			curtip = "Disconnect " .. name
			hovd = self
		end

		function disc:OnUnhover()
			if hovd == self then
				popup = false
				hovd = nil
			end
		end
	end

	local greenA = green:Copy()
	local grayA = Colors.Gray:Copy()
	local txW = 0

	scr:On("Paint", function(self, w, h)
		self.SizeFrac = self.SizeFrac or 0
		local a = self.SizeFrac * 255

		greenA.a = a
		grayA.a = a

		local y = h - 24 + self.SizeFrac * 24
		local x, y = self:LocalToScreen(w/2, y)
		BSHADOWS.BeginShadow()
			DisableClipping(true)
				draw.RoundedBoxEx(8, x - txW / 2 - 6, y, txW + 12, 24, grayA, false, false, true, true)
				local txw, txh = draw.SimpleText("Total: +" .. total .. " PW", "OS24", x, y, greenA, 1, 5)
				txW = txw
			DisableClipping(false)
		BSHADOWS.EndShadow(3, 2, 1, 255)
	end)

	return scr
end

local red = Color(200, 100, 100)

function ENT:CreateConsumersScroll(pnl, me)
	local scr = self:CreateBaseScroll(pnl, "Consumers", {
		url = "https://i.imgur.com/poRxTau.png",
		name = "electricity.png"
	})

	scr.X = pnl:GetWide() / 2 + 8
	scr.Y = pnl.CircleY - scr:GetTall() / 2

	local grid = self:GetGrid()
	local total = 0

	for k,v in ValidPairs(grid.Consumers) do
		local f = scr:Add("InvisPanel")
		f:Dock(TOP)
		f:DockMargin(0, 0, 0, 8)
		f:SetTall(64)

		local name = v.PrintName or "wtf"
		local gens = "-" .. v.PowerRequired .. "PW"
		total = total + v.PowerRequired

		function f:Paint(w, h)
			surface.SetDrawColor(40, 40, 40)
			surface.DrawRect(0, 0, w, h)


			surface.SetDrawColor(30, 30, 30)
			self:DrawGradientBorder(w, h, 4, 4)

			draw.SimpleText(name, "OSB24", 64 + (w - 64) / 2, 4, color_white, 1, 5)

			draw.SimpleText("Consumes: " .. gens, "TWB24", 80, h/2 + 12, red, 0, 1)

			--draw.SimpleText("Stored: " .. v:GetPower() .. "PW", "TWB24", w/2 + 64, h/2 + 12, blue, 0, 1)

		end

		local ent = vgui.Create("SpawnIcon", f)
		ent:Dock(LEFT)
		ent:DockMargin(8, 2, 8, 2)
		local size = f:GetTall() - 4
		ent:SetSize(size, size)

		ent:SetModel(v:GetModel())

		local disc = vgui.Create("FButton", f)
		disc:Dock(RIGHT)
		disc:SetSize(24, 56)
		disc:DockMargin(8, 4, 4, 4)

		function disc:PostPaint(w, h)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawMaterial("https://i.imgur.com/6nOrAAO.png", "disconnecttall.png", 4, 0, w-8, h)
		end

		function disc:OnHover()
			popup = true
			curtip = "Disconnect " .. name
			hovd = self
		end

		function disc:OnUnhover()
			if hovd == self then
				popup = false
				hovd = nil
			end
		end
	end

	local redA = red:Copy()
	local grayA = Colors.Gray:Copy()
	local txW = 0

	scr:On("Paint", function(self, w, h)
		self.SizeFrac = self.SizeFrac or 0
		local a = self.SizeFrac * 255

		redA.a = a
		grayA.a = a

		local y = h - 24 + self.SizeFrac * 24
		local x, y = self:LocalToScreen(w/2, y)
		BSHADOWS.BeginShadow()
			DisableClipping(true)
				draw.RoundedBoxEx(8, x - txW / 2 - 6, y, txW + 12, 24, grayA, false, false, true, true)
				local txw, txh = draw.SimpleText("Total: -" .. total .. " PW", "OS24", x, y, redA, 1, 5)
				txW = txw
			DisableClipping(false)
		BSHADOWS.EndShadow(3, 2, 1, 255)
	end)

	return scr
end

function ENT:QMOnBeginClose(qm, self, pnl)

	if IsValid(qm.GenScroll) then
		qm.GenScroll:PopOut(nil, nil, BlankFunc)

		qm.GenScroll.AlphaOverride = true
	end
	if IsValid(qm.ConsumerScroll) then
		qm.ConsumerScroll:PopOut(nil, nil, BlankFunc)

		qm.ConsumerScroll.AlphaOverride = true
	end
end

function ENT:QMOnReopen(qm, self, pnl)
	if IsValid(qm.GenScroll) then
		qm.GenScroll:AlphaTo(120, 0.1, 0, function()
			qm.GenScroll.AlphaOverride = false
		end)

		qm.GenScroll.AlphaOverride = true
	end
	if IsValid(qm.ConsumerScroll) then
		qm.ConsumerScroll:AlphaTo(120, 0.1, 0, function()
			qm.ConsumerScroll.AlphaOverride = false
		end)

		qm.ConsumerScroll.AlphaOverride = true
	end
end

function ENT:QMOnClose(qm, self, pnl)
	if pnl.Cloud then pnl.Cloud:Remove() pnl.NoCloud = true end
end

function ENT:QMThink(qm, self, pnl)

	if pnl.NoCloud then return end --just in case

	pnl.Cloud = pnl.Cloud or vgui.Create("Cloud")

	local cloud = pnl.Cloud

	cloud.MaxW = 512
	cloud.Middle = 0.5
	cloud.Font = "OSB36"
	cloud:Popup(popup)
	cloud:SetLabel(curtip)
	cloud:SetAbsPos(pnl:LocalToScreen(425, 130))
end

function ENT:OpenShit(qm, self, pnl)

	pnl:SetSize(850, 600)	--cant fit
	pnl:CenterHorizontal()
	--pnl.Y = 0
	local x, y = 425, 200	--ScreenToLocal doesn't work for some reason...

	local me = BWEnts[self]

	pnl.CircleX = x

	local gens = self:CreateGeneratorsScroll(pnl, me)

	qm.GenScroll = gens
	gens:AlphaTo(120, 0.1):On("End", function()
		gens.AlphaOverride = false
	end)
	--qm:AddPopIn(gens, gens.X, gens.Y + pnl.CircleSize, 0, 32)

	local consumers = self:CreateConsumersScroll(pnl, me)
	qm.ConsumerScroll = consumers
	consumers:AlphaTo(120, 0.1):On("End", function()
		consumers.AlphaOverride = false
	end)
	--qm:AddPopIn(consumers, consumers.X, consumers.Y + pnl.CircleSize, 0, 32)

end


function ENT:CLInit()

	poles[#poles + 1] = self

	local me = BWEnts[self]
	me.ThrowLightning = {}
	me.Cables = {}

	self.Scrolls = {}

	local qm = self:SetQuickInteractable()

	qm.OnOpen = function(...) self:OpenShit(...) end
	qm.Think = function(...) self:QMThink(...) end
	qm.OnClose = function(...) self:QMOnBeginClose(...) end
	qm.OnFullClose = function(...) self:QMOnClose(...) end
	qm.OnReopen = function(...) self:QMOnReopen(...) end

	self:OnChangeGridID(self:GetGridID())
end

function ENT:OnChangeGridID(new)
	if self.OldGridID == new or new <= 0 then return end


	self.OldGridID = new

	local grid = PowerGrids[new]

	if not grid then
		grid = PowerGrid:new(self:CPPIGetOwner(), new)
		grid:AddLine(self)
	else
		grid:AddLine(self)
	end
end
local cab = Material("cable/cable2")
local lightning = Material("trails/electric")

hook.Add("PostDrawTranslucentRenderables", "DrawPoleCables", function(d, sb)
	--local b = bench("rendering")
	--b:Open()

	if sb then return end--or #poles <= 0 then return end

	for k, grid in pairs(PowerGrids) do

		if #grid.PowerLines == 0 then continue end

		for key, ent in pairs(grid.AllEntities) do
			local pos
			local genpos

			local pole = ent:GetLine()
			if not pole:IsValid() then continue end

			if ent.PowerType == "Line" then
				local pts = ent.ChainPoints
				local chosen = pts[key % (#pts - 1) + 1]

				pos = pole:LocalToWorld(chosen)
				genpos = ent:LocalToWorld(chosen)
				me = BWEnts[ent]
			else
				pos = pole:LocalToWorld(pole.ConnectPoint)
				genpos = ent:GetPos()
			end

			local me = BWEnts[pole]

			if not me.ThrowLightning then continue end

			render.SetMaterial(cab)


			local them = BWEnts[ent]
			local cab = me.Cables[ent]

			local qual = (ent.PowerType == "Line" and 35) or 10

			if not cab or cab.From ~= pos or cab.To ~= genpos then--if newpos or them.LastCablePos ~= genpos or them.LastCableTo ~= pos or not them.Cable then
				local h = (ent.PowerType == "Line" and math.min(20, math.sqrt(math.max(600 - pos:Distance(genpos), 16)))) or 3
				
				me.Cables[ent] = GenerateCable(pos, genpos, h, qual)
				me.Cables[ent].From = pos
				me.Cables[ent].To = genpos
			end

			local cable = me.Cables[ent]

			render.StartBeam(#cable)

				for i=1, qual do
					render.AddBeam( cable[i], 2, 0.5, color_white)
				end

			render.EndBeam()

			::fuck_off::
		end


	end

	--b:Close()
end)