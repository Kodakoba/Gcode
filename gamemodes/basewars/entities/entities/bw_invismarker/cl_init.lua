ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Base Entity"
ENT.DontCollide = true

function ENT:Initialize()
	--self:SetNoDraw(true)

	self:SetCustomCollisionCheck(true)
	self:EnableCustomCollisions(true)
end

function ENT:TestCollision(...)
	return false
end

function ENT:Draw()
	local mn, mx = self:GetCollisionBounds()

	render.DrawWireframeBox(self:GetPos(), self:GetAngles(), mn, mx)
end

hook.Add("ShouldCollide", "CollisionTest", function(a, b)
	if a.DontCollide or b.DontCollide then
		return false
	end
end)