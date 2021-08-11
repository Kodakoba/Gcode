
local PLAYER = debug.getregistry().Player

BaseWars.Raid = BaseWars.Raid or {}

Raids = BaseWars.Raid

Raids.FactionCooldown = 900
Raids.RaidCoolDown = 900
Raids.RaidDuration = 360

local raid = BaseWars.Raid

raid.Cooldowns = raid.Cooldowns or {}
raid.Participants = raid.Participants or {}

function PLAYER:InRaid()
	return raid.Participants[self]
end

raid.Errors = {}
local err = raid.Errors
local id = 0

local function makeErr(s)
	err[id] = LocalString(s, id)

	id = id + 1

	return err[id - 1]
end

--[[-----------------------------]]
--	  	 Faction v. Faction
--[[-----------------------------]]

	err.NeedAFaction 		= "You can't raid a faction without being in a faction yourself!"
	err.OwnFaction 			= "You can't really raid your own faction..."
	err.LowLevelFaction 	= "Every player's level in that faction is too low!"

	err.RaidedByOthers 		= "This faction is already being raided by someone else."
	err.RaidingOthers 		= "This faction is currently raiding someone else."
	err.RaidedByYou 		= "This faction is already being raided by you!"
	err.YouAreRaidedByThem 	= "You are currently being raided by this faction!"

--[[-----------------------------]]
--	  	  Player v. Player
--[[-----------------------------]]

	err.PlayerRaidedByOthers 	= "This player is already being raided by someone else."
	err.PlayerRaidingOthers 	= "This player is currently raiding someone else."
	err.PlayerRaidedByYou 		= "This player is already being raided by you!"
	err.PlayerYouAreRaidedByThem 	= "You are currently being raided by this player!"

	err.CantHaveAFaction 		= "You can't raid a player while in a faction!"
	err.RaidingSelf				= "Might be better to just sell your own stuff, y'know?"

	err.LowLevelPlayer 			= "This player's level is too low!"

--[==================================[
	Both
--]==================================]

	err.YouAreRaided 		= "You are currently being raided!"
	err.YouAreRaiding 		= "You are currently raiding someone else!"
	err.NoRaidables			= "There are no raidable entities!"
	err.Generic				= "Generic error. Dunno."
	err.YouNeedBase			= "You need a base to raid others!"
	err.TheyNeedBase		= "They don't have a base to raid!"
	err.YouAreUnraidable	= function(why)
		if why then
			return ("You are unraidable!\n(%s)"):format(why)
		else
			return "You are unraidable!"
		end
	end

	err.TargetUnraidable	= function(why)
		print("target unraidable:", why)
		if why then
			return ("Target is unraidable!\n(%s)"):format(why)
		else
			return "Target is unraidable!"
		end
	end

	err.RaidedOnCooldown 	= function(what)
		local who = IsFaction(what) and "This faction" or "This player"
		local _, left = what:RaidedCooldown()
		return ("%s is currently on cooldown from being raided. (%ds. remaining)"):format(who, left)
	end


for k,v in pairs(err) do
	err[k] = makeErr(v)
end

function raid.PickRaidedError(rder, rded)
	local rd = raid.IsParticipant(rded)
	if not rd then return end

	local prefix = IsFaction(rded) and "" or "Player"
	local main

	-- they are raiding...
	if rd:IsRaider(rded) then
		if rd:IsRaided(rder) then
			-- ...you
			main = "YouAreRaidedByThem"
		else
			-- ...someone else
			main = "RaidingOthers"
		end
	else
		-- they are being raided by...
		if rd:IsRaider(rder) then
			-- ...you
			main = "RaidedByYou"
		else
			-- ...someone else
			main = "RaidedByYou"
		end
	end

	if not main or not err[prefix .. main] then
		print("======")
		print("Unhandled condition?")
		print("	Raider:", rder)
		print("	Raided:", rded)
		print("	Prefix/main:", prefix, "/", main)
		print("=====")
		return err.Generic
	end

	return err[prefix .. main]
end

function raid.CanGenerallyRaid(ply, nonfac)
	if bit.bxor(ply:GetFaction() and 1 or 0, nonfac and 1 or 0) == 0 then
		return false, nonfac and err.CantHaveAFaction() or err.NeedAFaction()
	end

	if not GetPlayerInfoGuarantee(ply):GetBase() then
		return false, err.YouNeedBase()
	end

	return true
end

function raid.CanRaidPlayer(ply, ply2)
	local fac = ply:GetFaction()

	if fac then return false, err.CantHaveAFaction end
	if ply == ply2 then return false, err.RaidingSelf end

	if ply2:RaidedCooldown() then
		return false, err.RaidedOnCooldown(ply2)
	end

	if not ply2:GetBase() then
		return false, err.TheyNeedBase()
	end

	if ply:InRaid() then
		return false, raid.PickRaidedError(ply, ply2)
	end

	return true
end

function raid.CanRaidFaction(caller, fac2)
	-- caller isnt guaranteed to be present
	local self_check = caller == false
	local fac = not self_check and caller:GetFaction()

	if not fac and not self_check then return false, err.NeedAFaction end
	if fac == fac2 then return false, err.OwnFaction end

	if not self_check and fac:InRaid() then
		local rded = fac:Get("Raided")
		return raid.PickRaidedError(fac, rded)
	end

	if fac2:InRaid() then
		local rded = fac2:Get("Raided")
		return raid.PickRaidedError(fac2, rded)
	end

	if fac2:RaidedCooldown() then
		return false, raid.PickRaidedError(caller, fac2)
	end

	if not fac2:GetBase() then
		return false, caller and err.TheyNeedBase() or err.YouNeedBase()
	end

	local has_raidables = false

	for k,v in pairs(fac2:GetMembers()) do
		local ents = BaseWars.Ents.GetOwnedBy(v)

		for _, ent in ipairs(ents) do
			if ent.IsValidRaidable then has_raidables = true break end
		end
	end

	if has_raidables then
		return true
	else
		return false, err.NoRaidables
	end
end

function LibItUp.PlayerInfo:GetRaid()
	return self._Raid
end

function LibItUp.PlayerInfo:SetRaid(rd)
	if not rd:IsValid() then return end

	self._Raid = rd
	rd:On("Stop", "PInfoStore", function()
		self._Raid = nil
	end)
end

function LibItUp.PlayerInfo:IsEnemy(what)
	what = GetPlayerInfo(what)
	if not what:IsValid() then return end

	local rd = self:GetRaid()
	if not rd then return false end

	local rd2 = what:GetRaid()
	if not rd2 then return false end

	if rd ~= rd2 then return end

	return rd:GetSide(self) ~= rd2:GetSide(what)
end