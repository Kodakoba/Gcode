--
local PLAYER = debug.getregistry().Player

BaseWars.AFK = BaseWars.AFK or {}
local AFK = BaseWars.AFK

--[==================================[
			setters
--]==================================]

function AFK.ClearAFK(ply)
	ply:SetNW2Bool("IsAFK", false)
	ply:SetNW2Float("AFK", CurTime())
	ply:SetNW2Bool("AFKFocused", true)
	hook.Run("AFKExit", ply)

	AFK.Times[ply] = CurTime()
end

function AFK.GoAFK(ply)
	ply = ply or (CLIENT and LocalPlayer())
	assert(IsPlayer(ply))

	local since = AFK.Times[ply] or CurTime() - BaseWars.Config.AFKTime
	ply:SetNW2Bool("IsAFK", true)
	ply:SetNW2Float("AFK", since)
	hook.Run("AFKEnter", ply)
end

PLAYER.GoAFK = AFK.GoAFK

--[==================================[
			initializers
--]==================================]

function AFK.PlayerInitialSpawn(ply)
	if CLIENT then return end
	ply:SetNW2Float("AFK", CurTime())
	ply:SetNW2Bool("AFK", false)
end

hook.Add("PlayerInitialSpawn", "AFKInit", AFK.PlayerInitialSpawn)

function AFK.PlayerAuth(ply)
	AFK.ClearAFK(ply)
end

hook.Add("PlayerAuth", "AFKAuth", AFK.PlayerAuth)


--[==================================[
				tracking
--]==================================]

AFK.Times = AFK.Times or {}

function AFK.ActionPerformed(ply)
	AFK.Times[ply] = CurTime()
	if ply:IsAFK() then
		AFK.ClearAFK(ply)
	end
end

function AFK.CheckPlayers()
	local ct = CurTime()
	for ply, lastMv in pairs(AFK.Times) do
		if not ply:IsValid() then AFK.Times[ply] = nil continue end

		if ct - lastMv > BaseWars.Config.AFKTime then
			AFK.GoAFK(ply)
			AFK.Times[ply] = nil
		end
	end
end

timer.Create("AFK_Checker", 1, 0, AFK.CheckPlayers)

--[==================================[
			client interface
--]==================================]
util.AddNetworkString("AFK")

net.Receive("AFK", function(len, ply)
	local mode = net.ReadUInt(2)

	if mode == AFK.CLEAR then
		AFK.ActionPerformed(ply)
	elseif mode == AFK.FOCUS then
		local focus = net.ReadBool()
		if focus == nil then return end

		ply:SetNW2Bool("AFKFocused", focus)
	end
end)

