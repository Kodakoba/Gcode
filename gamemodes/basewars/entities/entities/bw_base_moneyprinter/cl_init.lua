AddCSLuaFile()
include("shared.lua")

function ENT:CLInit()

    if not self.FontColor then self.FontColor = color_white:Copy() end
    if not self.BackColor then self.BackColor = color_black:Copy() end

    self:On("DrawCable", "CablesInRack", self.ShouldDrawInRack)

    self:On("DTChanged", "Upgrading", function(self, key, old, new)
        if key == "Level" and new > 1 and self:CPPIGetOwner() == LocalPlayer() then
            cookie.Set("PrinterUpgraded", "1")
        end
    end)

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


function ENT:DrawMoneyBar(pos, ang, scale, w, h, me, pwd)

    if me.TTR then me.PrintAmount = self:GetNWInt("UpgradeCost", 0) / me.TTR  end

    local w, h = 290*2, 72*2

    local Lv = me.dt.Level
    local Cp = me.dt.Capacity
    local Mt = me.dt.Multiplier

    local money = me:GetNWMoney()

    surface.SetDrawColor(Color(0, 0, 0))
    surface.DrawRect(0, 0, w, h)

    if pwd then
        surface.SetDrawColor(me.FontColor or Color(255,255,255))
        surface.DrawRect(wpad - 2, yoff - 2, (w-wpad*2) + 4, barH + 4)

        surface.SetDrawColor(me.BackColor or color_black)
        surface.DrawRect(wpad, yoff, (w-wpad*2), barH)

        local perc = money/Cp

        surface.SetDrawColor(me.FontColor or Color(255,255,255))
        surface.DrawRect(wpad, yoff, (w-wpad*2) * perc, barH)

        draw.SimpleText("$" .. money .. " / $"..Cp, "TW72", w/2, 36, color_white, 1, 1)
    end


end

local blk = Color(0, 0, 0, 250)

function ENT:DrawMisc(pos, ang, scale, w, h, me, pwd)

    local nameW, nameH = w * 0.75, h * 0.2
    local nameX, nameY = (w - nameW) / 2, h * 0.075

    surface.SetDrawColor(blk)
    surface.DrawRect(nameX, nameY, nameW, nameH)

    if pwd then

        draw.SimpleText2(self.PrintName, "TW72", w/2, nameY, color_white, 1)
        draw.SimpleText2("Lv. " .. me.dt.Level, nil, w/2, nameY + nameH, color_white, 1, 4)
       
        if self:Health() / self:GetMaxHealth() < 0.25 then
            local sin = math.abs(math.sin(CurTime()*2))
            local col = Color(170 + sin*75, 40 + sin*40, 40 + sin*40)

            local x, y = nameX + nameW/2 - 180, nameY + nameH + 40

            surface.DrawRect(x, y, 360, 80)
            draw.SimpleText("Critical damage!", "TWB72", w/2, y + 40, col, 1, 1)
        end
    end
end

function ENT:DrawStats(pos, ang, scale, w, h, me, pwd)
    local w, h = 450, 75

    surface.SetDrawColor(Color(0, 0, 0, 250))
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(Color(0, 0, 0, 250))
    surface.DrawRect(0, h + 12, w, h)

    if pwd then

        local rate = me.GetPrintAmount(self)
        draw.SimpleText("$" .. BaseWars.NumberFormat(rate) .. "/s.", "OS64", w/2, h/2, color_white, 1, 1)

        local left = (me.Capacity - me.GetNWMoney(self)) / rate
        local str = "Full in "

        if left > 1 then
            local t = string.FormattedTime(left, "%01i:%02i")
            str = str .. t
        else
            str = "Full!"
        end

        draw.SimpleText(str, "OS64", w/2, h + 12 + h*.5, color_white, 1, 1)
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

    if moneyBar then
        moneyBar[1], moneyBar[2], moneyBar[3], moneyBar[4], moneyBar[5] = self:GetMoneyBarPos(ePos, eAng, angDirs)
    end

    if misc then
        misc[1], misc[2], misc[3], misc[4], misc[5] = self:GetMiscPos(ePos, eAng, angDirs)
    end

    if stats then
        stats[1], stats[2], stats[3], stats[4], stats[5] = self:GetStatsPos(ePos, eAng, angDirs)
    end
end

local mBar, misc, stats = {}, {}, {}

function ENT:Draw()

    self:DrawModel()
    if not self:ShouldDrawDisplay() then return end

    self:GetCachedPos(mBar, misc, stats)


    local me = self:GetTable()
    local pwd = self:GetPower()

    local pos, ang, scale, w, h = mBar[1], mBar[2], mBar[3], mBar[4], mBar[5]

    cam.Start3D2D(pos, ang, scale)
        local ok, err = pcall(self.DrawMoneyBar, self, pos, ang, scale, w, h, me, pwd)
        if not ok then print('Printers error:', err) end
    cam.End3D2D()

    pos, ang, scale, w, h = misc[1], misc[2], misc[3], misc[4], misc[5]

    cam.Start3D2D(pos, ang, scale)
        local ok, err = pcall(self.DrawMisc, self, pos, ang, scale, w, h, me, pwd)
        if not ok then print('Printers error:', err) end
    cam.End3D2D()

    pos, ang, scale, w, h = stats[1], stats[2], stats[3], stats[4], stats[5]

    cam.Start3D2D(pos, ang, scale)
        local ok, err = pcall(self.DrawStats, self, pos, ang, scale, w, h, me, pwd)
        if not ok then print('Printers error:', err) end
    cam.End3D2D()
end
