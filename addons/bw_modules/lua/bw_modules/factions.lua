local tag = "BaseWars.Factions"

Factions = Factions or {}

Factions.Factions = Factions.Factions or {}
Factions.FactionIDs = Factions.FactionIDs or {}

Factions.MaxMembers = 4

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


function Factions.CanCreate(name, pw, col, ply)
	if not name then
		return false, "Can't create a faction without a name!"
	end

	local nmLen = utf8.len(name)
	local pwLen = pw and utf8.len(pw)

	if ply:InFaction() then
		return false, "Can't create a new faction while in one!"
	end

	if nmLen < 5 or nmLen > 32 then
		return false, "Faction names must be 5-32 characters long."
	end

	if pw and pw ~= "" and (pwLen < 5 or pwLen > 32) then
		return false, "Faction passwords must be 5-32 characters long."
	end

	if Factions.Factions[name] then
		return false, "A faction with this name already exists."
	end

	return true
end