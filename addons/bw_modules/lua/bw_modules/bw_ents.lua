BaseWars.Ents = BaseWars.Ents or {}
BWEnts = BaseWars.Ents

local bwe = BWEnts
	bwe.Tables = bwe.Tables or {}
	bwe.EntsArr = bwe.EntsArr or ValidSeqIterable() 	-- sequential table of all basewars entities
	bwe.EntsOwners = bwe.EntsOwners or {}				-- table of [sid64] = {ValidSeqIter}


timer.Create("BW_CleanupEntGarbage", 30, 0, function()
	for k,v in pairs(bwe.Tables) do
		if not k:IsValid() then
			bwe.Tables[k] = nil
		end
	end
end)

local function getEntry(sid64)
	if IsPlayer(sid64) then
		sid64 = sid64:SteamID64()
	end

	local t = bwe.EntsOwners[sid64]
	if t then
		t:clean()
		return t
	else
		t = ValidSeqIterable()
		bwe.EntsOwners[sid64] = t
		return t
	end
end

local function untrackEnt(ent, owID)
	local entry = getEntry(owID)
	entry:remove(ent)
	bwe.EntsArr:remove(ent)
end

function BaseWars.Ents.GetAll()
	-- return a copy
	local ret = {}
	for k,v in bwe.EntsArr:iter() do
		ret[k] = v
	end

	return ret
end

function BaseWars.Ents.GetOwnedBy(who)
	local sid64

	if isstring(who) then
		sid64 = (who:match("STEAM_") and util.SteamIDTo64(who)) or who
	elseif IsPlayer(who) then
		sid64 = who:SteamID64()
	end

	if not sid64 then
		error("bad argument #1 to BaseWars.Ents.GetOwnedBy (steamid/steamid64/player expected," ..
				"got `" .. type(who) .. "` (" .. tostring(who) .. ")")
		return
	end

	local ret = {}
	for k,v in getEntry(sid64):iter() do
		ret[k] = v
	end

	return ret
end

-- CPPIAssignOwnership runs before the new owner is assigned
hook.Add("CPPIAssignOwnership", "BWTrackOwner", function(ply, ent)
	if not ply:IsValid() then return end

	local _, sid64 = ent:CPPIGetOwner()

	if sid64 then
		-- there was a previous owner before this,
		-- remove their ownership
		local their = getEntry(sid64)
		their:remove(ent)
	end

	if IsPlayer(ply) then
		local t = getEntry(ply)
		t:add(ent)
	end

	bwe.EntsArr:addExclusive(ent)
end)

hook.Add("EntityActuallyRemoved", "BWUntrackOwner", function(ent, entTable)
	local owID = ent.FPPOwnerID -- fpp exclusive
	if not owID then return end -- dafuq

	untrackEnt(ent, owID)
end)

hook.Add("NotifyShouldTransmit", "BWEntEntry", function(ent, enter)
	if enter then
		BWEnts.Tables[ent] = BWEnts.Tables[ent] or {}
	end
end)