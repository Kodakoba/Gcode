include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
local m_min = math.min
local meta = FindMetaTable("Entity")

util.AddNetworkString("ConnectGenerator")

function ENT:Init()

	Generators[#Generators + 1] = self
	self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
	timer.Simple(0, function() self:PingGrids() end)
	self:SetPowered(true)
end

function ENT:PingGrids()

	local mypos = self:GetPos()
	local cable = self.ConnectDistance ^ 2
	local ow = self:CPPIGetOwner()
	if not ow or not IsValid(ow) then return end --???

	for _, grid in pairs(PowerGrids) do --picks the closest powerline entity and connects to it if it exists and exits the function
		if not grid.Owner:IsValid() or not grid.Owner:IsTeammate(ow) then continue end

		local mindist, minpole = math.huge

		for _, line in ipairs(grid.PowerLines) do
			local pos = line:GetPos()
			local dist = pos:DistToSqr(mypos)

			if dist < cable and dist < mindist then
				mindist = dist
				minpole = line
			end
		end

		if minpole then
			grid:AddGenerator(self, minpole)
			return
		end

	end

	--this will execute if a grid wasn't found
	PowerGrid:new(ow):AddGenerator(self) --i'm here on my ooooooooown...
end

function ENT:ForceUpdate()
	self.TransmitTime = CurTime()
end

function ENT:UpdateTransmitState()
	if not self.TransmitTime or CurTime() - self.TransmitTime < 0.5 then
		self.TransmitTime = self.TransmitTime or CurTime()
		return TRANSMIT_ALWAYS
	end
	return TRANSMIT_PVS
end

function ENT:Think()
	if not self.TransmitTime or CurTime() - self.TransmitTime < 0.5 then 
		self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
	else
		self:RemoveEFlags( EFL_FORCE_CHECK_TRANSMIT )
	end

	self:CheckCableDistance()
	self:Emit("Think")
end

function ENT:CheckCableDistance(bwe)
	bwe = bwe or BWEnts[self]


	if bwe.CheckDist then
		local line = self:GetLine()
		if not line:IsValid() then line = self:GetHotwired() end
		if not line:IsValid() then return end

		local pos = self:GetPos()
		local pos2 = line:GetPos()

		if pos:DistToSqr(pos2) > math.min(bwe.ConnectDistanceSqr, BWEnts[line].ConnectDistanceSqr) then
			self:Disconnect()
		else
			bwe.CheckDist = nil
		end
	end

	bwe.CheckDist = false
end

function ENT:PhysicsUpdate()
	BWEnts[self].CheckDist = true
end

function ENT:OnConnectToLine(line)
	self:SetHotwired(NULL)
	self.Hotwired = nil

	self:SetLine(line)
end

function ENT:ConnectTo(ent)
	if ent.PowerType ~= "Consumer" and ent.PowerType ~= "Line" then return end

	local grid = self:GetGrid()
	local other_grid = ent:GetGrid()

	if ent.PowerType == "Consumer" then

		local count = table.Count(grid.AllEntities)

		if count > 2 then print("more than 2 ents", count) return end
		if count == 2 and #grid.Consumers == 1 then
			-- this was a generator + consumer pair; disconnect old consumer & add a new one in its' place
			grid:RemoveConsumer(grid.Consumers[1])
		elseif #grid.Consumers > 1 then
			print("more than 2 consumers or some shit?", #grid.Consumers)
			return
		end


		for k,v in ipairs(other_grid.Generators) do
			if v:GetHotwired() == ent then
				v:SetHotwired(Entity(0))
			end
		end

		other_grid:RemoveConsumer(ent)
		other_grid.Hotwired = nil

		grid:AddConsumer(ent)
		grid.Hotwired = {self, ent}

		self:SetLine(NULL)
		self:SetHotwired(ent)

		ent:SetLine(NULL)
		
		grid:On("RemovedGenerator", "TrackHotwired", function(grid, rem)
			if rem == self and grid.Hotwired and grid.Hotwired[1] == self then
				grid.Hotwired = nil
			end
		end)

		grid:On("RemovedConsumer", "TrackHotwired", function(grid, rem)
			if rem == ent and grid.Hotwired and grid.Hotwired[2] == rem then
				grid.Hotwired = nil
			end
		end)
	else
		grid:RemoveGenerator(self)
		other_grid:AddGenerator(self)
		self:SetLine(ent)

		other_grid.Hotwired = nil
		grid.Hotwired = nil
	end

end

function ENT:Disconnect(filter_out)
	local grid = self:GetGrid()
	if not grid or not grid.AllEntities[self:EntIndex()] then print("no grid or not in grid", grid) return end

	local hw = self:GetHotwired()

	grid:RemoveGenerator(self)
	grid.Hotwired = nil
	self:SetHotwired(NULL)
	self:SetLine(NULL)

	PowerGrid:new(self:CPPIGetOwner()):AddGenerator(self)

	net.Start("ConnectGenerator")
		net.WriteEntity(self)
		if hw:IsValid() then net.WriteEntity(hw) else net.WriteEntity(self) end

		local filt = RecipientFilter()
		filt:AddPVS(self:LocalToWorld(self:OBBCenter()))
		if filter_out then filt:RemovePlayer(filter_out) end

	net.Send( filt )
end

net.Receive("ConnectGenerator", function(_, ply)
	local disconnect = net.ReadBool()
	local gen = net.ReadEntity()
	if not gen:IsValid() or not gen.IsGenerator then return end

	if not disconnect then
		local ent = net.ReadEntity()

		if not ent:IsValid() then return end
		if not gen.Cableable or not (ent.IsElectronic or ent.Connectable) then return end

		gen:ConnectTo(ent)
	else
		gen:Disconnect(ply)
	end

end)