include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")

util.AddNetworkString("Pole")

local m_min = math.min

PowerPoles = PowerPoles or {}
poles = PowerPoles


function ENT:Init(me)
	me.ConnectDistanceSqr = self.ConnectDistance ^ 2

	hook.Once("CPPIAssignOwnership", self, function(self, ply, ent)
		if self == ent then
			self:PingGrids(ply)
		end
	end)
end

function ENT:PingGrids(ow)
	local mypos = self:GetPos()
	local cable = self.ConnectDistance ^ 2
	ow = ow or self:CPPIGetOwner()

	local cur_grid

	local available_grids = {}

	--find all grids we can even modify (eg owned by factionmates)
	for _, grid in pairs(PowerGrids) do
		if not grid.Owner or not grid.Owner:IsValid() or not grid.Owner:IsTeammate(ow) then printf("grid %d doesn't have a valid owner; ignoring", grid.ID) continue end
		available_grids[#available_grids + 1] = grid
	end

	local chosen_pole

	for _, grid in ipairs(available_grids) do
		print("checking grid #" .. grid.ID .. " for availability to hook onto")
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
			print("available:", minpole, grid)
			cur_grid = grid --we found an existing grid we can connect to
			chosen_pole = minpole
		end
	end

	if not cur_grid then print("no poles nearby; creating new grid") cur_grid = PowerGrid:new(ow) end --we're gonna have to create a new grid

	cur_grid:AddLine(self, chosen_pole) --then connect ourselves to that grid


	--here we're done finding a grid and we have either a brand new one or an existing one,
	--now let's connect shtuff

	for _, grid in ipairs(available_grids) do
		--connect every powerline-less generator and then consumer
		print("checking grid #" .. grid.ID)
		for _, gen in ipairs(grid.Generators) do
			if gen.Grid and gen:GetLine():IsValid() then print("gen has a line") continue end

			local pos = gen:GetPos()
			local dist = pos:DistToSqr(mypos)
			if dist < cable then
				print("connecting", gen, "to pole")
				gen:OnConnectToLine(self)
				cur_grid:AddGenerator(gen, self)
			else
				print("gen too far:", dist, cable)
			end
		end
		print("consumers ^", PrintTable(grid.Consumers))
		for _, ent in ipairs(grid.Consumers) do
			print("consumer:", ent)
			if ent.Grid and IsValid(ent:GetLine()) then print('ent has grid alreay and a line', ent:GetLine()) continue end

			local pos = ent:GetPos()
			local dist = pos:DistToSqr(mypos)
			if dist < cable then
				if ent.Grid then ent.Grid:Remove() end
				cur_grid:AddConsumer(ent, self)
			else
				print("too far")
			end
		end

	end
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
	print("not implemented: adding", ent, "to pole connection")
end

function ENT:Disconnect(ent)

end

function ENT:Think()
	local me = BWEnts[self]
	if me.CheckDist and self.Grid then
		local pos = self:GetPos()
		local range = me.ConnectDistanceSqr

		for k,v in pairs(self.Grid.AllEntities) do
			if v.PowerType == "Line" then
				if v==self or self:GetLine() ~= v then continue end
				if pos:DistToSqr(v:GetPos()) > range then
					print("too far, removin")
					self.Grid:RemoveLine(self, true)
					self:SetLine(NULL)
					break
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