
Colors.DarkWhite = Color(220, 220, 220) --yes, dark white
Colors.Blue = Color(60, 140, 200)

local bpmat = Material("__error")

local caches = {}
local t3c1, t3c2 = Color(4, 12, 8), Color(0.3, 2, 1)
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
		local x, y = math.floor(w * 0.1), math.floor(h * 0.1)
		local dw, dh = math.ceil(w - x * 2), math.ceil(h - y * 2)
		local id = 2

		if caches[id] then
			surface.SetDrawColor(255, 255, 255)
			caches[id]:Paint(x, y, dw, dh, true)
			surface.SetMaterial(bpmat)
			surface.DrawTexturedRect(x, y, dw, dh)
		else
			local hand = BSHADOWS.GenerateCache("bp_tier" .. id, w, h)
			hand:SetGenerator(function(hand, w, h)
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(bpmat)
				surface.DrawTexturedRect(0, 0, w, h)
			end)

			caches[id] = hand
			hand:CacheShadow(1, 6, 8, Colors.DarkGray, Colors.DarkGray)
		end
	end,

	--[[
		Tier 3 paint
	]]

	[3] = function(self, w, h)
		local x, y = math.floor(w * 0.1), math.floor(h * 0.1)
		local dw, dh = math.ceil(w - x * 2), math.ceil(h - y * 2)
		local id = 3

		if caches[id] then
			surface.SetDrawColor(255, 255, 255, 110)
			caches[id]:Paint(x, y, dw, dh, true)
			surface.SetMaterial(bpmat)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(x, y, dw, dh)
		else
			local hand = BSHADOWS.GenerateCache("bp_tier" .. id, w, h)
			hand:SetGenerator(function(hand, w, h)
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(bpmat)
				surface.DrawTexturedRect(0, 0, w, h)
			end)

			caches[id] = hand
			hand:CacheShadow(3, {14, 8}, 8, t3c1, t3c2)
		end
	end,

	--[[
		Tier 4 paint
	]]

	[4] = function(self, w, h)
		local x, y = math.floor(w * 0.1), math.floor(h * 0.1)
		local dw, dh = math.ceil(w - x * 2), math.ceil(h - y * 2)
		local id = 4

		if caches[id] then
			surface.SetDrawColor(255, 255, 255)
			caches[id]:Paint(x, y, dw, dh, true)
			surface.SetMaterial(bpmat)
			surface.DrawTexturedRect(x, y, dw, dh)
		else
			local hand = BSHADOWS.GenerateCache("bp_tier" .. id, w, h)
			hand:SetGenerator(function(hand, w, h)
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(bpmat)
				surface.DrawTexturedRect(0, 0, w, h)
			end)

			caches[id] = hand
			hand:CacheShadow(3, {18, 12}, 8, t4c1, t4c2)
		end
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

