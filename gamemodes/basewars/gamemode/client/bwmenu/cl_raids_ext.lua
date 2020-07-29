local tab = {}
BaseWars.Menu.Tabs["Raids"] = tab


local function onOpen(navpnl, tabbtn, prevPnl)
	if IsValid(prevPnl) then prevPnl:PopInShow() return end
	local f = BaseWars.Menu.Frame

	local pnl = vgui.Create("Panel", f)
	f:PositionPanel(pnl)
	pnl:Debug()

	tab.Panel = pnl
end

local function onClose(navpnl, tabbtn, prevPnl)
	tab.Panel:PopOutHide()
end

tab[1] = onOpen
tab[2] = onClose
