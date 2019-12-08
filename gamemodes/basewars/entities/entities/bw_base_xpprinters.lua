--easylua.StartEntity("bw_base_moneyprinter")

local fontName = "BaseWars.MoneyPrinter1"

ENT.Base = "bw_base_moneyprinter"

ENT.Model = "models/grp/printers/printer.mdl"
ENT.Skin = 0

ENT.Capacity        = 10000
ENT.Money           = 0
ENT.MaxPaper        = 2500
ENT.PrintInterval   = 1 
ENT.PrintAmount     = 10
ENT.MaxLevel        = 25
ENT.UpgradeCost     = 1000
ENT.EXPCurrency = "EXP"
ENT.PrintName       = "XP Printer(you shouldn't be seeing this!)"


local wpad = 32

local yoff = 90
local barH = 32

function ENT:DrawMoneyBar(pos, ang, scale)
     local me = self:GetTable()

    if me.TTR then me.PrintAmount = self:GetNWInt("UpgradeCost", 0) / me.TTR  end
    
    local w, h = 290*2, 72*2

    local disabled = self:GetNWBool("printer_disabled")
   

    local Pw = me:IsPowered()
    local Lv = me:GetLevel()
    local Cp = me:GetCapacity()
    local Mt = me:GetMultiplier()

    local money = me:GetMoney()
    surface.SetDrawColor(Color(0, 0, 0))
    surface.DrawRect(0, 0, w, h)
    

    surface.SetDrawColor(me.FontColor or Color(255,255,255))
    surface.DrawRect(wpad - 2, yoff - 2, (w-wpad*2) + 4, barH + 4)

    surface.SetDrawColor(me.BackColor or color_black)
    surface.DrawRect(wpad, yoff, (w-wpad*2), barH)

    local perc = money/Cp

    surface.SetDrawColor(me.FontColor or Color(255,255,255))
    surface.DrawRect(wpad, yoff, (w-wpad*2) * perc, barH)

    draw.SimpleText("EXP" .. money .. " / EXP$"..Cp, "OS72", w/2, 36, color_white, 1, 1)


end