function ENT:CreateCreationCanvas(menu, inv) -- hm
	caches = {}

	local ent = self
	local canv = vgui.Create("InvisPanel", menu)
	canv:SetSize(menu:GetWide(), menu:GetTall() - menu.HeaderSize)
	canv.Y = menu.HeaderSize

	local cy = canv.Y

	canv.Delta = DeltaText()

	mats.random = mats.random or draw.RenderOntoMaterial("bp_random", 48, 48, function(w, h)
		draw.SimpleText("?", "MRB72", w/2, h/2, color_white, 1, 1)
	end)

	local curcost = 0
	local SelectedType = "random"
	local SelectedTier = 1

	local delta = canv.Delta

	local dtext = delta:AddText("")
	dtext:SetColor(Colors.DarkWhite)
	local ptype = dtext:AddFragment("Random")
	dtext:AddFragment(" Tier ")
	local ptier = dtext:AddFragment("?")
	dtext:AddFragment(" Blueprint")

	delta:SetAlignment(1)
	delta:SetFont("MR36")

	local bp_col = color_white:Copy()

	function canv:UpdateCost()
		local newcost = Inventory.Blueprints.GetCost(SelectedTier, SelectedType)

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

	--[[
		Tier selection
	]]

	local lbl = vgui.Create("DLabel", canv)
		lbl:SetPos(0, 0)
		lbl:SetFont("MR36")
		lbl:SetText("Select Blueprint Tier")

		lbl:SizeToContents()
		lbl:CenterHorizontal()

	local icons = vgui.Create("FIconLayout", canv)
		icons:SetPos(32, lbl:GetTall())
		icons:SetSize(canv:GetWide() - icons:GetPos()*2, 120)
		icons:SetColor(Color(0, 0, 0, 0))
		icons.MarginX = 16


	function canv:Paint(w, h)
		delta:Paint(w/2, icons.Y + icons:GetTall() + 16)

		if self.Cost then
			self:To("BPAlpha", 255, 0.3, 0, 0.3)
			local a = self.BPAlpha or 0
			bp_col.a = a

			surface.SetDrawColor(bp_col)
			surface.DrawMaterial("https://i.imgur.com/zhejG17.png", "bp128.png", w/2 - 72, h - 158, 64, 64)
			self.Cost:Paint(w/2, h - 150)
		end


		local x, y = self:LocalToScreen(math.max(-self.X, 0), 0)
		BSHADOWS.SetScissor(x, y, x + w, y + h)
	end

	function canv:PaintOver(w, h)
		BSHADOWS.SetScissor()
	end

	local tw = icons:GetWide()

	local btns = 4

	local sel

	local text = "Tier %d Blueprint"
	local cycled = false

	local cType

	for i=1, btns do

		local tier = icons:Add("FButton")

		tier:SetSize(96, 120 - 16)
		if not Inventory.Blueprints.GetCost(i) then
			tier:SetEnabled(false)
			tier:SetAlpha(60)
		end

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

			SelectedTier = i

			canv:UpdateCost()
			canv:MakeTier(i)
		end
	end
	icons.IncompleteCenter = true
	--icons:AutoCenter()

	function canv:GenerateDetails()
		cType = vgui.Create("FComboBox", canv)
		cType:SetSortItems(false)
		cType:CenterHorizontal()
		cType:PopIn()

		cType.Y = icons.Y + icons:GetTall() + 16 + draw.GetFontHeight(delta:GetFont()) + 16
		cType:SetSize(160, 40)
		--cType:SetFont("TWB32")
		cType:SetContentAlignment(5)
		cType:SetColor(Color(70, 70, 70))

		local t = {}

		for k,v in pairs(Inventory.Blueprints.Types) do
			v = table.Copy(v)
			v.Name = v.Name or k
			v.Key = k
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

			local choice = cType:AddChoice(name, v.Key, v.Default, mat, function(self, opt)
				opt.IconW = icon.IconW or opt.IconW
				opt.IconH = icon.IconH or opt.IconH

				opt.IconPad = icon.IconPad or opt.IconPad
			end)

			if v.Default then
				SelectedType = v.Key
			end
		end

		local lastsel = 1 	--index for determining which way deltatext will scroll
							--when changing type

		function cType:OnSelect(i, val, key)

			if i > lastsel then
				dtext:SetDropStrength(12)
				dtext:SetLiftStrength(-12)
			else
				dtext:SetDropStrength(-12)
				dtext:SetLiftStrength(12)
			end

			lastsel = i

			dtext:ReplaceText(ptype, val)
			SelectedType = key

			canv:UpdateCost()
		end

		canv.HasBlueprintsAmt = Inventory.Util.GetItemCount(LocalPlayer().Inventory.Backpack, "blank_bp")


		canv.Cost = DeltaText():SetFont("MR48")


		canv.CostPiece = canv.Cost:AddText("x"):SetColor(Colors.Blue)

		canv.CostPiece.Animation.Length = 0.3

		canv.CostFragmentInd, canv.CostFragment = canv.CostPiece:AddFragment(curcost, nil, false)

		local format = "  (x%s)"

		local haveind, havefrag = canv.CostPiece:AddFragment(format:format(canv.HasBlueprintsAmt), nil, false)

		canv.HaveFragmentInd = haveind
		canv.CostPiece:SetFragmentFont(haveind, "MR24")

		havefrag.AlignY = 1

		local h,s,v = ColorToHSV(Colors.Blue)
		local have_col = HSVToColor(h, s, v - 0.1)

		havefrag.Color = have_col

		canv.Cost:CycleNext()


		canv.Begin = vgui.Create("FButton", canv)
		local btn = canv.Begin
		btn:SetSize(192, 56)
		btn:Center()
		btn.Y = canv:GetTall() - 72

		btn.Font = "OSB36"
		btn.Label = "Begin!"

		function btn:Think()
			canv.HasBlueprintsAmt = Inventory.Util.GetItemCount(LocalPlayer().Inventory.Backpack, "blank_bp")

			local _, frag = canv.CostPiece:ReplaceText(haveind, format:format(canv.HasBlueprintsAmt))

			if frag then
				frag.Font = "MR24"
				frag.AlignY = 1
				frag.Color = have_col
			end

			canv.HasEnough = canv.HasBlueprintsAmt >= curcost

			if canv.HasEnough then
				self:SetColor(50, 150, 250)
				LC(canv.CostFragment.Color, Colors.Blue, 15)

				self:SetEnabled(true)
			else
				local grey = Colors.Button
				self:SetColor()
				LC(canv.CostFragment.Color, Colors.DarkerRed, 15)

				self:SetEnabled(false)
			end
		end

		function btn:DoClick()
			net.Start("BlueprintConstructor")
				net.WriteEntity(ent)
				net.WriteUInt(SelectedTier, 4)
				net.WriteString(SelectedType)
			net.SendToServer()

		end
	end

	function canv:MakeTier(tier)
		if not cycled then
			delta:CycleNext()
			dtext.Fragments[ptier].Text = tier
			cycled = true
		else

			if tier > SelectedTier then
				dtext:SetDropStrength(12)
				dtext:SetLiftStrength(-12)
			else
				dtext:SetDropStrength(-12)
				dtext:SetLiftStrength(12)
			end

			dtext:ReplaceText(ptier, tier)
		end

		if not cType then -- this is the first time we're making tier info: create panels
			self:GenerateDetails()
		end
	end

	function canv:Disappear(now)
		if now then
			self:SetPos(-self:GetWide(), cy)
			--self:Hide()
		else
			self:MoveTo(-self:GetWide(), cy, 0.4, 0, 0.3)
			self:PopOutHide(0.4, 0.3)
		end
	end

	function canv:Appear(now)
		if now then
			self:SetPos(0, cy)
			self:Show()
		else
			self:MoveTo(0, cy, 0.4, 0, 0.3)
			self:PopInShow(0.4)
		end
	end

	return canv
end