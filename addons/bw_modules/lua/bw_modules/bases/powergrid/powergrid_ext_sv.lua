local bw = BaseWars.Bases
bw.ThinkInterval = 0.3

local pg = bw.PowerGrid


-- power i/o tracking

function pg:UpdatePowerIn(gen)
	local pw_in = 0
	for k,v in ipairs(self:GetGenerators()) do
		pw_in = pw_in + v.PowerGenerated
	end

	self:SetPowerIn(pw_in)
end

pg:On("AddedGenerator", "UpdatePowerIn", pg.UpdatePowerIn)
pg:On("RemovedGenerator", "UpdatePowerIn", pg.UpdatePowerIn)


function pg:UpdatePowerOut(con)
	local pw_out = 0
	for k,v in ipairs(self:GetConsumers()) do
		pw_out = pw_out + v.PowerRequired
	end

	self:SetPowerOut(pw_out)
end

pg:On("AddedConsumer", "UpdatePowerOut", pg.UpdatePowerOut)
pg:On("RemovedConsumer", "UpdatePowerOut", pg.UpdatePowerOut)



-- list tracking

function pg:ConsumerAddList(e)
	self._UnpoweredEnts[e] = true
	e:SetPowered(false)
	print("added to list, unpowered")
end

function pg:ConsumerRemoveList(e)
	self._UnpoweredEnts[e] = nil
	self._PoweredEnts[e] = nil

	e:SetPowered(false)
	print("removed from list, unpowered")
end

pg:On("AddedConsumer", "UpdateList", pg.ConsumerAddList)
pg:On("RemovedConsumer", "UpdateList", pg.ConsumerRemoveList)


function pg:PowerEnt(ent)
	self._PoweredEnts[ent] = true
	self._UnpoweredEnts[ent] = nil

	ent:SetPowered(true)
end

function pg:UnpowerEnt(ent)
	self._PoweredEnts[ent] = nil
	self._UnpoweredEnts[ent] = true

	ent:SetPowered(false)
end



function pg:Think()
	local base = self:GetBase()
	if not base or not self:GetValid() then return end

	local cur = self:GetPower()
	local add = self:GetPowerIn()
	local sub = self:GetPowerOut()

	if sub == 0 and add == 0 then return end

	local changes = {}

	if cur + add >= sub then
		-- we can upkeep every ent so dont bother and just set everyone as powered
		local diff = add - sub

		for ent, _ in pairs(self._UnpoweredEnts) do
			table.insert(changes, {ent, true})
		end

		if diff < 0 then
			self:TakePower(-diff)
		else
			self:AddPower(diff)
		end
	elseif cur + add < sub then
		-- we can upkeep only some entities
		local cur_sub = 0

		-- first we try to upkeep the already-powered ents
		for ent, _ in pairs(self._PoweredEnts) do
			if cur + add > cur_sub + ent.PowerRequired then
				cur_sub = cur_sub + ent.PowerRequired
			else
				-- we can't upkeep this ent
				table.insert(changes, {ent, false})
			end
		end

		if cur_sub < cur + add then
			-- we still have some power left to try and power some unpowered ents
			for ent, _ in pairs(self._UnpoweredEnts) do
				if cur + add > cur_sub + ent.PowerRequired then
					-- we can upkeep this ent
					table.insert(changes, {ent, true})
					cur_sub = cur_sub + ent.PowerRequired
				end
			end
		end
	end

	for k, dat in ipairs(changes) do
		local ent = dat[1]
		if dat[2] then
			self:PowerEnt(ent)
		else
			self:UnpowerEnt(ent)
		end
	end
end

hook.Add("EntityEnteredBase", "NetworkBase", function(base, ent)
	if not ent.IsBaseWars then return end

	local grid = base.PowerGrid
	if not grid then print("enter - base didnt have power grid?", base) return end

	grid:AddEntity(ent)
end)

hook.Add("EntityExitedBase", "NetworkBase", function(base, ent)
	if not ent.IsBaseWars then return end

	local grid = base.PowerGrid
	if not grid then print("exit - base didnt have power grid?", base) return end

	grid:RemoveEntity(ent)
end)


local lastThink = CurTime()

hook.Add("Tick", "PowerGrid_Tick", function()
	if CurTime() < lastThink + bw.ThinkInterval then return end

	lastThink = CurTime() + bw.ThinkInterval

	for _, base in pairs(BaseWars.Bases.Bases) do
		local grid = base.PowerGrid
		if not grid then continue end

		local ok, err = pcall(grid.Think, grid)
		if not ok then
			bw.Log("Error in %s base think: %s", base, err)
			continue
		end
	end
end)