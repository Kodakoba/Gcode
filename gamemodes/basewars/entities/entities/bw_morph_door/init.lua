include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")

function ENT:Init(me)

end

function ENT:Think()

end


function ENT:Use(ply)
	if self.HasPhysics then
		self:PhysicsInit(SOLID_VPHYSICS)
		self.HasPhysics = false

		self:SetBound1(Vector())
		self:SetBound2(Vector())
		return
	end

	local verts, vertDist, allHit = self:GetBounds()

	--if not allHit then ply:ChatPrint("no") return end

	local mins = Vector(-self.BoxThickness, -vertDist[2], vertDist[4])
	local maxs = Vector(self.BoxThickness, vertDist[1], -vertDist[3])

	self:BoksFiziks(mins, maxs)
	self.HasPhysics = true
end

function ENT:Think()
	if self.HasPhysics then
		local phys = self:GetPhysicsObject()
		if phys then
			phys:EnableMotion(false)
		end
	end
end