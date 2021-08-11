AddCSLuaFile()
include("shared.lua")

function ENT:CLInit()

	if not self.FontColor then self.FontColor = color_white end
	if not self.BackColor then self.BackColor = color_black end

	self.FontColor = self.FontColor:Copy() 		-- copy the colors from the ENT structure so we can change their RGB
	self.BackColor = self.BackColor:Copy() 		-- without changing the original color structure

	-- this one is for dimmed back color when there's no power
	local h,s,v = self.BackColor:ToHSV()

	local dimV = 0.2

	if v < 0.3 and v > 0.05 then
		dimV = 0.1
	end

	self.BackColorDimmed = draw.ColorChangeHSV(self.BackColor:Copy(), nil, nil, -dimV)

	self:On("DrawCable", "CablesInRack", self.ShouldDrawInRack)

	self:On("DTChanged", "Upgrading", function(self, key, old, new)
		if key == "Level" and new > 1 and self:CPPIGetOwner() == LocalPlayer() then
			cookie.Set("PrinterUpgraded", 1)
		end
	end)

	self.LastJitter = math.random()
	self.LastJittered = CurTime()
end

function BaseWars.EverUpgraded()
	return cookie.GetNumber("PrinterUpgraded", 0) ~= 0
end

local wpad = 32


local yoff = 90
local barH = 32

function ENT:ShouldDrawInRack()
	if self:GetPrinterRack():IsValid() then
		return false
	end
end


local black = Color(0, 0, 0, 220)

local jitterA = 100
local white = Color(255, 255, 255)

local setFont = surface.SetFont
local getTextSize = surface.GetTextSize
local setDrawColor = surface.SetDrawColor
local rect = surface.DrawRect

local simpleText = draw.SimpleText2
if not simpleText then
	include("moarpanels/draw.lua")
	simpleText = draw.SimpleText2
end

local cache = setmetatable({}, {__mode = "kv"}) --bruh...

function ENT:DrawUpgradeCost(y, w, h)
	local upW, upH = 0, 64 + 18

	local costMoney = self:GetUpgradeCost() or 0
	costMoney = costMoney * self:GetLevel()
	local cost = Language("Price", BaseWars.NumberFormat(costMoney))
	local what = "Upgrade cost:"

	local costW, whatW = cache[cost], cache[what]

	if not costW then
		setFont("BSB64")
		costW = getTextSize(cost)
		cache[cost] = costW
	end

	if not whatW then
		setFont("BS24")
		whatW = getTextSize(what)
		cache[what] = whatW
	end

	upW = math.max(costW, whatW) + 24

	local upX, upY = w/2 - upW/2, y

	setDrawColor(black:Unpack())
	rect(upX, upY, upW, upH)

	--draw.RoundedBox(16, upX, upY, upW, upH, black)

	local _, th = simpleText(what, "BS24", upX + upW / 2, upY, white, 1)
	simpleText(cost, "BSSB64", upX + upW / 2, upY + (th * 0.875), white, 1)
end

function ENT:DrawMoneyBar(pos, ang, scale, _, _, me, pwd)

	if me.TTR then me.PrintAmount = self:GetNWInt("UpgradeCost", 0) / me.TTR  end

	local w, h = 580, 144

	local Cp = me.dt.Capacity

	local money = me:GetNWMoney()

	setDrawColor(0, 0, 0)
	rect(0, 0, w, h)
	local fontCol = me.FontColor
	local backCol = pwd and me.BackColor or me.BackColorDimmed

	setDrawColor(fontCol:Unpack())
	rect(wpad - 2, yoff - 2, (w - wpad*2) + 4, barH + 4)

	setDrawColor(backCol:Unpack())
	rect(wpad, yoff, (w - wpad*2), barH)

	local perc = money / Cp

	setDrawColor(fontCol:Unpack())
	rect(wpad, yoff, (w - wpad*2) * perc, barH)

	local cur = Language("Price", money)
	local cap = Language("Price", Cp)

	draw.SimpleText2(cur .. " / " .. cap, "TW72", w/2, 36, white, 1, 1)

end

local blk = Color(0, 0, 0, 250)

function ENT:DrawMisc(pos, ang, scale, w, h, me, pwd)

	local nameW, nameH = w * 0.75, h * 0.2
	local nameX, nameY = (w - nameW) / 2, h * 0.075

	setDrawColor(blk)
	rect(nameX, nameY, nameW, nameH)
	simpleText(me.PrintName, "BS64", w/2, nameY, white, 1)

	if pwd then

		simpleText("Lv. " .. me.dt.Level, nil, w/2, nameY + nameH, color_white, 1, 4)

		if self:Health() / self:GetMaxHealth() < 0.25 then
			local sin = math.abs(math.sin(CurTime()*2))
			local col = Color(170 + sin*75, 40 + sin*40, 40 + sin*40) -- todo: creating color every frame

			local x, y = nameX + nameW/2 - 180, nameY + nameH + 40

			rect(x, y, 360, 80)
			simpleText("Critical damage!", "MRB72", w/2, y + 40, col, 1, 1)
		end
	end
end


