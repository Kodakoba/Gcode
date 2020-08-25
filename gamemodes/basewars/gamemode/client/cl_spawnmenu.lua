


local gens = BaseWars.Generators
local SpawnList = BaseWars.SpawnList

local function IsGroup(ply, group)
	if not ply.CheckGroup then error("what the fuck where's ULX") return end
	if not IsValid(ply) or not ply:IsPlayer() then return end

	if ply:CheckGroup(string.lower(group)) or (ply:IsAdmin() and (group=="vip" or group=="trusted")) or ply:IsSuperAdmin() then
		return true
	end

	return false

end

local SpawnlistCanvas

local tohide = {}

hook.Add("OnSpawnMenuClose", "RemoveClouds", function()	--grrrrrrrrrr

	for k,v in pairs(tohide) do
		if not IsValid(v) then tohide[k] = nil continue end

		v:Remove()
	end

end)



--https://i.imgur.com/s5Xbx2b.png

--local b = bench("btns", 600)

local function createSubCategory(canv, cat_name, subcat_name, data)
	local items = data.Items

	local pnl = vgui.Create("InvisPanel", canv) --holder for diconlayout
	pnl:Dock(TOP)
	pnl:DockMargin(0, 8, 0, 4)
	pnl:SetWide(canv:GetWide())
	pnl:SetTall(5000)

	local pnlcol = Colors.LightGray:Copy()
	pnlcol.a = 160



	local ics = vgui.Create("DIconLayout", pnl)
	ics:Dock(BOTTOM)
	ics:DockMargin(4, 0, 4, 8)

	ics:SetSpaceX(4)
	ics:SetSpaceY(4)
	ics:SetBorder(4)

	local icscol = Color(205, 205, 205)

	function pnl:Paint(w, h)
		draw.RoundedBox(8, 0, 0, w, h, pnlcol)

		local tX = 4

		if data.Icon then
			local iW, iH = data.Icon:GetSize()
							-- V the top part is 32px iirc
			data.Icon:Paint(tX, 16 - iH / 2)
			tX = tX + iW + 4
		end

		draw.SimpleText(data.Name, "OSB28", tX, 16, color_white, 0, 1)
		-- holy shit diconlayout sucks
		local iX, iY = ics:GetPos()
		local iW, iH = ics:GetSize()
		draw.RoundedBox(8, iX, iY, iW, iH + 4, icscol)

		draw.EnableFilters()
	end

	function pnl:PaintOver()
		draw.DisableFilters()
	end
	local its = table.Copy(items)

	table.sort(its, function(a, b)
		if a.Level == b.Level then
			return a.Price < b.Price
		else
			return a.Level < b.Level
		end
	end)

	local ply = LocalPlayer()

	local ply_money, ply_level = ply:GetMoney(), ply:GetLevel()
	function pnl:Think()
		ply_money, ply_level = ply:GetMoney(), ply:GetLevel()
	end

	for _, dat in ipairs(its) do
		local name, lv, price = dat.Name, dat.Level, dat.Price
		local mdl = dat.Model
		local btn = ics:Add("FButton")
		btn:SetSize(76, 76)

		btn.Shadow.MaxSpread = 1.1
		btn.Shadow.Alpha = 150
		btn.Shadow.Intensity = 2
		btn.Shadow.HoverSpeed = 0.1
		btn.Shadow.UnhoverSpeed = 0.1
		btn.Shadow.UnhoverEase = 1.2

		btn.HoverFrac = 0

		hook.Add("OnSpawnMenuClose", btn, function()
			btn:RemoveCloud("description")
		end)

		btn:SetDoubleClickingEnabled(false)

		btn.Shadow.Color = color_white:Copy()

		local rand = math.random()

		local sic = btn:Add("SpawnIcon")
		sic:SetModel(mdl)
		sic:SetSize(60, 60)
		sic:SetPos(6, 16)

		sic:SetMouseInputEnabled(false)

		function btn:Demask(x, y, w, h)
			draw.RoundedStencilBox(8, x + 3, y + 3, w - 6, h - 6, color_white)
		end
		function btn:Mask(x, y, w, h)
			surface.SetDrawColor(color_white:Unpack())
			surface.DrawRect(x, y, w, h)
		end

		local drawBtn = btn.DrawButton

		function btn:DrawButton(...)
			local w, h = self:GetSize()
			draw.BeginMask(self.Mask, self, ...)
			draw.DeMask(self.Demask, self, ...)
			draw.DrawOp()
			drawBtn(self, ...)
			draw.FinishMask()
		end

		local enoughColor = Color(50, 240, 50, 150)
		local notEnoughColor = Color(220, 50, 50, 150)
		local wayEnoughColor = Color(35, 95, 255, 180)
		local barelyEnoughColor = Color(220, 210, 110, 150)

		local moneytxCol = notEnoughColor:Copy()
		local curCol = Colors.Red:Copy()

		local shortName = name

		surface.SetFont("BS14")

		for i=1, #name do
			local nm = name:sub(1, i)
			local tW = surface.GetTextSize(nm)

			if tW > btn:GetWide() - 8 then
				shortName = nm:sub(1, -4) .. "..."
				break
			end
		end

		local shortNameCol = color_white:Copy()
		local shortNameShadow = color_black:Copy()

		function btn:PaintOver(w, h)
			shortNameCol.a = (1 - self.HoverFrac) * 255
			shortNameShadow.a = (1 - self.HoverFrac) * 255

			draw.SimpleText(shortName, "BS14", w/2 + 1, 4 - 22 * self.HoverFrac + 1, shortNameShadow, 1)
			draw.SimpleText(shortName, "BS14", w/2, 4 - 22 * self.HoverFrac, shortNameCol, 1)
			
		end

		function btn:PrePaint(w, h)
			--b:Open()

			local enough, way_enough, barely_enough = ply_money >= price, ply_money > price * 50, ply_money < price * 3
			local enough_lv = ply_level >= lv

			local col = curCol
			local txcol

			draw.LerpColor(1, curCol, enoughColor, barelyEnoughColor)

			if enough and enough_lv then
				if way_enough then
					col = wayEnoughColor
					txcol = Colors.Money
				elseif barely_enough then
					col = barelyEnoughColor

					--draw.LerpColor(self.HoverFrac, curCol, barelyEnoughColor, enoughColor)

					txcol = barelyEnoughColor
				else
					col = enoughColor
					txcol = Colors.Money
				end
			else
				col = notEnoughColor
			end

			moneytxCol:Set(txcol or col)
			moneytxCol.a = 255

			draw.RoundedBox(8, 2, 2, w - 4, h - 4, col)
		end

		local lastHovFrac = nil

		function btn:Think()
			if self.HoverFrac ~= lastHovFrac then
				local sz = 60 + 8 * self.HoverFrac
				sic:SetSize(sz, sz)
				sic:CenterHorizontal()
				sic.Y = self:GetTall() - sic:GetTall() - 4
				lastHovFrac = self.HoverFrac
			end
		end

		function btn:OnHover()
			self:To("HoverFrac", 1, 0.2, 0, 0.2)
			local cl, new = self:AddCloud("description")

			if new then
				cl.Font = "OS22"
				cl.MaxW = 450
				cl.AlignLabel = 1
				cl:AddSeparator(nil, 8)
				cl:AddFormattedText(Language.Currency .. BaseWars.NumberFormat(price), moneytxCol, "OSB20", 18, nil, 1)
				cl:AddFormattedText(Language.Level .. " " .. lv, Colors.Level, "OSB20", nil, nil, 1)
				cl:SetRelPos(self:GetWide() / 2)
				cl.ToY = -8

				cl:SetText(name)
			end
		end

		function btn:OnUnhover()
			self:To("HoverFrac", 0, 0.2, 0, 0.2)
			self:RemoveCloud("description")
		end

		function btn:DoClick()
			self:SetColor(color_white, true)
			self.Shadow.MaxSpread = 1.7
			self.Shadow.Alpha = 255

			self:LerpColor(self.Color, Colors.Button, 0.3, 0.07, 0.3, true)
			self:LerpColor(self.drawColor, Colors.Button, 0.3, 0.07, 0.3, true)
			self:MemberLerp(self.Shadow, "MaxSpread", 1.1, 0.3, 0.13, 0.3, true)

			RunConsoleCommand("basewars_spawn", cat_name, dat.CatID)
			--self:LerpColor(self.drawColor, Colors.Button, 0.3, 0.15, 0.3)
		end

	end

	local perf_layout = ics.PerformLayout --BWERGH

	function ics:PerformLayout(w, h)
		perf_layout(self, w, h)
		pnl:SetTall(ics:GetTall() + 8 + 32)
	end
