--hairy balls

function Research.RequestResearch(perk, ent)
	local id = perk.ID
	local lv = LocalPlayer():GetPerk(id)

	local reqs = perk.Levels[lv + 1]

	if not reqs or not IsValid(ent) then return end

	net.Start("Research")
		net.WriteUInt(perk.NumID, 16)
		net.WriteEntity(ent)
	net.SendToServer()
end



local pmain

local curcat
local cmat = Material("vgui/circle")

function CreatePerkFrame(par, perk, ent)
	local f = vgui.Create("InvisPanel", par)
	f:SetPos(24 + 200 + 8, 4)
	f:SetSize(par:GetWide() - 24 - 200 - 16, par:GetTall())

	f.Perk = perk

	local names = {}
	local descs = {}
	local reqs = {}
	local ylds = {}

	local reqp

	local lv = LocalPlayer():GetPerk(perk:GetID())

	function f:CreateLabels(perk)
		local name = vgui.Create("DLabel", f)
		name:SetText(perk:GetName())
		name:SetFont("TW64")


		local desc = vgui.Create("DLabel", f)
		desc:SetFont("OS20")
		desc:SetText(perk:GetDescription():WordWrap(self:GetWide() - 32, "OS20"))

		desc.X = 8
		desc.Y = 80

		local yields
		local pylds = perk.Levels[lv + 1].Yields

		if pylds then
			yields = vgui.Create("Panel", f)
			yields:SetSize(reqp:GetWide(), 72)
			yields.Y = reqp.Y - 72
			yields.Btns = {}

			function yields:Paint(w, h)
				draw.RoundedBox(4, 0, 0, w, h, Color(40, 40, 40))

				surface.SetDrawColor(Color(30, 30, 30))

				surface.SetMaterial(MoarPanelsMats.gu)
				surface.DrawTexturedRect(0, 0, w, 4)

				surface.SetMaterial(MoarPanelsMats.gd)
				surface.DrawTexturedRect(0, h - 4, w, 4)


			end

			local i = 0

			for k,v in pairs(pylds) do
				i = i + 1
				local b = vgui.Create("FButton", yields)
				b:SetSize(64, 64)
				b:SetPos(8 + 72*(i-1), 4)

				function b:OnHover()
					print("you dare hover over me?")
					if not self.Cloud then
						self.Cloud = vgui.Create("Cloud", self)
						local cl = self.Cloud

						if v.name then
							cl.Label = v.name
						end

						if v.desc then
							for k,v in pairs(v.desc) do
								cl:AddFormattedText(v.Text, v.Color or Color(255, 255, 255), v.font or "OS18", (v.Continuation and 0))
							end
						end
						local x, y = self:LocalToScreen(32, 0)
						cl:SetAbsPos(32, -16)
					end

					local cl = self.Cloud

					cl:Popup(true)
				end

				function b:OnUnhover()
					if self.Cloud then
						self.Cloud:Popup(false)
					end
				end

				local icurl
				local icname
				local ix, iy, iw, ih
				local icol

				local imdl

				function b:PostPaint(w, h)
					if imdl then
						surface.SetDrawColor(Color(255, 255, 255))
						draw.DrawOrRender(self, imdl, 0, 0, w, h)

					elseif icurl then
						local nw, nh = iw or w, ih or h

						local nx = ix or w/2 - nw/2
						local ny = iy or h/2 - nh/2

						surface.SetDrawColor(icol or Color(255, 255, 255))
						surface.DrawMaterial(icurl, icname, nx, ny, nw, nh)
					end
				end

				if v.model then
					imdl = v.model
				end

				if v.icon then
					local i = v.icon

					icurl = i.URL
					icname = i.Name
					ix, iy, iw, ih = i.X, i.Y, i.W, i.H
					icol = i.Color
				end

			end


			ylds[#ylds + 1] = yields
		end

		local reql = vgui.Create("Panel", reqp)	--requirements panel: subpanel, contains labels on it
		reql:SetSize(reqp:GetSize())
		reql:PopIn()


		local reqs = perk:GetRequirements(lv + 1)

		local reqsdraw = {}

		for k,v in pairs(reqs) do
			if not Items[k] then continue end

			local item = Items[k]
			local text = "x%s %s"

			text = text:format(v, item.name)

			reqsdraw[k] = {text = text, has = Inventory.EnoughItem(k, v)}

		end

		function reql:Paint(w, h)

			draw.SimpleText("Requirements for lv. " .. lv + 1 .. ":", "TWB28", w/2, 4, color_white, 1, 5)
			local i = 1
			local col = 0

			for k,v in pairs(reqsdraw) do
				draw.SimpleText(v.text, "TW24", 8 + 150*col, 32 + i*20, (v.has and Color(100, 200, 100)) or Color(200, 100, 100), 0, 1)
				i = i+1

				if 32+i*20 > 150 then
					col = col + 1
					i = 1
				end
			end
			if table.IsEmpty(reqsdraw) then
				draw.SimpleText("Free!", "TWB32", w/2, h/2 - 16, Color(150, 150, 150), 1, 1)
			end

		end

		local start = vgui.Create("FButton", reql)

		start:SetSize(200, 50)
		start:SetColor(100, 200, 100)

		start:Center()
		start.Y = reql:GetTall() - 60
		start.Label = "Start Research"
		function start:Think()
			if self.PermaDisabled then return end

			for k,v in pairs(reqsdraw) do
				if not v.has then self:SetColor(50, 50, 50) self.Disabled = true return end
			end
			self:SetColor(100, 200, 100)
			self.Disabled = false
		end

		function start:DoClick()
			if self.Disabled or self.PermaDisabled then return end
			Research.RequestResearch(perk, ent)
			if IsValid(pmain) then
				pmain:PopOut()
			end
			f:PopOut()
			self.PermaDisabled = true
		end
		name:SizeToContents()
		name:Center()
		name.Y = 16

		desc:SizeToContents()

		return name, desc, reql
	end

	reqp = vgui.Create("InvisPanel", f)	--requirements panel: main, merely a container for subpanels, also for painting
	reqp:SetPos(0, f:GetTall() - 200)
	reqp:SetSize(f:GetWide(), 200)

	local nl, dl, rl = f:CreateLabels(perk)

	names[1] = nl
	descs[1] = dl
	reqs[1] = rl


	function f:Paint(w, h)

		local prk = f.Perk

		draw.RoundedBoxEx(8, 0, 0, w, h, Color(45, 45, 45), true, true)

		--draw.SimpleText(perk:GetName(), "TW64", w/2, 6, color_white, 1)
	end



	function reqp:Paint(w, h)
		local prk = f.Perk

		surface.SetAlphaMultiplier(f:GetAlpha() / 255)
		draw.RoundedBoxEx(6, 0, 0, w, h, Color(30, 30, 30), false, false, true, true)

		surface.SetMaterial(MoarPanelsMats.gu)
		surface.SetDrawColor(10, 10, 10, 150)
		surface.DrawTexturedRect(0, 0, w, 4)
	end


	function f:ChangePerk(perk)

		for k,v in pairs(names) do
			v:PopOut(0.05)
			table.remove(names, k)
		end

		for k,v in pairs(descs) do
			v:PopOut(0.05)
			table.remove(descs, k)
		end

		for k,v in pairs(reqs) do
			v:PopOut(0.05)
			table.remove(reqs, k)
		end

		for k,v in pairs(ylds) do
			v:PopOut(0.05)
			table.remove(ylds, k)
		end

		local name, desc, reql = self:CreateLabels(perk)

		table.insert(names, name)
		table.insert(descs, desc)
		table.insert(reqs, reql)

		self.Perk = perk
	end

	f.ReqPnl = reqp

	f:PopIn()

	return f
end

--[[
function CreatePerkList(par, subcat, ent)

	local pmain = vgui.Create("InvisPanel", par)
	pmain:SetPos(100 + 8, 0)
	pmain:SetSize(par:GetWide() - 8, par:GetTall())
	pmain:PopIn()
	pmain.Expanded = false
	pmain.SubCat = subcat



	function pmain:Think()

		if not IsValid(par) then return end

		if par.Expanded ~= self.Expanded then
			self:SizeTo(((par.Expanded and par.ExpandsTo) or par.UnexpandsTo) - 108, -1, 0.4, 0, 0.3)
			self.Expanded = par.Expanded
		end

	end

	local f = vgui.Create("FScrollPanel", pmain)
	f:SetPos(24, 0)
	f:SetSize(200, par:GetTall())
	f:GetCanvas():DockPadding(8, 4, 8, 8)

	f.GradBorder = true
	pmain.scr = f

	local pf

	function pmain:Disappear()
		self:PopOut()
		if IsValid(pf) then pf:PopOut() end
	end

	local perksfr = vgui.Create("InvisPanel", f)
	perksfr.Perks = {}
	perksfr:SetWide(f:GetWide())

	function pmain:NewPerks(tbl)

		if IsValid(perksfr) then

			local sanim = perksfr:NewAnimation(0.6, 0, 0.7, function(_, self)
					self:Remove()
					f.VBar.NoResize = false
				end)

			sanim.Think = function(_, s, fr)
				s:SetAlpha(255 - 255*fr)

				f.VBar.NoResize = true 	--Forces the subcats scrollpanel to not stretch vertically
			end

			perksfr:MoveBy(0, 600, 0.5, 0, 2)

			perksfr = nil
		end

		perksfr = vgui.Create("InvisPanel", f)	--where perks should be added; exists purely to make the
												--perks-falling-animation work
		perksfr.Perks = {}
		perksfr:SetWide(f:GetWide())

		for k,v in pairs(tbl) do
			local perk = vgui.Create("FButton", perksfr)
			perk:Dock(TOP)
			perk:SetTall(48)
			perk:DockMargin(4, 4, 4, 8)
			perk.Label = v:GetName()
			perk.DrawShadow = false

			perk:InvalidateParent()
			perk.Perk = v

			function perk:PostPaint(w, h)
				local v = self.Perk
				local ic = v:GetIcon()
				self.Label = v:GetName()
				if ic then
					surface.SetDrawColor(255, 255, 255)
					surface.DrawMaterial(ic.url, ic.name, 8, 8, 32, 32)

					self.TextAX = 0
					self.TextX = 48
				end
				if IsValid(pf) and pf.Perk == self.Perk then
					self.Color = Color(50, 150, 250)
				else
					self.Color = Color(70, 70, 70)
				end


			end

			function perk:DoClick()
				if not IsValid(pf) then
					pf = CreatePerkFrame(pmain, self.Perk, ent)

					local scr = par.scr

					if IsValid(scr) and not scr.Folded then
						scr:Fold(24, function()
							pmain:MoveBy(76 + 24, 0, 0.2, 0, 0.3)
						end)
						pmain:MoveBy(-76 - 24, 0, 0.2, 0, 0.3)
					end


				elseif self.Perk ~= pf.Perk then
					pf:ChangePerk(self.Perk)

					local scr = par.scr

					if IsValid(scr) and not scr.Folded then
						scr:Fold(24, function()
							pmain:MoveBy(76 + 24, 0, 0.2, 0, 0.3)
						end)
						pmain:MoveBy(-76 - 24, 0, 0.2, 0, 0.3)
					end

				end
			end
			perksfr.Perks[#perksfr.Perks + 1] = perk
		end

		perksfr:SetPos(0, -(#perksfr.Perks * 60 + 16))
		perksfr:SetSize(f:GetWide(), #perksfr.Perks * 60 + 16)

		perksfr:MoveBy(0, #perksfr.Perks * 60 + 16, 0.4, 0.07, 0.4)

	end

	pmain:NewPerks(subcat.Perks)


	function pmain:ChangeSubCat(subcat)
		local i = 1
		self.SubCat = subcat
		pmain:NewPerks(subcat.Perks)

	end


	return pmain

end
]]

function CreatePerkTree(par, subcat, ent)
	local main = vgui.Create("Panel", par)
	main:SetPos(116, 0)
	main:SetSize(par.UnfoldedW - 124, par:GetTall())
	main.SubCat = subcat
	main:PopIn()
	main.Offset = {x = 0, y = 0}

	local canvas = vgui.Create("Panel", main)

	local origW, origH = 1200, 1200

	canvas:SetSize(origW, origH)	--source seems ok with ridiculous panel sizes.

	local setpos = false

	canvas.Offset = {x = 0, y = 0}
	canvas.Panels = {}
	canvas.Size = 1
	canvas.NewSize = 1


	canvas:SetMouseInputEnabled(true)

	local mW, mH = main:GetSize()


	canvas:SetPos(-canvas:GetWide()/2 + mW/2, -canvas:GetTall()/2 + mH/2)

	local container = vgui.Create("Panel", canvas)
	container:SetSize(canvas:GetSize())
	container.Offset = {x = 0, y = 0}
	container.Panels = {}

	container.Size = 0.5
	container.NewSize = container.Size - 0.00000001
	container:SetMouseInputEnabled(true)

	container.PrevW, container.PrevH = container:GetSize()

	container.WasWhere = {container:GetPos()}

	container.ZoomedWhere = {container:GetWide() / 2, container:GetTall() / 2}
	container.Moved = {0, 0}

	function canvas:Paint(w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(40, 40, 40))

		local size = container.Size

		local div = 1 / size

		render.PushFilterMag( TEXFILTER.ANISOTROPIC )
		render.PushFilterMin( TEXFILTER.ANISOTROPIC )

		local gW, gH = 240, 240
		local u, v = mW/gW * div, mH/gH * div



		local u2, v2 = u + (50*size), v + (50*size)

			surface.DisableClipping(true)
			surface.SetDrawColor(50+self.Size*20, 50+self.Size*20, 50+self.Size*20, 70)

			local xd, yd = -container.X, -container.Y

			surface.DrawUVMaterial("https://i.imgur.com/UVOE9B2.png", "grid.png", -canvas.X, -canvas.Y, mW, mH, -u - xd, -v - yd, u - xd, v - yd)
			surface.DisableClipping(false)

		render.PopFilterMag()
		render.PopFilterMin()

	end

	par:Fold()

	function main:Disappear()
		par:Unfold()
		self:PopOut()
	end

	function main:ChangeSubCat(new)
		self.SubCat = new
	end

	local lx, ly
	local was = false


	function container:Think()

		local dx, dy = 0, 0
		local mdown = input.IsMouseDown(MOUSE_RIGHT)

		if mdown and self.Moving then
			local mx, my = input.GetCursorPos()

			dx, dy = mx - (lx or mx), my - (ly or my)
			lx, ly = mx, my
		elseif not mdown then
			self.Moving = false
			lx, ly = nil, nil
		end

		if self.NewSize ~= self.Size then
			local change = self.Size

			self.Size = L(self.Size, self.NewSize, 15)
			canvas.Size = self.Size

			local oldW, oldH = self:GetSize()

			self:SetSize(origW * self.Size, origH * self.Size)

			local difW, difH = self:GetWide() - oldW, self:GetTall() - oldH

			local preW, preH = self.PrevW, self.PrevH

			local oldX, oldY = self.WasWhere[1], self.WasWhere[2]
			local zX, zY = self.ZoomedWhere[1], self.ZoomedWhere[2]

			local frac = math.min(self.NewSize, self.Size) / math.max(self.NewSize, self.Size)

			local w, h = self:GetSize()

			local curX, curY = self:GetPos()
			local mv = self.Moved

			local tomovex, tomovey = (zX/preW*difW), (zY/preH*difH)--(zX - oldX + w) * frac, (zY - oldY + h) * frac

			if tomovex < 1 and tomovex> -1
			or tomovey < 1 and tomovey> -1 then
			else --oops

				self:SetPos(
					curX - (tomovex),
					curY - (tomovey)
				)

			end

			for k, pnl in pairs(self.Panels) do

				pnl:SetSize(pnl.OrigW * self.Size, pnl.OrigH * self.Size)

				pnl.X = (pnl.OrigFX/100 * self:GetWide()) - pnl:GetWide()/2
				pnl.Y = (pnl.OrigFY/100 * self:GetTall()) - pnl:GetWide()/2

			end
		end

		self:SetPos(self.X + dx, self.Y + dy)
	end

	function container:Paint(w, h)
		--draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 20))
		surface.SetDrawColor(Color(200, 100, 100))

		for k,v in pairs(self.Panels) do

			local w, h = v:GetSize()

			if v.ConnectedTo then
				local lX, lY = v:ScreenToLocal(self:LocalToScreen(v.ConnectedTo:GetPos()))

				draw.RotatedBox(v.X + w/2, v.Y + h/2, v.X + lX+w/2, v.Y + lY+h/2, self.Size*4)
			end

		end
	end


	function container:OnMousePressed(k)
		if k~=MOUSE_RIGHT then print("no") return end

		self.Moving = true

	end

	function container:OnMouseWheeled(d)
		self.PrevW, self.PrevH = self:GetSize()
		self.NewSize = math.Clamp(self.NewSize + d/10, 0.25, 1.25)
		self.WasWhere = {self:GetPos()}

		local mX, mY = self:ScreenToLocal(input.GetCursorPos())
		mX = math.Clamp(mX, 0, self:GetWide())
		mY = math.Clamp(mY, 0, self:GetTall())
		self.ZoomedWhere = {mX, mY}
		self.Moved = {0, 0}
	end

	function container:OnMouseReleased(k)
		if k~=MOUSE_RIGHT then return end
		self.Moving = false
		lx, ly = 0, 0
	end

	canvas.OnMouseWheeled = function(_, d) container:OnMouseWheeled(d) end
	canvas.OnMouseReleased = function(_, d) container:OnMouseReleased(d) end
	canvas.OnMousePressed = function(_, d) container:OnMousePressed(d) end

	function container:AddPanel(pnl, fx, fy)
		self.Panels[#self.Panels + 1] = pnl

		pnl:SetSize(pnl:GetWide() * self.Size, pnl:GetTall() * self.Size)

		x, y = self:GetWide() * fx/100 - pnl:GetWide() / 2, self:GetTall()*fy/100 - pnl:GetTall() / 2

		pnl:SetParent(self)
		pnl:SetPos(x, y)

		pnl.OrigW, pnl.OrigH = pnl:GetSize()
		pnl.OrigX, pnl.OrigY = x, y
		pnl.OrigFX, pnl.OrigFY = fx, fy
	end

	for name, perk in pairs(subcat.Perks) do

		local lastNode

		for lv, lvt in ipairs(perk.Levels) do

			if not lvt.Pos then print("Can't get pos for perk", perk.Name) continue end

			local btn = vgui.Create("DButton")
			btn:SetSize(200, 200)
			btn:SetText("")

			if lastNode then btn.ConnectedTo = lastNode end

			function btn:Paint(w, h)

				surface.SetDrawColor(Color(80, 80, 80))
				draw.MaterialCircle(w/2, h/2, w, h)

				surface.SetDrawColor(color_white)
				surface.DrawMaterial("https://i.imgur.com/dO5eomW.png", "plus.png", w * 0.2, h * 0.2, w*0.6, h*0.6)

				--draw.SimpleText(lv, "OS20", w/2, h, color_white, 1, 4)

			end
			local omp = btn.OnMousePressed

			function btn:OnMousePressed(k)
				if k==MOUSE_RIGHT then
					container:OnMousePressed(k)
				else
					omp(self, k)
				end
			end
			lastNode = btn

			container:AddPanel(btn, lvt.Pos.x, lvt.Pos.y)
		end

	end

	return main

end

function OpenResearchSelectMenu(ent)
	local self = ent
	if IsValid(pmain) then return end

	local f = vgui.Create("FFrame")

	pmain = f
	f:SetSize(800, 600)
	f:Center()
	f:MakePopup()
	f.Shadow = {}

	local fw = 800
	local hh = f.HeaderSize + 4
	local ent = self

	f:PopIn()

	local rslist = vgui.Create("FScrollPanel", f)
	rslist:SetPos(8, hh)
	rslist:SetSize(250, 600 - f.HeaderSize - 8)
	rslist:GetCanvas():DockPadding(8, 8, 8, 8)

	rslist.GradBorder = true

	local cats = {}
	local subfr = {}

	local perklist 	--perktree created by CreatePerkTree function
	local unexp		--invisible button for unfolding

	--Categories panel

	local function CreateSubScroll(skipanim)

		unexp = vgui.Create("DButton", f)
		unexp:SetMouseInputEnabled(false)
		unexp:SetPos(0, hh)
		unexp:SetSize(32, rslist:GetTall() )
		unexp:SetText("")

		function unexp:Paint()

		end
		function unexp:DoClick()
			perklist:Disappear()
			perklist = nil
		end

		subfr = vgui.Create("InvisPanel", f)	--main subframe button, holds subcats, perks and perk info
		subfr:SetPos(8 + 250, f.HeaderSize + 4)

		local unexpw = fw - 250 - 8 - 24 - 8
		local expw = fw - 32 - 8

		subfr:SetSize(unexpw, f:GetTall() - f.HeaderSize - 8)
		subfr:PopIn()
		subfr:MoveBy(16, 0, 0.2, 0.05, 0.4)

		subfr.Expanded = false

		subfr.ExpandsTo = expw
		subfr.UnexpandsTo = unexpw

		local scr = vgui.Create("FScrollPanel", subfr)	--subcats scroll

		local function UnexpandButton(self, wid, callback)	--stinky solution
			local btn = vgui.Create("DButton", subfr)

			btn:SetPos(self.X, 0)
			btn:SetSize(wid, subfr:GetTall())
			btn:SetAlpha(0)

			self.Folded = true

			local scr = self

			function btn:DoClick()
				callback()
				self:Remove()
				scr.Folded = false
			end

			function btn:Think()
				if not IsValid(self) or not subfr or not subfr.Expanded then
					self:Remove()
					scr.Folded = false
				end
			end

		end

		scr.Fold = UnexpandButton
		local po = scr.PaintOver

		local a = 0

		local st = 0	--trying out new way of animating
		local et = 0
		local out = true

		function scr:PaintOver(w, h)
			po(self, w, h)
			surface.SetDrawColor(10, 10, 10, a)
			surface.DrawRect(0, 0, w, h)

			if self.Folded and out then --well this was cancer.
				st = CurTime() 			--probably need to find a smarter way, yeah?
				et = CurTime() + 0.3
				out = false
			elseif not self.Folded and not out then --actually i shouldve used the Animations library lol
				st = CurTime()
				et = CurTime() + 0.3
				out = true
			end

			local frac = math.min(math.TimeFraction(st, et, CurTime()), 1)
			frac = 1 - ((1 - frac) ^ (1/0.3))

			a = frac * 230

			if out then
				a = math.max(230 - a, 0)
			end

		end

		function subfr:Think()

			if IsValid(perklist) and not self.Expanded then

				self:MoveTo(8 + 24, hh, 0.4, 0, 0.3)
				self:SizeTo(expw, -1, 0.4, 0, 0.3)
				scr:MoveTo(8, 0, 0.35, 0, 0.3)
				self.Expanded = true

			elseif not IsValid(perklist) and self.Expanded then

				self:MoveTo(24 + 250, hh, 0.4, 0, 0.3)
				self:SizeTo(unexpw, -1, 0.4, 0, 0.3)
				scr:MoveTo(0, 0, 0.35, 0, 0.3)
				self.Expanded = false

			end
			unexp:SetMouseInputEnabled(self.Expanded)
		end

		subfr.UnfoldedW = expw
		subfr.FoldedW = unexpw
		function subfr:Paint(w, h)
			draw.RoundedBox(8, 0, 0, w, h, Color(60, 60, 60))
		end

		function subfr:Fold()
			self.Expanded = false
		end

		function subfr:Unfold()
			self.Expanded = true
		end

		local a = 0
		local po = rslist.PaintOver

		function rslist:PaintOver(w, h)
			po(self, w, h)
			if not IsValid(subfr) then return end

			if subfr.Expanded then
				a = L(a, 240, 15)
			else
				a = L(a, 0, 20)
			end

			surface.SetDrawColor(10, 10, 10, a)
			surface.DrawRect(0, 0, w, h)
		end


		subfr.scr = scr
		scr:SetSize(100, subfr:GetTall())

		scr.GradBorder = true

		function subfr:Regenerate(cat, noanim)

			local scrsubpnl = vgui.Create("InvisPanel", scr)

			scrsubpnl.Btns = {}
			local i = 0
			local sanim
			local size = 40

			for k, subcat in pairs(curcat:GetSubCategories()) do

				local subbtn = vgui.Create("DButton", scrsubpnl)

				subbtn:SetPos(10, 8 + 88 * i)
				subbtn:SetSize(80, 80)
				subbtn:SetText("")
				function subbtn:Paint(w, h)

					if scrsubpnl.Shrink and not sanim then

						sanim = scrsubpnl:NewAnimation(0.6, 0, 0.7, function()
							scrsubpnl:Remove()
							scr.VBar.NoResize = false
						end)

						sanim.Think = function(_, _, fr)
							size = 40 - 12*fr
							scrsubpnl:SetAlpha(255 - 255*fr)
							scr.VBar.NoResize = true
						end

						scrsubpnl:MoveBy(0, subfr:GetTall(), 0.5, 0, 3)
						scr.VBar.NoResize = true
					end

					local sel = IsValid(perklist) and perklist.SubCat == subcat
					self.Color = LC(self.Color or Color(75, 75, 75), (sel and Color(50, 150, 250)) or Color(75, 75, 75))

					surface.SetDrawColor( ColorAlpha(self.Color, scrsubpnl:GetAlpha() ) )
					draw.NoTexture()

					draw.MaterialCircle(w/2, h/2, size*2)

					local s2 = size - 16
					surface.SetDrawColor(ColorAlpha(color_white, scrsubpnl:GetAlpha()))
					surface.DrawMaterial(subcat:GetIcon().url, subcat:GetIcon().name, w/2 - s2, h/2 - s2, s2 * 2, s2 * 2)

				end

				function subbtn:DoClick()
					if scrsubpnl.Shrink then return end

					if perklist and IsValid(perklist) then

						if perklist.SubCat == subcat then
							perklist:Disappear()
							perklist = nil
						else
							perklist:ChangeSubCat(subcat)
						end

					else
						perklist = CreatePerkTree(subfr, subcat, ent)
					end

				end
				scrsubpnl.Btns[i] = subbtn
				i = i + 1

			end

			scr.SubPnl = scrsubpnl

			scrsubpnl:SetSize(120, 16 + 88*i)
			if not noanim then
				scrsubpnl:SetPos(0, -16 - 88*i)
				scrsubpnl:MoveBy(0, 16 + 88*i, 0.4, 0.1, 0.5)
			end
			f.SubcatsPanel = scrsubfr
		end

		subfr:Regenerate(nil, skipanim)

	end

	for id, cat in pairs(Research.Categories) do
		local cbtn = vgui.Create("FButton", rslist)
		cbtn:Dock(TOP)
		cbtn:SetTall(48)
		cbtn:DockMargin(0, 4, 0, 8)

		cbtn.DrawShadow = false

		cbtn.cat = cat

		function cbtn:PostPaint()
			surface.SetDrawColor(255, 255, 255)
			surface.DrawMaterial(cat:GetIcon().url, cat:GetIcon().name, 6, 6, 36, 36)

			self.Color = (curcat == self.cat and Color(50, 150, 250)) or Color(70, 70, 70)
		end

		cbtn.TextX = 36 + 6 + 12
		cbtn.TextAX = 0
		cbtn.Label = cat:GetName()

		function cbtn:DoClick()
			if not curcat or curcat ~= self.cat then
				curcat = self.cat

				if not subfr or not IsValid(subfr) then
					CreateSubScroll()
				elseif IsValid(subfr) then
					subfr.scr.SubPnl.Shrink = true
					subfr:Regenerate(cat)
				end


			elseif curcat == self.cat and IsValid(subfr) then
				local x, a = subfr.X, subfr:GetAlpha()

				local an = subfr:NewAnimation(0.2, 0, 0.4, function(_, self)
					if IsValid(self) then self:Remove() end
				end)

				an.Think = function(_, self, frac)
					self.X = x - (16*frac)
					self:SetAlpha(a - a*frac)
				end

				--subfr:PopOut()
				subfr = nil
				curcat = nil
			end

		end

		if curcat == cat then
			CreateSubScroll(true)
		end
	end

end





local infof

function OpenResearchInfoMenu(ent, perk)
	local self = ent
	if IsValid(infof) then return end

	local f = vgui.Create("FFrame")
	infof = f

	f:SetSize(600, 300)
	f:Center()
	f:PopIn()

	f:MakePopup()

	f.Shadow = {}

	perk = Research.IDs[perk]

	local lv = ent:GetRSLevel()
	local time = ent:GetRSTime()

	local tx = "Researching %s"
	tx = tx:format(perk:GetName())

	function f:PostPaint(w, h)
		draw.SimpleText(tx, "OSB48", w/2, f.HeaderSize + 4, color_white, 1, 5)

		local timestr = "%s"
		timestr = timestr:format(string.FormattedTime( math.Round(time - CurTime(), 2), "%02i:%02i.%02i" ))
		surface.SetDrawColor(color_white)

		local tw, th = draw.SimpleText(timestr, "OSB36", w/2, h/2 - 32, Color(200, 200, 200), 1, 1)
		surface.DrawMaterial("https://i.imgur.com/JYpGKqh.png", "clock.png", w/2 - tw/2 - 8 - 32, h/2 - 32 - 16, 32, 32)
	end

	local yields
	local pylds = perk.Levels[lv + 1].Yields

	if pylds then
		yields = vgui.Create("Panel", f)
		yields:SetSize(f:GetWide(), 72)
		yields.Y = f:GetTall() - 72
		yields.Btns = {}

		function yields:Paint(w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(40, 40, 40))

			surface.SetDrawColor(Color(30, 30, 30))

			surface.SetMaterial(MoarPanelsMats.gu)
			surface.DrawTexturedRect(0, 0, w, 4)

			surface.SetMaterial(MoarPanelsMats.gd)
			surface.DrawTexturedRect(0, h - 4, w, 4)


		end

		local i = 0

		for k,v in pairs(pylds) do
			i = i + 1
			local b = vgui.Create("FButton", yields)
			b:SetSize(64, 64)
			b:SetPos(8 + 72*(i-1), 4)

			function b:OnHover()

				if not self.Cloud then
					self.Cloud = vgui.Create("Cloud", self)
					local cl = self.Cloud

					if v.name then
						cl.Label = v.name
					end

					if v.desc then
						for k,v in pairs(v.desc) do
							cl:AddFormattedText(v.Text, v.Color or Color(255, 255, 255), v.font or "OS18", (v.Continuation and 0))
						end
					end
					local x, y = self:LocalToScreen(32, 0)
					cl:SetAbsPos(32, -16)
				end

				local cl = self.Cloud

				cl:Popup(true)
			end

			function b:OnUnhover()
				if self.Cloud then
					self.Cloud:Popup(false)
				end
			end

			local icurl
			local icname
			local ix, iy, iw, ih
			local icol

			local imdl

			function b:PostPaint(w, h)
				if imdl then
					surface.SetDrawColor(Color(255, 255, 255))
					draw.DrawOrRender(self, imdl, 0, 0, w, h)

				elseif icurl then
					local nw, nh = iw or w, ih or h

					local nx = ix or w/2 - nw/2
					local ny = iy or h/2 - nh/2

					surface.SetDrawColor(icol or Color(255, 255, 255))
					surface.DrawMaterial(icurl, icname, nx, ny, nw, nh)
				end
			end

			if v.model then
				imdl = v.model
			end

			if v.icon then
				local i = v.icon

				icurl = i.URL
				icname = i.Name
				ix, iy, iw, ih = i.X, i.Y, i.W, i.H
				icol = i.Color
			end

		end

	end
end