setfenv(1, _G)

local i = 15

local mat = CreateMaterial("bruv" .. i, "UnlitGeneric", {
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$alpha"] = 1,
	--["$color"] = "[0 0 0]",
	--["$alphatest"] = 1,
	--["$alphatestreference"] = 0.1,
})

fuck = draw.GetRT("fuckmee" .. i, 128, 64)

local mat2 = CreateMaterial("bruver" .. i, "UnlitGeneric", {
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$alpha"] = 1,
	["$color"] = "[1 0 0]",
	--["$alphatest"] = 1,
	--["$alphatestreference"] = 0.2,
})

mat2:SetTexture("$basetexture", fuck:GetName("$basetexture"))

function outlineBunch(cb)

	draw.RenderOntoMaterial("bruv" .. i, 256, 128, cb, function(rt)

		render.OverrideAlphaWriteEnable(true, true)

		render.CopyRenderTargetToTexture(fuck)
        render.BlurRenderTarget(rt, 2, 2, 1)

        render.SetMaterial(mat)
        render.DrawScreenQuad()


        cb(Colors.Red)

        return false
	end, nil, nil, mat)

end

local b = bench("wat", 600)

hook.Add("HUDPaint", "bruh", function()
	b:Open()

	local w, h = 128, 64
	local x, y = 0, 0--math.sin(CurTime() * 2) * 150, math.cos(CurTime() * 2) * 150

	outlineBunch(function(c)
		draw.SimpleText("holy shit", "OS24", w/2 + x, h/2 + y, IsColor(c) and c or color_black, 1, 1)
	end)

	surface.SetDrawColor(color_white)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(0, 128, 256, 128)

	--draw.SimpleText("bruh moment aaaaaaa", "OSB48", 256, 512 + 256, ColorAlpha(color_white, 255), 1, 1)

	b:Close():print()
end)