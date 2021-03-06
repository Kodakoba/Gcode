util.AddNetworkString("BaseCore")

local bw = BaseWars.Bases
local actions = {}

actions[bw.Actions.Claim] = function(ply)
	local ent = net.ReadEntity()													-- 192^2
	if not bw.IsCore(ent) or not ply:Alive() or ent:GetPos():DistToSqr(ply:GetPos()) > 36864 then
		printf("claim by %s not allowed: %s is core = %s; alive = %s; distance = %.1f.",
			ply, bw.IsCore(ent), ply:Alive(), ent:GetPos():Distance(ply:GetPos()) )
		return
	end

	ent:RequestClaim(ply)
end

net.Receive("BaseCore", function(len, ply)
	local ac = net.ReadUInt(bw.Actions.SZ)
	if not actions[ac] then errorf("Player %s attempted to request an unknown action with ID: %d.", ac) return end

	actions[ac] (ply)
end)