
--BaseWars.Bases.MarkTool:Finish()

local bases = BaseWars.Bases

local bnd = Bind("areamark_baseselect")
bnd:SetHeld(false)

local BASE_MENU_KEY = KEY_R

local TOOL = BaseWars.Bases.MarkTool

local STATE_BASESELECT = -1
local STATE_FIRST = 0
local STATE_SECOND = 1
local STATE_CONFIRM = 2

local state_titles = {
	[STATE_BASESELECT] = "Select a base",
	[STATE_FIRST] = "Point #1",
	[STATE_SECOND] = "Point #2",
	[STATE_CONFIRM] = "Confirm"
}

local state_descs = {
	[STATE_BASESELECT] = "Hold R and either pick a base, or create one",
	[STATE_FIRST] = "LMB to select",
	[STATE_SECOND] = "LMB to select\nRMB to rewind",
}

TOOL.State = STATE_BASESELECT
TOOL.ConfirmedStateUCMD = 0

TOOL.CurrentArea = {}

TOOL.Information = {}
TOOL.Name = "[sadmin] AreaMark"
TOOL.Category = "Admin Tools"
TOOL.CurrentBase = nil
TOOL.IsBWAreaMark = true

function TOOL:DrawHUD()
	return false
end

function TOOL:LeftClick(tr)
	if not self.CurrentBase then return end

	local ucmd = LocalPlayer():GetCurrentCommand():CommandNumber()
	if not IsFirstTimePredicted() then
		local ret = self.State < STATE_CONFIRM or ucmd == self.ConfirmedStateUCMD
		return ret
	end

	if self.State < STATE_CONFIRM then
		self.State = self.State + 1
		self.CurrentArea[self.State] = tr.HitPos
		print("added into", self.State)
		if self.State == STATE_CONFIRM then
			--OrderVectors(self.CurrentArea[1], self.CurrentArea[2])
			self.ConfirmedStateUCMD = ucmd
		end

		return true
	end

	return false -- first pred
end

function TOOL:RightClick(tr)
	if not IsFirstTimePredicted() then return end

	if self.State == 3 then
		self.State = STATE_FIRST
		table.Empty(self.CurrentArea)
		return true
	elseif self.State > 0 then
		print("removed", self.State)
		self.CurrentArea[self.State] = nil
		self.State = self.State - 1
	end
end

function TOOL:GetCurrentStateText()
	local ret = state_titles[self.State]
	return (ret or "?????"), not not ret
end

function TOOL:GetCurrentStateDescription()
	local ret = state_descs[self.State]
	return (ret or "?????"), not not ret
end

function TOOL:ChangeState(to)
	self.State = to
	table.Empty(self._StateCache)
end

local descFont = "BS32"
surface.SetFont(descFont)
local descHgt = select(2, surface.GetTextSize("W"))

function TOOL:DrawToolScreen(w, h)
	self._StateCache = self._StateCache or {} -- not a shared table

	surface.SetDrawColor(color_black)
	surface.DrawRect(0, 0, w, h)

	local txt, has = self:GetCurrentStateText()

	local font = self._StateCache.TitleFont or Fonts.PickFont("BSB", txt, w - 16)
	self._StateCache.TitleFont = font

	local desc = self._StateCache.Description or string.WordWrap2(self:GetCurrentStateDescription(), w - 8, descFont)
	self._StateCache.Description = desc


	local _, tH = draw.SimpleText(txt, font, w/2, 8, color_white, 1, 5)

	local amt = amtNewlines(desc)

	
	surface.SetFont(descFont)
	local cy = tH + (h - tH) / 2  -  descHgt * (amt + 1) / 2
	for s, line in eachNewline(desc) do
		draw.SimpleText2(s, nil, w/2, cy, Colors.DarkWhite, 1, 5)
		cy = cy + descHgt
	end

	if not has then
		draw.SimpleText("state: " .. self.State, "OS36", w/2, h/2 + hgt / 2, color_white, 1, 5)
	end
end

TOOL:Finish()

-- get the localplayer's tool instance if it's equipped
-- returns either the tool instance or false

function TOOL:GetInstance()
	local lp = LocalPlayer()
	if not lp or not lp:IsValid() then return false end

	local tool = lp:GetTool()
	local wep = tool and tool:GetWeapon()
	if not tool or not tool.IsBWAreaMark or lp:GetActiveWeapon() ~= wep then return false end

	return self
end

local appearTime, appearEase = 0.4, 0.2
local disappearTime, disappearEase = 0.15, 3

