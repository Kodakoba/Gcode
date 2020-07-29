local tab = {}
BaseWars.Menu.Tabs["Factions"] = tab


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
end

local function onClose(navpnl, tabbtn, prevPnl)
	tab.Panel:PopOutHide()
end

local function onCreateTab(f, tab)
	tab:SetIcon("https://i.imgur.com/vXEMPKP.png", "faction_32.png")
end

tab[1] = onOpen
tab[2] = onClose
tab[3] = onCreateTab

tab.Order = math.huge
tab.IsDefault = true