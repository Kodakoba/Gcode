include("shared.lua")
AddCSLuaFile("shared.lua")

local blue = Color(40, 120, 250)
local green = Color(80, 200, 80)


function ENT:CLInit()

end

local col = Color(70, 70, 70, 120)
Colors.DarkWhite = Color(220, 220, 220) --yes, dark white
Colors.Blue = Color(60, 140, 200)

local menu

local bpmat = Material("")

local prerenders = {}

local function OntoMat(id, w, h, func)	--scrapped

	if not prerenders[id] then
		prerenders[id] = draw.RenderOntoMaterial("bphelp1shadow" .. id, w, h, func)
	else
		surface.SetDrawColor(color_white)
		surface.SetMaterial(prerenders[id])
		surface.DrawTexturedRect(0, 0, w, h)
	end

end


local t3c1, t3c2 = Color(0, 12, 5), Color(0, 0.3, 0.35)
local t4c1, t4c2 = Color(12, 4, 0), Color(12, 4, 0)

local BlueprintPaints = {

	--[[
		Tier 1 paint
	]]

	[1] = function(self, w, h)
		
			surface.SetDrawColor(Colors.DarkWhite)
			surface.DrawMaterial("https://i.imgur.com/zhejG17.png", "bp128.png", w/2 - 36, h/2 - 36, 72, 72)

	end,

	--[[
		Tier 2 paint
	]]

	[2] = function(self, w, h)
		local x, y = self:LocalToScreen(0, 0)

		BSHADOWS.BeginShadow()--x - 12, y - 12, w + 24, w + 24)

		self:ApplyMatrix()
			surface.SetDrawColor(color_white)
			surface.SetMaterial(bpmat)
			surface.DrawTexturedRect(x + w/2 - 38, y + h/2 - 38, 76, 76)
		self:PopMatrix()

		BSHADOWS.EndShadow(1, 0.6, 2, 125, 60, 2, nil, Colors.DarkGray, Colors.DarkGray)


	end,

	--[[
		Tier 3 paint
	]]

	[3] = function(self, w, h)
		local x, y = self:LocalToScreen(0, 0)

		local shine = math.sin(CurTime() * 1)
		local shinecol = math.cos(CurTime() * 0.6)

		t3c1.g = 9 + shine * 2
		t3c1.b = 3 + shine * 0.7

		t3c2.g = 4 + shinecol * 0.7
		t3c2.b = 2 + shinecol * 1

		BSHADOWS.BeginShadow()
		self:ApplyMatrix()
			surface.SetDrawColor(color_white)
			surface.SetMaterial(bpmat)
			surface.DrawTexturedRect(x + w/2 - 40, y + h/2 - 40, 80, 80)
		self:PopMatrix()
		BSHADOWS.EndShadow(1, 2 + shine * 0.2, 1, 255, 60, 2, nil, t3c1, t3c2)
	end,

	--[[
		Tier 4 paint
	]]

	[4] = function(self, w, h)
		local x, y = self:LocalToScreen(0, 0)

		local shine = math.sin(CurTime() * 0.8)
		local shinecol = math.cos(CurTime() * 0.5)
		t4c1.r = 12 + 5 * shine
		t4c1.g = 4 + shine * 2

		t4c1.r = 7 + shinecol * 1
		t4c2.g = 3 + shinecol * 0.5

		BSHADOWS.BeginShadow()
		self:ApplyMatrix()
			surface.SetDrawColor(color_white)
			surface.SetMaterial(bpmat)
			surface.DrawTexturedRect(x + w/2 - 40, y + h/2 - 40, 80, 80)
		self:PopMatrix()
		BSHADOWS.EndShadow(2, 2 + shine * 0.5, 2, 205, 60, 2, nil, t4c1, t4c2)
	end,

	--[[
		Tier 5 paint (no)
	]]

	[5] = function(self, w, h)
		local x, y = self:LocalToScreen(0, 0)

		BSHADOWS.BeginShadow(x, y, w, h)

			surface.SetDrawColor(color_white)
			surface.SetMaterial(bpmat)
			surface.DrawTexturedRect(w/2 - 40, h/2 - 40, 80, 80)

		BSHADOWS.EndShadow(2, 45, 1, 205, 60, 2, nil, Color(230, 5, 5), Color(170, 1, 1))
	end,
}


local mats = {	-- "random" will be rendered from an RT as soon as the menu opens
	random = nil,
	pistol = nil,
	AR = nil,
	shotgun = nil,
	sniper = nil
}

