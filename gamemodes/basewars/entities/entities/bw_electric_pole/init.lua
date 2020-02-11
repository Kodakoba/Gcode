include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")

util.AddNetworkString("Pole")

local m_min = math.min

PowerPoles = PowerPoles or {}
poles = PowerPoles


function ENT:Init(me)
	me.GeneratorEnts = {}
	me.Generators = ValidSeqIterable()

	me.Electronics = ValidSeqIterable()

	me.LastTransfer = CurTime()
	me.CableLength = self.CableLength ^ 2
	me.MultipleGenerators = true 
	
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

				local them = BWEnts[v]
				if not them then print("???", v) return end 
				if IsValid(them.ConnectedTo) then return end 

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
	local id = #me.Generators

	if id >= self.MaxGenerators - 1 then print("max generators reached", id, self.MaxGenerators) return end 

	local id = me.Generators:add(gen)
	me.GeneratorEnts[gen] = id

	gen:PreventGenerating(true)

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

	gen:PreventGenerating(false)

	self:NetworkEnts()
end

function ENT:NetworkEnts()
	local me = BWEnts[self]
	
	local setDT = self.SetDTEntity 

	--default: loop 0 to MaxGenerators (max. 8)

	local null = Entity(0)

	me.Generators:clean()
	me.Electronics:clean()

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

	for k,v in me.Generators:pairs() do 
		local ent = BWEnts[v]
		pw_in = pw_in + ent.PowerGenerated + ent.Power

		pw_stored[k] = ent.Power
		sum_stored = sum_stored + ent.Power
	end

	local was_stored = sum_stored 

	me.Electronics:clean()
	me.Generators:clean()

	local els = 0

	for k,v in ipairs(me.Electronics) do 
		if not BWEnts[v].DontPower then els = els + 1 end
	end

	for k,v in ipairs(me.Electronics) do 
		local ent = BWEnts[v]
		if ent.DontPower then continue end 


		local rate = math.max(ent.PowerDrain + 10, 150, pw_in / els)

		rate = math.min(rate, pw_in / els) 						--if rate has to be more than what would be evenly distributed, so be it
		
		rate = math.min(rate, ent.PowerCapacity - ent.Power) 	--rate won't be more than required to max power

		local from_gen = math.min(pw_in, rate)

		pw_in = pw_in - from_gen
		rate = from_gen 

		els = els - 1 

		ent.Power = ent.Power + rate

		if pw_in <= 0 and sum_stored <= 0 then break end
	end

	if was_stored > pw_in then 	--stored power was drained

		local spent = was_stored - pw_in 	--how much power was spent?

		for k,v in me.Generators:pairs() do 
			local ent = BWEnts[v]

			local was = ent.Power

			ent.Power = math.max(was - spent, 0)

			spent = spent - was
			if spent <= 0 then break end
		end

	elseif pw_in > 0 then 				--stored power wasn't drained; there are leftovers

		local gens = #me.Generators

		for k,v in me.Generators:pairs() do 
			local ent = BWEnts[v]

			local was = ent.Power

			local add = pw_in / gens 	--the added power is distributed evenly between gens

			ent.Power = math.min(was + add, ent.PowerCapacity)

			pw_in = pw_in - add

			gens = gens - 1

			v:SetPower(ent.Power)		--because generators connected to the pole don't generate power, and thus, don't network their own vars

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