function TOOL:ShowBaseSelection(cur)
	local pnl
	cur[2] = self
	if cur[1] and cur[1]:IsValid() then
		pnl = cur[1]

		pnl.Disappearing = false
		pnl:Stop()
		pnl:Show()
		pnl:SetMouseInputEnabled(true)

		bnd:SetHeld(false)

		gui.SetMousePos(unpack(pnl.LastMouse))
	else
		pnl = vgui.Create("FFrame")
		cur[1] = pnl

		pnl:SetSize(ScrW() * 0.15, ScrH() * 0.5)
		pnl:SetPos(ScrW(), 0)
		pnl:CenterVertical()

		pnl:MakePopup()
		pnl:SetKeyBoardInputEnabled(false)
		gui.SetMousePos(ScrW() * 0.9 - pnl:GetWide() / 2, pnl.Y + pnl:GetTall() / 2)

		pnl.AppearFrac = 0
		
		local focused = false
		local hostage = false	-- are we on only because they switched to text entry, unswitched and didn't hold R again?

		local held = false	-- is the R key held? switches to `true` when the textentry gets focused for the first time

		pnl.HostageFrac = 0

		function pnl:PrePaint(w, h)
			self:To("HostageFrac", hostage and 1 or 0, 0.3, 0, 0.3)

			local fr = self.AppearFrac
			surface.SetDrawColor(0, 0, 0, fr * 200)
			DisableClipping(true)
				surface.DrawRect(-ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2)
				if hostage or self.HostageFrac > 0 then
					draw.SimpleText("press R to close the menu", "OS20", w/2, -28 * self.HostageFrac, Colors.DarkerWhite, 1)
					hostage = hostage and not bnd:GetButtonState()
				end
			DisableClipping(false)

			if held then held = input.IsKeyDown(BASE_MENU_KEY) end
		end

		local scr = vgui.Create("SearchLayout", pnl)
		scr:Dock(FILL)
		scr:InvalidateParent(true)

		for baseID, base in pairs(bases.Bases) do
			local fb = vgui.Create("FButton")
			fb:SetSize(180, 40)
			scr:Add(fb, base:GetName() or "[unnamed?]")
			fb.Label = base:GetName() or "[unnamed?]"
		end

		-- if the search bar gets focus, keep the bind held
		-- when it loses focus, still keep the bind held because 

		scr.SearchBar:On("GetFocus", function()
			bnd:SetHeld(true)

			if not hostage then
				held = true
			end

			focused = true
			pnl:SetKeyBoardInputEnabled(true)
		end)

		scr.SearchBar:On("LoseFocus", function()
			focused = false
			hostage = bnd:GetHeld()
			pnl:SetKeyBoardInputEnabled(false)
		end)

		bnd:On("ButtonChanged", scr.SearchBar, function(self, to)
			if to == true and not focused then
				bnd:SetHeld(false)
			end
		end)

		local fuckOff = FrameNumber()	-- AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
		function scr.SearchBar:OnKeyCodeTyped(key)
			-- ABSOLUTE ASS
			if key == BASE_MENU_KEY and held then fuckOff = FrameNumber() return true end
		end

		function scr.SearchBar:AllowInput(a)
			if fuckOff == FrameNumber() then fuckOff = nil return true end
		end
		
	end

	pnl:To("AppearFrac", 1, appearTime, 0, appearEase)
	pnl:MoveTo(ScrW() * 0.9 - pnl:GetWide(), pnl.Y, appearTime, 0, appearEase)
end

function TOOL:HideBaseSelection(cur)
	if not IsValid(cur[1]) then table.Empty(cur) return end

	local pnl = cur[1]
	pnl:To("AppearFrac", 0, disappearTime, 0, disappearEase)
	pnl.LastMouse = {gui.MousePos()}
	pnl:SetMouseInputEnabled(false)
	bnd:SetHeld(false)

	pnl:MoveTo(ScrW(), pnl.Y, disappearTime, 0, disappearEase, function(_, pnl)
		pnl:Hide()
	end)

	
end

hook.Add("PostDrawTranslucentRenderables", "BW_AreaMarkTool", function(d, s)
	if d or s then return end

	local tool = TOOL:GetInstance()
	if not tool then return end

	local p1, p2 = tool.CurrentArea[1], tool.CurrentArea[2]
	if not p1 then return end

	local col = color_white

	if not p2 then
		p2 = lp:GetEyeTrace().HitPos
		col = Colors.Golden
		if not p2 then return end -- ??
	end

	render.DrawWireframeBox(vector_origin, angle_zero, p1, p2, col, true)
end)


bnd:SetDefaultKey(BASE_MENU_KEY)
bnd:SetKey(BASE_MENU_KEY)
bnd:SetDefaultMethod(BINDS_HOLD)
bnd:SetMethod(BINDS_HOLD)

bases.MarkToolPanelInfo = bases.MarkToolPanelInfo or {}	-- {panel, tool_instance}

local curTool = bases.MarkToolPanelInfo	

bnd:On("ButtonChanged", 1, function()
	if not IsValid(curTool[1]) then bnd:SetHeld(false) end -- just a failsafe
end)

bnd:On("Activate", 1, function(self, ply)
	local tool = TOOL:GetInstance()
	if not tool then return end
	tool:ShowBaseSelection(curTool)
end)

bnd:On("Deactivate", 1, function(self, ply)
	if not curTool[2] then return end
	curTool[2]:HideBaseSelection(curTool)
end)