AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Items/BoxSRounds.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.CanHurt = true
	local phys = self:GetPhysicsObject()

	if phys and phys:IsValid() then
		phys:Wake()
	end
	
	self.AmmoCharge = 12
	self.AmmoGiveDelay = CurTime()
	
	timer.Simple(300, function()
		SafeRemoveEntity(self)
	end)
end

function ENT:Use()
return false
end

function ENT:OnTakeDamage(dmginfo)
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
end

local wep, am, amc, cl, ammo, mag

function ENT:Think()
	if SERVER then
		if CurTime() > self.AmmoGiveDelay then
			for k, v in pairs(ents.FindInSphere(self:GetPos(), 96)) do
				if v:IsPlayer() and v:Alive() then
					if self.AmmoCharge > 0 then
						wep = v:GetActiveWeapon()
						am = wep:GetPrimaryAmmoType()
						
						if am != -1 then
							amc = v:GetAmmoCount(am)
							
							if wep.Primary and wep.Primary.ClipSize then
								mag = wep:Clip1()
								
								if wep.Primary.ClipSize * 6 * (wep.MaxAmmoMod and wep.MaxAmmoMod or 1) + math.Clamp(wep.Primary.ClipSize - mag, 0, wep.Primary.ClipSize) > amc then
									self.AmmoCharge = self.AmmoCharge - 1
									v:EmitSound("items/ammo_pickup.wav", 60, 100)
									
									ammo = math.Clamp(amc + (wep.Primary.ClipSize > 50 and wep.Primary.ClipSize / 2 or wep.Primary.ClipSize) * (wep.GiveAmmoMod and wep.GiveAmmoMod or 1), 0, wep.Primary.ClipSize * 6 * (wep.MaxAmmoMod and wep.MaxAmmoMod or 1) + math.Clamp(wep.Primary.ClipSize - mag, 0, wep.Primary.ClipSize))
									v:SetAmmo(ammo, am)
								end
							end
						end
						
						cl = wep:GetClass()
						
						for k2, v2 in ipairs(v:GetWeapons()) do
							am = v2:GetPrimaryAmmoType()
							amc = v:GetAmmoCount(am)
							
							if amc == 0 and v2:Clip1() == 0 and cl != v2:GetClass() then
								if v2.Primary and v2.Primary.ClipSize then
									v:SetAmmo(v2.Primary.ClipSize * 0.5, am)
								else
									v:SetAmmo(15, am)
								end
							end
						end
						
						if wep.Secondary and wep.Secondary.Ammo != "none" and v:GetAmmoCount(wep.Secondary.Ammo) < 6 then
							v:GiveAmmo(1, wep.Secondary.Ammo)
							self.AmmoCharge = self.AmmoCharge - 1
						end
					else
						SafeRemoveEntity(self)
					end
				end
				
			end
			self.AmmoGiveDelay = CurTime() + 0.4
		end
	end
end

function ENT:OnRemove()
return false
end 