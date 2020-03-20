--hi

local mesh_global		--global mesh: vertices of this mesh are global
local mesh_local 		--local mesh: positions of this mesh are local to 0,0,0
local mtrx = Matrix()

local whereglob = Vector (-5524.6411132813, -4492.7807617188, 217.62652587891) --where to draw the global-pos mesh
local wherelocal = Vector (-5534.6411132813, -4492.7807617188, 217.62652587891) --where to draw the local-pos mesh (translated via matrix)

local globang = Angle(180, 270, 0)
local locang = Angle(180, 90, 0) 	--idk why but global and local angles differ, maybe i messed up the maths in "globquad"
									--shouldn't matter for lighting anyways

local globcol = Color(0, 255, 0)	--global pos color is green
local loccol = Color(0, 0, 255)		--local pos color is green
							
									--for some reason the mat i picked doesnt wanna use these colors ^ 
									--you can identify which is which by the lines though, they hit the top-left of the mesh
local normalglob = globang:Forward()
local normalloc = Vector(0, 1, 0)--globang:Forward()--locang:Right()

local size = 48 

local locquad = {
	{ pos = Vector(0,  0,  0), u = 0, v = 0 }, 		-- TL
	{ pos = Vector(size, 0,  0), u = 1, v = 0 }, 	-- TR
	{ pos = Vector(size, 0, size), u = 1, v = 1 }, 	-- BR
	{ pos = Vector(0, 0, size), u = 0, v = 1 }, 	-- BL
}

local globquad = {
	{ pos = whereglob, u = 0, v = 0 }, 											-- TL
	{ pos = whereglob + globang:Right() * size, u = 1, v = 0 }, 						-- TR
	{ pos = whereglob + globang:Right() * size + globang:Up() * size, u = 1, v = 1 }, 	-- BR
	{ pos = whereglob + globang:Up() * size, u = 0, v = 1 }, 							-- BL
}

local mat = CreateMaterial("muhmesh2", "VertexLitGeneric", {
	["$basetexture"] = "phoenix_storms/lag_sign",
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$vertexcolor"] = 1,
})

local function GetMeshes()

	if not mesh_global then --generate new meshes
		local gm = Mesh()
		local lm = Mesh()

		mesh.Begin(gm, MATERIAL_QUADS, 1) --generate mesh with global coords

			for k,v in ipairs(globquad) do 
				mesh.Position(v.pos)
				mesh.Normal(normalglob)
				mesh.Color(globcol.r, globcol.g, globcol.b, globcol.a)
				mesh.TexCoord(0, v.u, v.v)
				mesh.AdvanceVertex()
			end

		mesh.End()

		mesh.Begin(lm, MATERIAL_QUADS, 1) --generate mesh with local coords

			for k,v in ipairs(locquad) do 
				mesh.Position(v.pos)
				mesh.Normal(normalloc)
				mesh.Color(loccol.r, loccol.g, loccol.b, loccol.a)
				mesh.TexCoord(0, v.u, v.v)
				mesh.AdvanceVertex()
			end

		mesh.End()

		mtrx:SetTranslation(wherelocal)
		mtrx:SetAngles(locang)

		mesh_global = gm 
		mesh_local = lm

		MeshGlob = mesh_global
		MeshLoc = mesh_local
	end

	return mesh_global, mesh_local
end
--[[

hook.Add("PostDrawTranslucentRenderables", "draww", function() end)

hook.Add("PostDrawEffects", "draww", function()
	cam.Start3D()

	local gm, lm = GetMeshes()
	local flashon = LocalPlayer():FlashlightIsOn()
	render.SetMaterial(mat)
	gm:Draw()

	render.PushFlashlightMode(flashon) 	--draw projected textures on the global mesh
		gm:Draw()
	render.PopFlashlightMode()

	cam.PushModelMatrix(mtrx)	--push a matrix which has pos+angle data for local mesh
		lm:Draw()

		render.PushFlashlightMode(flashon)	--local mesh won't work apparently with projected textures (tho they worked for me before????????????????)
			lm:Draw()
		render.PopFlashlightMode()

	cam.PopModelMatrix()

	render.DrawLine(whereglob, whereglob + normalglob * 32, globcol) --display normals' lines
	render.DrawLine(wherelocal, wherelocal + normalloc * 32, loccol)

	cam.End3D()
end)]]