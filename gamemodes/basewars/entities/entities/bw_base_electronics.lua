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
ENT.EmitUnusableBeeps = true

ENT.ConnectDistance = 550

ENT.RebootTime = 3

function ENT:Reboot()
	self.RebootStart = CurTime()
	self:SetRebooting(true)
end

function ENT:DrainPower(val)
	local pw = self.Power
	if pw and CurTime() - self.Power < 1.1 then return true end

	return false
end

function ENT:IsPowered(val)
	return self:GetPowered()
end

function ENT:Disconnect()
	self:GetGrid():RemoveConsumer(self)
	PowerGrid:new((self:CPPIGetOwner())):AddConsumer(self)
end

if SERVER then

	function ENT:CheckCableDistance(bwe)
		bwe = bwe or BWEnts[self]
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
	end

	function ENT:Think()
		local me = self:GetTable()
		local bwe = BWEnts[self]

		self:CheckCableDistance(bwe)

		local pow = self:DrainPower()
		if not pow then return end

		local hpfrac = self:Health() / self:GetMaxHealth()

		if hpfrac < 0.2 and CurTime() > (bwe.NextSpark or 0) and math.random(0, 10) == 0 then

			self:Spark()

			bwe.NextSpark = CurTime() + math.random(5, 15) / 10
		end

		me.ThinkFunc(self)

	end

	function ENT:StartBitching()
		self:SetLine(NULL)

		local grid = PowerGrid:new((self:CPPIGetOwner()))
		grid:AddConsumer(self)
	end

	function ENT:CheckUsable()



	end

	function ENT:Use(activator, caller, usetype, value)

		if self:CheckUsable() == false then return end

		if (not self:IsPowered() or self:BadlyDamaged()) then

			if (not self.LastUnusuableBeep or CurTime() - self.LastUnusuableBeep > 1) and self.EmitUnusableBeeps then
				self.LastUnusuableBeep = CurTime()
				self:EmitSound("buttons/button10.wav")
			end

			return
		end

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
