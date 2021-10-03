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

	return err
end

local function CreateRTAndMat(dec)

	local rt = dec.RT or draw.GetRT(dec.Name .. "Decal", dec.RTW, dec.RTH)
	dec.RT = rt

	local mat = dec.Mat
	if not mat then
		mat = CreateMaterial(dec.Name, "VertexLitGeneric", {
			["$basetexture"] = rt:GetName(),
			["$translucent"] = 1,
			["$vertexalpha"] = 1,
			["$vertexcolor"] = 1,
		})
	end

	mat:SetTexture("$basetexture", rt:GetName()) --in the event it changed

	if not dec.Mat or dec.RTUpdate or dec.NeedsMorePaint then
		dec.NeedsMorePaint = (RTRender(true, rt, dec.RTPaint) ~= nil)
	end

	dec.Mat = mat

	return mat, rt
end

hook.Add("PostDrawTranslucentRenderables", "mittyvis", function(sb, dpth)
	if sb or dpth then return end

	local lp = EyePos()

	for k,v in pairs(Memes.Decals) do
		if not v.PixPos then continue end

		local dist = lp:DistToSqr(v.PixPos)

		if dist > v.MaxDistSqr then
			v.Vis = 0
		elseif dist < v.PixRadSqr then
			v.Vis = 1
		else
			v.Vis = util.PixelVisible(v.PixPos or v.Pos, v.PixRad or 32, v.PixVisHandle)
			--render.SetColorMaterialIgnoreZ()
			--render.DrawSphere(v.PixPos or v.Pos, 8, 16, 16, color_white)
		end

		v:Emit("CheckVis", v.Vis)
	end

end)

Memes.Decals = Memes.Decals or {}

local function drawDecal(v, lp)
	local rt, mat = CreateRTAndMat(v)
	local mesh = MakeMesh(v, rt)
	if not mesh then return end

	local lr = render.ComputeLighting(v.Middle, v.Normal)--:Unpack()
	lr:Mul(v.LightMultiplication or 1)

	v.Mat:SetVector("$color", lr)
	render.SetMaterial(v.Mat)

	mesh:Draw()

	if lp:FlashlightIsOn() then
		v.Mat:SetVector("$color", Vector(1, 1, 1))
		render.PushFlashlightMode(true)
			mesh:Draw()
		render.PopFlashlightMode()
	end
end

hook.Add("PostDrawTranslucentRenderables", "mittypls", function(bd, bs)
	if bd or bs then return end

	render.SuppressEngineLighting(true)
	local lp = LocalPlayer()

	for k,v in pairs(Memes.Decals) do
		if not v.Vis or v.Vis > 0 then

			cam.PushModelMatrix(v.Matrix)
				local ok, err = pcall(drawDecal, v, lp)
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

Memes.Decal = Memes.Decal or Emitter:extend()
local dec = Memes.Decal

ChainAccessor(dec, "Name", "Name")
ChainAccessor(dec, "Matrix", "Matrix")
ChainAccessor(dec, "Normal", "Normal")
ChainAccessor(dec, "Pos", "Pos")
ChainAccessor(dec, "Ang", "Ang")
ChainAccessor(dec, "Scale", "Scale")
ChainAccessor(dec, "PixPos", "PixPos")
ChainAccessor(dec, "PixRad", "PixRad")
ChainAccessor(dec, "RTPaint", "RTPaint")
ChainAccessor(dec, "RTUpdate", "RTUpdate")
ChainAccessor(dec, "MeshW", "MeshW")
ChainAccessor(dec, "MeshH", "MeshH")
ChainAccessor(dec, "Color", "Color")

ChainAccessor(dec, "RtW", "RtW")
ChainAccessor(dec, "RtH", "RtH")

ChainAccessor(dec, "LightMultiplication", "Light")
ChainAccessor(dec, "Middle", "Middle")

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

		light = light multiplication for correction
		------------
		todo: make this function return a decal object so
			  you don't have to give so many args
	]]

	local d = Memes.Decal:new()

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

	d.MeshW = mw or 64
	d.MeshH = mh or 64

	d.RTW = rtw or 128
	d.RTH = rth or 128

	d.PixVisHandle = util.GetPixelVisibleHandle()
	d.PixPos = pixpos or (pos + ang:Right() * d.MeshW / 2 * d.Scale + ang:Up() * -d.MeshH / 2 * d.Scale)

	d.PixRad = pixrad or 32
	d.PixRadSqr = (d.PixRad ^ 2) * 2

	d.RTPaint = rtpaint or BlankFunc
	d.RTUpdate = rtupd

	d.MaxDistSqr = 1024^2
	d.LightMultiplication = light
	d.Middle = d.Pos + (d.Ang:Right() * d.MeshW * scale / 2) - (d.Ang:Up() * d.MeshH * scale / 2)
	Memes.Decals[name] = d

	return d
end


if not game.GetMap():find("evocity") then return end

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

		local dec = Memes.AddDecal("mitty", where, ang, scale, Vector(0, -1, 0))
		dec:SetRTPaint(function(w, h)
			if not mitty:Exists() or (mitty:Exists() and mitty:IsDownloading()) then return true end --need downloading

			surface.SetDrawColor(color_white)
			mitty:Paint(0, 0, 128, 128)
		end)

		dec:SetRTUpdate(false)
		dec:SetPixPos(viswhere)
	end


