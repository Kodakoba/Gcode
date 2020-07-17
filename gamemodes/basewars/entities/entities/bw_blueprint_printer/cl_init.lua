include("shared.lua")
AddCSLuaFile("shared.lua")

local blue = Color(40, 120, 250)
local green = Color(80, 200, 80)

hdl.DownloadFile("https://i.imgur.com/SpRAhWY.jpg", "crafting/bp_line.jpg", function(fn)
	local mat = Material(fn, "noclamp")

	if not BlueprinterMat then

		BlueprinterMat = CreateMaterial("BlueprintPrinter_Line", "VertexLitGeneric", {
			["$nocull"] = 1,
			["$model"] = 1,

			["$texturescrollspeed"] = 0.05,

			["$vertexcolor"] = 1,

			["Proxies"] = {
				["TextureScroll"] = {
					["texturescrollvar"] = "$basetexturetransform",
					["texturescrollrate"] = "$texturescrollspeed",
					["texturescrollangle"] = -90
				},

				["BlueprintScroll"] = {
					resultVar = "$texturescrollspeed"
				}
			}
		})

	end

	BlueprinterMat:SetTexture("$basetexture", mat:GetTexture("$basetexture"))

	matproxy.Add({
		name = "BlueprintScroll",
		init = function( self, mat, values )

		end,
		bind = function( self, mat, ent )
			mat:SetFloat("$texturescrollspeed", ent.ScrollSpeed or 0.1)
		end
	})

end)



function ENT:CLInit()

	local me = BWEnts[self]

end

local onRow = 2

local slotPadX, slotPadY = 8, 8
local slotSize = 64

function ENT:SlotCreated(slot)

	slot.HoverGradientColor = Colors.Red -- you can't put anything in my dude

	slot:On("Drop", "DropOre", function(slot, slot2, item)
		return false
	end)

	slot:On("Paint", "DrawLocked", function(slot, w, h)
		local locked = slot.Locked
		if not locked then return end

		local lv = self:GetLevel()
		local col = slot.Unlocks - lv <= 1 and color_white or Colors.LightGray

		surface.SetDrawColor(col:Unpack())
		surface.DrawMaterial("https://i.imgur.com/QOyRzCr.png", "padlock_64rotated.png", w/2 - 16, h/2 - 16 - 4, 32, 32)

		draw.SimpleText("LV" .. slot.Unlocks, "OS18", w/2, h/2 + 12, col, 1, 5)
	end)

	slot.Inventory = self.Storage
	slot:TrackChanges(slot.Inventory, slot.ID)

	if slot.Inventory.Slots[slot.ID] then
		slot:SetItem(slot.Inventory.Slots[slot.ID])
	end
end

function ENT:GenerateWithdrawMenu(menu, old)
	if IsValid(old) then old:PopInShow() return old end

	local ent = self

	local pnl = vgui.Create("Panel", menu)
	menu:PositionPanel(pnl)

	local rows = math.ceil(self.TotalSlots / onRow)

	local fullH = rows *  (slotSize + slotPadY) - slotPadY
	local fullW = onRow * (slotSize + slotPadX) - slotPadX

	local infoW = 110
	local pW = pnl:GetWide() - infoW

	for i=1, self.TotalSlots do
		local row = math.floor((i - 1) / onRow) 	-- starts @ 0
		local col = (i-1) % onRow					-- starts @ 0

		local x = pW / 2 - fullW / 2 + (slotSize + slotPadX) * col
		local y = pnl:GetTall() / 2 - fullH / 2 + (slotSize + slotPadY) * row
		local slot = vgui.Create("ItemFrame", pnl)

		local locked = i > self.Slots

		slot:SetSize(slotSize, slotSize)
		slot:SetPos(x, y)
		slot.Locked = locked
		slot.Unlocks = row + 1

		slot.ID = i

		self:SlotCreated(slot)
	end

	function pnl:Paint(w, h)
		local fin = ent:GetNextFinish()
		local is_pw = ent:IsPowered()

		local left = math.max(fin - CurTime(), 0)
		local tx = ("%.1f s."):format(left, 2)

		surface.SetDrawColor(Colors.DarkGray)
		surface.DrawRect(w - infoW, 0, infoW, h)

		surface.SetDrawColor(10, 10, 10)
		surface.SetMaterial(MoarPanelsMats.gl)
		surface.DrawTexturedRect(w - infoW, 0, 5, h)

		if not is_pw then
			draw.SimpleText("No power.", "MR18", w - infoW/2, h/2, Colors.LightGray, 1, 1)
		elseif ent:GetJammed() then
			draw.SimpleText("Full!", "MR18", w - infoW/2, h/2, Colors.Red, 1, 1)
		else
			draw.SimpleText("Next print in:", "MR18", w - infoW/2, h/2 - 9, color_white, 1, 1)
			draw.SimpleText(tx, "MR18", w - infoW/2, h/2 + 9, color_white, 1, 1)
		end
	end
end


local menu

function ENT:OpenMenu()
	if IsValid(menu) then return end

	local inv = Inventory.Panels.CreateInventory(LocalPlayer().Inventory.Backpack, nil, {
		SlotSize = 64,
		SlotPadding = 4
	})

	--inv:SetTall(350)
	inv:CenterVertical()

	menu = vgui.Create("NavFrame")
	menu:SetRetractedSize(40)
	menu:SetExpandedSize(160)
	menu:SetSize(300, inv:GetTall())
	menu.Shadow = {}

	local sumW = menu:GetWide() + 8 + inv:GetWide()

	menu.X = ScrW() / 2 - sumW / 2
	menu.Y = inv.Y
	inv.X = menu.X + menu:GetWide() + 8

	inv:Bond(menu)
	menu:Bond(inv)

	menu:MakePopup()
	menu.Inventory = inv

	local tab = menu:AddTab("blueprints n shizz", function(_, _, old) self:GenerateWithdrawMenu(menu, old) end)
	tab.Font = "BS16"
	tab:Select(true)
	tab:SetTall(48)
end

function ENT:Draw()
	self:CalculateScrollSpeed()
	self:DrawModel()

	local pos = self:LocalToWorld(Vector(-12, -14, 79))
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Forward(), 90)

	cam.Start3D2D(pos, ang, 0.03)

		local ok, err = pcall(function()

		end)

	cam.End3D2D()

	if not ok then
		print("err", err)
	end

end

net.Receive("BlueprintPrinter", function()
	local ent = net.ReadEntity()
	if not IsValid(ent) then error("wtf " .. tostring(ent)) return end

	ent:OpenMenu()
end)