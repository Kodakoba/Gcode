--Todo: actually make it a different panel class instead of
--this shit


BSHADOWS = BSHADOWS or {}
local render = render 

	--The original drawing layer
	BSHADOWS.RenderTarget = GetRenderTarget("bshadows_original", ScrW(), ScrH())
	 
	--The shadow layer
	BSHADOWS.RenderTarget2 = GetRenderTarget("bshadows_shadow",  ScrW(), ScrH())
	 
	--The matarial to draw the render targets on
	BSHADOWS.ShadowMaterial = CreateMaterial("bshadows","UnlitGeneric",{
	    ["$translucent"] = 1,
	    ["$vertexalpha"] = 1,
	    ["alpha"] = 1
	})
	 
	--When we copy the rendertarget it retains color, using this allows up to force any drawing to be black
	--Then we can blur it to create the shadow effect
	BSHADOWS.ShadowMaterialGrayscale = CreateMaterial("bshadows_grayscale","UnlitGeneric",{
	    ["$translucent"] = 1,
	    ["$vertexalpha"] = 1,
	    ["$alpha"] = 1,
	    ["$color"] = "0 0 0",
	    ["$color2"] = "0 0 0"
	})
	BSHADOWS.ShadowMaterialGrayscale:SetString("$color", "0 0 0")
	BSHADOWS.ShadowMaterialGrayscale:Recompute()

	BSHADOWS.ShadowMaterialColor = CreateMaterial("bshadows_colorscale","UnlitGeneric",{
	    ["$translucent"] = 1,
	    
	    ["$vertexalpha"] = 1,
	    ["$vertexcolor"] = 1,

	    ["$alpha"] = 1,
	    ["$color"] = "[255 0 0]",
	    ["$color2"] = "[255 0 0]"
	})
	--Call this to begin drawing a shadow
	BSHADOWS.BeginShadow = function()
	 
	    --Set the render target so all draw calls draw onto the render target instead of the screen
	    render.PushRenderTarget(BSHADOWS.RenderTarget)
	 
	    --Clear is so that theres no color or alpha
	    render.OverrideAlphaWriteEnable(true, true)
	    render.Clear(0,0,0,0)
	    render.OverrideAlphaWriteEnable(false, false)
	 
	    --Start Cam2D as where drawing on a flat surface
	    cam.Start2D()
	 
	    --Now leave the rest to the user to draw onto the surface
	end
	 
	--This will draw the shadow, and mirror any other draw calls the happened during drawing the shadow
	BSHADOWS.EndShadow = function(intensity, spread, blur, opacity, direction, distance, _shadowOnly, color)
	   
	    --Set default opcaity
	    opacity = opacity or 255
	    direction = direction or 0
	    distance = distance or 0
	    _shadowOnly = _shadowOnly or false
	 
	    --Copy this render target to the other
	    render.CopyRenderTargetToTexture(BSHADOWS.RenderTarget2)
	 
	    --Blur the second render target
	    if blur > 0 then
	        render.OverrideAlphaWriteEnable(true, true)
	        render.BlurRenderTarget(BSHADOWS.RenderTarget2, spread, spread, blur)
	        render.OverrideAlphaWriteEnable(false, false)
	    end
	 
	    --First remove the render target that the user drew
	    render.PopRenderTarget()
	    local mat = BSHADOWS.ShadowMaterialGrayscale
	    --[[
	 	if color then 

	 		local c1 = "{" .. color.r .. " " .. color.g .. " " .. color.b .. "}"
	 		mat = BSHADOWS.ShadowMaterialColor
	 		print(c1)
	 		if mat:GetString("$color") ~= c1 then 
	 			print('recomputing')
		 		mat:SetString("$color", c1)
		 		mat:SetString("$color2", c1)
		 		mat:Recompute() --bUt iTs eXpEnsiVe!1!1
		 	end
	 		
	 	end
		]]
	    --Now update the material to what was drawn
	    BSHADOWS.ShadowMaterial:SetTexture('$basetexture', BSHADOWS.RenderTarget)
	 
	    --Now update the material to the shadow render target
	    mat:SetTexture('$basetexture', BSHADOWS.RenderTarget2)
	 
	    --Work out shadow offsets
	    local xOffset = math.sin(math.rad(direction)) * distance
	    local yOffset = math.cos(math.rad(direction)) * distance
	 
	    --Now draw the shadow
	    mat:SetFloat("$alpha", opacity/255) --set the alpha of the shadow
	    render.SetMaterial(mat)
	    for i = 1 , math.ceil(intensity) do
	        render.DrawScreenQuadEx(xOffset, yOffset, ScrW(), ScrH())
	    end
	 
	    if not _shadowOnly then
	        --Now draw the original
	        BSHADOWS.ShadowMaterial:SetTexture('$basetexture', BSHADOWS.RenderTarget)
	        render.SetMaterial(BSHADOWS.ShadowMaterial)
	        render.DrawScreenQuad()
	    end
	 
	    cam.End2D()
	end
