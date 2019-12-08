
ENT.Base = "bw_base_electronics"

ENT.Model = "models/lt_c/sci_fi/box_crate.mdl"
ENT.Skin = 0

ENT.PrintName = "Weapon Storage"

ENT.IsValidRaidable = false

ENT.PresetMaxHealth = 250
ENT.PowerRequired = 5
ENT.CurrentGun = ENT.CurrentGun or nil
ENT.Guns = ENT.Guns or 0

ENT.AnimPos = 0

    function ENT:DerivedDataTables()

    self:NetworkVar("String", 2, "CurrentGun")
    self:NetworkVar("Int", 3, "Guns")
    --self:NetworkVar("Int", 4, "Cost")

    end

    function ENT:Calc3D2DParams()

            local pos = self:GetPos()
            local ang = self:GetAngles()

            pos = pos + ang:Up() * 40 + (ang:Up() * self.AnimPos*20)
            pos = pos + ang:Forward() * -20
            pos = pos + ang:Right() * 10

            ang:RotateAroundAxis(ang:Up(), 90)
            ang:RotateAroundAxis(ang:Forward(), 90)
            ang:RotateAroundAxis(ang:Right(), 90)
            return pos, ang, 0.2

        end

local wepname
ENT.txtcol = {255,255,255}
ENT.gotowhite = true
    function ENT:Draw()
        local str
        self:DrawModel() 
        if LocalPlayer():GetEyeTrace().Entity and LocalPlayer():GetEyeTrace().Entity == self then 
            self.AnimPos = L(self.AnimPos, 1) 
        else 
            self.AnimPos = L(self.AnimPos, 0) 
        end
        if not self.AnimPos or self.AnimPos < 0.05 then return end
            self.alpha = self.AnimPos*180
            local pos,ang = self:Calc3D2DParams()

            if self.gotowhite then self.txtcol = LC(self.txtcol, Color(255,255,255), 5) end

            cam.Start3D2D(pos, ang, 0.05)

            draw.RoundedBox(2,0,0,800,280,Color(0,0,0,self.alpha))
            local num = self:GetGuns() > 0 and self:GetGuns() or ""
           
            if self:GetCurrentGun() then

                local weptbl = weapons.Get(self:GetCurrentGun()) or nil
                if weptbl and weptbl.PrintName then wepname = weptbl.PrintName else wepname = nil end

            end

            if wepname then str = wepname  str_num="Stored: ".. tostring(num)  elseif self:GetGuns() < 1 then str="None!" str_num="" else str = "Some gun(?)" str_num="Stored: ".. tostring(num) end
           -- local cost=tostring(self:GetCost())
            draw.SimpleText(str,"BaseWars.MoneyPrinter.Huge",400,280/2.5,Color(self.txtcol[1],self.txtcol[2],self.txtcol[3], self.alpha*1.5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            draw.SimpleText(str_num,"BaseWars.MoneyPrinter.Huge",400,280/1.5,Color(self.txtcol[1],self.txtcol[2],self.txtcol[3], self.alpha*1.5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            --draw.SimpleText("Cost: " .. cost.." souls","BaseWars.MoneyPrinter.Huge",400,280/1.2,Color(self.txtcol[1],self.txtcol[2],self.txtcol[3], self.alpha*1.5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            cam.End3D2D()


    end

    net.Receive("wepbox_changed", function()
        local ent=net.ReadEntity()
        if tonumber(ent:GetGuns()) > 0 then
            ent.gotowhite=false
            ent.txtcol = {250,30,30}

         timer.Simple(0.5, function() ent.gotowhite=true end)
        end

    end)

