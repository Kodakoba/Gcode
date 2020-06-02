Memes = Memes or {}

local size = 64

local quad = {
	{ pos = Vector(0,  0,  0), u = 0, v = 0, normal = Vector(0, 1, 0) }, 	-- TL
	{ pos = Vector(size, 0,  0), u = 1, v = 0, normal = Vector(0, 1, 0) }, 	-- TR
	{ pos = Vector(size, 0, size), u = 1, v = 1, normal = Vector(0, 1, 0) }, 	-- BR
	{ pos = Vector(0, 0, size), u = 0, v = 1, normal = Vector(0, 1, 0) }, 	-- BL
}

local novec, noang = Vector(), Angle()

local function MakeMesh(dat, mat)
	--[[
	accepts a table:
		{
			Mesh = generated mesh, if it doesnt exist this will generate it,
			color = optional, color structure
			Pos = position where to draw the mesh
			Ang = angle at which to draw the mesh
			Normal = normal vector for lighting, optional but don't expect proper lighting if you dont specify this
		}

	]]
	if not dat.Mesh then
		print(mat)
		local m = Mesh(mat)
		dat.Mesh = m

		local col = dat.Color or Color(200, 200, 200)


		mesh.Begin(m, MATERIAL_QUADS, 1)

			xpcall(function()
				local w, h = dat.MeshW, dat.MeshH

				local pos = dat.Pos or novec
				local ang = dat.Ang or noang

				local right = ang:Right()
				local down = -(ang:Up())

				mesh.Position( pos ) -- TL
				mesh.Normal(dat.Normal or novec)
				mesh.Color(col.r, col.g, col.b, col.a)
				mesh.TexCoord(0, 0, 0)
				mesh.AdvanceVertex()

				mesh.Position( pos + right * w ) -- TR
				mesh.Normal(dat.Normal or novec)
				mesh.Color(col.r, col.g, col.b, col.a)
				mesh.TexCoord(0, 1, 0)
				mesh.AdvanceVertex()

				mesh.Position( pos + right * w + down * h ) -- BR
				mesh.Normal(dat.Normal or novec)
				mesh.Color(col.r, col.g, col.b, col.a)
				mesh.TexCoord(0, 1, 1)
				mesh.AdvanceVertex()

				mesh.Position( pos + down * h ) -- BL
				mesh.Normal(dat.Normal or novec)
				mesh.Color(col.r, col.g, col.b, col.a)
				mesh.TexCoord(0, 0, 1)
				mesh.AdvanceVertex()

			end, function(err)
				print("u fucked up", err)
			end)

		mesh.End()

	end

	return dat.Mesh
end

Memes.MakeMesh = MakeMesh

local col = Color(150, 150, 150)

local function RTRender(make2d, rt, func) --if make2d, make ur own 2d context

	--local w, h = ScrW(), ScrH()
	local w, h = rt:Width(), rt:Height()

	render.PushRenderTarget(rt)

		if make2d then
			cam.Start2D()
		end

			render.Clear(0, 0, 0, 0)
			render.OverrideAlphaWriteEnable(true, true)

			local ok, err = pcall(func, w, h)

			render.OverrideAlphaWriteEnable(false, false)

		if make2d then
			cam.End2D()
		end

	render.PopRenderTarget()

	if not ok then
		print("Decal error:", err)
	end

end

local function CreateRTAndMat(dec)

	local rt = dec.RT or draw.GetRT(dec.Name .. "Decal", dec.RTW, dec.RTH)
	dec.RT = rt

	local mat = dec.Mat or CreateMaterial(dec.Name, "VertexLitGeneric", {
		["$basetexture"] = rt:GetName(),
		["$translucent"] = 1,
		["$vertexalpha"] = 1,
		["$vertexcolor"] = 1,
	})

	mat:SetTexture("$basetexture", rt:GetName()) --in the event it changed

	if not dec.Mat or dec.RTUpdate or dec.NeedsMorePaint then
		dec.NeedsMorePaint = (RTRender(true, rt, dec.RTPaint) ~= nil)
	end

	dec.Mat = mat

	return mat, rt
end

local handle = util.GetPixelVisibleHandle()
local vis = 0

hook.Add("PostDrawTranslucentRenderables", "mittyvis", function()

	local lp = EyePos()

	for k,v in pairs(Memes.Decals) do
		local dist = lp:DistToSqr(v.PixPos)

		if dist > v.MaxDistSqr then
			v.Vis = 0
		elseif dist < v.PixRadSqr then
			v.Vis = 1
		else
			v.Vis = util.PixelVisible(v.PixPos or v.Pos, v.PixRad or 32, v.PixVisHandle)
		end

	end

end)

Memes.Decals = Memes.Decals or {}

hook.Remove("PostDrawViewModel", "mittypls")
for k,v in pairs(hook.GetTable()) do if v.mittypls then hook.Remove(k, "mittypls") end end

