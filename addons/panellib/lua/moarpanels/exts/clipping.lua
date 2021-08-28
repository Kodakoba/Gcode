local sz = 512

local circMaskRT = GetRenderTargetEx("__CircleMaskRT", sz, sz, RT_SIZE_OFFSCREEN,
									MATERIAL_RT_DEPTH_SHARED, 0, 0, -1)

local circMaskRTMat = CreateMaterial("__CircleMaskRTMat", "UnlitGeneric", {
	["$basetexture"] = circMaskRT:GetName(),
	["$translucent"] = 1,
})

--[[
	Generate Circle mask
]]
local circURL, circName = "https://i.imgur.com/XAWPA15.png", "medium-circle.png"




local circMaskMatRT = GetRenderTargetEx("__CircleMaskMatRT", sz, sz, RT_SIZE_OFFSCREEN,
									MATERIAL_RT_DEPTH_SHARED, 0, 0, -1)

local circMaskMat = CreateMaterial("__CircleMaskMat", "UnlitGeneric", {
	['$basetexture'] = circMaskMatRT:GetName(),
	["$translucent"] = 1,
})

Promise(function(res)
	draw.GetMaterial(circURL, circName, nil, res)
end):Then(function(mat)

	render.PushRenderTarget(circMaskMatRT)
		cam.Start2D()
			render.Clear(0, 0, 0, 0)
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		cam.End2D()
	render.PopRenderTarget()

	--circMaskMat:SetTexture("$basetexture", mat:GetTexture("$basetexture"))
	--circMaskMat:SetTexture("$basetexture", mat:GetTexture("$basetexture"))
end):Exec()

function draw.MaskCircle(x, y, rad, func, ...)
	rad = rad * 2
	render.PushRenderTarget(circMaskRT)
		cam.Start2D()
			render.Clear(0, 0, 0, 0, true)
			local ok, err = pcall(func, ...)

			render.SetWriteDepthToDestAlpha(false)
				render.OverrideBlend( true, BLEND_SRC_COLOR, BLEND_SRC_ALPHA, 3 )
					surface.SetMaterial(circMaskMat)
					surface.DrawTexturedRect(0, 0, sz, sz)
				render.OverrideBlend(false)
			render.SetWriteDepthToDestAlpha(true)

		cam.End2D()
	render.PopRenderTarget()

	if ok == false then
		error(err)
		return
	end

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(circMaskRTMat)
	surface.DrawTexturedRect(x, y, rad, rad)
end

function draw.EnableMaskCircle(x, y, w, h)

	render.PushRenderTarget(circMaskRT, x, y, w, h)
		cam.Start2D()
			render.OverrideDepthEnable(true, true)
			render.Clear( 0, 0, 0, 0, true )

end
			-- draw op

function draw.DisableMaskCircle(x, y, rad)
			render.SetWriteDepthToDestAlpha(false)
				render.OverrideBlend( true, BLEND_SRC_COLOR, BLEND_SRC_ALPHA, 3 )
					surface.SetMaterial(circMaskMat)
					surface.DrawTexturedRect(0, 0, rad, rad)
				render.OverrideBlend(false)
			render.SetWriteDepthToDestAlpha(true)

		cam.End2D()
	render.PopRenderTarget()
	render.OverrideDepthEnable(false, true)

	render.OverrideColorWriteEnable(true, true)
	render.OverrideAlphaWriteEnable(true, true)
	surface.SetDrawColor(0, 0, 0, 120)
	surface.SetMaterial(circMaskRTMat)
	surface.DrawTexturedRect(x or 0, y or 0, rad, rad)
end

function draw.BeginMask(mask, ...)
	render.SetStencilPassOperation( STENCIL_KEEP )

	render.SetStencilEnable(true)

		render.ClearStencil()

		render.SetStencilTestMask(0xFF)
		render.SetStencilWriteMask(0xFF)

		draw.SetMaskDraw(false)

		render.SetStencilReferenceValue( 1 ) --include

		if mask then mask(...) end

end

function draw.SetMaskDraw(should)
	if should then
		render.SetStencilCompareFunction( STENCIL_ALWAYS )
		render.SetStencilPassOperation( STENCIL_REPLACE )
	else
		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilFailOperation( STENCIL_REPLACE )
	end
end

function draw.DisableMask()
	render.SetStencilEnable(false)
end

function draw.ReenableMask()
	render.SetStencilEnable(true)
end

function draw.DeMask(demask, ...) --requires mask to be started
	render.SetStencilReferenceValue( 0 ) --exclude
	if demask then demask(...) end
end

function draw.DrawOp()
	render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilReferenceValue( 0 )
end

function draw.FinishMask()
	render.SetStencilEnable(false)
end


function draw.Masked(mask, op, demask, deop, ...)

	render.SetStencilPassOperation( STENCIL_KEEP )

	render.SetStencilEnable(true)

		render.ClearStencil()

		render.SetStencilTestMask(0xFF)
		render.SetStencilWriteMask(0xFF)

		render.SetStencilCompareFunction( STENCIL_NEVER )
		render.SetStencilFailOperation( STENCIL_REPLACE )

		render.SetStencilReferenceValue( 1 ) --include

		mask(...)

		render.SetStencilReferenceValue( 0 ) --exclude

		if demask then

			demask(...)

		end

		render.SetStencilCompareFunction( STENCIL_NOTEQUAL )
		render.SetStencilFailOperation( STENCIL_KEEP )

		op(...)	--actual draw op

		if deop then
			render.SetStencilCompareFunction( STENCIL_EQUAL )

			deop(...)
		end

	render.SetStencilEnable(false)

end
