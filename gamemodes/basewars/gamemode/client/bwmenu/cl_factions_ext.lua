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

local function onOpen(navpnl, tabbtn, prevPnl, noanim)
	if IsValid(prevPnl) then
		if noanim then prevPnl:Show() else prevPnl:PopInShow() end
		return
	end
	local f = BaseWars.Menu.Frame

	local pnl = vgui.Create("Panel", f)
	f:PositionPanel(pnl)
	pnl:Debug()

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

	for k,v in ipairs(sorted) do
		local name = v[1]
		local fac = v[2]
		printf("#%d: %s", k, name)
	end
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