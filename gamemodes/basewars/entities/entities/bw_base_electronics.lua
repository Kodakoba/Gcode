AddCSLuaFile()

ENT.Base = "bw_base"
ENT.Type = "anim"
ENT.PrintName = "Base Electricals"

ENT.Model = "models/props_c17/metalPot002a.mdl"
ENT.Skin = 0

ENT.IsElectronic = true
ENT.PowerRequired = 20
ENT.PowerCapacity = 1000

function ENT:DrainPower(val)

	local me = BWEnts[self]

	if not self:IsPowered(val) then BWEnts[self].Power = 0 self:SetPower(0) return false end

	
	local req = (val or self.PowerRequired)

	if CurTime() - (me.LastDrain or 0) < 1 and not val then return me.Power > req end
		
	
	local enuff = me.Power - req > 0

	me.Power = math.max(me.Power - req, 0)
	self:SetPower(me.Power)
	me.LastDrain = CurTime()

	return enuff

end

function ENT:IsPowered(val)
	local me = BWEnts[self]
	if CLIENT then 
		return self:GetPower() >= (val or self.PowerRequired)
	else
		return me.Power >= (val or self.PowerRequired)
	end

end

if SERVER then

	function ENT:Think()
		local me = self:GetTable()
		local bwe = BWEnts[self]

		bwe.PowerDrain = self.PowerRequired 

		local pow = self:DrainPower()

		local dmgd = (self:GetMaxHealth() / self:Health()) < 0.2

		if pow and dmgd and math.random(0, 11) == 0 then

			self:Spark()

		end

		if BaseWars.Watery then 

			if self:WaterLevel() > 0 and not me.GetWaterProof(self) then

				if not me.FirstTime and not dmgd then

					me.SetHealth(self, 25)
					me.Spark(self)

					me.FirstTime = true

				end

				if me.rtb == 2 then

					me.rtb = 0
					me.TakeDamage(self, 1)

				else

					me.rtb = me.rtb + 1

				end

			else

				me.FirstTime = false

			end

		end

		local State = Res ~= false

		if bwe.CheckDist and bwe.ConnectedTo then 
			local pos = self:GetPos()

			local cto = me.ConnectedTo
			local pos2 = cto:GetPos()

			if pos:DistToSqr(pos2) > bwe.CableLength then 
				self:StartBitching()
			else 
				me.CheckDist = nil 
			end
		end

		me.ThinkFunc(self)

	end

	function ENT:CheckUsable()



	end

	function ENT:Use(activator, caller, usetype, value)

		if self:CheckUsable() == false then return end

		if not self:IsPowered() or self:BadlyDamaged() then

			self:EmitSound("buttons/button10.wav")

		return end

		self:UseFunc(activator, caller, usetype, value)

	end

end
