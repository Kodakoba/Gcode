if not LibItUp.Networkable then include("networkable.lua") end
LibItUp.SetIncluded()

LibItUp.PlayerInfo = LibItUp.PlayerInfo or LibItUp.Networkable:callable()
local PI = LibItUp.PlayerInfo

LibItUp.PlayerInfoTables = LibItUp.PlayerInfoTables or {
	-- [info] = PI
	Player = {},
	SteamID = {},
	SteamID64 = {}
}

local PIT = LibItUp.PlayerInfoTables

function PI:Initialize(id, is_sid64) -- we can't know that the id is a steamID64
	local ply
	local sid
	local sid64

	if IsPlayer(id) then
		ply = id
		sid = ply:SteamID()
		sid64 = ply:SteamID64()
	elseif not is_sid64 and string.IsSteamID(id) then
		ply = player.GetBySteamID(id)
		sid = id
		sid64 = util.SteamIDTo64(sid)
	else
		if not is_sid64 then
			LibItUp.Log("Initialized PlayerInfo using SteamID64 (`%s`), even though 2nd arg wasn't `true`.", id)
		end

		ply = player.GetBySteamID64(id)
		sid = util.SteamIDFrom64(id)
		sid64 = id
	end

	self:SetPlayer(ply)
	self:SetSteamID(sid)
	self:SetSteamID64(sid64)

	local pi = LibItUp.PlayerInfoTables

	pi.Player[ply] = self
	pi.SteamID[sid] = self
	pi.SteamID64[sid64] = self
end

ChainAccessor(PI, "_Player", "Player")
ChainAccessor(PI, "_SteamID", "SteamID")
ChainAccessor(PI, "_SteamID64", "SteamID64")

hook.Add("PlayerDisconnect", "PlayerInfoEmit", function(ply)
	local sid64 = ply:SteamID64()
	local PI = PIT.SteamID64[sid64]
	if not PI then return end

	PI:Emit("Disconnect", ply)
end)

hook.Add("PlayerInitialSpawn", "PlayerInfoEmit", function(ply)
	local sid64 = ply:SteamID64()
	local PI = PIT.SteamID64[sid64] or PI:new(sid64, true)

	PI:Emit("Connect", ply)
end)

hook.Add("PlayerAuthed", "PlayerInfoEmit", function(ply, sid)
	local PI = PIT.SteamID[sid] or PI:new(ply)
	PI:Emit("StartReconnect", ply)
end)

for k,v in ipairs(player.GetAll()) do
	local PI = PIT.Player[v] or PI:new(v)
end

local PLAYER = FindMetaTable("Player")
function PLAYER:GetPInfo()
	return LibItUp.PlayerInfoTables.Player[self] or PI:new(self)
end