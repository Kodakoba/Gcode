AddCSLuaFile()

ENT.Base            = "bw_base_generator"
ENT.PrintName       = "Numismatic Reactor"

ENT.Model           = "models/props_c17/cashregister01a.mdl"

ENT.PowerGenerated  = 0
ENT.PowerGenerated2  = 7500
ENT.PowerCapacity   = 500000

ENT.TransmitRadius  = 1000
ENT.TransmitRate    = 750

function ENT:DerivedGenDataTables()
    self:NetworkVar("Int",2,"Money")
end

function ENT:Use(act,cal)
    self:UseFunc(act,cal)
end


function ENT:UseFunc(activator,caller)

    if activator:IsPlayer()&&activator==caller then
        if BaseWars.Money:GetMoney(activator) < 2000000 then return end
        if self:GetMoney() > 5000000 then return end
        BaseWars.Money:TakeMoney(activator, 2000000)
        self:SetMoney(self:GetMoney()+2000000)
        self.ents =  ents.FindInSphere(self:GetPos(), self.TransmitRadius)
    end 

end

function ENT:ThinkFunc()
    if self:GetPower() < 450000 then
        if self:GetMoney() > 9999 then
           self:ReceivePower(self.PowerGenerated2)
           self:SetMoney(self:GetMoney()-5000)
        end
    end
end

if CLIENT then

    function ENT:Draw()

        self:DrawModel()

        local ok, err = pcall(function()

            local ang=self:GetAngles()
            local pos = self:GetPos()+ang:Forward()*-4.5+ang:Right()*5.55+ang:Up()*3.7

            ang:RotateAroundAxis(self:GetAngles():Forward(),90)

            local money = self:GetMoney()
            if not money then return end 

            local money = BaseWars.LANG.CURRENCY .. BaseWars.NumberFormat(money)

            cam.Start3D2D(pos, ang,0.1)
                draw.RoundedBox(0,0,-80,140,35,Color(0,0,0,alpha))
            cam.End3D2D()

            local pos = self:GetPos()+ang:Forward()*11+ang:Right()*-15+ang:Up()*5.6
            ang:RotateAroundAxis(self:GetAngles():Up(),180)
             cam.Start3D2D(pos, ang,0.035)
             draw.DrawText(money, "BaseWars.MoneyPrinter.Huge", 250, 100, Color(255,255,255, 255), TEXT_ALIGN_CENTER)
             cam.End3D2D()
        end)

        if not ok then 
            print(err)
        end
    end
end