end

local function openCategory(pnl, btn)
	local cat = btn.Category
	if not SpawnList[cat] then
		errorf("attempt to open unknown basewars spawnlist category: %s", cat)
		return
	end

	if IsValid(pnl.OpenCategory) and pnl.OpenCategory.Category == cat then return end

	local canv = vgui.Create("FScrollPanel", pnl)
	canv:SetSize(pnl:GetSize())

	pnl:On("PerformLayout", canv, function(self, w, h)
		canv:SetSize(w, h)
	end)

	canv.NoDraw = true
	canv:GetCanvas():DockPadding(8, 36, 8, 4)
	canv.Category = cat

	pnl.OpenCategory = canv

	local boxcol = Colors.Gray:Copy()
	boxcol.a = 210

	local titleCol = color_white:Copy()
	local h, s, v = titleCol:ToHSV()
	draw.ColorModHSV(titleCol, h, s - 0.1, v - 0.1)

	local iconCol = draw.ColorModHSV(titleCol:Copy(), h, s, v + 0.1)
	local ic = IsIcon(btn.Icon) and btn.Icon:Copy()

	local iconPadding = 4
	local boxPadding = 8

	if ic then
		ic:SetColor(iconCol)
	end

	canv:GetCanvas().Paint = function(self, w, h)
		surface.SetFont("BS32")

		local tw = (surface.GetTextSize(cat))
		local tx = w/2 - tw/2

		if ic then
			tw = tw + (ic:GetSize()) + iconPadding
			tx = w/2 - tw/2 + (ic:GetSize()) + iconPadding
		end

		draw.RoundedBox(8, w/2 - tw/2 - boxPadding, 5, tw + boxPadding * 2, 34, boxcol)

		if ic then
			ic:Paint(w/2 - tw/2, 8)
		end

		surface.SetTextPos(tx, 8)
		surface.SetTextColor(titleCol)
		surface.DrawText(cat)
	end

	pnl:AddCatCanvas(canv)

	for subname, data in SortedPairsByMemberValue(SpawnList[cat].Subcategories, "Priority", true) do
		createSubCategory(canv, cat, subname, data)
	end

	return canv
