
--credits to <CODE BLUE>
BSHADOWS_ID = BSHADOWS_ID or 0 
BSHADOWS_ID = BSHADOWS_ID + 1

BSHADOWS = {}
local render = render 

	BSHADOWS.RenderTarget = GetRenderTarget("bshadows_original", ScrW(), ScrH())
	 
	BSHADOWS.RenderTarget2 = GetRenderTarget("bshadows_shadow",  ScrW(), ScrH())
	 
	BSHADOWS.ShadowMaterial = BSHADOWS.ShadowMaterial or CreateMaterial("bshadows" .. BSHADOWS_ID,"UnlitGeneric",{
	    ["$translucent"] = 1,
	    ["$vertexalpha"] = 1,
	    ["alpha"] = 1
	})
	 
	BSHADOWS.ShadowMaterialGrayscale = BSHADOWS.ShadowMaterialGrayscale or CreateMaterial("bshadows_grayscale" .. BSHADOWS_ID,"UnlitGeneric",{
	    ["$translucent"] = 1,
	    ["$vertexalpha"] = 1,
	    ["$alpha"] = 1,
	    
	    ["$color"] = "[0 0 0]",
	})

	BSHADOWS.ShadowMaterialColorscale = BSHADOWS.ShadowMaterialColorscale or CreateMaterial("bshadows_colorscale" .. BSHADOWS_ID,"UnlitGeneric",{
	    ["$translucent"] = 1,

	    ["$vertexalpha"] = 1,

	    ["$alpha"] = 1,
	    ["$color"] = "[255 255 255]",
	})

	BSHADOWS.ShadowMaterialColor = BSHADOWS.ShadowMaterialColor or CreateMaterial("bshadows_color" .. BSHADOWS_ID,"UnlitGeneric",{
	    ["$translucent"] = 1,
	    
	    ["$vertexalpha"] = 1,

	    ["$alpha"] = 1,
	    ["$color"] = "[255 255 255]",
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
	    local shmat = BSHADOWS.ShadowMaterial

	    if color then 
	    	mat = BSHADOWS.ShadowMaterialColorscale

	    	local vc = Vector(color.r, color.g, color.b) --nO cOloR mEtatAblE
	    	mat:SetVector("$color", vc)
	    	--mat:SetVector("$color2", vc)
	    	--mat:Recompute()
	    end

	    --Now update the material to what was drawn
	    shmat:SetTexture('$basetexture', BSHADOWS.RenderTarget)
	 
	    --Now update the material to the shadow render target
	    mat:SetTexture('$basetexture', BSHADOWS.RenderTarget2)
	 
	    --Work out shadow offsets
	    local xOffset = math.sin(math.rad(direction)) * distance
	    local yOffset = math.cos(math.rad(direction)) * distance
	 

	    mat:SetFloat("$alpha", opacity/255)
	    render.SetMaterial(mat)
	    for i = 1 , math.ceil(intensity) do
	        render.DrawScreenQuadEx(xOffset, yOffset, ScrW(), ScrH())
	    end
	 
	    if not _shadowOnly then
	        BSHADOWS.ShadowMaterial:SetTexture('$basetexture', BSHADOWS.RenderTarget)
	        render.SetMaterial(shmat)
	        render.DrawScreenQuad()
	    end
	 
	    cam.End2D()
	end

if IsValid(testp) then testp:Remove() return else return end

testp = vgui.Create("FFrame")
local p = testp

p:SetSize(600, 400)
p:Center()
p.Shadow = {}
function p:PostPaint(w, h)
	--draw.RoundedPolyBoxEx(16, 50, 100, 500, 200, Color(250, 20, 20, 250))
	surface.SetDrawColor(Color(250, 50, 50))
	BSHADOWS.BeginShadow()
		--draw.DrawMaterialCircle(w/2, h - 64, 128)
		draw.NoTexture()
		draw.SimpleText("Peepee poopoo peepee poopoo", "OS72", w/2, h-64, Color(255, 255, 255))--DrawCircle(w/2, h-64, 32, 128)
	BSHADOWS.EndShadow(1, 0.1, 3, nil, 45, 1, nil, HSVToColor((CurTime() * 120)%360, 1, 1) )
end