function ENT:DrawStats(pos, ang, scale, _, _, me, pwd)
	local w, h = 450, 75

	setDrawColor(0, 0, 0, 250)

	rect(0, 0, w, h)
	rect(0, h + 12, w, h)

	if pwd then

		local rate = me.GetPrintAmount(self)
		simpleText("$" .. BaseWars.NumberFormat(rate) .. "/s.", "OS64", w/2, h/2, color_white, 1, 1)

		local left = (me.Capacity - me.GetNWMoney(self)) / rate
		local str = "Full in "

		if left > 1 then
			local t = string.FormattedTime(left, "%01i:%02i")
			str = str .. t
		else
			str = "Full!"
		end

		simpleText(str, "OS64", w/2, h + 12 + h*.5, color_white, 1, 1)
	end

end

local mBarAngle = Angle()

function ENT:GetMoneyBarPos(pos, eAng, dirs)

	mBarAngle:Set(eAng)

	pos = pos + dirs[1] * 1.8
	pos = pos + dirs[2] * 16.5
	pos = pos + dirs[3] * 11.74

	mBarAngle:RotateAroundAxis(dirs[1], 90)
	mBarAngle:RotateAroundAxis(dirs[3], -90)

	return pos, mBarAngle, 0.025

end

local miscAngle = Angle()

function ENT:GetMiscPos(pos, eAng, dirs)

	miscAngle:Set(eAng)

	pos = pos + dirs[1] * 2.5
	pos = pos + dirs[2] * -16.99
	pos = pos + dirs[3] * 14.89

	miscAngle:RotateAroundAxis(dirs[1], 90)

	local scale = 0.05
	local mul = 1 / 0.05
	local w, h = 29.8 * mul, 32.85 * mul
	return pos, miscAngle, scale, w, h

end

local statsAngle = Angle()

function ENT:GetStatsPos(pos, eAng, dirs)

	statsAngle:Set(eAng)

	pos = pos + dirs[1] * 2
	pos = pos + dirs[2] * 17.08
	pos = pos + dirs[3] * -3.2

	statsAngle:RotateAroundAxis(dirs[1], 90)
	statsAngle:RotateAroundAxis(dirs[3], -90)
	return pos, statsAngle, 0.025

end

local lp

function ENT:ShouldDrawDisplay()
	if not lp then lp = LocalPlayer() end

	local dist = lp:GetPos():DistToSqr(self:GetPos())
	if dist > 65536 then return false end

	return true
end

local angDirs = {
	-- up, forward, right
}

function ENT:GetCachedPos(moneyBar, misc, stats)
	-- O M E G A O P T I M I Z E
	local ePos, eAng = self:GetPos(), self:GetAngles()
	angDirs[1], angDirs[2], angDirs[3] = eAng:Up(), eAng:Forward(), eAng:Right()

	if moneyBar then							-- money bar has w, h hardcoded
		moneyBar[1], moneyBar[2], moneyBar[3]--[=[ , moneyBar[4], moneyBar[5] ]=] = self:GetMoneyBarPos(ePos, eAng, angDirs)
	end

	if misc then
		misc[1], misc[2], misc[3], misc[4], misc[5] = self:GetMiscPos(ePos, eAng, angDirs)
	end

	if stats then						-- stats have w, h hardcoded
		stats[1], stats[2], stats[3]--[=[ , stats[4], stats[5] ]=] = self:GetStatsPos(ePos, eAng, angDirs)
	end
end

local mBar, misc, stats = {}, {}, {}

function ENT:Draw()

	self:DrawModel()

	if not self:ShouldDrawDisplay() then return end

	self:GetCachedPos(mBar, misc, stats)

	local me = self:GetTable()
	local pwd = self:GetPower()

	if pwd then
		jitterA = 255
	else
		if CurTime() - me.LastJittered > 0.1 then
			me.LastJitter = math.random()
			me.LastJittered = CurTime()
		end

		local rand = me.LastJitter
		jitterA = 10 + rand * 7
	end

	white.a = jitterA
	me.FontColor.a = jitterA

	local pos, ang, scale, w, h = mBar[1], mBar[2], mBar[3], mBar[4], mBar[5]

	cam.Start3D2D(pos, ang, scale)
		local ok, err = pcall(self.DrawMoneyBar, self, pos, ang, scale, w, h, me, pwd)
		if not ok then print('Printers error:', err) end
	cam.End3D2D()



	pos, ang, scale, w, h = misc[1], misc[2], misc[3], misc[4], misc[5]

	cam.Start3D2D(pos, ang, scale)

		ok, err = pcall(self.DrawMisc, self, pos, ang, scale, w, h, me, pwd)
		if not ok then print('Printers misc. error:', err) end


		local y = h * 0.2 + h * 0.075 + h * 0.05

		ok, err = pcall(self.DrawUpgradeCost, self, y, w, h)
		if not ok then print('Printers upgrade cost error:', err) end

	cam.End3D2D()




	pos, ang, scale, w, h = stats[1], stats[2], stats[3], stats[4], stats[5]

	cam.Start3D2D(pos, ang, scale)
		ok, err = pcall(self.DrawStats, self, pos, ang, scale, w, h, me, pwd)
		if not ok then print('Printers error:', err) end
	cam.End3D2D()


end


function ENT:PaintStructureInfo(w, y)
	local Cp = self.dt.Capacity
	local money = self:GetNWMoney()
	local cur = Language("Price", money)
	local cap = Language("Price", Cp)

	local tw = draw.SimpleText2(cur .. " / " .. cap, "OSB24", w/2, y, color_white, 1, 5)

	return 24, tw
end