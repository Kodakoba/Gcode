AddCSLuaFile()

local base = "bw_base"
ENT.Base = base
ENT.Type = "anim"
ENT.PrintName = "Base Electricals"


ENT.Model = "models/props_c17/metalPot002a.mdl"
ENT.Skin = 0

ENT.IsElectronic = true
ENT.PowerType = "Consumer"

ENT.PowerRequired = 20
ENT.EmitUnusableBeeps = true

ENT.ConnectDistance = 550
ENT.ConnectPoint = Vector()

ENT.RebootTime = 3

function ENT:Reboot()
	self.RebootStart = CurTime()
	self:SetRebooting(true)
end

function ENT:IsPowered()
	return self:GetPowered()
end

ENT.GetPower = ENT.IsPowered

function ENT:SetupDataTables()
	baseclass.Get(base).SetupDataTables(self)

	self:NetworkVar("Bool", 0, "Powered")
	self:NetworkVar("Float", 0, "RebootTime")

	self:NetworkVar("Int", 0, "GridID")

	self:NetworkVar("Entity", 0, "Line")

	if CLIENT then
		self:On("DTChanged", "GridID", function(self, name, old, new)
			if name ~= "GridID" then return end
			self:OnChangeGridID(new)
		end)
	end

end



function ENT:Disconnect()
	self:GetGrid():RemoveConsumer(self)
	PowerGrid:new( (self:CPPIGetOwner()) ):AddConsumer(self)
end

if SERVER then

	function ENT:Think()
		local me = self:GetTable()

		local hpfrac = self:Health() / self:GetMaxHealth()

		if hpfrac < 0.2 and
			CurTime() > (me.NextSpark or 0) and
			math.random(0, 10) == 0 then
			self:Spark()
			me.NextSpark = CurTime() + math.random(5, 15) / 10
		end

		me.ThinkFunc(self)
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

	function ENT:Initialize()
		baseclass.Get("bw_base").Initialize(self)
	end

else

	function ENT:Initialize()
		baseclass.Get("bw_base").Initialize(self)
	end

end
