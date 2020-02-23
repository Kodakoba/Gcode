include("shared.lua")
AddCSLuaFile("shared.lua")

local blue = Color(40, 120, 250)
local green = Color(80, 200, 80)


function ENT:CLInit()

	local me = BWEnts[self]

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

		BSHADOWS.BeginShadow(x - 12, y - 12, w + 24, w + 24)

			surface.SetDrawColor(color_white)
			surface.SetMaterial(bpmat)
			surface.DrawTexturedRect(w/2 - 38 + 12, h/2 - 38 + 12, 76, 76)

		BSHADOWS.EndShadow(1, 10, 4, 125, 60, 2, nil, Colors.DarkGray, Colors.DarkGray)


	end,

	--[[
		Tier 3 paint
	]]

	[3] = function(self, w, h)
		local x, y = self:LocalToScreen(0, 0)

		BSHADOWS.BeginShadow(x, y, w, h)

			surface.SetDrawColor(color_white)
			surface.SetMaterial(bpmat)
			surface.DrawTexturedRect(w/2 - 40, h/2 - 40, 80, 80)

		BSHADOWS.EndShadow(1, 25, 3, 205, 60, 2, nil, Color(0, 4, 0), Color(0, 2, 0))
	end,

	--[[
		Tier 4 paint
	]]

	[4] = function(self, w, h)
		local x, y = self:LocalToScreen(0, 0)

		BSHADOWS.BeginShadow()
			surface.SetDrawColor(color_white)
			surface.SetMaterial(bpmat)
			surface.DrawTexturedRect(x + w/2 - 40, y + h/2 - 40, 80, 80)
		BSHADOWS.EndShadow(2, 2, 2, 205, 60, 2, nil, Color(12, 4, 0), Color(12, 4, 0))
	end,

	--[[
		Tier 5 paint
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

	mats.random = mats.random or draw.RenderOntoMaterial("bp_random", 48, 48, function(w, h)
		draw.SimpleText("?", "MRB72", w/2, h/2, color_white, 1, 1)
	end)

	menu = vgui.Create("FFrame")
	menu:SetSize(650, 500)

	menu:SetPos(ScrW() / 2 - (menu:GetWide() + 350) / 2, ScrH() / 2 - menu:GetTall() / 2)

	menu.Shadow = {}

	menu:MakePopup()
	menu:PopIn()

	menu.Delta = DeltaText()

	menu.Inventory = Inventory.CreateFrame(Inventory.Data.Temp)

	function menu:OnRemove()
		if IsValid(self.Inventory) then 
			self.Inventory:Remove()
		end
	end

	local inv = menu.Inventory 
	inv:SetSize(342, menu:GetTall())
	inv:MoveRightOf(menu, 8)
	inv.Y = menu.Y

	inv:CreateItems()

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

	function menu:PostPaint(w, h)
		delta:Paint(w/2, 80 + 120 + 24)

		if self.Cost then 
			surface.SetDrawColor(color_white)
			surface.DrawMaterial("https://i.imgur.com/zhejG17.png", "bp128.png", w/2 - 72, h - 158, 64, 64)
			self.Cost:Paint(w/2, h - 150)
		end

	end

	function menu:UpdateCost()
		curcost = math.floor(basecost * costmult)
		if self.Cost then 
			self.CostPiece:ReplaceText(self.CostFragmentInd, curcost)
		end
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
	icons.CenterX = true 

	icons:SetPos(80, 80)
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

	local text = "Tier %d Blueprint"
	local cycled = false

	local cType

	for i=0, btns - 1 do 
		local num = i+1

		local tier = icons:Add("FButton")

		tier:SetSize(96, 120 - 16)

		function tier:PostPaint(w, h)
			if BlueprintPaints[i+1] then 
				BlueprintPaints[i+1] (self, w, h) 
			end
		end

		function tier:DoClick()
			if sel then 
				sel:SetColor(70, 70, 70)
			end

			self:SetColor(30, 130, 190)

			sel = self

			basecost = Inventory.BlueprintCosts[i + 1]

			menu:UpdateCost()
			menu:MakeTier(i + 1)
		end
	end

	icons:AutoCenter()

	function menu:MakeTier(t)

		if not cycled then 
			delta:CycleNext()
			dtext.Fragments[ptier].Text = t
			cycled = true 
		else
			dtext:ReplaceText(ptier, t)
		end

		if not cType then 

			cType = vgui.Create("FComboBox", menu)
			cType:SetSortItems(false)
			cType:CenterHorizontal()

			cType.Y = 280
			cType:SetSize(160, 40)
			cType:SetFont("TWB32")
			cType:SetContentAlignment(5)
			cType:SetColor(Color(70, 70, 70))

			local t = {} 

			for k,v in pairs(Inventory.BlueprintTypes) do 
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

				local icon = v.Icon or {}

				if v.Icon and not mat then

					if icon.RenderName then 

						mat = draw.RenderOntoMaterial(icon.RenderName, icon.RenderW, icon.RenderH, icon.Render)
						mats[icon.RenderName] = mat

					elseif icon.IconName then

						mat = draw.GetMaterial(icon.IconURL, icon.IconName, icon.IconFlags, function(mat, cache)
							if cache then print("oh shit oh fuck") return end

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

				cType:AddChoice(name, v.CostMult, v.Default, mat, function(self, opt)
					opt.IconW = icon.IconW or opt.IconW
					opt.IconH = icon.IconH or opt.IconH

					opt.IconPad = icon.IconPad or opt.IconPad
				end)
			end

			function cType:OnSelect(i, val, mult)
				dtext:ReplaceText(ptype, val)

				costmult = mult 

				menu:UpdateCost()
			end

			menu.Cost = DeltaText():SetFont("MR48")

			menu.CostPiece = menu.Cost:AddText("x"):SetColor(Colors.Blue)
			menu.CostFragmentInd = menu.CostPiece:AddFragment(curcost, nil, false)

			menu.Cost:CycleNext()


			menu.Begin = vgui.Create("FButton", menu)
			local btn = menu.Begin 
			btn:SetSize(192, 56)
			btn:Center()
			btn.Y = menu:GetTall() - 72

			btn.Font = "MR36"
			btn.Label = "Begin!"

			function btn:Think()
				menu.HasBlueprintsAmt = Inventory.Data.Temp:GetItemCount("blank_bp")
				menu.HasEnough = menu.HasBlueprintsAmt >= curcost

				print("cur cost:", curcost, menu.HasEnough)

				if menu.HasEnough then 
					print("enuff")
					self:SetColor(50, 150, 250)
				else 
					print("not enuff")
					local grey = Colors.Button
					self:SetColor()
				end
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