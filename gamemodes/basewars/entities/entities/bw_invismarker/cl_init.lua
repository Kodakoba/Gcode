ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Base Entity"
ENT.DontCollide = true

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	self:SetNoDraw(true)

	self:SetCustomCollisionCheck(true)
	self:EnableCustomCollisions(true)
end

function ENT:TestCollision(...)
	return false
end

hook.Add("ShouldCollide", "CollisionTest", function(a, b)
	if a.DontCollide or b.DontCollide then
		return false
	end
end)