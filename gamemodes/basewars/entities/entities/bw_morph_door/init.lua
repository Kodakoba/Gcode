include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")

function ENT:Init(me)

end

function ENT:Think()

end


function ENT:Use(ply)
	if self.HasPhysics then
		local close = self:GetOpen()

		if close then
			self:CreateCollision()
			self:SetOpen(false)
		else
			--self:PhysicsInit(SOLID_NONE)
			self:SetOpen(true)
		end
		--self:PhysicsInit(SOLID_VPHYSICS)
		--self.HasPhysics = false

		--[[self:SetBound1(Vector())
		self:SetBound2(Vector())

		self:SetInstalled(false)]]
		return
	end

	--if not allHit then ply:ChatPrint("no") return end

	self:CreateCollision()
	self:SetInstalled(true)
	self.HasPhysics = true
end

function ENT:Think()
	if self.HasPhysics then
		local phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:EnableMotion(false)
		end
	end
end