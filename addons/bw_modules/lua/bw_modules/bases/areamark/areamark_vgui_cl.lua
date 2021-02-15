
local bw = BaseWars.Bases
local bnd = Bind("areamark_baseselect")
local TOOL = BaseWars.Bases.MarkTool


--[[
	https://i.imgur.com/GsHXv4T.png
	https://i.imgur.com/GsHXv4T.png
	https://i.imgur.com/GsHXv4T.png
	https://i.imgur.com/GsHXv4T.png
	https://i.imgur.com/GsHXv4T.png
	https://i.imgur.com/GsHXv4T.png
	https://i.imgur.com/GsHXv4T.png
]]


function TOOL:OpenBaseGUI(base)
	if IsValid(bw.BaseGUI) then
		bw.BaseGUI:Remove()
	end

	local pnl = self:CreateTemplateGUI()
	local scale = pnl:GetWide() / 544

	pnl.NameEntry:SetValue(base:GetName())

	pnl.ConfirmBtn:SetIcon(Icons.Dickbutt:Copy():SetSize(40, 40))
	pnl.ConfirmBtn.Label = "Edit base"

	local zCanvas = vgui.Create("InvisPanel", pnl)
	pnl:InvalidateLayout(true)
	--zCanvas:Debug()
	zCanvas:SetPos(pnl.NameEntry.X, pnl.NameEntry.Y + pnl.NameEntry:GetTall() + 16)
	zCanvas:SetSize(pnl:GetWide() - pnl.NameEntry.X * 2, pnl.ConfirmBtn.Y - zCanvas.Y - 16)

	local zscr = vgui.Create("FScrollPanel", zCanvas)
	zscr:Dock(LEFT)
	zscr:SetWide(pnl:GetWide() * 0.6)
	

	local zp = vgui.Create("FIconLayout", zscr)
	zp.IncompleteCenter = true
	zp.MarginX = 8
	zp.PaddingX = 16
	zp:Dock(FILL)

	local selectedZone
	local font = "OS20"

	surface.SetFont(font)
	local dotw = surface.GetTextSize("...")

	for k,v in ipairs(base:GetZones()) do
		local zb = vgui.Create("FButton", zscr)
		zb:SetSize(128, 48)
		zb.Font = font

		local fits = string.MaxFits(v:GetName(), zb:GetWide() - 4, zb.Font)
		if fits ~= v:GetName() then
			fits = string.MaxFits(v:GetName(), zb:GetWide() - 8 - dotw, zb.Font) .. "..."
		end
		zb.Label = fits

		zb.Zone = v
		zb.ZoneCopy = v -- !! TODO : make this an actual copy and only modify it !!

		zp:Add(zb)

		function zb:Select(b)
			if b then
				self:SetColor(Colors.Sky)
			else
				self:SetColor(Colors.Button)
			end
			print("selected", b)
		end

		function zb:DoClick()
			if selectedZone then
				selectedZone:Select(false)
				zCanvas:Emit("DeselectZone", selectedZone)
			else
				zCanvas:Emit("FirstSelect", self)
			end

			if selectedZone == self then
				selectedZone = nil
				zCanvas:Emit("FullDeselect", self)
				return
			end

			zCanvas:Emit("SelectZone", self, selectedZone)

			selectedZone = self
			print("selected zone", self)
			self:Select(true)
		end
	end

	zCanvas:InvalidateLayout(true)

	local zoneTE_Y = 0
	local zoneTE_H = 32

	local zoneTE

	-- each button's settings
	local btnHeight = 36 * scale 
	local amtButtons = 2
	local btnPad = 6

	-- will be used to center all icons in a row
	local buttonsHeight = btnHeight * amtButtons + btnPad * (amtButtons - 1)

	local center = (zCanvas:GetTall() - zoneTE_Y - zoneTE_H) / 2 + zoneTE_Y + zoneTE_H

	local addZone = vgui.Create("FButton", zCanvas)
		addZone.X = zscr.X + zscr:GetWide() + 8
		addZone:SetSize(btnHeight, btnHeight)
		addZone.Y = center - buttonsHeight / 2
		addZone:SetColor(Colors.Greenish)
		addZone:SetIcon(Icons.Plus:Copy():SetSize(btnHeight - 12, btnHeight - 12))

	local yeetZone = vgui.Create("FButton", zCanvas)
		yeetZone.X = zscr.X + zscr:GetWide() + 8
		yeetZone:SetSize(btnHeight, btnHeight)
		yeetZone.Y = center - buttonsHeight / 2 + btnHeight + btnPad
		yeetZone:SetColor(Colors.Reddish)
		yeetZone:SetDisabled(true)
		yeetZone:SetIcon(Icons.TrashCan:Copy():SetSize(btnHeight - 12, btnHeight - 12))

	local save = vgui.Create("FButton", zCanvas)
		save.X = yeetZone.X + yeetZone:GetWide() + 8
		save.Y = yeetZone.Y
		save:SetColor(Colors.Sky:Copy():ModHSV(0, 0, -0.1))
		save:SetSize(yeetZone:GetSize())
		save:SetIcon(Icons.Save:Copy():SetSize(btnHeight - 12, btnHeight - 12))
		save:SetDisabled(true)

	function save:DoClick()
		local zname = zoneTE:GetValue()
		local zone = selectedZone.ZoneCopy
		zone:SetName(zname)
		local pr = bw.RequestZoneEdit(zone)
		print("promise", pr)
		pr:Then(function()
			print("success")
		end, function()
			print("bad!")
			local why = net.ReadCompressedString()
			pnl:AddError(why)
		end)
	end

	local function removeZoneTE()
		zoneTE:SetPos(zoneTE:GetPos())
		zoneTE:Dock(NODOCK)
		zoneTE:MoveBy(0, 24, 0.2, 0, 2)
		zoneTE:SetZPos(-255)
		zoneTE:AlphaTo(0, 0.2, 0, 1.5, function(_, self) self:Remove() end)

		zoneTE = nil
	end

	local limgood = Color(130, 130, 130)
	local limbad = Colors.Reddish:Copy()
	local curlim = limgood:Copy()

	local function createZoneTE(z)
		if IsValid(zoneTE) then removeZoneTE() end

		zoneTE = vgui.Create("FTextEntry", zCanvas)
		zoneTE:Dock(TOP)
		zoneTE:DockMargin(8, zoneTE_Y, 0, 0)
		zoneTE:SetTall(zoneTE_H)
		zoneTE:SetPlaceholderText("Zone Name")
		zoneTE:SetValue(z:GetName())

		zoneTE:PopIn()
		zoneTE:InvalidateParent(true)
		zoneTE:Dock(NODOCK)
		zoneTE:SetMaxChars(bw.MaxZoneNameLength)

		zoneTE.Y = zoneTE.Y - zoneTE:GetTall()
		zoneTE:MoveBy(0, zoneTE:GetTall(), 0.2, 0.1, 0.3)

		zoneTE:On("PostPaint", function(self, w, h)
			local cur = #self:GetValue()
			local can = bw.MaxZoneNameLength
			-- long zone names are not advised
			self:LerpColor(curlim, cur >= can / 2 and limbad or limgood, 0.2, 0, 0.3)
			DisableClipping(true)
				draw.SimpleText(cur .. "/" .. can, "OS20", w, h, curlim, 2, 5)
			DisableClipping(false)
		end)
	end

	function zCanvas:CreateZoneControls(zb)
		yeetZone:SetDisabled(false)
		createZoneTE(zb.Zone)

		save:SetDisabled(false)
	end

	function zCanvas:RemoveZoneControls(zb)
		yeetZone:SetDisabled(true)
		save:SetDisabled(true)
		removeZoneTE()
	end

	function zCanvas:SwitchZone(to, from)
		local zto = to.Zone
		local zfrom = from and from.Zone

		createZoneTE(zto)
	end

	zCanvas:On("FirstSelect", "A", zCanvas.CreateZoneControls)
	zCanvas:On("FullDeselect", "AAA", zCanvas.RemoveZoneControls)
	zCanvas:On("SelectZone", "AAAAA", zCanvas.SwitchZone)
