--Work started: 16.05.19

if SERVER then return end
Prestige = {}
local PrestigeFrame = nil

local PerkList = {}

--[[
	PerkButton
]]


local PB = {}
local err = Material("__error")
function PB:Init()

	self.Name = "[NO NAME]"
	self.Desc = "[NO DESC]"
	self.Icon = err
	self.BorderColor = Color(255,0,0)

	self.UID = nil 
	self.GotPerk = false

	self.DrawShadow = false
end

function PB:SetPerk(uid)
	local perk = Perks.Data[uid]
	if not perk then return end 

	self.Name, self.BorderColor = perk:GetName(true)
	self.Desc = perk:GetDescription()
	self.Icon = perk:GetIcon()
	self.UID = uid 
	self.PerkID = perk:GetID()

	self.GotPerk = true 

end

function PB:PerkDraw(w, h)
	if not self.GotPerk then return end

	local col = self.BorderColor or Color(0, 0, 255)

	surface.SetDrawColor(color_white)

	surface.SetMaterial(self.Icon)
	surface.DrawTexturedRect(4, 4, w-8, h-8)

	surface.SetDrawColor(col)
	self:DrawGradientBorder(w, h, 3, 3)

end

function PB:Paint(w, h)
	self:Draw(w, h)
	self:PerkDraw(w, h)
end

vgui.Register("PerkButton", PB, "FButton")

local function GetPerks()
	PerkList = {}
	net.Start("FetchPerks")
	net.SendToServer()
end

local gr = Material("vgui/gradient-r")

local flow = Material("vgui/prestige/flow.png", "")

function CreatePerksFrame(par)
	local f = vgui.Create("InvisPanel", par)
	par:AlignPanel(f)

	f:SetAlpha(0)
	f:AlphaTo(255, 0.1)
	--f:DockPadding(12, 12, 0, 12)

	function f:Paint(w,h)
		draw.RoundedBoxEx(8, 0, 0, w, h, Color(50, 50, 50), nil, nil, true, true)
	end

	local grid = vgui.Create("FScrollPanel", f)
	grid:Dock(LEFT)
	grid:SetWide(72 * 4 + 24)

	grid.Perks = {}

	f.Perks = grid

	function grid:Paint(w,h)

		surface.SetDrawColor(40, 40, 40)
		surface.DrawRect(0,0,w, h)

		surface.SetDrawColor(35, 35, 35)

		surface.SetMaterial(gr)
		surface.DrawTexturedRect(w-6, 0, 6, h)

	end

	local wrapped = {}

	function f:Think()
		local pnl = vgui.GetHoveredPanel()
		if not pnl or not pnl.UID then return end 

		local hov = grid.Perks[pnl.UID]

		if hov then 

			if IsValid(self.DescPanel) and self.DescPanel.Describes ~= hov then 
				self.DescPanel:AlphaTo(0, 0.12)
				self.DescPanel:MoveBy(5, 2, 0.12, 0, 0.4, function(t,s) if IsValid(s) then s:Remove() end end)
				self.DescPanel = nil 
			elseif IsValid(self.DescPanel) and self.DescPanel.Describes == hov then return end

			self.DescPanel = vgui.Create("InvisPanel", self)
			local p = self.DescPanel
			p:SetAlpha(0)
			p:AlphaTo(255, 0.1, 0.08)
			p.Describes = hov
			p:SetSize(self:GetWide() - grid:GetWide(), grid:GetTall())
			p:MoveRightOf(grid,0)
			p:SetPos(p.X, grid.Y)

			function p:Paint(w,h)
				if not wrapped[hov.PerkID] then 
					wrapped[hov.PerkID] = string.WordWrap(hov.Desc, w - 8, "R18")
				end

				draw.SimpleText(hov.Name, "TWB32", w/2, 8, color_white, 1, 5)
				draw.DrawText(wrapped[hov.PerkID], "R18", 8, 64, color_white, 0, 5)
			end
		end
	end

	function f:Update(t)
		local found = {}

		local padx, pady = 8, 8

		local gx, gy = padx, pady
		local size = 64


		for k,v in pairs(grid.Perks) do 
			if not t[v.UID] then v:Remove() continue end 
			found[v.UID] = true 
		end

		for k,v in pairs(t) do 

			if not found[k] then 
				local perk = vgui.Create("PerkButton", grid)
				perk:SetSize(size, size)
				perk:SetPerk(k)

				perk:SetPos(gx, gy)

				grid.Perks[k] = perk --???? tables cant store userdata as keys?????? 

				gx = gx + size + padx
				if gx + size + padx > grid:GetWide() then 
					gx = padx 
					gy = gy + size + pady
				end

			end

		end

	end

	if par.PerkData then f:Update(par.PerkData) end

	return f
end

function Prestige.Open()
	GetPerks()
	PrestigeFrame = vgui.Create("TabbedFrame")

	--http://vaati.net/Gachi/shared/eeeeeloop.mp3
	hdl.DownloadFile("http://vaati.net/Gachi/shared/eeeeeloop.mp3", "eee_loop.dat")
	hdl.DownloadFile("http://vaati.net/Gachi/shared/no_turning_back.mp3", "noturningback.dat")
	hdl.DownloadFile("http://vaati.net/Gachi/shared/gg.mp3", "gg.dat")
	local f = PrestigeFrame 
	f.Shadow = {}
	f:SetSize(800, 650)
	f:Center()
	f:MakePopup()
	f:SetAlpha(0)
	f:AlphaTo(255, 0.1)

	function f:UpdatePerks(t)
		self.PerkData = t
		if self.Perks then 
			self.Perks:Update(t)
		end
	end

	f.TabFont = "TW28"


	f:AddTab("Perks", function()
		f.Perks = CreatePerksFrame(f)
	end, 
	function()
		f.Perks:AlphaTo(0,0.1, 0, function(t,s) s:Remove() end)
		f.Perks = nil
	end)

	f:AddTab("Prestige", function()
		f.Prestige = Perks.CreatePrestigeFrame(f)
	end, 
	function()
		f.Prestige:AlphaTo(0,0.1, 0, function(t,s) s:Remove() end)
		f.Prestige = nil
	end)

	f:SelectTab("Perks")




end


hook.Add("Think", "PrestigeMenu", function()

	if input.IsKeyDown(KEY_F4) and not (IsValid(PrestigeFrame)) then Prestige.Open() end

end)

hook.Add("PerksFetched", "PerksMenu", function(t)
	if not IsValid(PrestigeFrame) then return end 
	PrestigeFrame:UpdatePerks(t)
end)

net.Receive("GetPerkChoices", function()
	local perks = net.ReadUInt(8)
	--perkSelections = {}
	for i=1, perks do
		local pID = net.ReadUInt(8)
		local eff = net.ReadUInt(8)
		perkSelections[#perkSelections+1] = {PerkID = pID, Eff = eff + 100}
	end
end)