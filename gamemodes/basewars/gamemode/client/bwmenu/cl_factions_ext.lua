local tab = {}
local fonts = BaseWars.Menu.Fonts

BaseWars.Menu.Tabs["Factions"] = tab

--[[------------------------------]]
--	   	   	   Helpers
--[[------------------------------]]

-- dim the provided color
local dim = function(col, amt, sat, safe)
	local ch, cs, cv = col:ToHSV()
	cv = cv * (amt or 0.8)

	-- color is very close to Color(50, 50, 50) which is the scrollpanel color
	if safe and cs < 0.15 and (cv > 0.15 and cv < 0.25) then
		-- if it's sufficiently bright, make it gray
		-- otherwise, make it pitch black
		cv = (cv >= 0.2) and 0.35 or 0.05
	end

	draw.ColorModHSV(col, ch, cs * (sat or 0.9), cv)
end

-- return a dimmed copy of the color
local getDimmed = function(col, amt, sat, safe)
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

		draw.SimpleText(self.Faction.name, fonts.BoldSmall, w/2, 2, col, 1)

	local x, y = self:LocalToScreen(0, 0)
	frac = self.MembFrac or 0

	render.SetScissorRect(x + w * frac, y, x + w, y + h, true)

		draw.SimpleText(self.Faction.name, fonts.BoldSmall, w/2, 2, color_white, 1)
	render.SetScissorRect(0, 0, 0, 0, false)
end

--[[------------------------------]]
--	   	   Action Selection
--[[------------------------------]]

-- Someone's faction

local function createFactionActions(f, fac)
	local pnl = vgui.Create("Panel", f)
	f.FactionFrame = pnl

	pnl.Faction = fac

	f:SetPanel(pnl)

	local col = getDimmed(fac:GetColor(), 0.2, 0.3, true)

	local h, s, v = col:ToHSV()
	draw.ColorModHSV(col, h, s, math.max(v, 0.15))

	local bordCol = fac:GetColor():Copy()
	h, s, v = bordCol:ToHSV()

	draw.ColorModHSV(bordCol, h, s, (v < 0.3 and s < 0.1) and 0.06 or v)
	function pnl:Paint(w, h)
		surface.DisableClipping(true)
			surface.SetDrawColor(col:Unpack())
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(bordCol:Unpack())
			self:DrawGradientBorder(w, h, 3, 3)
		surface.DisableClipping(false)
	end

end

-- Creating a new faction

local oldNewFac

