AddCSLuaFile()

PowerGrid = PowerGrid or Emitter:extend()

function PowerGrid.UpdateIDs()
	for k, grid in ipairs(PowerGrids) do
		--if grid.ID == k then continue end

		grid.ID = k

		for id, ent in pairs(grid.AllEntities) do
			if not IsValid(ent) then grid.AllEntities[id] = nil continue end --wat
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

PowerGrid:On("AddedGenerator", "UpdatePowerIn", PowerGrid.UpdatePowerIn)
PowerGrid:On("RemovedGenerator", "UpdatePowerIn", PowerGrid.UpdatePowerIn)


function PowerGrid:UpdatePowerOut(con)
	local pw_out = 0
	for k,v in ipairs(self.Consumers--[[OfTheCumChalice]]) do
		pw_out = pw_out + v.PowerRequired
	end

	self.PowerOut = pw_out
end

PowerGrid:On("AddedConsumer", "UpdatePowerOut", PowerGrid.UpdatePowerOut)
PowerGrid:On("RemovedConsumer", "UpdatePowerOut", PowerGrid.UpdatePowerOut)


function PowerGrid:Initialize(ow, id, id2) --`id` is only used clientside, when we rely on the server fixing up powergrids to be sequential
										   --`id2` is to fix up CPPIGetOwner returning uniqueID
	if ow and ow:UniqueID() == id then
		id = id2
	end

	self.Generators = {}
	self.Consumers = {}
	self.Batteries = {}
	self.PowerLines = {}

	self.AllEntities = {}

	self.Changes = {}

	self.Owner = ow

	self.Connections = 0

	self.PowerIn = 0		--generated per second
	self.PowerOut = 0		--used up per second
	self.PowerStored = 0	--currently stored power
	self.MaxPowerStored = 500	--how much can be stored

	local newid = id or #PowerGrids + 1
	PowerGrids[newid] = self

	self.ID = newid

end

PowerGrid:On("Changed", "TrackConnections", function(self)

	if self.Connections == 0 then
		self:Remove()
	end

	PowerGrid.UpdateIDs()
end)

PowerGrid:On("Changed", "UpdateNetworking", function(self, ent)
	if not table.HasValue(self.AllEntities, ent) then
		self.Changes[ent] = false --removed
	else
		self.Changes[ent] = true --added
	end
end)

