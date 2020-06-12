include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")

util.AddNetworkString("Pole")

local m_min = math.min

PowerPoles = PowerPoles or {}
poles = PowerPoles


function ENT:Init(me)
	timer.Simple(0, function() self:PingGrids() end)
end

function ENT:PingGrids()
	local mypos = self:GetPos()
	local cable = self.ConnectDistance ^ 2
	local ow = self:CPPIGetOwner()

	local cur_grid

	local available_grids = {}

	--find all grids we can even modify (eg owned by factionmates)
	print(#available_grids, #PowerGrids)

	for _, grid in ipairs(PowerGrids) do
		if not grid.Owner:IsValid() or not grid.Owner:IsTeammate(ow) then continue end
		available_grids[#available_grids + 1] = grid
	end


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
		end
	end
	print("found grid?", cur_grid)
	if not cur_grid then cur_grid = PowerGrid:new(ow) end --we're gonna have to create a new grid

	cur_grid:AddLine(self) --then connect ourselves to that grid


	--here we're done finding a grid and we have either a brand new one or an existing one,
	--now let's connect shtuff

	for _, grid in ipairs(available_grids) do
		--connect every powerline-less generator and then consumer

		for _, gen in ipairs(grid.Generators) do
			if gen.Grid and IsValid(gen:GetLine()) then print("gen has lines") continue end

			local pos = gen:GetPos()
			local dist = pos:DistToSqr(mypos)
			if dist < cable then
				cur_grid:AddGenerator(gen, self)
			end
		end

		for _, ent in ipairs(grid.Consumers) do
			if ent.Grid and IsValid(ent:GetLine()) then print("ent has lines") continue end

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

hook.Add("BaseWars_PlayerBuyEntity", "PoleAddPowerGrid", function(ply, ent)

end)