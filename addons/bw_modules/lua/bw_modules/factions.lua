local tag = "BaseWars.Factions"

Factions = Factions or {}

Factions.Factions = Factions.Factions or {}
Factions.FactionIDs = Factions.FactionIDs or {}

local facs = Factions


local PLAYER = debug.getregistry().Player

function PLAYER:IsTeammate(ply)
	return (ply:Team() == 1 and ply == self) or ply:Team() == self:Team()
end