if SERVER then return end

local MODULE = BaseWars.HUD or {}
BaseWars.HUD = MODULE


local draw = draw

local backcol = Color(40, 40, 40)
local hdcol = Color(30, 30, 30)

local alpha = 0

local w, h = 180, 55

local lastpos = Vector()
local lastent


local function AlphaColors(a, ...)
	local cols = {...}

	for k,v in ipairs(cols) do
		v.a = a
	end
end

local EntMaxHP = 0
local EntHP = 0

local PWFG = Color(50, 140, 240)

local vm = Matrix()

local name = ""

local anims

local function make()
	anims = Animatable(true)
end

if not Animatable then
	hook.Add("LibbedItUp", "BaseWarsHUD", make)
else
	make()
end

local rebootingMaxWidth = 0
local rebootingMaxText = "Rebooting..."

surface.SetFont("OS18")
rebootingMaxWidth = (surface.GetTextSize(rebootingMaxText))

local minDist = 80
local defaultMaxDist = 200
local maxDist = defaultMaxDist
local minScale = 0.2

local function DrawStructureInfo()

	local me = LocalPlayer()

	local trace = me:GetEyeTrace()
	local ent = trace.Entity

	local valid = IsValid(ent) -- and ent.IsBaseWars

	local dist = lastpos:Distance(trace.StartPos)

	if not valid then
		anims:To("Alpha", 0, 0.25, 0, 0.2)
	else
		local wep = me:GetActiveWeapon()
		local class = (IsValid(wep) and wep:GetClass())
				-- not holding a physgun = 250,
				-- holding an entity with the physgun = 140,
				-- just have the physgun out = 230
		local to = (class ~= 'weapon_physgun' and 250) or me:GetPhysgunningEntity() and 80 or 230

		local ep = ent:LocalToWorld(ent:OBBCenter())

		dist = ep:Distance(EyePos())
		lastent = ent

		name = ent.PrintName or "wat"

		local should, distAppear = hook.Run("BW_ShouldPaintStructureInfo", ent, dist)
		alphaTo = alphaTo or to

		maxDist = distAppear or defaultMaxDist

		if dist < maxDist * (1 - minScale) and should then
			anims:To("Alpha", alphaTo, 0.15, 0, 0.3)
			lastpos = ep
		else
			anims:To("Alpha", 0, 0.3, 0, 0.3)
		end
	end

	alpha = anims.Alpha or 0
	backcol.a = alpha
	hdcol.a = alpha

	local ts = lastpos:ToScreen()

	if not ts.visible or alpha < 1 or not IsValid(lastent) then return end

	local frac = (math.max(dist, minDist) - minDist) / (maxDist - minDist)
	local scale = Lerp(1 - frac, minScale, 1)

	local x, y = ts.x, ts.y 	--middle of the window's XY
	local sx, sy = x, y 		--top left XY

	vm:Identity()
	vm:SetScale(Vector(scale, scale, 1))
	vm:SetTranslation(Vector(x, y))

	vm:Translate(Vector(-w/2, -h/2))

	sx, sy = sx - w/2 * scale, sy - h/2 * scale

	local amult = surface.GetAlphaMultiplier()

	render.PushFilterMin(TEXFILTER.ANISOTROPIC)
	cam.PushModelMatrix(vm)
	surface.SetAlphaMultiplier(amult * (alpha / 255))
		hook.NHRun("BW_PaintStructureInfo", anims, lastent)
	surface.SetAlphaMultiplier(amult)
	cam.PopModelMatrix()
	render.PopFilterMin()
end

function MODULE.PaintFrame(w, h, headerH)
	local round = math.min(6, headerH / 2)

	draw.RoundedBoxEx(round, 0, 0, w, headerH, hdcol, true, true)
	draw.RoundedBoxEx(6, 0, 0 + headerH, w, h - headerH, backcol, nil, nil, true, true)
end

--[==================================[
		Death Cooldown HUD
--]==================================]
local vm2 = Matrix()

local ela
local dead = false

local left

local CreateElastic

CreateElastic = function(func, off)
	ela = Animations.InElastic(0.8, off, func, function()
		if not dead then ela = nil return end
		CreateElastic(func, 0.2)
	end, 0.7, 1.4, 2)
end

local rot = 0
local txw

local function DrawDeathCoolDown()
	local me = LocalPlayer()
	if me:Alive() then dead = false return end

	dead = true

	local t = me:GetRespawnTime()
	if not t then return end

	local dt = me:GetDeathTime()
	if not dt then return end

	left = t - CurTime()

	local frac = left / (t - dt)
	frac = math.min(1, frac)

	local leftfrac = 1 - frac

	draw.NoTexture()
	surface.SetDrawColor(60, 60, 60)

	render.SetStencilEnable(true)

		render.ClearStencil()

		render.SetStencilWriteMask(0xFF)
		render.SetStencilTestMask(0xFF)

		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)

		render.SetStencilCompareFunction(STENCIL_NEVER)
		render.SetStencilFailOperation(STENCIL_REPLACE)

		render.SetStencilReferenceValue(1)

			draw.Circle(ScrW()/2, ScrH() - 192, 56, 32, leftfrac*100)

		render.SetStencilReferenceValue(2)

			draw.Circle(ScrW()/2, ScrH() - 192, 32, 32)

		render.SetStencilCompareFunction(STENCIL_NOTEQUAL)

			draw.MaterialCircle(ScrW()/2, ScrH() - 192, 92)

		render.SetStencilReferenceValue(1)

		render.SetStencilCompareFunction(STENCIL_EQUAL)

			surface.SetDrawColor(color_white)
			draw.MaterialCircle(ScrW()/2, ScrH() - 192, 92)

	render.SetStencilEnable(false)

	if not ela then
		CreateElastic(function(fr)
			rot = fr*360
		end, math.abs(left)%1 - 0.1)
	end

	local a = 255

	if left-1 <= 0 then
		a = (math.max(left, 0)^4)*255
	end

	print(a)

	surface.SetFont("OSB32")
	local tw, th = surface.GetTextSize(tostring(math.floor(left)))
	txw = L(txw, tw, 5)

	surface.SetTextPos(0, 0)
	vm2:SetAngles(Angle(0, rot, 0))
	vm2:SetTranslation(Vector(ScrW()/2, ScrH() - 192))
	vm2:Translate(Vector((tw-txw)/2 - tw/2, -th/2, 0))



	cam.PushModelMatrix(vm2)
		local ok, err = pcall(function()
			surface.SetTextColor(255, 255, 255, a)
			surface.DrawText(math.floor(left))
		end)
	cam.PopModelMatrix()
end


local function PaintStuff()
	DrawStructureInfo()

	DrawDeathCoolDown()
end

hook.Add("HUDPaint", "StructureInfoPaint", PaintStuff)

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true
}

hook.Add( "HUDShouldDraw", "HideHUD", function(name)	--wiki example copypasting gang rise up
	if hide[name] then return false end

end )