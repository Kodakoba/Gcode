AddCSLuaFile("cl_init.lua")
ENT.Base = "bw_base_electronics"
ENT.Type = "anim"
ENT.PrintName = "Weapon Crafter"
ENT.Model = "models/props_combine/combine_mortar01b.mdl"
ENT.PowerRequired = 2
ENT.PowerCapacity = 3000
if SERVER then
    util.AddNetworkString("Basewars.WeaponCrafter.Menu")
    util.AddNetworkString("BaseWars.WeaponCrafter.ReqCook")
    util.AddNetworkString("BaseWars.WeaponCrafter.Status")
end

hook.Add("PlayerCanPickupWeapon", "NoPickUp", function(ply, wep)
    if wep.IsConstructing then return false end

        ply:GiveAmmo(wep:GetMaxClip1(), wep:GetPrimaryAmmoType())

    end)

function ENT:CheckUsable()

    if self.Time and self.Time + 0.5 > CurTime() then return false end
    
end




    function ENT:StableNetwork()

        self:NetworkVar("String", 1, "Gun")
        self:NetworkVar("Bool", 2, "Busy")
        self:NetworkVar("Float", 3, "Time")
        self:NetworkVar("Float", 4, "FinishTime")
    end

net.Receive("BaseWars.WeaponCrafter.ReqCook", function(len, ply)
        local me = net.ReadEntity()
        local gun = net.ReadString()

        if not gun then return end
        if me:GetPos():DistToSqr(ply:GetPos()) > 65536 then return end
        if me:GetClass() ~= "bw_weaponcrafter" then return end
        me:StartCook(gun, ply) 

    end)


function ENT:UseFunc(ply)

    local Owner = BaseWars.Ents:ValidOwner(self)
    if not BaseWars.Ents:Valid( self ) then return end
    if not BaseWars.Ents:ValidPlayer(Owner) or not BaseWars.Ents:ValidPlayer(ply) then return end
    if Owner ~= ply then return end

       self.Time=CurTime()+0.5

        net.Start("BaseWars.WeaponCrafter.Menu")
            net.WriteEntity(self)
        net.Send(ply)
    
end


function ENT:StartCook(gun, ply)
    local price
    local mdl 
    local class
    print(gun, ply)
    if self:GetBusy() then return end


    for k,v in pairs(BaseWars.SpawnList.Loadout) do 

        for k2,v2 in pairs(v) do 

            if k2==gun then 
                price = v2.Price*10
                mdl = v2.Model
                class = v2.ClassName
                break 
            end
            print(k2, gun)
        end

        if price then break end

    end

    if not price then return end

    if ply:GetMoney() < price then return end
    if IsValid(self.Gun) then self.Gun:Remove() end
    ply:TakeMoney(price)
    
    self.Blueprint = {mdl, class}
    self.QueuedGun = true
    self.TimePerGun = 0

    if price < 1000000 then self.TimePerGun = 10 return end--mil
    if price < 5000000 then self.TimePerGun = 15 return end --5 mil
    if price < 10000000 then self.TimePerGun = 20 return end --10 mil
    if price < 50000000 then self.TimePerGun = 30 return end --50 mil
    if price < 100000000 then self.TimePerGun = 45 return end --100 mil

    self:CreateGun(self.Blueprint)

end



function ENT:Think()

    if not self:GetBusy() then 
        if not IsValid(self.Gun) and self.QueuedGun then self:CreateGun(self.Blueprint) end
    end

    local t = self:GetTime()
    if not self:GetBusy() then return end

    if CurTime() - self:GetTime()  < self.TimePerGun then return end

    local wep = ents.Create("bw_weapon")
    local tbl = self.Blueprint

    wep.Model = tbl[1]
    wep.WeaponClass = tbl[2]

    wep:SetModel(tbl[1])
    local pos = self:GetPos() + self:GetUp()*32 + self:GetForward()*5
    wep:SetPos(pos)
    wep:SetAngles(Angle(0,0,0))
    wep:Spawn()

    constraint.NoCollide(wep, self, 0, 0)

    self:SetBusy(false)
    self:SetTime(0)
    self:SetFinishTime(0)
    self.Gun = wep
 end

function ENT:CreateGun(tbl)

    self.Cooking = true
    self:SetGun(tbl[2]) 
        
    self:SetBusy(true)
    self:SetTime(CurTime())
    self:SetFinishTime(CurTime() + self.TimePerGun)
end
