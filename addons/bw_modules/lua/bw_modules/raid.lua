
local PLAYER = debug.getregistry().Player

BaseWars.Raid = BaseWars.Raid or {}

Raids = BaseWars.Raid
Raids.FactionCooldown = 900

local raid = BaseWars.Raid

raid.Cooldowns = raid.Cooldowns or {}

function PLAYER:InRaid()
	return self:GetNWBool("Raided", false)
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
	err.RaidedByOthers 		= "This faction is already being raided by someone else."
	err.RaidingOthers 		= "This faction is currently raiding someone else."
	err.RaidedByYou 		= "This faction is already being raided by you!"
	err.YouAreRaidedByThem 	= "You are currently being raided by this faction!"

--[[-----------------------------]]
--	  	  Player v. Player
--[[-----------------------------]]

	err.CantHaveAFaction 		= "You can't raid a player while in a faction!"
	err.RaidingSelf				= "Might be better to just sell your own stuff, y'know?"
	err.PlayerRaidedByOthers 	= "This player is already being raided by someone else."
	err.PlayerRaidingOthers 	= "This player is currently raiding someone else."
	err.PlayerRaidedByYou 		= "This player is already being raided by you!"

-- Both:
	err.YouAreRaided 		= "You are currently being raided!"
	err.YouAreRaiding 		= "You are currently raiding someone else!"

	err.RaidedOnCooldown 	= function(ply, fac)
		local who = IsFaction(fac) and "This faction" or "This player"
		local _, left = fac:RaidedCooldown()
		return ("%s is currently on cooldown from being raided. (%ds. remaining)"):format(who, left)
	end

function raid.CanRaidPlayer(ply, ply2)
	local fac = ply:GetFaction()

	if fac then return false, err.CantHaveAFaction end
	if ply == ply2 then return false, err.RaidingSelf end

	if ply2:RaidedCooldown() then
		return false, err.RaidedOnCooldown
	end

	if ply:InRaid() then
		return false, err.YouAreRaided
	end
end

function raid.CanRaidFaction(ply, fac2)
	local fac = ply:GetFaction()
	if not fac then return false, err.NeedAFaction end
	if fac == fac2 then return false, err.OwnFaction end

	if fac:InRaid() then
		local rded = fac:Get("Raided")
		return 	(rded and (rded == fac2 and err.YouAreRaidedByThem or err.YouAreRaided))
				or err.YouAreRaiding
	end

	if fac2:InRaid() then
		local rded = fac2:Get("Raided")
		return 	( rded and (rded == fac and err.RaidedByYou or err.RaidedByOthers) )
				or err.RaidingOthers
	end

	if fac2:RaidedCooldown() then
		return false, err.RaidedOnCooldown
	end
end