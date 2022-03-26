easylua.StartEntity("stencil_lol")

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "lol"
ENT.Model = "models/props_interiors/bathtub01a.mdl"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local vecs = {
	"39.536098 19.347164 17.781855",
	"32.734222 25.246820 17.820553",
	"-42.914150 24.302975 17.691286",
	"-45 18.058834 17.859316",
	"-45 -4.778322 17.874786",
	"-42.896866 -10.244874 17.856885",
	"32.202637 -12 17.820549",
	"38.202637 -9.278468 17.820549",
	"40.886834 -7.478467 17.782646",
	"44.430828 -3.030275 17.773338",
	"45.430828 -0.030275 17.773338",
	"46.430828 3.030275 17.773338",
	"46.425951 10.448728 17.770561",
	"43.525951 16.448728 17.770561",
	"40.525951 20.448728 17.770561",
}

for k,v in ipairs(vecs) do vecs[k] = Vector(v) end

if _MESH then _MESH:Destroy() end

local ms
if CLIENT then
	_MESH = Mesh()
	ms = _MESH

	mesh.Begin(ms, MATERIAL_POLYGON, #vecs + 2)
		--[[mesh.Position(vector_origin)
		mesh.Color(255, 255, 255, 0)
		mesh.AdvanceVertex()]]

		for i=#vecs, 1, -1 do
			mesh.Position(vecs[i])
			mesh.Color(0, 0, 0, 0)
			mesh.AdvanceVertex()
		end

		mesh.Position(vecs[#vecs])
		mesh.Color(0, 0, 0, 0)
		mesh.AdvanceVertex()

		--[[for i=1, 33 do
			local deg = math.rad(360 / 32 * i)

			local cos = math.cos(deg)
			local sin = math.sin(deg)
			sin = math.abs(sin) ^ 0.5 * math.Sign(sin)
			print(sin, i)

			mesh.Position(Vector(
				cos * 48,
				6 + sin * 16,
				-16
			))

			--mesh.TexCoord(0, math.cos(deg), math.sin(deg))
			mesh.Color(255, 255, 255, 255)
			mesh.AdvanceVertex()
		end]]
	mesh.End()
end

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		--self:PhysicsInit(SOLID_VPHYSICS)
		--self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInitBox(
			Vector (-40.786346435547, -9.5917730331421, 17.64867401123),
			Vector (42.420059204102, 20.204027175903, 23.776845932007)
		)
	end
end

local mat = Material("vgui/null")

function ENT:Draw()
	if halo.RenderedEntity() == self then self:DrawModel() return end

	local mx = self:GetWorldTransformMatrix()
	--mx:Rotate(Angle(180, 0, 0))

	self:DrawModel()

	render.SetMaterial(mat)
	cam.PushModelMatrix(mx, true)
		draw.StartMask()
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_ALWAYS)
			render.SetStencilPassOperation(STENCIL_REPLACE)
			render.SetStencilZFailOperation(STENCIL_ZERO)
			render.ClearStencil()
			ms:Draw()
		draw.DrawOp()
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			cam.IgnoreZ(true)
				self:DrawModel()
			cam.IgnoreZ(false)
		draw.FinishMask()
	cam.PopModelMatrix()

	--self:DrawModel()
end

easylua.EndEntity()