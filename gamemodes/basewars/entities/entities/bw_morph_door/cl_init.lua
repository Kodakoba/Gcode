include("shared.lua")
AddCSLuaFile("shared.lua")


function ENT:CLInit()

end


local cols = {
	[true] = Colors.Green:Copy(),
	[false] = Colors.Red:Copy()
}

for k,v in pairs(cols) do
	v.a = 50
end

function ENT:GenerateMesh(vectbl)
	self.DoorMesh = Mesh()
	local msh = self.DoorMesh

end

function ENT:Draw()
	self:DrawModel()

	--sides[1], sides[2] = self:GetRight(), self:GetUp()
	local pos = self:GetPos()

	local verts, vertDist, all_hit = self:GetBounds()

	local mins = Vector(-self.BoxThickness, -vertDist[2], vertDist[4])
	local maxs = Vector(self.BoxThickness, vertDist[1], -vertDist[3])

	OrderVectors(mins, maxs)
	--[[local uz, dz = math.max(verts[3].z, verts[1].z), math.min(verts[4].z, verts[2].z)

	verts[3]:Set(verts[2])
	verts[3].z = uz

	verts[4]:Set(verts[1])
	verts[4].z = dz

	verts[1].z = uz
	verts[2].z = dz]]

	render.SetColorMaterial()
	render.DrawQuad(verts[1], verts[3], verts[2], verts[4], cols[all_hit])

	render.DrawWireframeBox(pos, self:GetAngles(), mins, maxs, color_white)
end