end

function TOOL:OpenNewBaseGUI()
	if IsValid(bw.BaseGUI) then -- two base GUIs shouldn't be open
		bw.BaseGUI:Remove()
	end

	local tool = self
	local pnl = self:CreateTemplateGUI()
	pnl.ConfirmBtn:SetIcon(Icons.Plus)
	pnl.ConfirmBtn.Label = "Create new base"

	function pnl.ConfirmBtn:DoClick()
		local name = pnl.NameEntry:GetValue()
		local pr = bw.RequestBaseCreation(name)
		self.AwaitingReply = true
		pnl:AlphaTo(120, 0.3, 0, 0.3)

		pr:Then(function()
			self.AwaitingReply = false
			pnl:PopOut()
			local id = net.ReadUInt(bw.NW.SZ.base)

			if bw.Bases[id] then
				tool:OpenBaseGUI(bw.Bases[id])
			else
				bw:On("ReadBases", "WaitFor" .. id, function(_, new)
					if new[id] then
						tool:OpenBaseGUI(new[id])
						bw:RemoveListener("ReadBases", "WaitFor" .. id)
					end
				end)
			end

		end, function()
			self.AwaitingReply = false
			pnl:AlphaTo(255, 0.3, 0, 0.3)
			local why = net.ReadCompressedString()

			pnl:AddError(why)
		end)

	end
