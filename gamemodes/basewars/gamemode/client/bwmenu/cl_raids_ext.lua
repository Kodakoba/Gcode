local tab = {}
BaseWars.Menu.Tabs["Raids"] = tab

local function removePanel(pnl, hide)
	if pnl.__selMove then pnl.__selMove:Stop() end

	pnl.__selMove = pnl:MoveBy(16, 0, 0.2, 0, 1.4)

	if hide then
		pnl:PopOutHide()
	else
		pnl:PopOut()
	end

end

local function createActionCanvas(f, fac)
	local pnl = vgui.Create("FactionPanel", f, "Canvas for " .. tostring(fac))

	f.FactionFrame = pnl
	f:SetPanel(pnl)

	pnl:SetFaction(fac)

	return pnl
end

local function createRaidActions(pnl, fac, canv)
	local old = true -- = the canvas already existed, aka they switched from faction tab to raid tab

	if not canv or canv.Faction ~= fac then
		old = false
		canv = createActionCanvas(pnl, fac)
	end

	local can = false

	if fac == LocalPlayer():GetFaction() then return end

	local mn = canv.Main

	local raid = vgui.Create("FButton", mn)
	raid:SetSize(mn:GetWide() * 0.4, 36)
	raid:Center()
	raid.Label = "Start raid!"

	if old then
		local old = mn:GetTall() - 44
		raid.Y = mn:GetTall() + 8
		raid:To("Y", old, 0.3, 0, 0.3)
	else
		raid.Y = mn:GetTall() - 44
	end

	raid:SetColor(Color(180, 70, 70), true)

	raid:SetIcon("https://i.imgur.com/xyrD9OM.png", "salilsawaarim.png", 24, 24)
	raid.Icon.IconX = 8

	function raid:Disappear()
		local mn = canv.Main

		self:PopOut(0.2)
		self:To("Y", mn:GetTall() + 8, 0.25, 0, 3):Then(function()
			self:Remove()
		end)
	end

	canv:AddElement("Exclusive", raid)
end

local function createFactionlessActions(pnl, fac, scr, oldcanv)
	if oldcanv and oldcanv ~= pnl.NoFactionRaidCanvas then
		removePanel(oldcanv)
	end

	local canv = pnl.NoFactionRaidCanvas or createActionCanvas(pnl, fac)

	scr:AddElement("NoFaction", canv)
	pnl.NoFactionRaidCanvas = canv

	if IsValid(pnl.NoFactionRaidCanvas) then
		pnl.NoFactionRaidCanvas:PopInShow()
	end

	pnl:SetPanel(canv)

	canv:InvalidateLayout(true)

	local scr = vgui.Create("FScrollPanel", canv)
	scr:Dock(FILL)

	scr:DockMargin(0, canv:GetTall() * 0.05 * 2 + BaseWars.Menu.Fonts.BoldSizes.Medium, 0, 0)

	function canv:Disappear()
		removePanel(self, true)
	end
end

local function onOpen(navpnl, tabbtn, _, noanim)
	local f = BaseWars.Menu.Frame

	local pnl = f.FactionsPanel	-- pnl : holder for everythingg, scr: panel holding a scrollpanel in it
	local scr = IsValid(pnl) and pnl.FactionScroll.FactionScroll --kek

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
			if pnl.FactionFrame == pnl.NoFactionRaidCanvas then
				createFactionlessActions(pnl, pnl.FactionFrame.Faction, scr)
			else
				createRaidActions(pnl, pnl.FactionFrame.Faction, pnl.FactionFrame)
			end
		end
	else
		pnl, scr = BaseWars.Menu.CreateFactionList(f)
	end

	local noFac = scr:AddButton(Factions.NoFaction)
	scr:AddElement("NoFaction", noFac)

	function pnl:FactionClicked(fac, ...)
		local old = IsValid(pnl.FactionFrame) and pnl.FactionFrame

		if old and old.Faction == fac then return end
		if old and old.Faction ~= fac then
			removePanel(old, true)
		end

		if fac:GetID() == -1 then
			createFactionlessActions(pnl, fac, scr, ...)
			return
		end

		createRaidActions(pnl, fac, pnl.FactionFrame)
	end

	tabbtn.Panel = pnl

	return pnl, true, true
end

local function onClose(navpnl, tabbtn, prevPnl, newTab)
	local pnl = tabbtn.Panel
	pnl.FactionScroll.FactionScroll:RemoveElements("NoFaction")
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