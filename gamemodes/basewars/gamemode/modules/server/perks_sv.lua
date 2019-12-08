
MODULE.Name = "PerksSV"
MODULE.Realm = 1
Perks = Perks or {}

_SVPerks = {}

util.AddNetworkString("FetchPerks")

sql.Debugging = true

local PLAYER = debug.getregistry().Player

local CreateQuery = "CREATE TABLE IF NOT EXISTS player_perks (PerkUID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, puid INT, PerkID INT, PerkEffect INT, Equipped INT NOT NULL);"

sql.Query(CreateQuery)


perk = {}
perk.__index = perk 

function perk:GetEffect()
	return self.Effect 
end

function perk:GetUID()
	return self.PerkUID
end

function perk:IsSpecial()
	return self.Effect > 190
end
local function isPlayer(ply)

    return (ply and IsValid(ply) and ply:IsPlayer())
    
end

function Perks:DROPEET()
	sql.Check("DROP TABLE player_perks")
	sql.Check(CreateQuery)
	

end

function Perks.CreatePerk(ply, id, eff)
	local puid = ply:GetUID()
	if not puid then return end 

	if not id then print('you forgot perkID!') return end 
	if not eff then print('you forgot perkeffect!') return end 

	local str = "INSERT INTO player_perks(puid, PerkID, PerkEffect, Equipped) VALUES(%s, %s, %s, 0)"
	str = str:format(puid, id, eff)
	sql.Check(str)

	local uid = sql.Check("SELECT seq FROM sqlite_sequence WHERE name=='player_perks'", true)

	uid = tonumber(uid[1]['seq'])

	local perktbl = {
		PerkUID = uid,
		PerkID = id,
		PerkOwner = ply,
		PerkEffect = eff,
		Equipped = 0,
	}

	setmetatable(perktbl, perk)
	ply.Perks[uid] = perktbl
end
PLAYER.GivePerk = Perks.CreatePerk
PLAYER.CreatePerk = Perks.CreatePerk


function Perks.FetchPerks(ply)
	local puid = ply:GetUID()
	if not puid then return end 

	local dat = sql.Check("SELECT * FROM player_perks WHERE puid=="..puid, true) or {}
	local tbl = {}
	
	for k,v in pairs(dat) do
		tbl[k] = {}
		tbl[k].PerkUID = tonumber(v.PerkUID)
		tbl[k].PerkID = tonumber(v.PerkID)
		tbl[k].PerkEffect = tonumber(v.PerkEffect)
		v.Equipped = tonumber(v.Equipped)

		local eq = v.Equipped>=1

		tbl[k].Equipped = eq
		tbl[k].PerkOwner = ply

		tbl[k] = setmetatable(v, perk)
	end
	ply.Perks = tbl
	return tbl
end 
PLAYER.FetchPerks = Perks.FetchPerks

function Perks.GetPerks(ply)
	return ply.Perks or {}
end

PLAYER.GetPerks = Perks.GetPerks
local shorts = {
	PerkID = "i",
	PerkUID = "u",
	PerkEffect = "e",
	Equipped = "q",
}
local ignore = {
	["puid"] = true,
}
function Perks.NetworkPerks(ply)
	local amt = table.Count(ply.Perks)
	local ctbl = {}

	for uid, perk in pairs(ply.Perks) do 
		ctbl[uid] = {}
		local cperk = ctbl[uid]
		for k, v in pairs(perk) do
			if ignore[k] then continue end 

			if shorts[k] then 
				cperk[shorts[k]] = tonumber(v) or v 
			else 
				cperk[k] = tonumber(v) or v 
			end
		end
	end

	local json = util.TableToJSON(ctbl)

	local fj = string.gsub(json, "%d%.0", function(n) return util.NiceFloat(n) end)
	local comp = util.Compress(fj)

	local tonet = ""
	if #comp > #fj then tonet = fj else tonet = comp end 

	if #comp > #json then comp = json end

	net.Start("FetchPerks")
		net.WriteUInt(#comp, 32)
		net.WriteData(comp, #comp)
	--[[
		net.WriteUInt(amt, 16)

		for k,v in pairs(ply.Perks) do 

			net.WriteUInt(v.PerkID, 16)
			net.WriteUInt(v.PerkUID, 24)
			net.WriteFloat(v.PerkEffect)
			local eq = v.Equipped>=1 
			net.WriteBool(eq)

		end
	]]
	net.Send(ply)
end

net.Receive("FetchPerks", function(_, ply)
	ply:NetworkPerks()
end)
PLAYER.NetworkPerks = Perks.NetworkPerks

hook.Add("PlayerInitialSpawn", "Perks", function(ply)
	ply:FetchPerks()
end)
--[[-------------------------------------------------------------------------
Actual perk effects
---------------------------------------------------------------------------]]
local perkshooked = {}
local function Hook(event, perk, func)

	perkshooked[perk] = (perkshooked[perk] or 0) + 1


	hook.Add(event, "PerkHook"..tostring(perkshooked[perk]), func )

end

function PLAYER.GetPlayPerks()	--stub
	return {}
end