end

function TOOL:CreateTemplateGUI()
	local ff = vgui.Create("FFrame")
	bw.BaseGUI = ff

	local ratio = 5 / 3
	local min = math.min(ScrW() * 0.4 / ratio, ScrH() * 0.6)

	ff:SetSize(min * ratio, min)
	local w, h = min * ratio, min

	ff:Center()
	local x = ff.X
	ff.X = (ff.X + self.BaseSelection.X) / 2
	ff:To("X", x, 0.6, 0, 0.1)
	ff:MakePopup()
	ff:PopIn()

	local te = vgui.Create("FTextEntry", ff)
	ff.NameEntry = te
	te:Dock(TOP)
	te:DockMargin(w * 0.05, h * 0.1, w * 0.05, 0)
	te:SetPlaceholderText("Base name")

	local btn = vgui.Create("FButton", ff)
	btn.Label = "-REPLACEME-"
	btn:Dock(BOTTOM)
	btn:SetTall(h * 0.1)
	btn:DockMargin(w * 0.35, h * 0.1, w * 0.35, h * 0.03)
	btn:SetDisabled(true)
	btn:SetColor(Colors.Greenish, true)

	function btn:Think()
		local n = te:GetValue()
		if self.AwaitingReply then
			self:SetDisabled(true)
		else
			self:SetDisabled( not (#n < bw.MaxBaseNameLength and #n > bw.MinBaseNameLength) )
		end
	end

	ff.ConfirmBtn = btn

	local lastErr
	local wrapErr

	local col = Colors.Error:Copy()
	local boxcol = Colors.Gray:Copy()

	local txH = 28

	function ff:AddError(err)
		self.Error = err

		self:Timer("deerr", math.max(1.25, err:CountWords() * 0.1), 0, function()
			self.Error = nil
		end)
	end

	local errFont = "OS24"
	
	function ff:PrePaint(w, h)
		self:To("ErrFrac", self.Error and 1 or 0, 0.3, 0, self.Error and 0.3 or 2.4)
		
		if not lastErr and not self.Error or self.ErrFrac == 0 then return end

		if self.Error and lastErr ~= self.Error then
			wrapErr = string.WordWrap2(self.Error, w * 0.8, errFont)
		end

		lastErr = self.Error or lastErr

		col.a = 255 * self.ErrFrac
		boxcol.a = 255 * self.ErrFrac

		local textH = (amtNewlines(wrapErr) + 1) * txH
		local rev = 1 - self.ErrFrac
		local cy = h - textH * rev + 8 * self.ErrFrac

		local longest = 0
		surface.SetFont(errFont)
		for s, line in eachNewline(wrapErr) do
			longest = math.max(longest, (surface.GetTextSize(s)))
		end

		DisableClipping(true)
			draw.RoundedBox(8, w/2 - longest/2 - 4, cy - 4, longest + 8, textH + 8, boxcol)

			for s, line in eachNewline(wrapErr) do
				draw.SimpleText(s, errFont, w/2, cy, col, 1, 5)
				cy = cy + txH
			end
		DisableClipping(false)
	end

	return ff
end

TOOL:Finish()