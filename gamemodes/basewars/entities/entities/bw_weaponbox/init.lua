AddCSLuaFile("cl_init.lua")
ENT.Base = "bw_base_electronics"

ENT.Model = "models/lt_c/sci_fi/box_crate.mdl"
ENT.Skin = 0

ENT.PrintName = "Weapon Storage"

ENT.IsValidRaidable = false

ENT.PresetMaxHealth = 250
ENT.PowerRequired = 5
ENT.CurrentGun = ENT.CurrentGun or nil
ENT.Guns = ENT.Guns or 0

util.AddNetworkString("wepbox_changed")

function ENT:DerivedDataTables()

    self:NetworkVar("String", 2, "CurrentGun")
    self:NetworkVar("Int", 3, "Guns")

end

function ENT:Use(act,call,usetype,val)
    if not act:IsPlayer() or act~=call then return end

    if not self.CurrentGun then return end
    if self.Guns < 1 then return end
    local hasgun = false
    local weps = act:GetWeapons()
    for k,v in pairs(weps) do 
        if v:GetClass() == self.CurrentGun then hasgun = true break end
    end
    if hasgun then act:ChatPrint("You already have this weapon!") return end

    --if act.Souls < self.Cost then act:ChatPrint("Not enough souls!(You have "..tostring((act.Souls or 0)) .. ")") return end
    act:Give(self.CurrentGun)
    self.Guns = self.Guns - 1

    net.Start("wepbox_changed")
    net.WriteEntity(self)
    net.SendPVS(self:GetPos())
    
    if self.Guns < 1 then self.CurrentGun = nil end
    --act.Souls = act.Souls - self.Cost
    self:SetGuns(self.Guns or 0)
    self:SetCurrentGun(self.CurrentGun or "None! ")
    --self:SetCost(self.Cost)
    
end

function ENT:ThinkFunc()
if self.Guns == 0 then self.CurrentGun = nil end
--self:SetCost(self.Cost)
end

function ENT:PhysicsCollide(data, phys)

    --self.BaseClass:PhysicsCollide(data, phys)

    local ent = data.HitEntity
    if not BaseWars.Ents:Valid(ent) then return end
    
    if not ent:GetClass() == "bw_weapon" then return end
    local wep = ent.WeaponClass
    if not wep then return end
    if ent.FuckingDustIt then return end
    if isstring(self.CurrentGun) and self.CurrentGun ~= wep then return end
     self.CurrentGun = wep
     self.Guns = self.Guns + 1

     self:SetGuns(self.Guns or 0)
     self:SetCurrentGun(self.CurrentGun or "None! ")
     ent.FuckingDustIt = true
     timer.Simple(0, function() SafeRemoveEntity(ent) end)  --I hate garry
     return false
end