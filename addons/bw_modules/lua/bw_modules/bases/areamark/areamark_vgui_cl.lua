
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
	pnl.NameEntry:SetValue(base:GetName())

	pnl.ConfirmBtn:SetIcon(Icons.Dickbutt:Copy():SetSize(40, 40))
	pnl.ConfirmBtn.Label = "Edit base"

	local zscr = vgui.Create("FScrollPanel", pnl)
	pnl:InvalidateLayout(true)

	zscr:SetPos(pnl.NameEntry.X, pnl.NameEntry.Y + pnl.NameEntry:GetTall() + 16)
	zscr:SetSize(pnl:GetWide() * 0.6, pnl.ConfirmBtn.Y - zscr.Y - 16)

	local zp = vgui.Create("FIconLayout", zscr)
	zp.IncompleteCenter = true
	zp.MarginX = 8
	zp.PaddingX = 16
	zp:Dock(FILL)

		
	local font = "OS20"

	surface.SetFont(font)
	local dotw = surface.GetTextSize("...")

	for k,v in ipairs(base:GetZones()) do
		print("zone:", k, v)
		local zb = vgui.Create("FButton", zscr)
		zb:SetSize(128, 48)
		zb.Font = font

		local fits = string.MaxFits(v:GetName(), zb:GetWide() - 4, zb.Font)
		if fits ~= v:GetName() then
			fits = string.MaxFits(v:GetName(), zb:GetWide() - 8 - dotw, zb.Font) .. "..."
		end
		zb.Label = fits
		print(v:GetName())
		zp:Add(zb)
	end
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
		local pr = bw:RequestCreation(name)
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

			pnl.Error = why
			pnl:Timer("deerr", math.max(1.25, why:CountWords() * 0.1), 0, function()
				pnl.Error = nil
			end)
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
	local txH = 28

	function ff:PostPaint(w, h)
		self:To("ErrFrac", self.Error and 1 or 0, 0.3, 0, self.Error and 0.3 or 2.4)
		
		if not lastErr and not self.Error then return end

		if self.Error and lastErr ~= self.Error then
			wrapErr = string.WordWrap2(self.Error, w * 0.8, "OS28")
		end

		lastErr = self.Error or lastErr

		col.a = 255 * self.ErrFrac

		local cy = btn.Y - (amtNewlines(wrapErr) + 1) * txH - 16 + 32 - 32 * self.ErrFrac
		for s, line in eachNewline(wrapErr) do
			draw.SimpleText(s, "OS28", w/2, cy, col, 1, 5)
			cy = cy + txH
		end
		
	end

	return ff
end

TOOL:Finish()