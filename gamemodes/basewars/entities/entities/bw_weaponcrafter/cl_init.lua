
ENT.Base = "bw_base_electronics"
ENT.Type = "anim"
ENT.PrintName = "Weapon Crafter"
ENT.Model = "models/props_combine/combine_mortar01b.mdl"
ENT.PowerRequired = 2
ENT.PowerCapacity = 3000

function ENT:CheckUsable()

    if self.Time and self.Time + 0.5 > CurTime() then return false end
    
end



    function ENT:StableNetwork()

        self:NetworkVar("String", 1, "Gun")
        self:NetworkVar("Bool", 2, "Busy")
        self:NetworkVar("Float", 3, "Time")
        self:NetworkVar("Float", 4, "FinishTime")
    end



    function ENT:Calc3D2DParams()

            local pos = self:GetPos()
            local ang = self:GetAngles()

            pos = pos + ang:Up() * 60
            pos = pos + ang:Right()

            ang:RotateAroundAxis(ang:Up(), 90)
            ang:RotateAroundAxis(ang:Forward(), 90)
            return pos, ang, 0.1

        end

    function ENT:DrawDisplay()
        local alpha = math.min(self:GetFinishTime() - CurTime(), 1) * 255
        draw.RoundedBox(2,-60,-15,120,60, Color(0,0,0,  alpha/2))
        draw.DrawText( tostring( math.Round(self:GetFinishTime() - CurTime(), 1) ) , "BaseWars.MoneyPrinter.Big", 0, 0, Color(255,255,255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    function ENT:Think()

        self.sin = math.sin(CurTime()*2)
        self.mult = (self:GetTime()+30 - CurTime() > 0) and 4 or ValGoTo(self.mult, 0, 0.4)
        self.CSwep = self.CSwep or nil

        if self:GetBusy() and not IsValid(self.CSwep) then
            local weptbl = weapons.Get(self:GetGun())
            local model = "models/weapons/w_spade.mdl"

            if weptbl then 
                model = weapons.Get(self:GetGun()).WorldModel
            end
            
            self.CSwep = ents.CreateClientProp()
            local pos = self:GetPos() + self:GetUp()*32 + self:GetForward()*5
            self.CSwep:SetPos(pos)
            self.CSwep:SetModel(model)
            self.CSwep:SetMaterial("models/wireframe")
            self.CSwep:Spawn()
            local wep = self.CSwep
            local assembler = self

        end

        

        if not IsValid(self.CSwep) then return end

        if not self:GetBusy() then 
            self.CSwep:Remove() 
        end

        if self:GetFinishTime() - CurTime()  < 2 then 

            local pos = self:GetPos() + self:GetUp()*32 + self:GetForward()*5
            self.CSwep:SetPos(ValGoTo(self.CSwep:GetPos() or Vector(0,0,0), pos))
            self.CSwep:SetAngles(ValGoTo(self.CSwep:GetAngles() or Angle(0,0,0), Angle(0,0,0), 1) )
            return

        end

        
        local pos = self:GetPos() + self:GetUp()*32 + self:GetForward()*5 + self:GetUp()*self.sin*3
        self.CSwep:SetPos(pos)
        local ang = (self.CSwep:GetAngles() + Angle(0,FrameTime()*70, 0))
        ang:Normalize()
        self.CSwep:SetAngles( ang )




    end

    function ENT:Draw()
        self:DrawModel()
        local pos, ang, scale = self:Calc3D2DParams()

        cam.Start3D2D(pos, ang, scale)
            pcall(self.DrawDisplay, self, pos, ang, scale)
        cam.End3D2D()
    end

    function ENT:OnRemove()
        if IsValid(self.CSwep) then self.CSwep:Remove() end
    end
