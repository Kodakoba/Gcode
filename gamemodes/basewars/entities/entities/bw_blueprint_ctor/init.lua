include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")

util.AddNetworkString("BlueprintConstructor")

function ENT:Init(me)
	self.LastThink = CurTime()
end

function ENT:OpenMenu(ply)
	net.Start("BlueprintConstructor")
		net.WriteEntity(self)
	net.Send(ply)
end

function ENT:SendInfo(ply)
	if not ply and #self:GetSubscribers() == 0 then return end

	Inventory.Networking.NetworkInventory(ply or self:GetSubscribers(),
		self.Inventory, INV_NETWORK_FULLUPDATE)
end

function ENT:Think()
	local diff = CurTime() - self.LastThink
	if diff < math.max(CurTime() - self:GetNextFinish(), 0.5) or not self:GetActive() then
		return
	end

	self.LastThink = CurTime()

	if not self:IsPowered() then self:SetNextFinish(self:GetNextFinish() + diff) return end

	print("print in", CurTime() - self:GetNextFinish())

	if self:GetNextFinish() < CurTime() then
		print("printing")
		local itm = Inventory.Blueprints.Generate(self:GetBPTier(), self:GetBPType())
		itm._CtorPrinted = true
		self.Storage:InsertItem(itm):Then(function()
			self:SendInfo()
		end)

		self:SetActive(false)
		self:SetBPType("")
		self:SetBPTier(0)
	end

end

function ENT:QueueCreation(tier, type)
	self:SetActive(true)
	self:SetBPType(type)
	self:SetBPTier(tier)
	self:SetNextFinish(CurTime() + 10 * tier / 10)
end

function ENT:Use(ply)
	ply:Subscribe(self, 256)
	self:SendInfo(ply)
	self:OpenMenu(ply)
end

local bps

net.Receive("BlueprintConstructor", function(_, ply)
	bps = bps or Inventory.Blueprints

	local ent = net.ReadEntity()

	if not ent.BlueprintConstructor then return end
	if not ply:IsSubscribed(ent) then return end

	local tier = net.ReadUInt(4)
	local type = net.ReadString()

	print("attempting to create tier, type:", tier, type)

	local base_cost = Inventory.Blueprints.Costs[tier]
	if not base_cost or base_cost < 0 then
		errorf("%s attempted to craft 'tier %d' blueprint which is invalid (cost: %s)", ply, tier, base_cost)
		return
	end

	local ttype = Inventory.Blueprints.Types[type]
	if not ttype then
		errorf("%s attempted to craft '%s' tier %d blueprint which does not exist", ply, type, tier)
		return
	end

	local full_cost = Inventory.Blueprints.GetCost(tier, type)
	if not full_cost then print("no tier or type:", tier, type) return end

	print("full cost is", full_cost)

	local ok = Inventory.TakeItems(ply.Inventory.Backpack, "base_bp", full_cost)
	if not ok then print("player didnt have enough bp's (" .. full_cost .. ")") return end

	ent:QueueCreation(tier, type)
	ply:UI(ply.Inventory.Backpack)
end)