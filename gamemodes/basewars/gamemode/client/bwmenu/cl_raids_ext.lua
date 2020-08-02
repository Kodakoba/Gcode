local tab = {}
BaseWars.Menu.Tabs["Raids"] = tab


local function onOpen(navpnl, tabbtn, prevPnl)
	local f = BaseWars.Menu.Frame

	if IsValid(prevPnl) then
		prevPnl:PopInShow()
		f:PositionPanel(prevPnl)
		return prevPnl
	end

	local pnl = vgui.Create("Panel", f, "Raids Canvas")
	f:PositionPanel(pnl)

	tab.Panel = pnl
	return pnl
end

local function onClose(navpnl, tabbtn, prevPnl)
	tab.Panel:PopOutHide()
end

local function onCreateTab(f, tab)
	local ic = tab:SetIcon("https://i.imgur.com/xyrD9OM.png", "salilsawaarim.png")
	tab:SetDescription("Scan and raid others")
end


tab[1] = onOpen
tab[2] = onClose
tab[3] = onCreateTab