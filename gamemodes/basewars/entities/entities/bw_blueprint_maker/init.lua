include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")

util.AddNetworkString("BlueprintMaker")

function ENT:Init(me)

end

function ENT:SendInfo(ply)
	net.Start("BlueprintMaker")
		net.WriteEntity(self)
	net.Send(ply)
end

function ENT:Think()

end

function ENT:Use(ply)
	ply:Subscribe(self, 256)
	self:SendInfo(ply)
end

net.Receive("BlueprintMaker", function(_, ply)
	local ent = net.ReadEntity()

	if not ent.BlueprintMaker then return end
	if not ply:IsSubscribed(ent) then return end

	local tier = net.ReadUInt(4)
	local type = net.ReadString()

	print("attempting to create tier, type:", tier, type)

	local base_cost = Inventory.Blueprints.Costs[tier]
	if not base_cost or base_cost < 0 then errorf("%s attempted to craft 'tier %d' blueprint which is invalid (cost: %s)", ply, tier, base_cost) return end 

	local ttype = Inventory.Blueprints.Types[type]
	if not ttype then errorf("%s attempted to craft '%s' tier %d blueprint which does not exist", ply, type, tier) return end 

	local full_cost = math.floor(base_cost * (ttype.CostMult or 1))
	print("full cost is", full_cost)

end)