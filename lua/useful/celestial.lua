local bg = Color(2, 11, 21)

local gr = Color(70, 230, 145)
local red = Color(210, 80, 90)
local blu = Color(50, 120, 210)

local w, h = ScrW() * 0.5, ScrH() * 0.5

local brt = draw.GetRT("Blurs", w, h)

local vec = Vector()
local v2 = Vector(0, h / 2)

local m1 = Matrix()

local t = 0--math.random() * 10000

local function blurs()
	local sin = math.sin(CurTime() * 0.2)
	local cos = math.cos(CurTime() * 0.12)

	vec.x, vec.y = 1, 1

	m1:Reset()
	local sw, sh = ScrW(), ScrH()
	local mat = draw.RenderOntoMaterial("blurs", w, h, function()
		local w, h = sw, sh
		m1:Translate(v2)
			m1:Scale(vec)
		m1:Translate(-v2)

			cam.PushModelMatrix(m1, true)
				surface.DisableClipping(true)

					gr.a = 60
					surface.SetDrawColor(gr:Unpack())
					draw.DrawCircle(w * 0.1 + w*0.05*sin, h * 1.05 + h * 0.1 * sin, h * 0.4 + h * 0.05 * sin, 64)
					draw.DrawCircle(w * 1.1 + w*0.04*sin, h * 0.2, h * 0.6, 64)

					red.a = 35 + cos * 5
					surface.SetDrawColor(red:Unpack())
					draw.DrawCircle(w * 0.55, h * 0.35, h * 0.4, 64)

					red.a = 45 + sin * 5
					surface.SetDrawColor(red:Unpack())
					draw.DrawCircle(w * 0.6, h * 0.65, h * 0.2 + h * 0.05 * cos, 64)

					blu.a = 55 + cos * 5
					surface.SetDrawColor(blu:Unpack())
					draw.DrawCircle(w * 0.7 + w * 0.1 * sin, h * 1, h * 0.4, 64)
					draw.DrawCircle(w * 0.3 + w * 0.04 * sin, h * -0.1, h * 0.4, 64)

				surface.DisableClipping(false)
			cam.PopModelMatrix()

	end, function(rt)
		render.BlurRenderTarget(rt, 36, 8, 2)
		render.BlurRenderTarget(rt, 56, 8, 4)
	end, nil, nil, nil, true)

	surface.SetMaterial(mat)
	surface.SetDrawColor(Color(255, 255, 255, 220))

	local speed = sin * 0.01 + 0.006
	t = t + FrameTime() * speed

	local x = w * t % w
	local flip = w * t % (w * 2) > w

	surface.DrawTexturedRect(math.ceil(x) - (flip and w or 0), 0, w, h)
	surface.DrawTexturedRectUV(math.ceil(x) - (flip and 0 or w), 0, w, h, 1, 0, 0, 1)

	draw.SimpleText("hey fuckhead", "OSB48", w/2, h/2, color_white, 1, 1)
end

hook.Add("HUDPaint", "a", function()

	surface.SetDrawColor(bg:Unpack())
	surface.DrawRect(0, 0, w, h)

	blurs()
end)


concommand.Add("die", function() hook.Remove("HUDPaint", "a") end)