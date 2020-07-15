include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")

util.AddNetworkString("BlueprintPrinter")

function ENT:Init(me)
	self.LastPrint = CurTime()
end

function ENT:SendInfo(ply)
	if not ply and #self:GetSubscribers() == 0 then return end
	Inventory.Networking.NetworkInventory(ply or self:GetSubscribers()--[[Filter(ents.FindInPVS(self), true):Filter(IsPlayer)]], self.Inventory, INV_NETWORK_FULLUPDATE)
end

function ENT:IsFull()

	for i=1, self.Storage.MaxItems do
		local it = self.Storage.Slots[i]
		if not it then return false end

		if it:GetAmount() ~= it:GetBase():GetMaxStack() then return false end
	end

	return true

end

function ENT:Think()
	local me = BWEnts[self]

	if self:GetJammed() then
		if self:IsFull() then
			self.LastPrint = CurTime()
			return
		else
			self:SetJammed(false)
			self:SetNextFinish(self.LastPrint + self.PrintTime)
		end
	end

	if CurTime() - self.LastPrint >= self.PrintTime then

		if self:IsFull() then self:SetJammed(true) return end

		self.Storage:NewItem("base_bp", function()
			self:SendInfo()
		end, nil, nil, nil, true)

		self.LastPrint = CurTime()

	end

	self:SetNextFinish(self.LastPrint + self.PrintTime)
end

function ENT:Use(ply)
	ply:Subscribe(self, 256)
	self:SendInfo(ply)
	net.Start("BlueprintPrinter")
		net.WriteEntity(self)
	net.Send(ply)
end

net.Receive("BlueprintPrinter", function(_, ply)
	local ent = net.ReadEntity()

	if not ent.BlueprintPrinter then return end
	if not ply:IsSubscribed(ent) then return end

	--self:SendInfo(ply)
end)