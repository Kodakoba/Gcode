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

	function raid:DoClick()
		Raids.CallRaid(fac, true)
	end
	canv:AddElement("Exclusive", raid)
end

local function createFactionlessOption(pnl, scr, num, ply)
	local canv = pnl.NoFactionRaidCanvas

	local p = vgui.Create("GradPanel", scr, "PlayerFrame for " .. tostring(ply))
	p.GradSize = 2

	local hgt = 64 * BaseWars.Menu.Scale

	local y = 0

	for i=1, num - 1 do
		local p = scr.PlayerFrames[i]
		y = y + p:GetTall()
	end

	p.Y = y
	p:SetSize(canv:GetWide(), hgt)
	p:SetColor(Colors.DarkGray)

	local av = vgui.Create("CircularAvatar", p)
	av:Dock(LEFT)
	av:DockMargin(hgt / 12, hgt / 12, 0, hgt / 12)

	function av:Resize()
		av:InvalidateParent(true)
		av:SetWide(av:GetTall())
							-- pick best size
		av:SetPlayer( ply, (av:GetTall() <= 64 and 64 or 128) )
	end

	av:Resize()
	av.Rounding = 8 * BaseWars.Menu.Scale

	p.Avatar = av

	local nm = ply:Nick()
	local lastnm = ply:Nick()

	p.Money = ply:GetMoney()

	function p:Disappear()
		if self.Disappearing then return end

		self.Disappearing = self:PopOut():Then(function()
			self:Emit("Disappear")
		end)
	end

	function p:Think()
		if ply:IsValid() then
			nm = ply:Nick()
			self:To("Money", ply:GetMoney(), 0.6, 0, 0.2)
			if ply:Team() ~= Factions.FactionlessTeamID then
				self:Disappear()
			end
		else
			self:Disappear()
		end
	end

	p:On("Paint", "DrawName", function(self, w, h)
		local tW, tH = draw.SimpleText(nm, BaseWars.Menu.Fonts.MediumSmall, av.X + av:GetWide() + 6, av.Y, color_white, 0, 5)

		if ply == LocalPlayer() then
			draw.SimpleText("  (" .. Language.You:lower() .. "!)", BaseWars.Menu.Fonts.Small, av.X + av:GetWide() + 6 + tW, av.Y + tH * 0.875, Colors.LighterGray, 0, 4)
		end


		draw.SimpleText(Language("Price", self.Money), BaseWars.Menu.Fonts.Small, av.X + av:GetWide() + 6, av.Y + tH * 0.75 + 2, Colors.LighterGray, 0, 5)
	end)

	function p:Shuffle(newID, now)
		local y = 0

		for i=1, newID - 1 do
			local p = scr.PlayerFrames[i]
			y = y + p:GetTall()
		end

		if now then
			self.Y = y
		else
			self:To("Y", y, 0.3, 0, 0.3)
		end
	end

	return p
end


local function createFactionlessActions(pnl, fac, scr, oldcanv)
	if oldcanv and oldcanv ~= pnl.NoFactionRaidCanvas then
		removePanel(oldcanv)
	end

	local canv = pnl.NoFactionRaidCanvas


	if IsValid(canv) then
		canv:PopInShow()
		canv:Emit("Reappear")
		pnl:SetPanel(canv)
		print("valid, reappeatring")
		return
	end

	canv = createActionCanvas(pnl, fac)
	scr:AddElement("NoFaction", canv)
	pnl.NoFactionRaidCanvas = canv
	pnl:SetPanel(canv)

	canv:InvalidateLayout(true)

	local scr = vgui.Create("FScrollPanel", canv)
	scr:Dock(FILL)

	scr:DockMargin(0, canv:GetTall() * 0.05 * 2 + BaseWars.Menu.Fonts.BoldSizes.Medium, 0, 0)

	local plyFrames = {}  -- [num] = frame
	local plyToFrame = {} -- [ply] = frame

	scr.PlayerFrames = plyFrames

	local function createPlyFrame(k, ply)
		local p = createFactionlessOption(pnl, scr, k, ply)
		plyFrames[k] = p
		plyToFrame[ply] = p

		if ply == LocalPlayer() then
			p:SetTall(p:GetTall() * 0.75)
			p.Avatar:Resize()
		end

		p:On("Disappear", function()
			local where = 0

			for i=#plyFrames, 1, -1 do
				local v = plyFrames[i]
				if p == v then
					table.remove(plyFrames, i)
					where = i
					break
				end
			end

			for i = where, #plyFrames do
				plyFrames[i]:Shuffle(i)
			end
		end)
	end

	local i = 0

	local plys = {}

	for k, ply in ipairs(team.GetPlayers(1)) do
		i = i + 1
		plys[i] = ply
	end

	local curMoney = LocalPlayer():GetMoney()

	local function sortPlayers()
		table.Filter(plys, IsValid)

		table.sort(plys, function(a, b)
			local m1, m2 = a:GetMoney(), b:GetMoney()

			if m1 == m2 then
				return a:Nick() < b:Nick() --alphabetical
			end

			return m1 > m2
		end)

		PrintTable(plys)
	end

	sortPlayers()
	for k, v in ipairs(plys) do
		createPlyFrame(k, v)
	end

	hook.Add("PlayerJoined", canv, function(_, ply)
		if not canv:IsValid() then return end
		plys[#plys + 1] = ply
		sortPlayers()
		for k,v in ipairs(plys) do
			if v == ply then
				createPlyFrame(k, ply)
			else
				plyToFrame[v]:Shuffle(k)
				plyFrames[k] = plyToFrame[v]
			end
		end
	end)

	hook.Add("MoneyChanged", canv, function(_, ply, old, new)
		timer.Simple(0, function() -- dumb
			sortPlayers()
			for k,v in ipairs(plys) do
				plyToFrame[v]:Shuffle(k)
				plyFrames[k] = plyToFrame[v]
			end
		end)
	end)

	canv:On("Reappear", "RetrackPlayers", function()
		sortPlayers()
		local rem = {}
		for k,v in ipairs(plys) do
			rem[v] = true
			plyToFrame[v]:Shuffle(k, true)
			plyFrames[k] = plyToFrame[v]
		end

		-- remove invalid players' frames instantly upon reopen
		for ply, fr in pairs(plyToFrame) do
			if not rem[ply] then -- the player is gone
				fr:Remove()
				for num, f2 in ipairs(plyFrames) do
					if fr == f2 then
						table.remove(plyFrames, num)
						break
					end
				end
			end
		end

	end)
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