hook.Add("PostDrawTranslucentRenderables", "mittypls", function(bd, bs)

	if bd or bs then return end

	render.SuppressEngineLighting(true)
	for k,v in pairs(Memes.Decals) do
		if not v.Vis or v.Vis > 0 then

			local lr = render.ComputeLighting(v.Middle, v.Normal)--:Unpack()
			lr:Mul(v.LightMultiplication or 1)

			local rt, mat = CreateRTAndMat(v)
			local mesh = MakeMesh(v, rt)

			if not mesh then return end

			local w, h = ScrW(), ScrH()

			cam.PushModelMatrix(v.Matrix)

				local ok, err = pcall(function()

					v.Mat:SetVector("$color", lr)
					render.SetMaterial(v.Mat)

					mesh:Draw()

					if LocalPlayer():FlashlightIsOn() then
						v.Mat:SetVector("$color", Vector(1, 1, 1))
						render.PushFlashlightMode(true)
							mesh:Draw()
						render.PopFlashlightMode()
					end

				end)

			cam.PopModelMatrix()

			--render.DrawLine(v.Pos, v.Pos + v.Normal * 32)
			if not ok then
				print("failed during decal draw:", err)
				return
			end
		end
	end
	render.SuppressEngineLighting(false)
end)


function Memes.AddDecal(name, pos, ang, scale, normal, col, rtpaint, rtupd, pixpos, pixrad, mw, mh, rtw, rth, light)

	--[[
		name: string
		pos: vec
		ang: angle
		scale: vec
		normal: vec for light calculation by mesh
		col: color

		rtpaint: function to paint on top of rt
			gets called with RT width and height args
			return anything in this function if it needs to be rerendered next frame (for example, ur still downloading the required mat)

		rtupd: if true, RT will do rtpaint every frame

		pixpos: where to check for pixel visibility, pos by default
		pixrad: radius to check for pixel visibility, 32 by default

		meshw = mesh width  ]
		meshh = mesh height ] 64 by default

		rtw = RT width  ]
		rth = RT height ] 128 by default

		------------
		todo: make this function return a decal object so
			  you don't have to give so many args
	]]

	if not rtpaint then error("rtpaint mandatory") return end

	local d = {}

	d.Name = name

	local mtrx = Matrix()
	d.Matrix = mtrx

	scale = (isnumber(scale) and Vector(scale, scale, scale)) or scale

	mtrx:Translate(pos)
		mtrx:SetScale(scale)
	mtrx:Translate(-pos)

	d.Normal = normal or ang:Right()

	d.Pos = pos
	d.Ang = ang
	d.Scale = scale

	d.PixVisHandle = util.GetPixelVisibleHandle()
	d.PixPos = pixpos or pos
	d.PixRad = pixrad or 32
	d.PixRadSqr = (d.PixRad ^ 2) * 2

	d.RTPaint = rtpaint
	d.RTUpdate = rtupd

	d.MeshW = mw or 64
	d.MeshH = mh or 64

	d.RTW = rtw or 128
	d.RTH = rth or 128

	d.MaxDistSqr = 1024^2
	d.LightMultiplication = light
	d.Middle = d.Pos + (d.Ang:Right() * d.MeshW * scale / 2) - (d.Ang:Up() * d.MeshH * scale / 2)
	Memes.Decals[name] = d
end



local mia, mitty



hook.Add("ChatHUDEmotesUpdated", "mittymeme", function(col)
	mia = col.MadeInAbyss
	if not mia then return end

	mitty = mia:GetEmotes().MittyElevator
	if not mitty then return end

	if mitty then
		mitty:Download()

		local where = Vector (-7823.2, -8613.3, -1293.35)
		local viswhere = Vector (-7811, -8618.03125, -1306.9388427734)

		local ang = Angle(-180, -90, 180)
		local scale = Vector(0.3, 0.3, 0.3)

		Memes.AddDecal("mitty", where, ang, scale, Vector(0, -1, 0), nil,
			function(w, h)
				if not mitty:Exists() or (mitty:Exists() and mitty:IsDownloading()) then return true end --need downloading

				surface.SetDrawColor(color_white)
				mitty:Paint(0, 0, 128, 128)
			end,
		false, viswhere, 32)
	end


end)

local stuck_where = Vector (-820.6, 44.415222167969, 485)

--Vector (-825.44427490234, 46.31368637085, 470.28253173828)
local stuck_ang = Angle(0, -111.6, 0)
local scale = Vector(0.2, 0.2, 0.2)

Memes.AddDecal("stuck", stuck_where, stuck_ang, scale, Vector(0.5, 1, 0), nil,
	function(w, h)
		draw.RoundedBox(16, 0, 0, w, h, ColorAlpha(Colors.DarkGray, 240))
		draw.SimpleText("Getting stuck is PROHIBITED.", "MR72", w/2, 0, Colors.Red, 1, 0)
		draw.SimpleText("If you are stuck, CEASE IMMEDIATELY.", "MR48", w/2, 72, Colors.Red, 1, 0)
	end,
false, stuck_where + stuck_ang:Right() * 128 * 0.2, 20, 256, 32, 1024, 128)

local function addMaN(ffz)
	local man = ffz:GetEmotes().MaN

	if man then
		man:Download()

		local where = Vector (3128.03, 5761.3, 166)
		local ang = Angle (180, 0, 180)
		local scale = Vector(0.05, 0.05, 0.05)

		Memes.AddDecal("pillarMaN", where, ang, scale, Vector(1, 0, 0), nil,
			function(w, h)
				if not man:Exists() or (man:Exists() and man:IsDownloading()) then return true end
				surface.SetDrawColor(color_white)
				man:Paint(0, 0, 128, 128)
			end,
		false, where, 8, nil, nil, nil, nil, 10)
	end
end

hook.Add("ChatHUDFFZUpdated", "manmeme", addMaN)

if Emotes and Emotes.Collections.FFZ then
	addMaN(Emotes.Collections.FFZ)
end