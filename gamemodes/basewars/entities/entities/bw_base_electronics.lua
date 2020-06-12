AddCSLuaFile()

ENT.Base = "bw_base"
ENT.Type = "anim"
ENT.PrintName = "Base Electricals"

ENT.Model = "models/props_c17/metalPot002a.mdl"
ENT.Skin = 0

ENT.IsElectronic = true
ENT.PowerType = "Consumer"

ENT.PowerRequired = 20
ENT.PowerCapacity = 1000

ENT.ConnectDistance = 550
function ENT:DrainPower(val)
	local pw = self.Power
	if pw and CurTime() - self.Power < 1.1 then return true end

	return false
end

function ENT:IsPowered(val)
	return self.Power
end

if SERVER then

	function ENT:Think()
		local me = self:GetTable()
		local bwe = BWEnts[self]

		if bwe.CheckDist and IsValid(self:GetLine()) then
			local pos = self:GetPos()

			local cto = self:GetLine()
			local pos2 = cto:GetPos()

			if pos:DistToSqr(pos2) > bwe.ConnectDistanceSqr then
				self:StartBitching()
			else
				bwe.CheckDist = nil
			end
		end

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


		me.ThinkFunc(self)

	end

	function ENT:StartBitching()
		print("bitchin and disconnecting")
		local me = BWEnts[self]
		self:SetLine(NULL)
		

		local grid = PowerGrid:new(self:CPPIGetOwner())
		grid:AddConsumer(self)
		print("new grid")
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
