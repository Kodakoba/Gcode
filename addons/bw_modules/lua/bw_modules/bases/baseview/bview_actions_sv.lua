util.AddNetworkString("BaseCore")

local bw = BaseWars.Bases
local bv = bw.BaseView
local ac = bv.Actions

local actions = {}

actions[ac.Enum.Claim] = function(ply)
	local ent = net.ReadEntity()													-- 192^2
	if not bw.IsCore(ent) or not ply:Alive() or ent:GetPos():DistToSqr(ply:GetPos()) > 36864 then return end

	ent:RequestClaim(ply)
end

net.Receive("BaseCore", function(len, ply)

end)