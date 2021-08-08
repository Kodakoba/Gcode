
util.AddNetworkString("BW_OwnershipChange")
util.AddNetworkString("BW_OwnershipChange_Mass")

local trackEnt
local bwe = BaseWars.Ents
	bwe.EntsArr = bwe.EntsArr or ValidSeqIterable() 	-- sequential table of all basewars entities
	bwe.EntsOwners = bwe.EntsOwners or {}				-- table of [sid64] = {ValidSeqIter}

hook.Add("CPPIAssignOwnership", "BWTrackOwner", function(ply, ent)
	if not ply:IsValid() then return end

	local id = ply:SteamID64()
	ent.CPPI_OwnerSID = id

	trackEnt(ent, id)
	bwe.EntsArr:addExclusive(ent)

	net.Start("BW_OwnershipChange")
		net.WriteUInt(ent:EntIndex(), 16)
		net.WriteString(id)
	net.Broadcast()

	-- run a new hook because, again, fpp sucks
	hook.Run("EntityOwnershipChanged", ply, ent, id)
end)

function BaseWars.Ents.NetworkAll(ply)
	net.Start("BW_OwnershipChange_Mass")

		local count = table.Count(SPropProtection.Props)
		net.WriteUInt(count, 16)

		for k,v in pairs(SPropProtection.Props) do
			local ent = v.Ent
			local sid64 = util.SteamIDTo64(v.SteamID)

			net.WriteUInt(ent:EntIndex(), 16)
			net.WriteString(sid64)
		end

	net.Send(ply)
end

hook.Add("PlayerFullyLoaded", "BW_NetworkOwnership", function(ply)
	BaseWars.Ents.NetworkAll(ply)
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

function trackEnt(ent, owID)
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


hook.Add("EntityActuallyRemoved", "BWUntrackOwner", function(ent, entTable)
	local owID = ent.FPPOwnerID -- fpp exclusive
	if not owID then return end -- dafuq

	untrackEnt(ent, owID)
end)