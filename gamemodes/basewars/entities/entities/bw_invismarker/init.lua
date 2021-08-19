AddCSLuaFile("cl_init.lua")

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Base Entity"
ENT.DontCollide = true

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")

	if CLIENT then return end
	self:PhysicsInitBox(self:OBBMins(), self:OBBMaxs())
	self:GetPhysicsObject():EnableMotion(false)
	self:SetCustomCollisionCheck(true)
	--self:EnableCustomCollisions(true)
	constraint.NoCollide(self, game.GetWorld(), 0, 0)
end

function ENT:TestCollision(...)
	return false
end

hook.Add("ShouldCollide", "CollisionTest", function(a, b)
	if a.DontCollide or b.DontCollide then
		return false
	end
end)