include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")
local m_min = math.min

PowerPoles = PowerPoles or {}
poles = PowerPoles


function ENT:Init(me)
	me.GeneratorEnts = {}
	me.Generators = {}

	me.Electronics = ValidSeqIterable()

	me.LastTransfer = CurTime()
	me.CableLength = self.CableLength ^ 2

	poles[#poles + 1] = self

	timer.Simple(0.2, function()
		if not IsValid(self) then return end

		local owner = self.CPPIOwner
		local pos = self:GetPos()

		local cons = BWOwners[owner]

		if not cons then return end 

		cons:clean()

		for k,v in pairs(cons) do 

			if v.IsGenerator then 
				local range = math.min(v.ConnectDistance^2, me.CableLength)
				if pos:DistToSqr(v:GetPos()) > range then continue end 
				v:ConnectTo(self)

				continue
			end

			if v.IsElectronic then 
				local range = me.CableLength	--electronics don't have a cable range
				if pos:DistToSqr(v:GetPos()) > range then continue end 

				self:ConnectTo(v)
			end
		end
		--timer.Simple(1, function() if not IsValid(self) then return end self:NetworkEnts() end)
	end)
end

function ENT:PhysicsUpdate(pos, ang)

	local me = BWEnts[self]

	for k,v in pairs(me.GeneratorEnts) do 
		if not BWEnts[k] then continue end
		BWEnts[k].CheckDist = true
	end

	for k,v in me.Electronics:pairs() do 
		if not BWEnts[v] then continue end

		BWEnts[v].CheckDist = true
	end

end

function ENT:OnConnected(gen)
	local me = BWEnts[self]

	local gens = me.GeneratorEnts
	local id = 0

	for k,v in pairs(gens) do 
		id = math.max(id, v + 1)
	end

	if id >= self.MaxGenerators - 1 then print("max generators reached", id, self.MaxGenerators) return end 

	print("connected to id", id)

	me.Generators[id] = gen
	me.GeneratorEnts[gen] = id

	gen:CallOnRemove("DisconnectFrom" .. self:GetCreationID(), function(gen)
		if not IsValid(self) then return end 

		print("hey disconnected")
		self:NetworkEnts()

		me.GeneratorEnts[gen] = nil
		me.Generators[id] = nil 
	end)

	self:NetworkEnts()
end

function ENT:OnDisconnect(gen)
	local me = BWEnts[self]

	me.Generators[me.GeneratorEnts[gen]] = nil
	me.GeneratorEnts[gen] = nil 

	self:NetworkEnts()
end

function ENT:NetworkEnts()
	local me = BWEnts[self]
	
	local setDT = self.SetDTEntity 

	--default: loop 0 to MaxGenerators (max. 8)

	local null = Entity(0)

	for i=0, self.MaxGenerators - 1 do 

		if me.Generators[i] then 
			setDT(self, i, me.Generators[i])
		else 
			setDT(self, i, null)
		end

	end

	--loop 1 to MaxElecronics and, if ent exists, network as ID with i + MaxGenerators	(max. 16)

	for i=0, self.MaxElectronics - 1 do 

		if me.Electronics[i] then 
			setDT(self, i + self.MaxGenerators, me.Electronics[i])
		else 
			setDT(self, i + self.MaxGenerators, null)
		end

	end

end

function ENT:Think()

	local me = BWEnts[self]

	--[[
		Power transfer
	]]

	if CurTime() - me.LastTransfer < 0.5 then return end 

	me.LastTransfer = CurTime()

	local pw_in = 0

	local pw_stored = {}
	local sum_stored = 0

	local pw_out = 0

	for k,v in pairs(me.Generators) do 
		local ent = BWEnts[v]
		pw_in = pw_in + ent.PowerGenerated 

		pw_stored[k] = ent.Power
		sum_stored = sum_stored + ent.Power
	end

	local was_stored = sum_stored 

	for k,v in me.Electronics:pairs() do 
		local ent = BWEnts[v]

		local rate = math.max(250, ent.PowerDrain + 50, ent.PowerCapacity / 10)
		rate = math.min(rate, ent.PowerCapacity - ent.Power)

		local from_gen = math.min(pw_in, rate)
		local from_stored = math.min(rate - from_gen, sum_stored)

		pw_in = pw_in - from_gen
		rate = from_gen + from_stored

		sum_stored = sum_stored - from_stored 

		ent.Power = ent.Power + rate
	end

	if was_stored > sum_stored then
		local diff = was_stored - sum_stored

		for k,v in pairs(me.Generators) do 
			local ent = BWEnts[v]

			local was = ent.Power

			ent.Power = math.max(was - diff, 0)

			diff = diff - was
			if diff <= 0 then break end
		end

	end

end

function ENT:ConnectTo(ent)
	print("connecting to", ent)

	local me = BWEnts[self]
	local them = BWEnts[ent]

	if not them then print("did not find them bwents table") return false end

	them.ConnectedTo = self

	local key = #me.Electronics + 1

	if key <= self.MaxElectronics then 
		me.Electronics:add(ent)
	end

	self:NetworkEnts()
end

function ENT:Disconnect(ent)
	local key
	local me = BWEnts[self]

	for k,v in ipairs(me.Electronics) do 
		if v==ent then key = k break end 
	end

	table.remove(me.Electronics, key)

	if BWEnts[ent] and BWEnts[ent].ConnectedTo == self then 
		BWEnts[ent].ConnectedTo = nil 
	end

	self:NetworkEnts()
end

hook.Add("BaseWars_PlayerBuyEntity", "PoleAddPowerGrid", function(ply, ent)
	if ent.IsPole then return end 

	local owpoles = {}

	for k, pole in pairs(poles) do 
		if not IsValid(pole) then poles[k] = nil continue end 
		if pole:CPPIGetOwner() ~= ply then continue end 
		owpoles[#owpoles + 1] = pole
	end

	if #owpoles <= 0 then print("no owpoles") return end


	local pos = ent:GetPos()

	local chosen 	
	local dist = math.huge


	for k,v in pairs(owpoles) do 
		local et = BWEnts[v]
		if not et then continue end 

		local pdist = pos:DistToSqr(v:GetPos())
		local range = math.min(et.CableLength, (ent.ConnectDistance or math.huge)^2)

		if pdist > range then print("too much range", pdist, range) continue end 

		if dist > pdist then 
			chosen = v 
			dist = pdist 
		end

	end

	if not chosen then print("Uh oh:", chosen, dist) return end 


	local pole = chosen
	local etbl = BWEnts[ent]

	timer.Simple(0.5, function()
		if not IsValid(ent) then return end

		if ent.IsGenerator and not etbl.ConnectedTo then 
			ent:ConnectTo(pole)
			return
		end

		if ent.IsElectronic then 
			pole:ConnectTo(ent)
		end
	end)

end)