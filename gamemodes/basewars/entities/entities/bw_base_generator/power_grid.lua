AddCSLuaFile()

PowerGrid = Emitter:extend()

function PowerGrid.UpdateIDs()
	for k, grid in ipairs(PowerGrids) do
		--if grid.ID == k then continue end

		grid.ID = k

		for _, ent in ipairs(grid.AllEntities) do
			if not IsValid(ent) then table.remove(grid.AllEntities, _) continue end --wat
			if SERVER then 	ent:SetGridID(k) else
							ent.OldGridID = k end
		end
	end
end

PowerGrids = PowerGrids or {}

function PowerGrid:UpdatePowerIn(gen)
	local pw_in = 0
	for k,v in ipairs(self.Generators) do
		pw_in = pw_in + v.PowerGenerated
	end

	self.PowerIn = pw_in
end

PowerGrid:On("AddedGenerator", PowerGrid.UpdatePowerIn)
PowerGrid:On("RemovedGenerator", PowerGrid.UpdatePowerIn)

function PowerGrid:Initialize(ow, id, id2) --`id` is only used clientside, when we rely on the server fixing up powergrids to be sequential
										   --`id2` is to fix up CPPIGetOwner returning uniqueID
	if ow:UniqueID() == id then
		id = id2
	end

	self.Generators = {}
	self.Consumers = {}
	self.Batteries = {}
	self.PowerLines = {}

	self.AllEntities = {}

	self.Owner = ow

	self.Connections = 0

	self.PowerIn = 0		--generated per second
	self.PowerOut = 0		--used up per second
	self.PowerStored = 0	--currently stored power
	self.MaxPowerStored = 500	--how much can be stored

	PowerGrids[id or #PowerGrids + 1] = self

	self.ID = id or #PowerGrids

end

PowerGrid:On("Changed", function(self)
	if self.Connections == 0 then
		self:Remove()
	end

	PowerGrid.UpdateIDs()
end)

PowerGrid:On("RemovedLine", function(self, line)

	for k,v in pairs(self.Accessors) do
		--if k == "Line" then continue end
		local ents = self[v.tbl]

		for i=#ents, 1, -1 do --ty CornerPin for this https://discordapp.com/channels/565105920414318602/567617926991970306/720349414408847370
			--if there's no pole to be found here then the entity will be removed from the new grid, and if there's 0 connections
			--the powergrid will be removed entirely (replaced by new ones), see :On("Changed") above for the removal

			local ent = ents[i]
			if ent:GetLine() ~= line then continue end

			local new = self.FindNearestPole(ent)

			if not new then
				self["Remove" .. k] (self, ent, true) --failed to find a new pole for the entity, disconnect them into their own empty grid
			else
				ent.Line = new
				ent:SetLine(new)
			end

		end

	end

end)

function PowerGrid:Remove()
	table.RemoveByValue(PowerGrids, self)
end

local accessors = {
	Generator = {tbl = "Generators", emit = "Generator"},
	Consumer = {tbl = "Consumers", emit = "Consumer"},
	Battery = {tbl = "Batteries", emit = "Battery"},
	Line = {tbl = "PowerLines", emit = "Line"},
}

--[[
	Emit events:
	Changed: upon any change (removed / added a connection)
		1. Grid itself
		2. Ent that caused the change

	Add .. PowerType: when a connection of that power type gets added
		1. Grid itself
		2. Ent that caused the change
		...  Whatever else was passed

	Remove .. PowerType: when an entity disconnects from the grid
		1. Grid itself
		2. Ent that caused the change
		3. Will that entity create a new grid afterwards
]]
PowerGrid.Accessors = accessors

for k,v in pairs(accessors) do

	PowerGrid["Add" .. k] = function(self, ent, line, ...)
		local grid = ent:GetGrid()

		--First add the ent to a new grid

		local t = self[v.tbl]
		t[#t + 1] = ent

		self.Connections = self.Connections + 1
		ent.Grid = self

		if line then
			ent.Line = line
			ent:SetLine(line)
		end

		self.AllEntities[#self.AllEntities + 1] = ent

		--Only then remove
		if grid and grid ~= self then
			grid["Remove" .. ent.PowerType] (grid, ent)
		end

		self:Emit("Changed", ent, ...)
		self:Emit("Added" .. v.emit, ent, ...)

		if SERVER then ent:SetGridID(self.ID) end
	end

	PowerGrid["Remove" .. k] = function(self, ent, new)
		local t = self[v.tbl]

		for k,v in ipairs(t) do --remove from PowerType table (generator / powerline / battery)
			if v == ent then
				table.remove(t, k)
				break
			end
		end

		for k,v in ipairs(self.AllEntities) do --remove from all entities table
			if v == ent then
				table.remove(self.AllEntities, k)
				break
			end
		end

		--if ent.SetLine then ent:SetLine(NULL) end

		self.Connections = self.Connections - 1

		self:Emit("Changed", ent)
		self:Emit("Removed" .. v.emit, ent, new)

		if new then
			local new = PowerGrid:new(ent:CPPIGetOwner())
			new["Add" .. ent.PowerType] (new, ent)
			if SERVER then ent:SetGridID(ent:GetGrid().ID) end
		end

	end

end

function PowerGrid.FindNearestPole(ent) --this isn't a class function, it's a utility function
	local mypos = ent:GetPos()
	local cable = ent.ConnectDistance ^ 2
	local ow = ent:CPPIGetOwner()

	for _, grid in ipairs(PowerGrids) do
		if not grid.Owner:IsValid() or not grid.Owner:IsTeammate(ow) then print("no owner fuck you") continue end
		local mindist, minpole = math.huge

		for _, line in ipairs(grid.PowerLines) do
			if line == ent then continue end

			local pos = line:GetPos()
			local dist = pos:DistToSqr(mypos)

			if dist < cable and dist < mindist then
				mindist = dist
				minpole = line
			end
		end

		if minpole then return minpole end
	end

end

hook.Add("EntityRemoved", "ClearGrid", function(ent)
	local grid = ent.Grid

	if ent.PowerType and grid then
		grid["Remove" .. ent.PowerType](grid, ent)
	end
end)

function ENTITY:GetGrid()
	return self.Grid
end

function PowerGrid:Think()
	self:Emit("Think")

	local pw_in = self.PowerIn
	local pw_total = pw_in + self.PowerStored

	local ct = CurTime()

	for k,v in ipairs(self.Consumers) do
		local req = v.PowerRequired
		local enough = pw_total - req > 0
		v.Power = (enough and ct) or false

		if not enough then break end --rip

		pw_total = pw_total - req
	end

	self.PowerStored = math.Clamp(pw_total, 0, self.MaxPowerStored)
end

timer.Create("PowerGridThink", 1, 0, function()
	for k,v in ipairs(PowerGrids) do
		v:Think()
	end
end)
