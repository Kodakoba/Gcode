local tab = {}
BaseWars.Menu.Tabs["Raids"] = tab

local function removePanel(pnl, hide)
	pnl.__selMove = pnl:MoveBy(16, 0, 0.2, 0, 1.4)

	if hide then
		pnl:PopOutHide()
	else
		pnl:PopOut()
	end

end

local function createActionCanvas(f, fac)
	local pnl = vgui.Create("FactionPanel", f)

	f.FactionFrame = pnl
	f:SetPanel(pnl)

	pnl:SetFaction(fac)

	return pnl
end

local function createRaidActions(pnl, fac, canv)
	local old = true
	if not canv then
		old = false
		canv = createActionCanvas(pnl, fac)
	end
	local mn = canv.Main

	local raid = vgui.Create("FButton", mn)
	raid:SetSize(mn:GetWide() * 0.4, 36)
	raid:Center()
	raid.Y = mn:GetTall() - 44
	raid.Label = "Start raid!"
	if not old then raid:PopIn(nil, 0.1) end
	raid:SetColor(Color(180, 70, 70))

	raid:SetIcon("https://i.imgur.com/xyrD9OM.png", "salilsawaarim.png", 24, 24)
	raid.Icon.IconX = 8

	function raid:Disappear()
		self:PopOut(0.2)
		self:To("Y", mn:GetTall() + 8, 0.25, 0, 3):Then(function()
			self:Remove()
		end)
	end

	canv:AddElement("Exclusive", raid)
end

local function onOpen(navpnl, tabbtn, _, noanim)
	local f = BaseWars.Menu.Frame
	local pnl, scr = f.FactionsPanel	-- pnl : holder for everythingg, scr: panel holding a scrollpanel in it

	if IsValid(pnl) then

		if not pnl:IsVisible() then
			if noanim then
				pnl:Show()
			else
				pnl:PopInShow()
			end
			if IsValid(pnl.NewFaction) then
				pnl.NewFaction:Remove()
			end
		end

		f:PositionPanel(pnl)

		if IsValid(pnl.NewFaction) then
			local p = pnl.NewFaction
			local l, t, r, b = p:GetDockMargin()

			pnl.NewFaction:SizeTo(pnl.NewFaction:GetWide(), 0, 0.3, 0, 0.3, function()
				p:Remove()
			end):On("Think", function(self, fr)
				p:SetAlpha(255 * (1 - fr^0.6))
				p:DockMargin(l, t * (1 - fr), r, b * (1 - fr))
			end)

			pnl.NewFaction = nil
		end

		if IsValid(pnl.FactionFrame) then
			createRaidActions(pnl, pnl.FactionFrame.Faction, pnl.FactionFrame)
		end
	else
		pnl, scr = BaseWars.Menu.CreateFactionList(f)
	end

	function pnl:FactionClicked(fac, ...)
		createRaidActions(pnl, fac)
	end

	tabbtn.Panel = pnl

	return pnl, true, true
end

local function onClose(navpnl, tabbtn, prevPnl, newTab)
	local pnl = tabbtn.Panel

	if not newTab or not newTab.UsesFactions then
		pnl:PopOutHide()
	end

	if IsValid(pnl.FactionFrame) then
		pnl.FactionFrame:RemoveElements("Exclusive")
	end
end

local function onCreateTab(f, tab)
	local ic = tab:SetIcon("https://i.imgur.com/xyrD9OM.png", "salilsawaarim.png")
	tab:SetDescription("Scan and raid others")

	tab.UsesFactions = true
end


tab[1] = onOpen
tab[2] = onClose
tab[3] = onCreateTab