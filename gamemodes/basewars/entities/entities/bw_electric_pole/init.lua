include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")
local m_min = math.min

PowerPoles = PowerPoles or {}
poles = PowerPoles


function ENT:Init(me)
	me.GeneratorEnts = {}
	me.Generators = {}

	me.Electronics = {}

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
				local range = math.min(v.ConnectDistance, self.CableRange)
				if pos:Distance(v:GetPos()) > range then print("too far", range) continue end 
				v:ConnectTo(self)

				continue
			end

			if v.IsElectronic then 
				self:ConnectTo(v)
			end
		end
		--timer.Simple(1, function() if not IsValid(self) then return end self:NetworkEnts() end)
	end)
end

function ENT:PhysicsUpdate(pos, ang)

	local me = BWEnts[self]

	for k,v in pairs(me.Generators) do 
		if not BWEnts[k] then continue end
		BWEnts[k].CheckDist = CurTime()
	end

end

function ENT:OnConnected(gen)
	local me = BWEnts[self]

	local gens = me.Generators
	local id = 0

	for k,v in ipairs(gens) do 
		id = k
	end

	if id >= self.MaxGenerators - 1 then print("max generators reached", id, self.MaxGenerators) return end 

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

	me.Generators[me.GeneratorsEnts[gen]] = nil
	me.GeneratorEnts[gen] = nil 

	self:NetworkEnts()
end

function ENT:NetworkEnts()
	local me = BWEnts[self]
	
	local setDT = self.SetDTEntity 

	--default: loop 0 to 7

	for i=0, self.MaxGenerators - 1 do 
		print("checking generator #" .. i)

		if me.Generators[i] then 
			setDT(self, i, me.Generators[i])
		end
	end

	--default: loop 8 to (8 + 16 - 1) = loop 8 to 23

	for i=self.MaxGenerators, self.MaxGenerators + self.MaxElectronics - 1 do 

		print("checking electronic #" .. i - self.MaxGenerators, "(but networking as", i .. ")" )

		if me.Electronics[i - self.MaxGenerators] then 
			setDT(self, i, me.Electronics[i])
		end
	end

end

function ENT:Think()


end

function ENT:ConnectTo(ent)
	print("connecting to", ent)
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
		local pdist = pos:Distance(v:GetPos())
		local range = math.min(v.CableRange, (ent.ConnectDistance or math.huge))

		if pdist > range then continue end 

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