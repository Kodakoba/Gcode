local tab = {}
BaseWars.Menu.Tabs["Factions"] = tab

local function getMembers(fac)
	local all = player.GetAll()
	local ind = fac.id
	local amt = 0

	for k,v in ipairs(all) do
		if v:Team() == ind then
			amt = amt + 1
		end
	end
end

-- yoinked my own code from bw18
-- this is not for the button, this is for the faction info
local pickFactionTextColor = function(h, s, v, fcol)
	return v > 0.4 and fcol or color_white
end

-- this is for the button
local pickFactionButtonTextColor = function(h, s, v)
	return v > 0.75 and color_black or color_white
end

local function facBtnPaint(self, w, h)
	local fh, fs, fv = self.Faction:GetColor():ToHSV()
	local col = pickFactionButtonTextColor(fh, fs, fv)

	draw.SimpleText(self.Faction.name, BaseWars.Menu.Fonts.BoldSmall, w/2, 2, col, 1)
end

local function onOpen(navpnl, tabbtn, prevPnl, noanim)
	local f = BaseWars.Menu.Frame

	if IsValid(prevPnl) then
		if noanim then
			prevPnl:Show()
		else
			prevPnl:Show()
			prevPnl:PopInShow()
		end

		f:PositionPanel(prevPnl)

		return prevPnl
	end

	local pnl = vgui.Create("Panel", f, "Factions Canvas")
	f:PositionPanel(pnl)

	tab.Panel = pnl

	local facs = Factions.Factions
	local sorted = {}

	for name, dat in pairs(facs) do
		sorted[#sorted + 1] = {name, dat}
	end

	local me = LocalPlayer()

	table.sort(sorted, function(a, b)

		local name1, name2 = a[1], a[2]
		local a, b = a[2], b[2] --we're looking at facs

		local memb1 = a:GetMembers()
		local memb2 = b:GetMembers()

		local a_has_friends = false
		local b_has_friends = false

		local a_has_more = #memb1 > #b:GetMembers()
		local b_has_more = not a_has_more

		for k,v in ipairs(memb1) do
			if v:GetFriendStatus() == "friend" then
				a_has_friends = true
				break
			end
		end

		for k,v in ipairs(memb2) do
			if v:GetFriendStatus() == "friend" then
				b_has_friends = true
				break
			end
		end

		if a_has_friends and not b_has_friends then return true end 	-- first sort by friends

		if not a_has_more and not b_has_more then return name1 < name2 end -- if member counts are equal, sort alphabetically as a backup plan
		return a_has_more												-- sort by member counts
	end)

	local newH = math.floor(pnl:GetTall() * 0.08 / 2) * 2 + 1

	local scr = vgui.Create("FScrollPanel", pnl)
	scr:Dock(LEFT)
	scr:DockMargin(f.Scale > 0.75 and 8 or 4, 8, 0, newH + 4 + 4)
	scr:SetWide(pnl:GetWide() * 0.4)
	scr.GradBorder = true

	scr.Factions = {}

	local facHeight = 36 + (pnl:GetTall() - 16) * 0.05
	local facPad = (pnl:GetTall() - 16) * 0.03

	function scr:GetFactionY(num)
		return facPad / 2 + (num - 1) * (facHeight + facPad)
	end

	for k,v in ipairs(sorted) do
		local name = v[1]
		local fac = v[2]

		local btn = vgui.Create("FButton", scr)
		btn:SetPos(8, scr:GetFactionY(k))
		btn:SetSize(scr:GetWide() - 16, facHeight)
		btn.DrawShadow = false

		btn.Faction = fac

		-- dim the faction color a bit
		local dimmed = fac:GetColor():Copy()
		local ch, cs, cv = dimmed:ToHSV()
		draw.ColorModHSV(dimmed, ch, cs * 0.9, cv * 0.8)

		btn:SetColor(dimmed)
		btn.PostPaint = facBtnPaint
	end

	pnl:InvalidateLayout(true)

	local newFac = vgui.Create("FButton", pnl)
	newFac:SetPos(scr.X + 8, scr.Y + scr:GetTall() + 4)
	newFac:SetSize(scr:GetWide() - 16, newH)
	newFac:SetColor(Color(60, 190, 60))
	local scale = f.Scale
	local isize = math.floor(newFac:GetTall() * 0.6 / 2) * 2 + 1
	newFac:SetIcon("https://i.imgur.com/dO5eomW.png", "plus.png", isize, isize)
	newFac.Label = "Create a faction"
	newFac.Font = BaseWars.Menu.Fonts.Medium
	newFac.HovMult = 1.1
	return pnl
end

local function onClose(navpnl, tabbtn, prevPnl)
	tab.Panel:PopOutHide()
end

local function onCreateTab(f, tab)
	local ic = tab:SetIcon("https://i.imgur.com/JzTfIuf.png", "faction_64.png", 55 / 64) --the pic is 64x51
	tab:SetDescription("Team up with other players")
	ic.Size = tab.IconSize * 1.1
end

tab[1] = onOpen
tab[2] = onClose
tab[3] = onCreateTab

tab.Order = math.huge
tab.IsDefault = true