include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")

util.AddNetworkString("Pole")

local m_min = math.min

PowerPoles = PowerPoles or {}
poles = PowerPoles


function ENT:Init(me)
	me.ConnectDistanceSqr = self.ConnectDistance ^ 2
	timer.Simple(0, function() self:PingGrids() end)
end

function ENT:PingGrids()
	local mypos = self:GetPos()
	local cable = self.ConnectDistance ^ 2
	local ow = self:CPPIGetOwner()

	local cur_grid

	local available_grids = {}

	--find all grids we can even modify (eg owned by factionmates)
	for _, grid in ipairs(PowerGrids) do
		if not grid.Owner:IsValid() or not grid.Owner:IsTeammate(ow) then continue end
		available_grids[#available_grids + 1] = grid
	end

	local chosen_pole

	for _, grid in ipairs(available_grids) do
		--try to find an existing grid we can use first
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
			cur_grid = grid --we found an existing grid we can connect to
			chosen_pole = minpole
		end
	end

	if not cur_grid then cur_grid = PowerGrid:new(ow) end --we're gonna have to create a new grid

	cur_grid:AddLine(self, chosen_pole) --then connect ourselves to that grid


	--here we're done finding a grid and we have either a brand new one or an existing one,
	--now let's connect shtuff

	for _, grid in ipairs(available_grids) do
		--connect every powerline-less generator and then consumer

		for _, gen in ipairs(grid.Generators) do
			if gen.Grid and IsValid(gen:GetLine()) then continue end

			local pos = gen:GetPos()
			local dist = pos:DistToSqr(mypos)
			if dist < cable then
				cur_grid:AddGenerator(gen, self)
			end
		end

		for _, ent in ipairs(grid.Consumers) do
			if ent.Grid and IsValid(ent:GetLine()) then continue end

			local pos = ent:GetPos()
			local dist = pos:DistToSqr(mypos)
			if dist < cable then
				if ent.Grid then ent.Grid:Remove() end
				cur_grid:AddConsumer(ent, self)
			end
		end

	end

	self.Grid = cur_grid
end

function ENT:PhysicsUpdate(pos, ang)

end

function ENT:OnConnected(gen)

end

function ENT:OnDisconnect(gen)

end

function ENT:NetworkEnts()

end

function ENT:Think()

end

function ENT:ConnectTo(ent)

end

function ENT:Disconnect(ent)

end

function ENT:Think()
	local me = BWEnts[self]
	if me.CheckDist and self.Grid then
		local pos = self:GetPos()
		local range = me.ConnectDistanceSqr
		for k,v in ipairs(self.Grid.AllEntities) do
			if v.PowerType == "Line" then
				if v==self or self:GetLine() ~= v then continue end
				if pos:DistToSqr(v:GetPos()) > range then
					self.Grid:RemoveLine(v, true)
					self:SetLine(NULL)
				end
			else
				BWEnts[v].CheckDist = true
				v:CheckCableDistance()
			end
		end

		me.CheckDist = false
	end
end

function ENT:PhysicsUpdate(...)
	local me = BWEnts[self]
	me.CheckDist = true

end

hook.Add("BaseWars_PlayerBuyEntity", "PoleAddPowerGrid", function(ply, ent)

end)