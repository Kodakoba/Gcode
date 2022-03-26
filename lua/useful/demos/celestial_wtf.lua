local bg = Color(2, 11, 21)

local gr = Color(70, 230, 145)
local red = Color(210, 80, 90)
local blu = Color(50, 120, 210)

local dw, dh = ScrW() * 1, ScrH() * 1

local brt = GetRenderTarget("celestial2", dw, dh)
local brmat = CreateMaterial("celestial_mat4", "UnlitGeneric", {
	["$basetexture"] = brt:GetName(),
	--["$translucent"] = 1,
	["$vertexcolor"] = 1,
	--["$vertexalpha"] = 1,
})

local vec = Vector()
local v2 = Vector(0, dh / 2)

local m1 = Matrix()

local t = 0--math.random() * 10000

local ct = CurTime
local CurTime = function()
	return ct() * 10
end

local col = Color(255, 255, 255, 220)

local function DrawCircle(x, y, rad)
	rad = rad * 2
	surface.DrawTexturedRect(x - rad / 2, y - rad / 2, rad, rad)
end

local circMat = Material("data/" .. cdn.Folder .. "/materials/circle_cel.png")
local circFetching

local function blurs(w, h)

	if circMat:IsError() then
		if not circFetching then
			http.Fetch("https://i.imgur.com/6SdL8ff.png", function(b)
				file.Write(cdn.Folder .. "/materials/circle_cel.png", b)
				circMat = Material("data/" .. cdn.Folder .. "/materials/circle_cel.png", "smooth ignorez")
			end, function()
				print("faileled")
			end)

			circFetching = true
		end

		return
	end

	local sin = math.sin(CurTime() * 0.2)
	local cos = math.cos(CurTime() * 0.12)

	vec.x, vec.y = 1, 1

	m1:fReset()
	local sw, sh = ScrW(), ScrH()

	w = w or dw
	h = h or dh

	cam.Start2D()
	render.PushRenderTarget(brt, 0, 0, w, h)
	render.OverrideAlphaWriteEnable(true, true)
	render.ClearDepth()
	render.Clear(0, 0, 0, 0)
	render.PushFilterMag(TEXFILTER.ANISOTROPIC)
	render.PushFilterMin(TEXFILTER.ANISOTROPIC)
		m1:Translate(v2)
			m1:Scale(vec)
		m1:Translate(-v2)

		cam.PushModelMatrix(m1, true)
			surface.DisableClipping(true)
				surface.SetMaterial(circMat)

				gr.a = 60
				surface.SetDrawColor(gr:Unpack())
				DrawCircle(w * 0.1 + w*0.05*sin, h * 1.05 + h * 0.1 * sin, h * 0.4 + h * 0.05 * cos, 64)
				DrawCircle(w * 1.1 + w*0.04*cos, h * 0.2, h * 0.6, 64)

				red.a = 35 + cos * 5
				surface.SetDrawColor(red:Unpack())
				DrawCircle(w * 0.55, h * 0.35, h * 0.4, 64)

				red.a = 45 + sin * 5
				surface.SetDrawColor(red:Unpack())
				DrawCircle(w * 0.6 + w*0.06*sin, h * 0.65 + h*0.03*cos, h * 0.2 + h * 0.05 * cos, 64)

				blu.a = 55 + cos * 5
				surface.SetDrawColor(blu:Unpack())
				DrawCircle(w * 0.7 + w * 0.1 * sin, h * 1 - h * 0.03 * sin, h * 0.4, 64)
				DrawCircle(w * 0.3 + w * 0.04 * cos, h * -0.1, h * 0.4, 64)

			surface.DisableClipping(false)
		cam.PopModelMatrix()

	render.OverrideAlphaWriteEnable(false)
	render.PopRenderTarget()
	render.PopFilterMag()
	render.PopFilterMin()
	cam.End2D()

	render.BlurRenderTarget(brt, 36, 8, 2)
	render.BlurRenderTarget(brt, 56, 8, 4)


	surface.SetMaterial(brmat)
	surface.SetDrawColor( 255, 255, 255, 220 )

	local speed = sin * 0.01 * math.random() + 0.006
	t = t + FrameTime() * speed * 5

	local x = w * t % w
	local flip = w * t % (w * 2) > w

	surface.DrawTexturedRect(math.ceil(x) - (flip and w or 0), 0, w, h)
	surface.DrawTexturedRectUV(math.ceil(x) - (flip and 0 or w), 0, w, h, 1, 0, 0, 1)
end

CelestialBlur = blurs

hook.Add("HUDPaint", "a", function()
	surface.SetDrawColor(bg:Unpack())
	surface.DrawRect(0, 0, dw, dh)

	blurs()
end)


concommand.Add("die", function() hook.Remove("HUDPaint", "a") end)