local function createNewFaction(f)
	if IsValid(oldNewFac) then
		f:SetPanel(oldNewFac)
		return
	end

	local pnl = vgui.Create("Panel", f)
	f:SetPanel(pnl)
	oldNewFac = pnl
	pnl.IsNewFaction = true

	local name
	local pw
	local col

	local err

	function pnl:ValidateData()
		local nm = name:GetValue()
		local pw = pw:GetValue()

		local can, why = Factions.CanCreate(nm, pw, col:GetColor(), LocalPlayer())

		if not can then
			err = why
			return
		end

		-- we're all good
		err = nil
	end

	local errDT = DeltaText()
	errDT.AlignX = 1

	local txCol = Color(220, 65, 65)

	local fragNum

	local pieces = {}

	local bgCol = Colors.DarkGray:Copy()
	local gradCol = color_black:Copy()

	function pnl:Paint(w, h)
		-- bg
		surface.SetDrawColor(bgCol)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(gradCol)
		self:DrawGradientBorder(w, h, 3, 3)

		-- drawing faction name
		local tx = name:GetValue()
		surface.SetFont(fonts.BoldMedium)
		local newW, tH = surface.GetTextSize(tx)
		self:To("TextW", newW, 0.2, 0, 0.2)
		local tw = self.TextW or 0

		surface.SetTextPos(w/2 - tw/2, h * 0.1 - tH / 2)
		local txcol = col:GetColor():Copy()
		local th, ts, tv = txcol:ToHSV()
		if tv < 0.1 then
			ts = ts * tv / 0.1
		end
		draw.ColorModHSV(txcol, th, ts, math.Clamp(tv, 0.2, 0.8))

		surface.SetTextColor(txcol.r, txcol.g, txcol.b, txcol.a)
		surface.DrawText(tx)

		-- drawing errors

		self:ValidateData()

		if err then
			if pieces[err] then
				-- we had that error created; just activate it
				errDT:ActivateElement(pieces[err])
			else
				-- we never had an element for this error: create one

				local sizes = {12, 14, 16, 18, 20, 22, 24, 28, 32, 36, 48, 64, 72, 96, 128}
				local picked = "OSB18"

				for i=1, #sizes do
					surface.SetFont("OSB" .. sizes[i])
					local tw = surface.GetTextSize(err)

					if tw < w * 0.9 then
						picked = "OSB" .. sizes[i]
					else
						break
					end
				end

				local elem, num = errDT:AddText(err)
				elem:SetDropStrength(18)
				elem:SetLiftStrength(18)
				elem.Font = picked
				elem.Color = txCol
				pieces[err] = num
			end
		else
			if errDT:GetCurrentElement() then
				errDT:DisappearCurrentElement()
			end
		end

		errDT:Paint(w/2, h * 0.8)

		--draw.SimpleText(tx, fonts.BoldMedium, w/2, h * 0.1, col:GetColor(), 1, 1)
	end

	local entryCanvas = vgui.Create("InvisPanel", pnl)

	name = vgui.Create("FTextEntry", entryCanvas)
	name:SetSize(pnl:GetWide() * 0.8, 32)
	name:SetPlaceholderText("Faction name...")
	name:SetUpdateOnType(true)

	pw = vgui.Create("FTextEntry", entryCanvas)
	pw:SetSize(pnl:GetWide() * 0.7, 32)
	pw:SetPlaceholderText("Password...")

	pw.Y = name.Y + name:GetTall() + 8

	col = vgui.Create("DColorMixer", entryCanvas)
	col:SetPalette(false)
	col:SetAlphaBar(false)
	col:SetWangs(false)
	col.Y = pw.Y + pw:GetTall() + 8

	col:SetSize(pnl:GetWide() * 0.6, pnl:GetTall() * 0.4)

	local COLOR = FindMetaTable("Color") --roobat

	function col:ValueChanged(c)
		setmetatable(c, COLOR)

		gradCol:Set(c)
		local dimmed = getDimmed(c, 0.2, 0.5)
		bgCol:Set(dimmed)
	end

	local totalH = name:GetTall() + 8 + pw:GetTall() + 8 + col:GetTall()

	entryCanvas:SetSize(pnl:GetWide(), totalH)

	entryCanvas:Center()
	name:CenterHorizontal()
	pw:CenterHorizontal()
	col:CenterHorizontal()

	pnl:ValidateData()

	errDT:CycleNext()

	local doEet = vgui.Create("FButton", pnl)
	doEet:Dock(BOTTOM)
	doEet:SetTall(pnl:GetTall() * 0.075)
	doEet:DockMargin(pnl:GetWide() * 0.2, 0, pnl:GetWide() * 0.2, pnl:GetTall() * 0.02)

	local good = Color(70, 180, 80)
	local bad = Colors.Button:Copy()

	function doEet:Think()
		if err then
			self:SetColor(bad)
		else
			self:SetColor(good)
		end
	end

	function doEet:DoClick()
		if err then return end
		
		Factions.RequestCreate(name:GetValue(), pw:GetValue(), col:GetColor())

		hook.Add("FactionsUpdate", pnl, function()
			if Factions.Factions[name:GetValue()] then
				pnl:Remove()
			end
		end)
	end

	local isize = doEet:GetTall() * 0.6
	doEet:SetIcon("https://i.imgur.com/dO5eomW.png", "plus.png", isize, isize)
	doEet.Label = " Create"
end

local function onSelectAction(f, fac, new)

	local old = IsValid(f.FactionFrame) and f.FactionFrame
	local valid = old and old:IsValid() and old:IsVisible()

	if not new then
		print("not new")
		if valid and old.Faction == fac then return end -- don't create a new frame if it's the same fac as before

		if LocalPlayer():Team() ~= fac.id then
			createFactionActions(f, fac)
		else
			createOwnFactionActions(f, fac)
		end
	else
		if not valid or not old.IsNewFaction then
			createNewFaction(f)
		end
	end

	if valid then
		old.__selMove = old:MoveBy(16, 0, 0.2, 0, 1.4)
		old:PopOutHide()
	end
