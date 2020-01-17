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

	if me.Power < me.PowerDrain then me.LastDrain = CurTime() return false end

	local req = (val or me.PowerDrain)

	if CurTime() - (me.LastDrain or 0) < 1 and not val then return me.Power > req end
		
	
	local enuff = me.Power - req > 0
	if not enuff then return false end --if not enough then dont even drain power

	me.Power = math.max(me.Power - req, 0)
	self:SetPower(me.Power)
	me.LastDrain = CurTime()
	
	return true

end

function ENT:IsPowered(val)
	local me = BWEnts[self]
	if CLIENT then 
		return self:GetPower() >= (val or self.PowerRequired)
	else
		return me.Power >= (val or me.PowerDrain)
	end

end

if SERVER then

	--makes generators ignore this

	function ENT:SetUnpowerable(b)	
		BWEnts[self].DontPower = (b==nil and true) or b
	end


	--returns how much power was actually added:

	function ENT:AddPower(val, ignore)
		local me = BWEnts[self]
		if me.DontPower and not ignore then return 0 end 

		local add = math.min(val, me.PowerCapacity - me.Power)

		me.Power = me.Power + add

		return add
	end

	function ENT:Think()
		local me = self:GetTable()
		local bwe = BWEnts[self]

		bwe.PowerDrain = self.PowerRequired 

		local pow = self:DrainPower()
		if not pow then return end 

		local hpfrac = self:Health() / self:GetMaxHealth()

		if hpfrac < 0.2 and CurTime() > (bwe.NextSpark or 0) and math.random(0, 10) == 0 then

			self:Spark()

			bwe.NextSpark = CurTime() + math.random(5, 15) / 10
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

		if bwe.CheckDist and IsValid(bwe.ConnectedTo) then 
			local pos = self:GetPos()

			local cto = bwe.ConnectedTo
			if not IsValid(cto) then print("ConnectedTo invalid, say what") bwe.ConnectedTo = nil bwe.CheckDist = nil return end

			local pos2 = cto:GetPos()

			if pos:DistToSqr(pos2) > BWEnts[cto].CableLength then 
				self:StartBitching()
			else 
				bwe.CheckDist = nil 
			end
		end

		me.ThinkFunc(self)

	end

	function ENT:StartBitching()
		local me = BWEnts[self]
		if IsValid(me.ConnectedTo) and me.ConnectedTo.Disconnect then 
			me.ConnectedTo:Disconnect(self)
		end
		me.ConnectedTo = nil
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

	function ENT:OnPhysicsUpdate()

	end

	function ENT:PhysicsUpdate(...)
		local me = BWEnts[self]
		me.CheckDist = true

		self:OnPhysicsUpdate(...)
	end

end
