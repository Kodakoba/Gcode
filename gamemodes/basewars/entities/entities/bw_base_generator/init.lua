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
end

function ENT:PingGrids()

	local mypos = self:GetPos()
	local cable = self.ConnectDistance ^ 2
	local ow = self:CPPIGetOwner()
	if not ow or not IsValid(ow) then return end --???

	for _, grid in ipairs(PowerGrids) do --picks the closest powerline entity and connects to it if it exists and exits the function
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
	self.Grid = PowerGrid:new(ow)
	self.Grid:AddGenerator(self) --i'm here on my ooooooooown...
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
end
function ENT:CheckCableDistance(bwe)
	bwe = bwe or BWEnts[self]
	local line = self:GetLine()

	if bwe.CheckDist and IsValid(line) then
		local pos = self:GetPos()
		local pos2 = line:GetPos()

		if pos:DistToSqr(pos2) > math.min(bwe.ConnectDistanceSqr, BWEnts[line].ConnectDistanceSqr) then
			self:SetLine(NULL)
			local grid = PowerGrid:new(self:CPPIGetOwner())
			grid:AddGenerator(self)
		else
			bwe.CheckDist = nil
		end
	end
end

function ENT:PhysicsUpdate()
	BWEnts[self].CheckDist = true
end

net.Receive("ConnectGenerator", function(_, ply)
	local disconnect = net.ReadBool()
	local gen = net.ReadEntity()
	if not disconnect then
		local ent = net.ReadEntity()

		if not IsValid(gen) or not IsValid(ent) then return end
		if (not gen.IsGenerator and not gen.Cableable) or not (ent.IsElectronic or ent.Connectable) then return end

		gen:ConnectTo(ent)
	else
		if not IsValid(gen) or not gen.IsGenerator then return end
		gen:Disconnect()
	end

end)