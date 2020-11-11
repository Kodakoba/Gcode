if IsValid(SynthPnl) then SynthPnl:Remove() end
setfenv(0, _G)
AI = (_G.AI or 100) + 1

local maskSz = 256
local mask = GetRenderTargetEx("GridMaskRT" .. AI, maskSz, maskSz, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_SHARED, 16 + 8192, 0, IMAGE_FORMAT_RGBA8888)
local maskSrc = Material( "gui/gradient_down" )

local maskMat = CreateMaterial("GridMaskMat" .. AI, "UnlitGeneric", {
	["$basetexture"] = mask:GetName(),
	["$translucent"] = "1",
	["$vertexcolor"] = "1",
	["$vertexalpha"] = "1",
	["$ignorez"] = "1",
} )


local blur = GetRenderTargetEx("GridBlurRT" .. AI, maskSz, maskSz, RT_SIZE_OFFSCREEN, MATERIAL_RT_DEPTH_SHARED, 16 + 8192, 0, IMAGE_FORMAT_RGBA8888)

local blurMat = CreateMaterial("GridBlurMat" .. AI, "UnlitGeneric", {
	["$basetexture"] = blur:GetName(),
	["$translucent"] = "1",
	["$vertexcolor"] = "1",
	["$vertexalpha"] = "1",
	["$ignorez"] = "1",
} )

local pnl = vgui.Create("InvisPanel")

SynthPnl = pnl
pnl:SetSize(ScrW(), ScrH())

local m = Matrix()
local v = Vector()
local a = Angle(0, 0, 0)
local a2 = Angle(180, 90, -5)

local sw, sh = ScrW(), ScrH()

local function drawGrid(mat, col, times)
	col = col or color_white
	surface.SetDrawColor(col:Unpack())
	local v = -(CurTime() * 0.2) % 1
	if mat then
		surface.SetMaterial(mat)
		for i=1, (times or 1) do
			surface.DrawTexturedRect(0, 0, sw, sh, 0, 0, 1, 1)
		end
	else
		surface.DrawUVMaterial("https://i.imgur.com/UVOE9B2.png", "grid3.png", 0, 0, sw, sh, 0, v, 1, 2 + v)
	end
end

local function maskGrid()
	render.SetWriteDepthToDestAlpha(false)
		render.OverrideBlend( true, BLEND_SRC_COLOR, BLEND_SRC_ALPHA, 3)
			surface.SetMaterial(maskSrc)
			surface.DrawTexturedRect(0, 0, sw, sh)
		render.OverrideBlend(false)
	render.SetWriteDepthToDestAlpha(true)
end

local blue = Color(0, 255, 255)
local green = Color(180, 90, 210)

hook.Add("HUDPaint", "aaa", function()
	render.PushRenderTarget(blur)
	render.OverrideAlphaWriteEnable( true, true )
		render.Clear(0, 0, 0, 0, true)
		drawGrid()
		render.BlurRenderTarget(blur, 8, 8, 2)
	render.OverrideAlphaWriteEnable( false, false )
	render.PopRenderTarget()

	render.PushRenderTarget(mask)
	render.OverrideAlphaWriteEnable( true, true )
		render.Clear(0, 0, 0, 0, true)
		drawGrid(blurMat, blue, 3)
		drawGrid(nil, green)
		maskGrid()
	render.OverrideAlphaWriteEnable( false, false )
	render.PopRenderTarget()
end)



function pnl:Paint(w, h)
	surface.SetDrawColor(5, 5, 20)
	surface.DrawRect(0, 0, w, h)

	CelestialBlur(w, h)

	--[[cam.PushModelMatrix(m, true)
		surface.SetDrawColor(255, 255, 255, 60)
		surface.DrawUVMaterial("https://i.imgur.com/UVOE9B2.png", "grid.png", 0, h * 0.6, w, h * 0.4, 0, 0, 15, 4)
	cam.PopModelMatrix()]]

	draw.EnableFilters(true, true)

	cam.Start3D(v, a, 90, 0, 0, w, h)

		local ok, err = pcall(function()
			local vec = util.AimVector(a, 90, 0, h, w, h)
			render.CullMode(1)
			DisableClipping(true)
			cam.Start3D2D(v + vec * 250, a2, 0.3)


				local v = -(CurTime() * 0.2) % 1
				--surface.DrawUVMaterial("https://i.imgur.com/UVOE9B2.png", "grid3.png", -1000, 0, 3000, 200, 0, v, 24, 1 + v)

				surface.SetDrawColor(blue)
				surface.SetMaterial(blurMat)
				for i=1, 3 do
					surface.DrawTexturedRectUV(-1000, -200, 4000, 600, 0, 0, 8, (maskSz - 4) / maskSz)
				end

				--green.a = 120
				surface.SetDrawColor(green)
				surface.DrawUVMaterial("https://i.imgur.com/UVOE9B2.png", "grid3.png", -1000, 0, 4000, 400, 0, v, 8, 2 + v)

				White()
				surface.SetMaterial(maskMat)
				surface.DrawTexturedRectUV(-1000, 300, 4000, 400, 0, 0, 8, (maskSz - 4) / maskSz)

			cam.End3D2D()
		end)

		render.CullMode(0)

		DisableClipping(false)
	cam.End3D()

	draw.DisableFilters(true, true)
	if not ok then error(err) end
end