end)

do
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
end

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


do
	local pos = Vector(11995, 2069, 208.4)
	local ang = Angle(193, -15, 180)
	local scale = 0.2
	local normal = -ang:Forward()
	local col = color_white

	local url = "http://vaati.net/Gachi/shared/cerber_1.png"

	local rt = function(w, h)
	    surface.SetDrawColor(col)
	    draw.DrawGIF(url, "cerber", 0, 0, w, h, nil, nil, nil, 7)
	end

	local dec = Memes.AddDecal("cerberus", pos, ang, scale, normal)

	dec:SetColor(col)
	dec:SetRTPaint(rt)
	dec:SetRTUpdate(true)
	dec:SetPixPos(viswhere)
	dec:SetLight(4)
end

do
	local pos = Vector (-7220.75390625, -4795.423828125, 173.40898132324)
	local ang = Angle(0.54, -180.38, 0)
	local scale = 0.2
	local normal = -ang:Forward()
	local col = color_white


	local url = "https://i.imgur.com/nsUQcic.png"

	local rt = function(w, h)
	    surface.SetDrawColor(col)
	    local ret = surface.DrawMaterial(url, "jermy_clrkson.png", 0, 0, w, h)
	    if not ret then return false end
	end

	local dec = Memes.AddDecal("kfc_man", pos, ang, scale, normal)

	dec:SetColor(col)
	dec:SetRTPaint(rt)
	dec:SetRTUpdate(false)
	dec:SetPixPos(viswhere)
	dec:SetLight(4)
	dec:SetMeshW(128)
	dec:SetMeshH(256)
	dec:SetRtW(128)
	dec:SetRtH(256)
	dec:On("CheckVis", "lmao", function(self, vis)
		render.DrawWireframeSphere(self.PixPos, 16, 16, 16, color_white, false)
	end)
end

do
	local pos = Vector(4409.6293945313, -3619.03125, 200.04418945313)
	local ang = Angle(180, -90, 180)
	local scale = 0.5
	local normal = -ang:Forward()
	local col = color_white

	local stage = 0

	local not_looked = false
	local looked = false
	local looking = false

	local url = "http://vaati.net/Gachi/shared/thicc.png"
	local url2 = "https://i.imgur.com/TRh8Lq6.png"

	local snds = {
		{"https://vaati.net/Gachi/shared/snail1.mp3", 1.2, 2},
		{"https://vaati.net/Gachi/shared/sn2.mp3", 1.2, 2},
		{"https://vaati.net/Gachi/shared/sn3.mp3", 1.6, 2.4},
		{"https://vaati.net/Gachi/shared/sn4.mp3", 0, 0.8},
	}

	for k,v in pairs(snds) do
		hdl.DownloadFile(v[1], "mus/snail_" .. k .. ".dat", print, ErrorNoHalt)
	end

	local ratio = 349 / 893
	local thiccratio = 2048 / 1927
	local numPlay = 1

	local playTime = 0
	local startTime = 0
	local stopTime = 0

	local thicc = false

	local d = Memes.AddDecal("thicc", pos, ang, scale, normal, col, nil, nil, nil, 100, 256, 256, 1024, 1024, 4)

	local rt = function(w, h)
		local lookedFor = looked and CurTime() - looked
		thicc = SysTime() > startTime and SysTime() < stopTime

	    surface.SetDrawColor(col)

	    if not thicc then
	    	local sz = h * ratio
	    	local have = surface.DrawMaterial(url2, "omni.png", w / 2 - sz / 2, 20, sz, h)
	    	if not have then return true end
	    else
	    	playTime = 0
	    	local sc = 0.8
	    	local sz = h / thiccratio
	    	local tw, th = w * sc, sz * sc
	    	local have = surface.DrawMaterial(url, "thiccomni.png", w / 2 - tw / 2, h - th, tw, th)
	    	if not have then return true end
	    end
	    --draw.DrawGIF(url, "cerber", 0, 0, w, h, nil, nil, nil, 7)
	end


	d:SetRTPaint(rt)
	d:SetRTUpdate(true)
	d:On("CheckVis", "lmao", function(self, vis)
		if LocalPlayer():GetPos():DistToSqr(self.PixPos or vector_origin) > 262144 then
			looked = false not_looked = CurTime()
			return
		end

		looking = vis > 0

		if not looking then
			looked = false
			not_looked = not_looked or CurTime()
		else
			not_looked = false
			looked = looked or (vis > 0.2 and CurTime())
		end

		if not looking and CurTime() - not_looked > 5 and playTime == 0 and snds[numPlay] then

			playTime = SysTime()

			sound.PlayFile("data/hdl/mus/snail_" .. numPlay .. ".dat", "noplay 3d", function(ch, eid, en)
				playTime = -1
				if not IsValid(ch) then return end
				ch:Play()
				ch:SetVolume(2)
				ch:SetPos(self.PixPos)
				playTime = SysTime()
				print("numPlay", numPlay)
				startTime = snds[numPlay][2] + playTime
				stopTime = playTime + (snds[numPlay][3] or ch:GetLength())
				numPlay = numPlay + 1
			end)


		end

		if not looking and CurTime() - not_looked > 30 then
			numPlay = 1
		end
	end)
end

--https://i.imgur.com/ktA8pLc.jpeg