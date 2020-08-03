local tab = {}
BaseWars.Menu.Tabs["Factions"] = tab

--[[------------------------------]]
--	   	   	   Helpers
--[[------------------------------]]

-- dim the provided color
local dim = function(col, amt, sat)
	local ch, cs, cv = col:ToHSV()
	cv = cv * (amt or 0.8)

	-- color is very close to Color(50, 50, 50) which is the scrollpanel color
	if cs < 0.15 and (cv > 0.15 and cv < 0.25) then
		-- if it's sufficiently bright, make it gray
		-- otherwise, make it pitch black
		cv = (cv >= 0.2) and 0.35 or 0.05
	end

	draw.ColorModHSV(col, ch, cs * (sat or 0.9), cv)
end

-- return a dimmed copy of the color
local getDimmed = function(col, amt, sat)
	col = col:Copy()
	dim(col, amt, sat)
	return col
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

--[[------------------------------]]
--	   	   Faction Buttons
--[[------------------------------]]

local function facBtnPrePaint(self, w, h)
	local max = Factions.MaxMembers
	local fac = self.Faction

	local membs = fac:GetMembers()

	local frac = math.min(#membs / max, 1)
	self:To("MembFrac", frac, 0.4, 0, 0.3)
	frac = self.MembFrac or 0

	draw.RoundedBox(self.RBRadius or 8, 0, 0, w, h, Colors.Gray)

	local x, y = self:LocalToScreen(0, 0)
	render.SetScissorRect(x, y, x + w * frac, y + h, true)
end

local function facBtnPaint(self, w, h)
		local fh, fs, fv = self.Faction:GetColor():ToHSV()
		local col = pickFactionButtonTextColor(fh, fs, fv)

		draw.Masked(function()
			draw.RoundedPolyBox(self.RBRadius or 8, 0, 0, w, h, color_white)
		end, function()
			local r, g, b = 20, 20, 20
			if fv < 0.2 then
				r, g, b = 40, 40, 40
			end
			surface.SetDrawColor(r, g, b, 100)
			local u = -CurTime() % 25 / 25
			surface.DrawUVMaterial("https://i.imgur.com/y9uYf4Y.png", "whitestripes.png", 0, 0, w, h, u, 0, u + 0.5, 0.125)
		end)

		draw.SimpleText(self.Faction.name, BaseWars.Menu.Fonts.BoldSmall, w/2, 2, col, 1)

	local x, y = self:LocalToScreen(0, 0)
	frac = self.MembFrac or 0

	render.SetScissorRect(x + w * frac, y, x + w, y + h, true)

		draw.SimpleText(self.Faction.name, BaseWars.Menu.Fonts.BoldSmall, w/2, 2, color_white, 1)
	render.SetScissorRect(0, 0, 0, 0, false)
end

--[[------------------------------]]
--	   	   Action Selection
--[[------------------------------]]

-- Someone's faction

local function createFactionActions(f, fac)
	local pnl = vgui.Create("Panel", f)
	f.FactionFrame = pnl
	pnl:SetPos(f.FactionScroll.X + f.FactionScroll:GetWide(), 0)
								--    V because it'll move to the right by 8px
	pnl:SetSize(f:GetWide() - pnl.X - 8, f:GetTall())

	pnl:MoveBy(8, 0, 0.2, 0, 0.3)
	pnl:PopIn()

	local col = getDimmed(fac:GetColor(), 0.2, 0.3)

	local h,s,v = col:ToHSV()
	draw.ColorModHSV(col, h, s, math.max(v, 0.15))

	local bordCol = fac:GetColor():Copy()
	local h,s,v = bordCol:ToHSV()

	draw.ColorModHSV(bordCol, h, s, (v < 0.3 and s < 0.1) and 0.06 or v)
	function pnl:Paint(w, h)
		surface.SetDrawColor(col:Unpack())
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(bordCol:Unpack())
		self:DrawGradientBorder(w, h, 3, 3)
	end

	return pnl
end

local function onSelectAction(f, fac, new)
	if IsValid(f.FactionFrame) then
		f.FactionFrame:MoveBy(16, 0, 0.2, 0, 1.4)
		f.FactionFrame:PopOut()
	end

	if not new then
		if LocalPlayer():Team() ~= fac.id then
			f.FactionFrame = createFactionActions(f, fac)
		else
			f.FactionFrame = createOwnFactionActions(f, fac)
		end
	else
		f.FactionFrame = createNewFaction(f)
	end

end

--[[------------------------------]]
--	   		Factions Tab
--[[------------------------------]]

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

	pnl.SetFaction = function(self, fac)
		onSelectAction(self, fac, false)
	end

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
	pnl.FactionScroll = scr

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
		cv = cv * 0.8

		-- color is very close to Color(50, 50, 50) which is the scrollpanel color
		if cs < 0.15 and (cv > 0.15 and cv < 0.25) then
			-- if it's sufficiently bright, make it gray
			-- otherwise, make it pitch black
			cv = (cv >= 0.2) and 0.35 or 0.05
		end

		draw.ColorModHSV(dimmed, ch, cs * 0.9, cv)

		btn:SetColor(dimmed:Unpack())
		btn.PrePaint = facBtnPrePaint
		btn.PostPaint = facBtnPaint

		function btn:DoClick()
			pnl:SetFaction(self.Faction)
		end
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