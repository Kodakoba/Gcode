setfenv(0, _G)
local bg = Color(2, 11, 21)

local gr = Color(50, 190, 115)
local red = Color(200, 50, 70)
local reddish = Color(230, 100, 130)
local blu = Color(50, 120, 210)


local circleURL = "https://i.imgur.com/6SdL8ff.png"
local circlePath = "ttt/cache/materials/big_circle2.png"

local dw, dh = ScrW() * 1, ScrH() * 1

local brt = GetRenderTarget("Blurs", dw, dh)

local vec = Vector()
local v2 = Vector(0, dh / 2)

local m1 = Matrix()

local t = 0--math.random() * 10000

local ct = CurTime
local CurTime = function()
	return ct() * 2
end

local time = os.clock() * 1000

local blurTexName = "cel_blurRT" .. time
local blurrt = GetRenderTarget(blurTexName, ScrW() / 4, ScrH() / 4)

local mat_BlurX = CreateMaterial("cel_blurx" .. time, "g_blurx", {
	["$basetexture"] = blurTexName,
	["$size"] = "6",
	["$ignorez"] = "1",
	["$additive"] = "1",
	["$translucent"] = 1,
})

local mat_BlurY = CreateMaterial("cel_blury" .. time, "g_blury", {
	["$basetexture"] = blurTexName,
	["$translucent"] = 1,
	["$size"] = "6",
	["$ignorez"] = "1",
	["$additive"] = "1",
})

local mat_Main = CreateMaterial("cel_main" .. time, "UnlitGeneric", {
	["$basetexture"] = brt:GetName(),
	["$ignorez"] = 1,
	["$translucent"] = 1,
	["$vertexcolor"] = 1,
	["$vertexalpha"] = 1
})

local function BlurRenderTarget( rt, sizex, sizey, passes )

	mat_BlurX:SetTexture( "$basetexture", rt )
	mat_BlurY:SetTexture( "$basetexture", blurrt )
	mat_BlurX:SetFloat( "$size", sizex )
	mat_BlurY:SetFloat( "$size", sizey )

	for i=1, passes+1 do

		render.SetRenderTarget( blurrt )
		render.SetMaterial( mat_BlurX )
		render.DrawScreenQuad()

		render.SetRenderTarget( rt )
		render.SetMaterial( mat_BlurY )
		render.DrawScreenQuad()

	end

end

local circleMat

local shitCircle = CreateMaterial("_crapcircle", "UnlitGeneric", {
	["$basetexture"] = "vgui/circle",
	["$ignorez"] = 1,
	["$translucent"] = 1,

	["$vertexcolor"] = 1,
	["$vertexalpha"] = 1, -- what in the goddamn
})

local function createMat()
	circleMat = Material("data/" .. circlePath, "smooth ignorez")
	circleMat:SetInt("$translucent", 1)
	circleMat:SetInt("$vertexalpha", 1)
	circleMat:Recompute()
end

local function loadMat()
	if file.Exists(circlePath, "DATA") then
		createMat()
		return
	end

	http.Fetch(circleURL, function(b)
		file.Write(circlePath, b)
		createMat()
	end)
end

if IsValid( LocalPlayer() ) then
	loadMat()
else
	hook.Add("InitPostEntity", "bruhruh", loadMat)
end


local function SetMaterialCircle()

	if circleMat and not circleMat:IsError() then
		surface.SetMaterial(circleMat)
	else
		surface.SetMaterial(shitCircle)
	end
end

local function DrawMaterialCircle(x, y, rad)
	rad = rad * 2
	surface.DrawTexturedRect(x - rad/2, y - rad/2, rad, rad)
end

local function blurs(w, h)
	local sin = math.sin(CurTime() * 0.2)
	local cos = math.cos(CurTime() * 0.12)


	vec.x, vec.y = 1, 1

	m1:Reset()
	local sw, sh = ScrW(), ScrH()

	w = w or dw
	h = h or dh

	local speed = sin * 0.007 * math.random()
	t = t + FrameTime() * speed * 2

	cam.Start2D()
	render.PushRenderTarget(brt)
	render.OverrideAlphaWriteEnable(true, true)

		render.Clear(0, 0, 0, 0)

		m1:Translate(v2)
			m1:Scale(vec)
		m1:Translate(-v2)

		SetMaterialCircle()

		--cam.PushModelMatrix(m1, true)
			surface.DisableClipping(true)
				SetMaterialCircle()
				gr.a = 130
				surface.SetDrawColor(gr:Unpack())
				DrawMaterialCircle(w * 0.1 + w*0.05*sin, h * 1.05 + h * 0.1 * sin, h * 0.4 + h * 0.05 * cos, 64)
				DrawMaterialCircle(w * 1.1 + w*0.04*cos, h * 0.2, h * 0.6, 64)

				red.a = 85 + cos * 20
				surface.SetDrawColor(red:Unpack())
				DrawMaterialCircle(w * 0.65 + w * 0.034 * (1 - sin), h * 0.09 * math.cos(CurTime() * 0.04), h * 0.4, 64)

				reddish.a = 85 + sin * 15
				surface.SetDrawColor(reddish:Unpack())
				DrawMaterialCircle(w * 0.4 + w*0.022*sin, h * 0.6 + h*0.07*cos, h * 0.28 + h * 0.03 * math.max(cos, sin), 64)

				blu.a = 125 + cos * 5
				surface.SetDrawColor(blu:Unpack())
				DrawMaterialCircle(w * 0.7 + w * 0.1 * sin, h * 1 - h * 0.03 * sin, h * 0.4, 64)
				DrawMaterialCircle(w * 0.3 + w * 0.04 * cos, h * -0.1, h * 0.4, 64)

			surface.DisableClipping(false)
		--cam.PopModelMatrix()

		BlurRenderTarget(brt, 50, 50, 1)
		BlurRenderTarget(brt, 12, 12, 1)
	render.OverrideAlphaWriteEnable(false)
	render.PopRenderTarget()
	cam.End2D()
end

CelestialBlur = blurs

function CelestialBlurDraw(w, h)
	surface.SetMaterial(mat_Main)
	surface.SetDrawColor(255, 255, 255)

	local x = w * t % w
	local flip = w * t % (w * 2) > w

	surface.DrawTexturedRect(math.ceil(x) - (flip and w or 0), 0, w, h)
	surface.DrawTexturedRectUV(math.ceil(x) - (flip and 0 or w), 0, w, h, 1, 0, 0, 1)
end
hook.Add("HUDPaint", "a", function()
	surface.SetDrawColor(bg:Unpack())
	surface.DrawRect(0, 0, dw, dh)

	blurs()
	CelestialBlurDraw(ScrW(), ScrH())
end)


concommand.Add("die", function() hook.Remove("HUDPaint", "a") end)