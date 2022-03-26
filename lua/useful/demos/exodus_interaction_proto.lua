local item = _ITEM
local mx = Matrix()

local circle_color = Color(10, 10, 10, 230)
local ic = Icon("https://i.imgur.com/PYwijeL.png", "stfu_eat_hand.png")

local function paintInter(a)
	local prealpha = surface.GetAlphaMultiplier()

	surface.SetAlphaMultiplier(a)
		surface.SetDrawColor(circle_color)
		draw.DrawMaterialCircle(0, 0, 48)
		surface.SetDrawColor(color_white)
		ic:Paint(-16, -16, 32, 32)
	surface.SetAlphaMultiplier(prealpha)
end

local min_scale = 0.4
local disappear_scale = 0.7

local max_scale_dist = 48
local disappear_dist = 96

hook.Add("HUDPaint", "itempaint", function()
	if not item:IsValid() then return end

	local me = LocalPlayer()
	local mpos = me:GetPos()
	local itpos = item:LocalToWorld( item:OBBCenter() )
	local dist = mpos:Distance(itpos)

	local scale = min_scale + ( 1 - min_scale) * math.min( (disappear_dist - dist + max_scale_dist) / disappear_dist, 1 )
	local alpha = 1 - (disappear_scale - scale) / (disappear_scale - min_scale)

	local screen = itpos:ToScreen()
	local sx, sy = screen.x, screen.y
	if not screen.visible then return end

	mx:Reset()
	mx:TranslateNumber(sx, sy)
		mx:SetScaleNumber(scale, scale)
	--mx:TranslateNumber(-sx, -sy)

	DisableClipping(true)
	cam.PushModelMatrix(mx)
	draw.EnableFilters()
		local ok, err = pcall(paintInter, alpha)
	draw.DisableFilters()
	cam.PopModelMatrix()
	DisableClipping(false)

	if not ok then
		error(err)
	end
end)