local tab = {}
tab.Order = -1
BaseWars.Menu.Tabs["Settings"] = tab


local function onOpen(navpnl, tabbtn, prevPnl)
	local f = BaseWars.Menu.Frame

	if IsValid(prevPnl) then
		prevPnl:PopInShow()
		f:PositionPanel(prevPnl)
		return prevPnl
	end

	local pnl = vgui.Create("Panel", f, "Settings Canvas")
	f:PositionPanel(pnl)

	tab.Panel = pnl
	return pnl
end

local function onClose(navpnl, tabbtn, prevPnl)
	tab.Panel:PopOutHide()
end

local function onCreateTab(f, tab)
	local ic = tab:SetIcon("https://i.imgur.com/ZDzJwTM.png", "gear64.png")
	ic.Size = tab:GetTall() * 0.7
	tab:SetDescription("Settings n stuff")
end


tab[1] = onOpen
tab[2] = onClose
tab[3] = onCreateTab