include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
local m_min = math.min
local meta = FindMetaTable("Entity")

util.AddNetworkString("ConnectGenerator")



function ENT:Init()
	local me = BWEnts[self]

	me.PowerGenerated = self.PowerGenerated
	me.PowerCapacity = self.PowerCapacity
	me.Power = 0
	me.CableLength = (self.ConnectDistance or 600) ^ 2


	Generators[#Generators + 1] = self
end

function ENT:ConnectTo(ent)
	if ent:Distance(self) >= self.ConnectDistance then return end 

	local me = BWEnts[self]

	if me.ConnectedTo ~= ent and me.ConnectedTo then 
		if me.ConnectedTo.OnDisconnect then 
			me.ConnectedTo:OnDisconnect(self)
		end
	end
	
	if ent.OnConnected then 
		local go = ent:OnConnected(self)
		if go==false then return end 
	end

	
	me.ConnectedTo = ent 

	self:SetConnectedTo(ent)

	ent:CallOnRemove("NotifyGenerator" .. self:GetCreationID(), function(ent)

		if not IsValid(self) then return end 
		if me.ConnectedTo ~= ent then return end 
		
		me.ConnectedTo = nil
	end)

	if ent.OnConnected then 
		return
	else
		function ent.PhysicsUpdate(ent, pos, ang)
			if not IsValid(self) then ent.PhysicsUpdate = function() end return end
			me.CheckDist = CurTime()
		end
	end
end

function ENT:PhysicsUpdate()

	local me = BWEnts[self]
	me.CheckDist = CurTime()

end

function ENT:StartBitching()
	self:Disconnect()
end

function ENT:Disconnect()
	local me = BWEnts[self]
	if me.ConnectedTo.OnDisconnect then 
		me.ConnectedTo:OnDisconnect(self)
	end
	me.ConnectedTo = nil 

	self:SetConnectedTo(Entity(0))

end
function ENT:TransmitPower(amt)
	local me = BWEnts[self]
	if not me.ConnectedTo or not IsValid(me.ConnectedTo) then return end

	local t = BWEnts[me.ConnectedTo]
	local b4 = t.Power

	t.Power = math.min(t.Power + amt, t.PowerCapacity or t.MaxPower or 1000)

	local leftover = amt + b4 - t.Power 

	me.ConnectedTo:SetPower(t.Power)

	return leftover
end

function ENT:Think()
	local ct = CurTime()
	local me = BWEnts[self]

	if me.CheckDist and me.ConnectedTo then 
		local pos = self:GetPos()

		local cto = me.ConnectedTo
		local pos2 = cto:GetPos()

		if pos:DistToSqr(pos2) > me.CableLength then 
			self:StartBitching()
		else 
			me.CheckDist = nil 
		end
	end

	me.Power = math.min(me.Power + me.PowerGenerated, me.PowerCapacity)

	self:SetPower(me.Power)
	self:NextThink(CurTime() + 0.5)

	me.Power = self:TransmitPower(me.Power) or me.Power

	return true
end

net.Receive("ConnectGenerator", function(_, ply)
	local disconnect = net.ReadBool()
	local gen = net.ReadEntity()
	if not disconnect then
		local ent = net.ReadEntity()

		if not IsValid(gen) or not IsValid(ent) then return end 
		if (not gen.IsGenerator and not gen.Cableable) or not (ent.IsElectronic or ent.Connectable) then print('no') return end

		gen:ConnectTo(ent)
	else 
		if not IsValid(gen) or not gen.IsGenerator then return end
		gen:Disconnect()
	end

end)