end

function align(f, pnl)
	pnl:SetPos(f.FactionScroll.X + f.FactionScroll:GetWide(), 0)
								--    V because it'll move to the right by 8px
	pnl:SetSize(f:GetWide() - pnl.X - 8, f:GetTall())

	if pnl.__selMove then
		pnl.__selMove:Stop()
	end

	pnl:SetAlpha(0)
	pnl:MoveBy(8, 0, 0.2, 0, 0.3)
	pnl:PopInShow()

	print("aligning to", f)
	f.FactionFrame = pnl
end

-- returns a sorted table of {fac_name, fac_obj}

local function getSortedFactions()
	local facs = Factions.Factions
	local sorted = {}

	for name, dat in pairs(facs) do
		sorted[#sorted + 1] = {name, dat}
	end

	table.sort(sorted, function(a, b)

		local name1, name2 = a[1], a[2]
		local a, b = a[2], b[2] --we're looking at facs

		local memb1 = a:GetMembers()
		local memb2 = b:GetMembers()

		local a_has_friends = false
		local b_has_friends = false

		local a_has_more = #memb1 > #memb2
		local b_has_more = not a_has_more

		local me = LocalPlayer()

		for k,v in ipairs(memb1) do
			if v == me then return true end --auto-move to the top

			if v:GetFriendStatus() == "friend" then
				a_has_friends = true
				break
			end
		end

		for k,v in ipairs(memb2) do
			if v == me then return false end --vi lost

			if v:GetFriendStatus() == "friend" then
				b_has_friends = true
				break
			end
		end

		if a_has_friends and not b_has_friends then return true end 	-- first sort by friends

		if not a_has_more and not b_has_more then return name1 < name2 end -- if member counts are equal, sort alphabetically as a backup plan
		return a_has_more												-- sort by member counts
	end)


	return sorted
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

	pnl.CreateNewFaction = function(self)
		onSelectAction(self, nil, true)
	end

	pnl.SetPanel = align

	tab.Panel = pnl

	local me = LocalPlayer()

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

	function scr:AddButton(fac, num)
		local btn = vgui.Create("FButton", scr)
		btn:SetPos(8, scr:GetFactionY(num))
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

		scr.Factions[fac:GetName()] = btn

		return btn
	end

	local sorted = getSortedFactions()

	for k,v in ipairs(sorted) do
		local fac = v[2]

		scr:AddButton(fac, k)
	end

	_FACS = scr.Factions

	hook.Add("FactionsUpdate", scr, function()
		local sorted = getSortedFactions()


		for k,v in pairs(scr.Factions) do
			v.Sorted = false
		end


		for k,v in ipairs(sorted) do

			local name, fac = v[1], v[2]

			if IsValid(scr.Factions[name]) then

				scr.Factions[name].Sorted = true
				local desY = scr:GetFactionY(k)
				scr.Factions[name]:MoveTo(8, desY, 0.3, 0, 0.2)
			else
				local btn = scr:AddButton(fac, k)
				btn.Sorted = true
				btn.FacNum = k
			end
		end

		for name, btn in pairs(scr.Factions) do
			if IsValid(btn) and not btn.Sorted then
				-- if Sorted is false that means we didn't go over that button and, thus, the faction doesn't exist anymore
				btn:PopOut()
				scr.Factions[name] = nil
			end
		end

	end)

	pnl:InvalidateLayout(true)

	local newFac = vgui.Create("FButton", pnl)
	newFac:SetPos(scr.X + 8, scr.Y + scr:GetTall() + 4)
	newFac:SetSize(scr:GetWide() - 16, newH)
	newFac:SetColor(Color(60, 190, 60))

	local isize = math.floor(newFac:GetTall() * 0.6 / 2) * 2 + 1
	newFac:SetIcon("https://i.imgur.com/dO5eomW.png", "plus.png", isize, isize)
	newFac.Label = "Create a faction"
	newFac.Font = fonts.Medium
	newFac.HovMult = 1.1

	function newFac:DoClick()
		pnl:CreateNewFaction()
	end
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