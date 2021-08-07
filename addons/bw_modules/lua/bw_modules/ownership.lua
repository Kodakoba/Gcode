local ENTITY = FindMetaTable("Entity")
local PLAYER = FindMetaTable("Player")

BaseWars.Ents = BaseWars.Ents or {}

local bwe = BaseWars.Ents
	bwe.EntsArr = bwe.EntsArr or ValidSeqIterable() 	-- sequential table of all basewars entities
	bwe.EntsOwners = bwe.EntsOwners or {}				-- table of [sid64] = {ValidSeqIter}

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

local function trackEnt(ent, owID)
	local entry = getEntry(owID)
	entry:addExclusive(ent) -- just in case :ok_hand:
	bwe.EntsArr:addExclusive(ent)
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
hook.Add("CPPIAssignOwnership", "BWTrackOwner", function(ply, ent, id)
	if not ply:IsValid() then return end

	id = isstring(id) and id or ply:SteamID64()

	if id then
		-- there was a previous owner before this,
		-- remove their ownership
		local their = getEntry(id)
		their:remove(ent)

		if IsPlayer(ply) then
			trackEnt(ent, id)
		end
	end

	bwe.EntsArr:addExclusive(ent)

	-- force owner to be set because fpp fucking sucks
	ent.FPPOwner = ply
	ent.FPPOwnerID = id

	-- run a new hook because, again, fpp sucks
	hook.Run("EntityOwnershipChanged", ply, ent, id)
end)

hook.Add("EntityActuallyRemoved", "BWUntrackOwner", function(ent, entTable)
	local owID = ent.FPPOwnerID -- fpp exclusive
	if not owID then return end -- dafuq

	untrackEnt(ent, owID)
end)

-- returns PlayerInfo, worldspawn or false
function ENTITY:BW_GetOwner()
	local o1, o2 = self:CPPIGetOwner()
	if o1 == nil and o2 == nil then
		return game.GetWorld()
	end

	if SERVER then
		if self.FPPOwnerID then
			return GetPlayerInfo(self.FPPOwnerID, true)
		end

		return false
	else
		local id = FPP.entGetOwner(self)

		if IsPlayer(id) then
			return GetPlayerInfo(id)
		end

		return false
	end
end