PowerGrid:On("RemovedLine", "RepickLine", function(self, line)

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

	--table.RemoveByValue(PowerGrids, self) --DIE DIE DIE DIE DIE
	PowerGrids[self.ID] = nil
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

		if grid == self or self.AllEntities[ent:EntIndex()] then print(Realm(), "nope not adding", grid == self, ent:GetGridID(), self.AllEntities[ent:EntIndex()], ent, debug.traceback()) return end --nope

		--First add the ent to a new grid

		local t = self[v.tbl]
		t[#t + 1] = ent

		self.Connections = self.Connections + 1
		ent.Grid = self

		if line then
			ent.Line = line
			ent:SetLine(line)
		end

		self.AllEntities[ent:EntIndex()] = ent

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
		if not self.AllEntities[ent:EntIndex()] then print("What", ent, ent:EntIndex()) return end

		for k,v in ipairs(t) do --remove from PowerType table (generator / powerline / battery)
			if v == ent then
				table.remove(t, k)
				break
			end
		end

		self.AllEntities[ent:EntIndex()] = nil

		--[[for k,v in pairs(self.AllEntities) do --remove from all entities table
			self.AllEntities[ent:EntIndex()] = nil
		end]]

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
		grid.Owner = grid.Owner or table.Random(self.AllEntities):CPPIGetOwner()
		if not grid.Owner:IsValid() or not grid.Owner:IsTeammate(ow) then continue end
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

function PowerGrid:EntToTable(e)
	local t = e.PowerType
	return accessors[t] and self[accessors[t].tbl]
end

function PowerGrid:AddEntity(e, ...)
	local t = e.PowerType
	self["Add" .. t] (self, e, ...)
end

function PowerGrid:Network()
	local ns = netstack:new()

	local rems, adds = {}, {}

	for ent, what in pairs(self.Changes) do
		if not IsValid(ent) then continue end
		if what then
			adds[#adds + 1] = ent
		else
			rems[#rems + 1] = ent
		end
	end
	table.Empty(self.Changes)
	ns:WriteUInt(self.ID, 16)

		ns:WriteUInt(#rems, 8)
			for k,v in ipairs(rems) do
				ns:WriteEntity(v)
			end

		ns:WriteUInt(#adds, 8)
			for k,v in ipairs(adds) do
				ns:WriteEntity(v)
			end

		ns:WriteUInt(self.PowerStored, 24)

	return ns
end

function PowerGrid:Read()
	local removed = net.ReadUInt(8)
	for i=1, removed do
		local ent = net.ReadUInt(16)
		local ref = self.AllEntities[ent] --ent reference, NULL

		for k,v in pairs(accessors) do
			for k,v in pairs(self[v.tbl]) do --this is the only way to remove a NULL entity :(
				if v == ref then
					table.remove(self[v.tbl], k)
				end
			end
		end

		self.AllEntities[ent] = nil
	end

	local added = net.ReadUInt(8)
	for i=1, added do
		local ent = net.ReadEntity()
		if not IsValid(ent) then continue end --um?

		self.AllEntities[ent:EntIndex()] = ent

		local t = self:AddEntity(ent)
	end

	local pw = net.ReadUInt(24)
	self.PowerStored = pw
end

hook.Add("EntityRemoved", "ClearGrid", function(ent)
	local grid = ent.Grid

	if ent.PowerType and grid then
		local ok, err = pcall(grid["Remove" .. ent.PowerType], grid, ent)
		if not ok then
			printf("PowerGrid: EntityRemoved error: %s\nstack traceback: %s", err, debug.traceback())
		end
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

	local die = false

	for k,v in ipairs(self.Consumers) do
		local req = v.PowerRequired
		local enough = pw_total - req > 0

		local rebooting_time = v.RebootStart and CurTime() - v.RebootStart < v.RebootTime 	--should it still be rebooting?
		local is_rebooting = v:GetRebooting()												--is it currently rebooting?

		local should_reboot = rebooting_time --by default just obey the time

		--if we have enough,
		-- 	and it wasn't powered or it should be rebooting,
		-- 		and it was powered before (so new entities aren't in reboot)
		-- 			and it's not rebooting currently


		if enough and (not v.Power or v.ShouldReboot) and v.EverPowered and not is_rebooting then
			--start rebooting sequence
			v.RebootStart = CurTime()
			should_reboot = true
		elseif not enough and not v.Power then
			v.ShouldReboot = true --next time it's powered it will go into reboot
			v.RebootStart = nil
			should_reboot = false
		end

		v:SetRebooting(should_reboot)
		is_rebooting = should_reboot

		--[[if enough and (not v.Power or v.ShouldReboot) then -- it died this power tick
			v.RebootStart = CurTime()
			rebooting = true
		end

		if not enough and not v.Power then --it's dead and reboot time has passed; we're just straight up dead
			if not rebooting then
				v:SetRebooting(false)
				v.ShouldReboot = true
			end
		else
			v:SetRebooting(rebooting)
		end]]


		--it should resurrect this tick, check reboot time
		if enough and is_rebooting then
			-- it's still rebooting; drain power but don't make it powered yet
			enough = false
		end

		if enough then
			v.EverPowered = true
		end

		v.Power = (enough and ct) or false

		if not die then
			v:SetPowered(enough)

			if enough then
				pw_total = pw_total - req
			else
				die = true
			end
		else
			v:SetPowered(false) -- everything dies and everyone cries
		end
	end

	self.PowerStored = math.Clamp(pw_total, 0, self.MaxPowerStored)
end

if SERVER then
	util.AddNetworkString("PowerGrids")

	local networkTime = 1 --once per X seconds all grids get networked

	local lastNW = 0
	timer.Create("PowerGridThink", 0.25, 0, function()
		local nses = {}
		for k,v in ipairs(PowerGrids) do
			v:Think()
			nses[#nses + 1] = v:Network()
		end

		if CurTime() - lastNW > networkTime then

			net.Start("PowerGrids")
				net.WriteUInt(#nses, 16)
				for k,v in ipairs(nses) do
					net.WriteNetStack(v)
				end
			net.Broadcast()

			lastNW = CurTime()
		end

	end)
else

	net.Receive("PowerGrids", function()
		local grids = net.ReadUInt(16)
		for i=1, grids do
			local id = net.ReadUInt(16)
			if not PowerGrids[id] then printf("Received unknown grid #%d, ignoring", id) return end
			PowerGrids[id]:Read()
		end
	end)


end