function ENT:OpenMenu()
	if IsValid(menu) then return end
	local ent = self

	mats.random = mats.random or draw.RenderOntoMaterial("bp_random", 48, 48, function(w, h)
		draw.SimpleText("?", "MRB72", w/2, h/2, color_white, 1, 1)
	end)

	menu = vgui.Create("FFrame")
	menu:SetSize(600, 500)


	menu.Shadow = {}

	menu:MakePopup()
	menu:PopIn()

	menu.Delta = DeltaText()

	menu.Inventory = Inventory.Panels.CreateInventory(LocalPlayer().Inventory.Backpack, nil, {
		SlotSize = 64,
		FitsItems = 5
	})

	menu.Inventory:CenterVertical()

	menu:Bond(menu.Inventory)
	menu.Inventory:Bond(menu)

	local inv = menu.Inventory
	inv:SetTall(menu:GetTall())

	local FullW = inv:GetWide() + menu:GetWide()
									--   V inventory has 8px padding from menu
	menu:SetPos(ScrW() / 2 - FullW / 2 - 4, ScrH() / 2 - menu:GetTall() / 2)

	inv:MoveRightOf(menu, 8)
	inv.Y = menu.Y

	--inv:CreateItems()

	local basecost = 0

	local costmult = 1
	local curcost = basecost

	local delta = menu.Delta

	local dtext = delta:AddText("")
	dtext:SetColor(Colors.DarkWhite)
	local ptype = dtext:AddFragment("Random")
	dtext:AddFragment(" Tier ")
	local ptier = dtext:AddFragment("?")
	dtext:AddFragment(" Blueprint")

	delta:SetAlignment(1)
	delta:SetFont("MR36")

	local bp_col = color_white:Copy()

	function menu:PostPaint(w, h)
		delta:Paint(w/2, 80 + 120 + 24)

		if self.Cost then
		
			self:To("BPAlpha", 255, 0.3, 0, 0.3)
			local a = self.BPAlpha or 0
			bp_col.a = a

			surface.SetDrawColor(bp_col)
			surface.DrawMaterial("https://i.imgur.com/zhejG17.png", "bp128.png", w/2 - 72, h - 158, 64, 64)
			self.Cost:Paint(w/2, h - 150)
		end

	end

	function menu:UpdateCost()
		local newcost = math.floor(basecost * costmult)


		if self.Cost then
			if newcost > curcost then
				self.CostPiece:SetDropStrength(18)
				self.CostPiece:SetLiftStrength(-18)
			else
				self.CostPiece:SetDropStrength(-18)
				self.CostPiece:SetLiftStrength(18)
			end

			self.CostPiece:ReplaceText(self.CostFragmentInd, newcost)
		end

		curcost = newcost
	end

	local dled = draw.GetMaterial("https://i.imgur.com/zhejG17.png", "bp128.png", nil, function(mat)
		bpmat = mat
	end)

	if dled then
		bpmat = dled.mat
	end

	--[[
		Tier selection
	]]

	local icons = vgui.Create("FIconLayout", menu)

	icons:SetPos(32, 80)
	icons:SetSize(menu:GetWide() - icons:GetPos()*2, 120)
	icons:SetColor(Color(0, 0, 0, 0))
	icons.MarginX = 16

	local tw = icons:GetWide()

	local lbl = vgui.Create("DLabel", menu)

	lbl:SetPos(0, icons.Y - 40)
	lbl:SetFont("MR36")
	lbl:SetText("Select Blueprint Tier")

	lbl:SizeToContents()
	lbl:CenterHorizontal()

	local btns = 4

	local sel
	local SelectedTier = 0

	local text = "Tier %d Blueprint"
	local cycled = false

	local cType

	for i=1, btns do

		local tier = icons:Add("FButton")

		tier:SetSize(96, 120 - 16)

		function tier:PostPaint(w, h)
			if BlueprintPaints[i] then
				BlueprintPaints[i] (self, w, h)
			end
		end

		function tier:DoClick()
			if sel then
				sel:SetColor(70, 70, 70)
			end

			self:SetColor(30, 130, 190)

			sel = self

			basecost = Inventory.Blueprints.Costs[i]

			menu:UpdateCost()
			menu:MakeTier(i)
			SelectedTier = i
		end
	end
	icons.IncompleteCenter = true
	--icons:AutoCenter()

	function menu:MakeTier(t)

		if not cycled then
			delta:CycleNext()
			dtext.Fragments[ptier].Text = t
			cycled = true
		else

			if t > SelectedTier then
				dtext:SetDropStrength(12)
				dtext:SetLiftStrength(-12)
			else
				dtext:SetDropStrength(-12)
				dtext:SetLiftStrength(12)
			end

			dtext:ReplaceText(ptier, t)
		end

		if not cType then -- this is the first time we're making tier info: create panels

			cType = vgui.Create("FComboBox", menu)
			cType:SetSortItems(false)
			cType:CenterHorizontal()
			cType:PopIn()

			cType.Y = 280
			cType:SetSize(160, 40)
			cType:SetFont("TWB32")
			cType:SetContentAlignment(5)
			cType:SetColor(Color(70, 70, 70))

			local t = {}

			for k,v in pairs(Inventory.Blueprints.Types) do
				v = table.Copy(v)
				v.Name = v.Name or k

				t[#t + 1] = v
			end

			table.sort(t, function(a, b)
				return a.CostMult < b.CostMult or (a.Order and b.Order and a.Order > b.Order)
			end)

			for k,v in ipairs(t) do

				local name = v.Name
				local mat = mats[v.RenderName]

				local icon = v.CatIcon or {}

				if icon and not mat then

					if icon.RenderName then

						mat = draw.RenderOntoMaterial(icon.RenderName, icon.RenderW, icon.RenderH, icon.Render)
						mats[icon.RenderName] = mat

					elseif icon.IconName then

						mat = draw.GetMaterial(icon.IconURL, icon.IconName, icon.IconFlags, function(mat, cache)
							if cache then return end

							if IsValid(cType) then
								cType:SetChoiceMaterial(name, mat)
							end

							mats[icon.IconName] = mat
						end)

						if not mat.downloading and not mat.failed then
							mat = mat.mat
							cType:SetChoiceMaterial(name, mat)
							mats[icon.IconName] = mat
						end

					end

				end

				local choice = cType:AddChoice(name, v.CostMult, v.Default, mat, function(self, opt)
					opt.IconW = icon.IconW or opt.IconW
					opt.IconH = icon.IconH or opt.IconH

					opt.IconPad = icon.IconPad or opt.IconPad
				end)

				if v.Default then
					SelectedType = name
				end
			end

			local lastsel = 1 	--index for determining which way deltatext will scroll
								--when changing type

			function cType:OnSelect(i, val, mult)

				if i > lastsel then
					dtext:SetDropStrength(12)
					dtext:SetLiftStrength(-12)
				else
					dtext:SetDropStrength(-12)
					dtext:SetLiftStrength(12)
				end

				lastsel = i

				dtext:ReplaceText(ptype, val)

				costmult = mult
				SelectedType = val

				menu:UpdateCost()
			end

			menu.HasBlueprintsAmt = Inventory.Util.GetItemCount(LocalPlayer().Inventory.Backpack, "base_bp")


			menu.Cost = DeltaText():SetFont("MR48")


			menu.CostPiece = menu.Cost:AddText("x"):SetColor(Colors.Blue)

			menu.CostPiece.Animation.Length = 0.3

			menu.CostFragmentInd, menu.CostFragment = menu.CostPiece:AddFragment(curcost, nil, false)

			local format = "  (x%s)"

			local haveind, havefrag = menu.CostPiece:AddFragment(format:format(menu.HasBlueprintsAmt), nil, false)

			menu.HaveFragmentInd = haveind
			menu.CostPiece:SetFragmentFont(haveind, "MR24")

			havefrag.AlignY = 1

			local h,s,v = ColorToHSV(Colors.Blue)
			local have_col = HSVToColor(h, s, v - 0.1)

			havefrag.Color = have_col

			menu.Cost:CycleNext()


			menu.Begin = vgui.Create("FButton", menu)
			local btn = menu.Begin
			btn:SetSize(192, 56)
			btn:Center()
			btn.Y = menu:GetTall() - 72

			btn.Font = "OSB36"
			btn.Label = "Begin!"

			function btn:Think()
				menu.HasBlueprintsAmt = Inventory.Util.GetItemCount(LocalPlayer().Inventory.Backpack, "base_bp")

				local _, frag = menu.CostPiece:ReplaceText(haveind, format:format(menu.HasBlueprintsAmt))

				if frag then
					frag.Font = "MR24"
					frag.AlignY = 1
					frag.Color = have_col
				end

				menu.HasEnough = menu.HasBlueprintsAmt >= curcost

				if menu.HasEnough then
					self:SetColor(50, 150, 250)
					LC(menu.CostFragment.Color, Colors.Blue, 15)

					self.Disabled = false
				else
					local grey = Colors.Button
					self:SetColor()
					LC(menu.CostFragment.Color, Colors.DarkerRed, 15)

					self.Disabled = true
				end
			end

			function btn:DoClick()
				if self.Disabled then return end
				net.Start("BlueprintMaker")
					net.WriteEntity(ent)
					net.WriteUInt(SelectedTier, 4)
					net.WriteString(SelectedType)
				net.SendToServer()

			end

		end

	end

end

function ENT:Draw()
	self:DrawModel()

	local pos = self:LocalToWorld(Vector(-12, -14, 79))
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Forward(), 90)

	cam.Start3D2D(pos, ang, 0.03)

		local ok, err = pcall(function()
			draw.RoundedBox(8, 0, 0, 750, 650, col)
		end)

	cam.End3D2D()

	if not ok then
		print("err", err)
	end

end

net.Receive("BlueprintMaker", function()
	local ent = net.ReadEntity()
	if not IsValid(ent) or not ent.BlueprintMaker then error("wtf " .. tostring(ent)) return end

	ent:OpenMenu()
end)