AddCSLuaFile()
include("shared.lua")

ENT.ContextInteractable = true

function ENT:Init()

    if not self.FontColor then self.FontColor = color_white:Copy() end
    if not self.BackColor then self.BackColor = color_black:Copy() end

end

local wpad = 32


local yoff = 90
local barH = 32
function ENT:GetModsTable()
    return util.JSONToTable(self:GetMods()) or {}
end
function ENT:CanInteractItem(item)
    if item:GetID() ~= ItemIDs.OverClocker then return false end
    if self:GetModsTable().o then return false, "Already overclocked!" end
    return true
end

function ENT:OnItemHover(item)
    local can, err = self:CanInteractItem(item)
    if not can then return err, false end

    return "Overclock " .. self.PrintName
end

function ENT:InteractItem(item, slot)

    if not self:CanInteractItem(item) then return false end

    net.Start("OverclockPrinter")
        net.WriteEntity(self)
        net.WriteUInt(item:GetUID(), 32)
    net.SendToServer()

    return true
end

function ENT:ContextInteractItem(item, slot)

    local ok = self:InteractItem(item)
    if ok==false then return true end

end

function ENT:DrawMoneyBar(pos, ang, scale, me, pwd)

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

function ENT:DrawMisc(pos, ang, scale, me, pwd)


    local w, h = 236*2, 80*2

    surface.SetDrawColor(Color(0, 0, 0, 250))
    surface.DrawRect(0, 0, w, h)

    if pwd then
        draw.SimpleText(self.PrintName, "TW72", w/2, yoff - 36, color_white, 1, 1)
        draw.SimpleText("Lv. " .. me.dt.Level, "TW72", w/2, yoff + 24, color_white, 1, 1)
        local mods = me.dt.Mods
        mods = util.JSONToTable(mods)
        surface.SetDrawColor(Color(0, 0, 0, 220))
        if mods then
            surface.DrawRect(40, h + 60, w - 80, 120)
            local col = Color(255, 0, 0)
            local mat = mods.o --overclocker
            local over = Inventory.Crafting.utils.cats.Economy[1].vars
            local col = Color(255, 0, 0)

            for k,v in pairs(over) do
                if v.id == mat then
                    col = v.col or Color(200, 200, 200)
                    break
                end
            end

            surface.SetDrawColor(col)
            surface.DrawMaterial("https://i.imgur.com/DKw6IDz.png", "overclock.png", (w-80)/2 - 20, h + 60, 120, 120 )

            local tbl = {o = {}}
            tbl.o.col = col
            tbl.o.name = "overclock.png"
            tbl.o.url = "https://i.imgur.com/DKw6IDz.png"

            self.Mods = tbl --for other ents
        end

        if self:Health()/self:GetMaxHealth() < 0.25 then
            local sin = math.abs(math.sin(CurTime()*2))
            local col = Color(170 + sin*75, 40 + sin*40, 40 + sin*40)

            surface.DrawRect(w/2 - 180, h + 200, 360, 80)
            draw.SimpleText("Critical damage!", "TWB72", w/2, h + 240, col, 1, 1)
        end
    end
end

function ENT:DrawStats(pos, ang, scale, me, pwd)
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


function ENT:GetMoneyBarPos()

    local pos = self:GetPos()
    local ang = self:GetAngles()
    --Vector (17.3935546875, -11.271484375, -1.4185791015625)
    pos = pos + ang:Up() * 1.8
    pos = pos + ang:Forward() * 16.5
    pos = pos + ang:Right() * 11.74

    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(), 90)
    return pos, ang, 0.025

end


function ENT:GetMiscPos()

    local pos = self:GetPos()
    local ang = self:GetAngles()
    --Vector (17.3935546875, -11.271484375, -1.4185791015625)
    pos = pos + ang:Up() * 2.7
    pos = pos + ang:Forward() * -15
    pos = pos + ang:Right() * 11.74

    ang:RotateAroundAxis(ang:Up(), 90)
    --ang:RotateAroundAxis(ang:Forward(), 90)
    return pos, ang, 0.05

end

function ENT:GetStatsPos()

    local pos = self:GetPos()
    local ang = self:GetAngles()
    --Vector (17.3935546875, -11.271484375, -1.4185791015625)
    pos = pos + ang:Up() * 2
    pos = pos + ang:Forward() * 17.08
    pos = pos + ang:Right() * -3.2

    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(), 90)
    return pos, ang, 0.025

end

function ENT:Draw()

    self:DrawModel()

    local dist = LocalPlayer():GetPos():DistToSqr(self:GetPos())
    if dist > 65536 then return end

    local pos, ang, scale = self:GetMoneyBarPos()
    local me = self:GetTable() --i hate this but its omegaoptimization

    local pwd = self:GetPower()

    cam.Start3D2D(pos, ang, scale)
        local ok, err = pcall(self.DrawMoneyBar, self, pos, ang, scale, me, pwd)
        if not ok then print('Printers error:', err) end
    cam.End3D2D()

    local pos, ang, scale = self:GetMiscPos()

    cam.Start3D2D(pos, ang, scale)
        local ok, err = pcall(self.DrawMisc, self, pos, ang, scale, me, pwd)
        if not ok then print('Printers error:', err) end
    cam.End3D2D()

    local pos, ang, scale = self:GetStatsPos()

    cam.Start3D2D(pos, ang, scale)
        local ok, err = pcall(self.DrawStats, self, pos, ang, scale, me, pwd)
        if not ok then print('Printers error:', err) end
    cam.End3D2D()
end
