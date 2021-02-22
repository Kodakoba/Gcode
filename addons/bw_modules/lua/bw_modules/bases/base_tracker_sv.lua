local bw = BaseWars.Bases
local tick = engine.TickCount

local updateList = { --[[

	[ent] = {
		[1] = { entered_zones_array },
		[2] = {  exited_zones_array }
	}, ...

]] }

-- If an entity touches multiple bases at once, then, first of all, it's your fault,
-- and second, the oldest entered base will be considered as the `current` one.

-- If the player leaves that oldest base, the one that came after will be considered the `current` one.
-- This repeats for multiple bases (so you can touch 10 bases (you absolute madman), 
-- and the oldest one will be the current)

-- Current base: [ent] = cur_base
bw.BasePresence = bw.BasePresence or {
	-- [ent] = base_obj
}

-- Base queue: [ent] = {oldest_base, ..., newest_base}
bw.BasePresenceQueue = bw.BasePresenceQueue or {}

-- Zone presence: [ent] = { [zones_objects] = true }
-- A [key] = true structure works better here than in base queue
bw.ZonePresence = bw.ZonePresence or {}

-- TODO: Same as BaseQueue
bw.ZoneQueue = bw.ZoneQueue or {}

-- returns the current base the ent is in, false if in none
local function getBase(ent)
	return bw.BasePresence[ent] or false
end

-- returns the base queue for ent, guaranteed to be a table
local function getBaseQueue(ent)
	local t = bw.BasePresenceQueue[ent]
	
	if not t then
		t = {}
		bw.BasePresenceQueue[ent] = t
	end 

	return t
end

-- returns all zones ent is in, guaranteed to be a table
local function getZones(ent)
	local t = bw.ZonePresence[ent]

	if not t then
		t = {}
		bw.ZonePresence[ent] = t
	end 

	return t
end

--[[-------------------------------------------------------------------------
	INTERNAL
		Do not call these directly; you usually don't want to
		enter/exit bases manually! Use the base queue instead.
---------------------------------------------------------------------------]]
	local function enterBase(ent, base)
		bw.BasePresence[ent] = base

		base:Emit("EntityEntered", ent)
		ent:Emit("EnteredBase", base)
		hook.Run("EntityEnteredBase", base, ent)
	end

	local function exitBase(ent, base) -- exit a specific base; the only difference is the sanity check
		if base ~= getBase(ent) then
			errorf("Sanity check failed: %s != %s", base, getBase(ent))
			return
		end

		bw.BasePresence[ent] = nil

		base:Emit("EntityExited", ent)
		ent:Emit("ExitedBase", base)
		hook.Run("EntityExitedBase", base, ent)
	end

	local function exitBaseMaybe(ent) -- exit any base the entity was in, if they were: emit shtuff
		local cur = getBase(ent)
		bw.BasePresence[ent] = nil

		if cur then
			cur:Emit("EntityExited", ent)
			ent:Emit("ExitedBase", cur)
			hook.Run("EntityExitedBase", cur, ent)
		end
	end



--[[-------------------------------------------------------------------------
	Public
		Working with the base queue; bases may or may not be in the base queue

		Calling addBase when the base is in queue already and
		calling removeBase when it's not is perfectly fine.
---------------------------------------------------------------------------]]
local function addBase(ent, base)
	CheckArg(2, base, bw.IsBase)

	local t = getBaseQueue(ent)

	if not t[1] then -- the queue was empty; make us the current base
		enterBase(ent, base)
		t[1] = base
		return
	end

	-- make sure we don't put the base in multiple times
	local baseID = base:GetID()
	for k,v in ipairs(t) do
		if baseID == v:GetID() then return end
	end

	table.insert(t, base)
end

-- remove `base` if it was in ent's presence queue
local function removeBase(ent, base)
	CheckArg(2, base, bw.IsBase)

	local t = getBaseQueue(ent)
	if not t[1] then return end -- the queue was empty; don't bother

	-- if we're removing the current base, also remove us from being current
	if getBase(ent) == base then
		exitBase(ent, base)
	end

	local baseID = base:GetID()

	for k,v in ipairs(t) do
		if baseID == v:GetID() then
			table.remove(t, k)

			-- there was an another base in queue and we were the current base;
			-- make that one the new current base
			if t[1] and k == 1 then 
				enterBase(ent, t[1])
			end
			return
		end
	end
end

-- after changing the zone presence, call this to make sure
-- we update our base presence using zone presence
local function checkZoneBases(ent)
	local zones = getZones(ent)
	local bases = getBaseQueue(ent)
	local revBases = table.KeysToValues(bases) -- [base] = number

	local newBases = {} -- [confirmed_present_base] = true

	-- check for entering new bases
	
	for k,v in pairs(zones) do
		-- for every zone we're in, check if we're also in that zone's base
		local base = v:GetBase()
		if revBases[base] then newBases[base] = true continue end -- we're already in that base; don't care 
		-- we entered a new base: register
		addBase(ent, base)
		revBases[base] = true
		newBases[base] = true
	end

	-- check for exiting bases
	-- if some base is not present in newBases, that means we're 
	-- no longer in any zones, which belong to that base

	for _, base in ipairs(bases) do
		if not newBases[base] then
			removeBase(ent, base)
		end
	end
end

local function addZone(ent, zone)
	local t = getZones(ent)

	table.insert(t, zone)
	checkZoneBases(ent)
end

local function removeZone(ent, zone)
	local t = getZones(ent)
	if not t[1] then return end -- presence was empty; don't bother

	for k,v in ipairs(t) do
		if v == zone then
			table.remove(t, k)
			checkZoneBases(ent)
			return
		end
	end
end

function bw.Zone:_EntityEntered(brush, ent)
	--print(tostring(self), "->|", ent, tick())
	addZone(ent, self)
end

function bw.Zone:_EntityExited(brush, ent)
	--print(tostring(self), "<-|", ent, tick())
	removeZone(ent, self)
end

bw:On("DeleteZone", "Tracker", function(self, delzone)
	for ent, bases in pairs(bw.ZonePresence) do
		removeZone(ent, delzone)
	end
end)

bw:On("DeleteBase", "Tracker", function(self, delbase)
	for ent, bases in pairs(bw.BasePresenceQueue) do
		removeBase(ent, delbase)
	end
end)


hook.Add("EntityEnteredBase", "NetworkBase", function(base, ent)
	if not IsPlayer(ent) then return end

	local nw = bw.GetPlayerNW(ent)
	if not nw then print("wtf no playerdata networkable?") return end

	print("entered base; networking", base:GetID())
	nw:Set("CurrentBase", base:GetID())
	nw:Network()
end)

hook.Add("EntityExitedBase", "NetworkBase", function(base, ent)
	if not IsPlayer(ent) then return end

	local nw = bw.GetPlayerNW(ent)
	if not nw then print("wtf no playerdata networkable?") return end

	print("exited base; networking")
	nw:Set("CurrentBase", nil)
	nw:Network()
end)

--[[
timer.Create("BWBases_CollectGarbage", 60, 0, function()
	for ent, v in pairs(updateList) do
		if not ent:IsValid() then
			updateList[ent] = nil
		end
	end
end)
]]