end

local function MakeSpawnList()

	local pnl = vgui.Create("InvisPanel")	-- main canvas for the entire basewars tab
	pnl:Dock(FILL)
	SpawnlistCanvas = pnl

	local its -- items list on the right; predefined

	local cats = vgui.Create("FScrollPanel", pnl)
	cats:GetCanvas():DockPadding(0, 4, 0, 4)
	cats:Dock(LEFT)
	cats:SetWide(192)
	cats:DockMargin(0, 24, 16, 0)
	cats.GradBorder = true
	cats.BackgroundColor = Color(200, 200, 200)

	local active

	for k,v in SortedPairs(SpawnList) do
		local tab = vgui.Create("FButton", cats)
		tab:Dock(TOP)
		tab:SetTall(32)
		tab:DockMargin(0, 0, 0, 4)
		tab.NoDraw = true
		tab.Category = v.Name
		tab.Icon = v.Icon

		local ic = IsIcon(v.Icon) and v.Icon

		local col = Colors.LightGray:Copy()
		local sel_col = Color(40, 140, 230)

		local unsel_X = 6
		local sel_X = 20

		local ic_tx_padding = 4
		local box_padding = 2

		local font = "BS28"

		tab.IconX = unsel_X

		if IsIcon(v.Icon) then
			v.Icon:SetColor(col)
			v.Icon:SetFilter(true)
		end

		local box_col = Colors.LightGray:Copy()
		box_col.a = 120

		local fullW = 0

		surface.SetFont(font)
		local txW = surface.GetTextSize(v.Name)
		local icW = ic and ((ic:GetSize()) + ic_tx_padding) or 0

		fullW = txW + icW
		function tab:PostPaint(w, h)
			--draw.RoundedBox(8, self.IconX - box_padding, 0, fullW + box_padding*2, h, box_col)

			if active == self then
				self:To("IconX", sel_X, 0.2, 0, 0.15)
				self:LerpColor(col, sel_col, 0.3, 0, 0.3)
			else
				self:To("IconX", unsel_X, 0.2, 0, 0.2)
				self:LerpColor(col, Colors.LightGray, 0.3, 0, 0.3)
			end

			local x = math.Round(self.IconX)

			if IsIcon(v.Icon) then
				local iw, ih = v.Icon:GetSize()
				v.Icon:Paint(x, h/2 - ih/2)
				x = x + iw + ic_tx_padding
			end

			draw.SimpleText(v.Name, "BS28", x, h/2, col, 0, 1)
		end

		function tab:DoClick()
			local new = openCategory(its, tab)
			if new then
				active = self
			end
		end
	end

	its = vgui.Create("GradPanel", pnl)
	its:Dock(FILL)
	its:SetColor(Color(130, 130, 130))


	function its:PostPaint(w, h)
		local x, y = self:LocalToScreen(0, 0)
		BSHADOWS.SetScissor(x, y, w, h)
	end

	function its:PaintOver()
		BSHADOWS.SetScissor()
	end

	function its:PerformLayout(w, h)
		self:Emit("PerformLayout", w, h)
	end

	function its:AddCatCanvas(new)
		if IsValid(self.oldCanvas) then
			self.oldCanvas:To("X", 16, 0.2, 0, 1.6)
			self.oldCanvas:PopOut(0.15, 0.05)
			self.oldCanvas:SetZPos(-15)
		end

		self.oldCanvas = new
		new:PopIn(0.15, 0.05)
		new.X = new.X - 16
		new:To("X", 0, 0.3, 0, 0.3)
	end

	return pnl

