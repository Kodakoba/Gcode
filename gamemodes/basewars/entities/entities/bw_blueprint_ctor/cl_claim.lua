function ENT:SlotCreated(slot)
	local ent = self

	slot:On("Drop", "NoDrop", function(slot, slot2, item)
		return false
	end)

	slot:On("FakeItem", "Alpha", function(slot)
		slot:SetAlpha(255)
	end)

	function slot:DrawBorder(w, h)
		draw.RoundedBox(4, 0, 0, w, h, Colors.DarkGray)

		local fr = math.min(math.TimeFraction(ent:GetBPStart(), ent:GetNextFinish(), CurTime()), 1)
		draw.RoundedBox(4, 0, h - fr * h, w, fr * h, Colors.Sky)
	end

	slot.Inventory = self.Storage
	slot:TrackChanges(slot.Inventory, 1)

	self:UpdateSlot(slot)
end

function ENT:UpdateSlot(sl)
	if sl.Inventory.Slots[1] then
		sl:SetItem(sl.Inventory.Slots[1])
		return
	elseif not sl:GetItem() then
		local iid = "blueprint"
		local meta = Inventory.Util.GetMeta(iid)
		local newitem = meta:new(nil, iid)

		sl:SetFakeItem(newitem)
	end
end

function ENT:CreateClaimCanvas(menu, inv)
	local ent = self
	local canv = vgui.Create("InvisPanel", menu)
	canv:SetSize(menu:GetWide(), menu:GetTall() - menu.HeaderSize)
	canv.Y = menu.HeaderSize
	local cy = canv.Y

	function canv:Disappear(now)
		if now then
			self:SetPos(menu:GetWide(), cy)
			self:Hide()
		else
			self:MoveTo(menu:GetWide(), cy, 0.4, 0, 0.3)
			self:PopOutHide(0.1, 0.3)
		end
	end

	function canv:Appear(now)
		if now then
			self:SetPos(0, cy)
			self:Show()
		else
			self:MoveTo(0, cy, 0.4, 0, 0.3)
			self:PopInShow(0.4, 0.1)
		end
	end

	local slot = vgui.Create("ItemFrame", canv)
	slot:SetSize(128, 128)
	slot:Center()

	self:SlotCreated(slot)

	function canv.Think()
		self:UpdateSlot(slot)
	end

	local font = "MR32"
	surface.SetFont(font)
	local tw = surface.GetTextSize("99:99:99")

	function canv:Paint(w, h)
		local sx, sy = slot:GetPos()
		local tx, ty = sx + slot:GetWide() / 2, sy - 8
		
		local fmt = "%02d:%02d.%02d"
		local left = math.max(ent:GetNextFinish() - CurTime(), 0)
		local tm = string.FormattedTime(left, fmt)
		draw.SimpleText(tm, font, tx - tw / 2, ty, Colors.LighterGray, 0, 4)

		local _, th = draw.SimpleText("Tier " .. ent:GetBPTier(), font,
			tx, ty + slot:GetTall() + 16, Colors.LighterGray, 1, 5)

		local intTyp = ent:GetBPType()
		local typ = Inventory.Blueprints.Types[intTyp].Name

		draw.SimpleText("Type: " .. typ, font,
			tx, ty + slot:GetTall() + 16 + th, Colors.LighterGray, 1, 5)
	end

	return canv
end