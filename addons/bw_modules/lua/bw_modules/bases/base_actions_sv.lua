util.AddNetworkString("BaseCore")

local bw = BaseWars.Bases
local actions = {}

if not bw.Actions then
	include("base_actions.lua")
end

actions[bw.Actions.Claim] = function(ply)
	local ent = net.ReadEntity()
	if not bw.IsCore(ent) or not ply:Alive() or
		ent:GetPos():DistToSqr(ply:GetPos()) > 192^2 then
		printf("claim by %s not allowed: %s is core = %s; alive = %s; distance = %.1f.",
			ply, bw.IsCore(ent), ply:Alive(), ent:GetPos():Distance(ply:GetPos()) )
		return
	end

	ent:RequestClaim(ply)
end

actions[bw.Actions.Unclaim] = function(ply)
	local ent = net.ReadEntity()
	if not bw.IsCore(ent) or not ply:Alive() or
		ent:GetPos():DistToSqr(ply:GetPos()) > 192^2 then
		printf("unclaim by %s not allowed: %s is core = %s; alive = %s; distance = %.1f.",
			ply, bw.IsCore(ent), ply:Alive(), ent:GetPos():Distance(ply:GetPos()) )
		return
	end

	local base = ent:GetBase()
	if not base:IsOwner(ply) then
		printf("unclaim by %s not allowed: hostile unclaim not implemented", ply )
		return
	end

	--[[local fac, plys = base:GetOwner()
	if fac and fac:GetOwnerInfo() ~= GetPlayerInfo(ply) then
		printf("unclaim by %s not allowed: not owner of the faction `%s` (owner: %s)",
			ply, fac, fac:GetOwnerInfo())
		return
	end]]

	ent:RequestUnclaim(ply)
end

net.Receive("BaseCore", function(len, ply)
	local ac = net.ReadUInt(bw.Actions.SZ)
	if not actions[ac] then errorf("Player %s attempted to request an unknown action with ID: %d.", ac) return end

	actions[ac] (ply)
end)