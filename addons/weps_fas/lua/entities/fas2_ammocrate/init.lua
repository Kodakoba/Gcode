AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Items/ammocrate_smg1.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self.CanHurt = true
	local phys = self:GetPhysicsObject()

	if phys and phys:IsValid() then
		phys:Wake()
	end
	
	self.AmmoCharge = 200
	self.AmmoGiveDelay = CurTime()
	self.HP = 100
end

function ENT:Use()
	return false
end

local dmg, wep, am, amc, cl, ammo, ED, pos, mag

function ENT:OnTakeDamage(dmginfo)
	if self.Exploded then
		return
	end
	
	self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.02)
	
	dmg = dmginfo:GetDamage()
	self.HP = self.HP - dmg
	
	if self.HP <= 0 then
		self.Exploded = true
		
		pos = self:GetPos()
		util.BlastDamage(dmginfo:GetInflictor(), dmginfo:GetAttacker(), pos + Vector(0, 0, 32), 512, 100)
		
		ED = EffectData()
		ED:SetOrigin(pos)
		ED:SetScale(1)
		
		util.Effect("Explosion", ED)
		SafeRemoveEntity(self)
	end
end

function ENT:Think()
	if SERVER then
		if CurTime() > self.AmmoGiveDelay then
			for k, v in pairs(ents.FindInSphere(self:GetPos(), 96)) do
				if v:IsPlayer() and v:Alive() then
					if self.AmmoCharge > 0 then
						wep = v:GetActiveWeapon()
						
						if IsValid(wep) then
							am = wep:GetPrimaryAmmoType()
							
							if am != -1 then
								amc = v:GetAmmoCount(am)
								
								if wep.Primary and wep.Primary.ClipSize then
									mag = wep:Clip1()
									
									if math.Round(wep.Primary.ClipSize * 12 * (wep.MaxAmmoMod and wep.MaxAmmoMod or 1)) + math.Clamp(wep.Primary.ClipSize - mag, 0, wep.Primary.ClipSize) > amc then
										self.AmmoCharge = self.AmmoCharge - 1
										v:EmitSound("items/ammo_pickup.wav", 60, 100)
										
										ammo = math.Clamp(amc + (wep.Primary.ClipSize > 50 and wep.Primary.ClipSize / 2 or wep.Primary.ClipSize) * (wep.GiveAmmoMod and wep.GiveAmmoMod or 1), 0, math.Round(wep.Primary.ClipSize * 12 * (wep.MaxAmmoMod and wep.MaxAmmoMod or 1)) + math.Clamp(wep.Primary.ClipSize - mag, 0, wep.Primary.ClipSize))
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
							
							if wep.Secondary and wep.Secondary.Ammo != "none" and v:GetAmmoCount(wep.Secondary.Ammo) < 12 then
								v:GiveAmmo(1, wep.Secondary.Ammo)
								self.AmmoCharge = self.AmmoCharge - 1
							end
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