end

local spawnMenuTabs = {}

local function RemoveTabs()

	local ply = LocalPlayer()
	if not ply or not IsValid(ply) then return end

	--local Admin = ply:IsAdmin()

	function spawnmenu.Reload()
		for k,v in pairs(spawnMenuTabs) do
			spawnmenu.AddCreationTab(k, v.Function, v.Icon, v.Order)
		end
		RunConsoleCommand("spawnmenu_reload")

	end


	function spawnmenu.RemoveCreationTab(blah)
		spawnMenuTabs[blah] = spawnmenu.GetCreationTabs()[blah]
		spawnmenu.GetCreationTabs()[blah] = nil

	end

	spawnmenu.RemoveCreationTab("#spawnmenu.category.saves")
	spawnmenu.RemoveCreationTab("#spawnmenu.category.dupes")
	spawnmenu.RemoveCreationTab("#spawnmenu.category.postprocess")

	--if not Admin then

		spawnmenu.RemoveCreationTab("#spawnmenu.category.vehicles")
		spawnmenu.RemoveCreationTab("#spawnmenu.category.weapons")
		spawnmenu.RemoveCreationTab("#spawnmenu.category.npcs")
		--spawnmenu.RemoveCreationTab("#spawnmenu.category.entities")

	--end

	spawnmenu.Reload()

end


language.Add("spawnmenu.category.basewars", "BaseWars")
spawnmenu.AddCreationTab("#spawnmenu.category.basewars", MakeSpawnList, "icon16/building.png", BaseWars.Config.RestrictProps and -100 or 2)

if GetConVar("developer"):GetInt() < 1 then
	hook.Add("InitPostEntity", "BaseWars.SpawnMenu.RemoveTabs", RemoveTabs)
	RemoveTabs()
else

	hook.Remove("InitPostEntity", "BaseWars.SpawnMenu.RemoveTabs")
	RunConsoleCommand("spawnmenu_reload")
end
