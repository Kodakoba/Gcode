if not LibItUp.Networkable then include("networkable.lua") end
LibItUp.SetIncluded()

LibItUp.PlayerInfo = LibItUp.PlayerInfo or LibItUp.Emitter:callable()
local PI = LibItUp.PlayerInfo
PI.IsPlayerInfo = true
PI.CleanupIn = 900 -- being absent for 15min = playerinfo is cleaned up (NYI)

-- TODO: cleanup is important because networkables are kept in cache
-- this means it'll be networking useless data for each player that ever joined

LibItUp.PlayerInfoTables = LibItUp.PlayerInfoTables or {
	-- [info] = PI
	Player = {},
	SteamID = {},
	SteamID64 = {},

	Absent = {}
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

	if not sid or not sid64 then
		errorf("Can't create PlayerInfo without SteamID or SteamID64. %s %s %s",
			sid or "[nil]", sid64 or "[nil]", ply or "[nil]")
		return
	end

	if ply then self:SetPlayer(ply) end
	self:SetSteamID(sid)
	self:SetSteamID64(sid64)

	self.Networkable = Networkable:new("PI:" .. sid64)

	self._StartedSession = CurTime()
	self._EndedSession = nil
	self._TotalSession = 0

	if ply then PIT.Player[ply] = self end
	PIT.SteamID[sid] = self
	PIT.SteamID64[sid64] = self
end

ChainAccessor(PI, "_SteamID", "SteamID")	-- 	  !! Using SteamID's is not advised due to its' behavior on bots !!
											-- Use SteamID64 instead since it has a hack to work on bots on both realms
ChainAccessor(PI, "_SteamID64", "SteamID64")

function PI:SetSteamID64(id)
	self._SteamID64 = id
	PIT.SteamID64[id] = self

	if not self:GetSteamID() then
		local sid = util.SteamIDFrom64(id)
		self:SetSteamID(sid)
	end

	if not self:GetPlayer() then
		local ply = player.GetBySteamID64(id)
		if ply then
			self:SetPlayer(ply)
		end
	end
end


function PI:SetPlayer(ply)
	if not ply:IsValid() then return end
	self._Player = ply
	PIT.Player[ply] = self
end

function PI:GetPlayer()
	return self._Player
end

function PI:__tostring()
	return ("PlayerInfo [%s][ %s ]"):format(self:GetSteamID64() or "No SteamID64", self:GetPlayer() or "No Player")
end

function PI:get(id, is_sid64)
	if IsPlayerInfo(id) then return id end

	-- returns: pinfo, bool (newly created?)
	if IsPlayer(id) then
		if LibItUp.PlayerInfoTables.Player[id] then return LibItUp.PlayerInfoTables.Player[id], false end

		-- didnt find by player; try to find by sid64
		local sid64 = id:SteamID64()

		if LibItUp.PlayerInfoTables.SteamID64[sid64] then
			local pi = LibItUp.PlayerInfoTables.SteamID64[sid64]
			pi:SetPlayer(id)
			return pi, false
		end

	elseif not is_sid64 and string.IsSteamID(id) then
		if LibItUp.PlayerInfoTables.SteamID[id] then return LibItUp.PlayerInfoTables.SteamID[id], false end

		local ply = player.GetBySteamID(id)

		if ply and LibItUp.PlayerInfoTables.Player[ply] then
			local info = LibItUp.PlayerInfoTables.Player[ply]
			info:SetSteamID64(id)
		end
	else
		-- try to guess the sid64 as a last resort
		local str = tostring(id)
		is_sid64 = is_sid64 or str:IsMaybeSteamID64()

		if is_sid64 then
			if LibItUp.PlayerInfoTables.SteamID64[id] then return LibItUp.PlayerInfoTables.SteamID64[id], false end

			local ply = player.GetBySteamID64(id)

			if ply and LibItUp.PlayerInfoTables.Player[ply] then
				local info = LibItUp.PlayerInfoTables.Player[ply]
				info:SetSteamID64(id)
			end
		else
			errorf("Unknown ID passed to PlayerInfo:Get() (id = `%s`, is_sid64 = `%s`)", id, is_sid64)
		end
	end

	return PI:new(id, is_sid64), true
end

function PI:IsValid()
	return self._Valid ~= false
end

function PI:_Destroy()
	-- do not call this directly
	local pi = LibItUp.PlayerInfoTables
	pi.Player[self:GetPlayer()] = nil
	pi.SteamID[self:GetSteamID()] = nil
	pi.SteamID64[self:GetSteamID64()] = nil

	self._Valid = false
	self:Emit("Destroy")
	self:Invalidate()
	hook.Run("PlayerInfoDestroy", self)
end

function PI:_OnReconnect()
	if not self._EndedSession then return end
	self._TotalSession = self._TotalSession + (self._EndedSession - self._StartedSession)
	self._StartedSession = CurTime()
	self._EndedSession = nil
end

function PI:GetAbsent()
	-- return #1: number or false (false if player is not currently absent)
	-- return #2: last absent duration: number or false (false if the player was never absent)
	-- both of them can be numbers

	local since, till = self._AbsentSince, (self._AbsentStop or CurTime())
	if not since then return false, false end

	if self._Absent then
		local prev = (self._AbsentStop and till - since) or false
		return till - since, prev
	else
		return false, self._AbsentStop - self._AbsentSince
	end
end

function PI:InsertByID(tbl, what, info, ply, sid, sid64)
	info = (info == nil) or info
	ply = (ply == nil) or ply
	sid = (sid == nil) or sid
	sid64 = (sid64 == nil) or sid64

	if info then
		tbl[self] = what
	end

	if ply then
		tbl[self:GetPlayer()] = what
	end

	if sid then
		tbl[self:GetSteamID()] = what
	end

	if sid64 then
		tbl[self:GetSteamID64()] = what
	end
end

if CLIENT then
	function PI:SetUserID(uid)	-- as soon as a player with this userID becomes valid, we'll assign steamid and shit to it
		hook.Add("PlayerJoined", "AssignPlayerInfo:" .. uid, function(ply)
			if ply:UserID() == uid then
				self:SetPlayer(ply)
				PIT.Player[ply] = self
			end
		end)
	end

	net.Receive("PlayerInfoFill", function()
		local uid = net.ReadUInt(16)
		local sid64 = net.ReadString()

		local pinfo = PI:get(sid64, true)

		if not Player(uid):IsValid() then
			pinfo:SetUserID(uid)
		end
	end)
else
	util.AddNetworkString("PlayerInfoFill")

	function PI:NotifyEveryone()
		net.Start("PlayerInfoFill")
			net.WriteUInt(self:GetPlayer():UserID(), 16)
			net.WriteString(self:GetSteamID64())
		net.Broadcast()
	end
end

hook.Add("PlayerDisconnected", "PlayerInfoEmit", function(ply)
	local sid64 = ply:SteamID64()
	local pinfo = PIT.SteamID64[sid64]
	if not pinfo then return end

	PIT.Player[pinfo:GetPlayer()] = nil

	pinfo:Emit("Disconnect", ply)

	pinfo._AbsentSince = CurTime()
	pinfo._Absent = true

	PIT.Absent[pinfo] = pinfo._AbsentSince
end)

hook.Add("PlayerInitialSpawn", "PlayerInfoEmit", function(ply)
	local sid64 = ply:SteamID64()

	local pinfo, new = PI:get(sid64, true)

	if new then
		PIT.Player[ply] = pinfo
		pinfo:_OnReconnect()
		pinfo:NotifyEveryone()
	end

	pinfo:Emit("Connect", ply)
end)

hook.Add("PlayerAuthed", "PlayerInfoEmit", function(ply, sid)
	local pinfo = PI:get(ply)
	pinfo:Emit("StartReconnect", ply)

	pinfo._AbsentStop = CurTime()
	pinfo._Absent = false
	pinfo:NotifyEveryone()

	PIT.Absent[pinfo] = nil
end)

local function refill()
	for k,v in ipairs(player.GetAll()) do
		local pinfo = PI:get(v)
	end
end

hook.Add("InitPostEntity", "InitialFillPlayerInfo", refill)
refill()


local PLAYER = FindMetaTable("Player")
function PLAYER:GetPInfo()
	return PI:get(self)
end

function IsPlayerInfo(what)
	return istable(what) and what.IsPlayerInfo
end

function CanGetPInfo(what)
	-- can we turn the string into an ID?
	local can_turn = isstring(what) and (what:IsSteamID() or what:IsMaybeSteamID64())
	return IsPlayer(what) or can_turn or
			IsPlayerInfo(what)
end

CanGetPlayerInfo = CanGetPInfo

-- accepts SID, Player, PlayerInfo
-- accepts SID64 only if 2nd arg is true
function GetPlayerInfo(what, is_sid64)
	if not IsPlayer(what) and not isstring(what) and not IsPlayerInfo(what) then
		errorf("bad arg #1 to GetPlayerInfo" ..
			"(expected string [id], player or playerinfo, got %s)", type(what))
		return
	end

	return PI:get(what, is_sid64)
end

function GetPlayerInfoGuarantee(what, is_sid64)
	local pinfo = GetPlayerInfo(what, is_sid64)
	if not pinfo then errorf("Failed to obtain PlayerInfo using `%s` (%s)", what, type(what)) return end

	return pinfo, pinfo:GetPlayer()
end

hook.Add("NetworkableAttemptCreate", "PlayerInfo", function(nwID)
	if nwID:match("PI:(%d+)") then
		local sid64 = nwID:match("PI:(%d+)")
		GetPlayerInfoGuarantee(sid64, true)
		return true
	end
end)