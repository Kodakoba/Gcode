local tag = "BaseWars.Factions"

Factions = Factions or {}

Factions.Factions = Factions.Factions or {}
Factions.FactionIDs = Factions.FactionIDs or {}

local facs = Factions


local PLAYER = debug.getregistry().Player

function PLAYER:IsTeammate(ply)
	return (ply:Team() == 1 and ply == self) or ply:Team() == self:Team()
end

function PLAYER:GetFaction()
	return Factions.FactionIDs[self:Team()]
end

function PLAYER:GetFactionName()
	local fac = Factions.FactionIDs[self:Team()]
	if fac then return fac.name end

	return "no faction"
end