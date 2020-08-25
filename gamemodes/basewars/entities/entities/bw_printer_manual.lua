AddCSLuaFile()
ENT.Base = "bw_base_moneyprinter"

ENT.Skin = 0

ENT.Capacity        = 15000
ENT.PrintAmount     = 15
ENT.PowerRequired = 0
ENT.PowerCapacity = 50
ENT.PrintName = "Manual Printer"

ENT.FontColor = Color(200, 117, 51)
ENT.BackColor = color_black
ENT.IsValidRaidable = false

ENT.PrintAmount = 5
ENT.MaxLevel = 5
ENT.BypassMaster = true
ENT.RebootTime = 0
function ENT:UseFunc(act, call)
	if not self:GetGrid():TakePower(5) then return end

	local printed = self.PrintAmount * self:GetLevel()

	act:GiveMoney(printed)
	hook.Run("BaseWars_PlayerEmptyPrinter", call, self, printed)

end

local misc = {}
local anim = Animatable()
anim.a = 0
local a = 0

local white = Color(255, 255, 255)
local blk = Color(0, 0, 0)

local wrappedtx
local wrappedsrc
local lines

local curTipY = 0

function ENT:DrawTipDisplay(w, h, a)
	local tipW, tipH = w * 0.5, 72
	local tipX, tipY = w/2 - tipW/2, h * 0.05

	--surface.SetDrawColor(0, 0, 0, a * 220)
	--surface.DrawRect(tipX, tipY, tipW, tipH)

	blk.a = a * 220
	white.a = a * 255

	draw.RoundedBoxEx(32, tipX, tipY, tipW, tipH, blk, true, true, false, false)
	draw.SimpleText(Language.Tip, "OSB64", tipX + tipW / 2, tipY + tipH / 2, white, 1, 1)

	local contW, contH = w * 0.8, 0

		-- wrap text
		local contFont, exists = Language("PrinterUpgradeTipFont")
		if not exists then
			contFont = "OS28"
		end
		local hgt = contFont:match("%d+$")
		if not wrappedtx or wrappedsrc ~= Language.PrinterUpgradeTip then
			wrappedsrc = Language.PrinterUpgradeTip
			wrappedtx = string.WordWrap2(wrappedsrc, contW - 16, contFont)

			local _, lns = wrappedtx:gsub("[\r\n]", "")
			lines = lns + 1
			--lines = select("#", )
		end

		contH = lines * hgt + 16

	local contX, contY = w/2 - contW/2, tipY + tipH

	draw.RoundedBox(16, contX, contY, contW, contH, blk, false, false, true, true)
	draw.DrawText(wrappedtx, contFont, contX + 8, contY + 8, white)


	curTipY = contY + contH
end

local black = Color(0, 0, 0, 220)

function ENT:DrawDisplay(w, h, a)
	local upW, upH = 0, 64 + 18

	local costMoney = self:GetUpgradeCost() or 0
	costMoney = costMoney * self:GetLevel()
	local cost = Language("Price", BaseWars.NumberFormat(costMoney))
	local what = "Upgrade cost:"

	surface.SetFont("OSB64")
	local costW = surface.GetTextSize(cost)

	surface.SetFont("OS24")
	local whatW = surface.GetTextSize(what)

	upW = math.max(costW, whatW) + 24

	local upX, upY = w/2 - upW/2, h * 0.05 + a * (curTipY + 140)

	draw.RoundedBox(16, upX, upY, upW, upH, black)
	draw.SimpleText(what, "OS24", upX + upW / 2, upY, color_white, 1)
	draw.SimpleText(cost, "OSB64", upX + upW / 2, upY + 18, color_white, 1)
end

function ENT:Draw()
	self:DrawModel()
	self:GetCachedPos(nil, misc, nil)

	local pos, ang, scale, w, h = misc[1], misc[2], misc[3], misc[4], misc[5]

	local nameW, nameH = w * 0.75, h * 0.2
    local nameX, nameY = (w - nameW) / 2, h * 0.075
    local lp = LocalPlayer()

    if self:ShouldDrawDisplay() and not BaseWars.EverUpgraded() and
    	lp:GetMoney() > self:GetUpgradeCost() and self:CPPIGetOwner() == lp then
    	anim:To("a", 1, 0.3, 0, 0.2)
    else
    	anim:To("a", 0, 0.3, 0, 0.2)
    end

    local a = anim.a

    
	draw.EnableFilters()
	cam.Start3D2D(pos, ang, scale)
		if a > 0 then
			local ok, err = pcall(self.DrawTipDisplay, self, w, h, a)

			if not ok then
				print("err", err)
			end
		end

		local ok, err = pcall(self.DrawDisplay, self, w, h, a)

		if not ok then
			print("err", err)
		end
	cam.End3D2D()
	draw.DisableFilters()



end

function ENT:ThinkFunc()
end

function ENT:UseBypass()
end