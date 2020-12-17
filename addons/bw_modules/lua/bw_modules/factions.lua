local tag = "BaseWars.Factions"
MODULE.Name = "FactionsSH"

Factions = Factions or {}

Factions.Factions = Factions.Factions or {}
Factions.FactionIDs = Factions.FactionIDs or {}

Factions.MaxMembers = 4

Factions.FactionlessTeamID = 1

local facs = Factions

Factions.CREATE = 1		-- cl -> sv
Factions.FULLUPDATE = 1 -- sv -> cl

Factions.LEAVE = 2		-- cl -> sv
Factions.UPDATE = 2 	-- sv -> cl

Factions.JOIN = 3		-- cl -> sv
Factions.DELETE = 3		-- sv -> cl

Factions.KICK = 4

Factions.Errors = {}
local err = Factions.Errors
local id = 0

local function makeErr(s)
	err[id] = LocalString(s, id)

	id = id + 1

	return err[id - 1]
end

Factions.Errors.Generic 		= 	makeErr("Something went wrong.")
Factions.Errors.BadPassword 	= 	makeErr("Incorrect password!")
Factions.Errors.NamelessFac 	= 	makeErr("Can't create a faction without a name!")
Factions.Errors.AlreadyIn 		= 	makeErr("Can't create a new faction while in one!")
Factions.Errors.NameLength 		= 	makeErr("Faction names must be 5-32 characters long.")
Factions.Errors.PasswordLength 	= 	makeErr("Faction passwords must be 5-32 characters long.")
Factions.Errors.NameExists 		= 	makeErr("A faction with this name already exists.")
Factions.Errors.NoFac 			= 	makeErr("No such factions exist!")
Factions.Errors.JoinInRaid 		= 	makeErr("Can't join a faction while being raided!")
Factions.Errors.JoinInFac 		= 	makeErr("Can't join a faction while already in one!")


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
		return false, Factions.Errors.NamelessFac
	end

	local nmLen = utf8.len(name)
	local pwLen = pw and utf8.len(pw)

	if ply:InFaction() then
		return false, Factions.Errors.AlreadyIn
	end

	if nmLen < 5 or nmLen > 32 then
		return false, Factions.Errors.NameLength
	end

	if pw and pw ~= "" and (pwLen < 5 or pwLen > 32) then
		return false, Factions.Errors.PasswordLength
	end

	if Factions.Factions[name] then
		return false, Factions.Errors.NameExists
	end

	return true
end

function Factions.CanJoin(ply, fac)
	if ply:InFaction() then
		return false, Factions.Errors.JoinInFac
	end

	if ply:InRaid() or fac:InRaid() then
		return false, Factions.Errors.JoinInRaid
	end

	return true
end

hook.Add("BasewarsModuleLoaded", "CreateEmptyFaction", function(nm)
	if nm ~= "FactionsSV" and nm ~= "FactionsCL" then return end

	if not Factions.NoFaction then
		local fac

		if CLIENT then
			fac = Factions.meta:new(-1, "No Faction", Color(100, 100, 100))
		else
			fac = Factions.meta:new(false, -1, "No Faction", nil, Color(100, 100, 100))
		end

		-- factions with ID < 0 are automatically considered invalid and don't get a networkableID

		Factions.NoFaction = fac

		Factions.Factions["No Faction"] = nil
		Factions.FactionIDs[-1] = nil
	end
end)