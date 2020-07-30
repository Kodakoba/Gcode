MODULE = BaseWars.HUD or {}

MODULE.Name 	= "HUD"
MODULE.Author 	= "grmx"
MODULE.Realm 	= 2

BaseWars.HUD = {} 

local MODULE = BaseWars.HUD
local tag = "BaseWars.HUD"

if SERVER then return end


local clamp = math.Clamp
local floor = math.floor
local round = math.Round


local draw = draw 

local fade = true 

local backcol = Color(40, 40, 40)
local hdcol = Color(30, 30, 30)

local alpha = 0

local w, h = 180, 55
local headerH = 24

local lastpos = Vector()
local lastX, lastY = 0, 0
local lastent


local function DrawScalingBox(rad, x, y, w, h, col)
	rad = math.min(rad, h/2, w/2)

	draw.RoundedBox(rad, x, y, w, h, col)
end

local function DrawScalingPolyBox(rad, x, y, w, h, col)
	rad = math.min(rad, h/2, w/2)

	draw.RoundedPolyBox(rad, x, y, w, h, col)
end


local function AlphaColors(alpha, ...)
	local cols = {...}

	for k,v in ipairs(cols) do 
		v.a = alpha
	end
end

local HPBG = Color(75, 75, 75)
local HPFG = Color(200, 75, 75)

local white = Color(255, 255, 255)
local gray = Color(40, 40, 40)

local EntMaxHP = 0
local EntHP = 0

local HPFrac = 0

local PWFG = Color(50, 140, 240)

local EntMaxPW = 0
local EntPW = 0

local PWFrac = 0

local vm = Matrix()

local name = ""

local anims

local function make()
	anims = Animatable(true)
	anims.EntHPs = {}
end

if not Animatable then
	hook.Add("LibbedItUp", "BaseWarsHUD", make)
else
	make()
end

local function DrawStructureInfo()

	local me = LocalPlayer()

	local trace = me:GetEyeTrace()
	local ent = trace.Entity

	local valid = IsValid(ent) and ent.IsBaseWars

	local dist = math.max(lastpos:Distance(trace.StartPos) - 96, 0)

	if not valid then
		anims:To("Alpha", 0, 0.25, 0, 0.2)
	else

		local wep = me:GetActiveWeapon()
		local class = (IsValid(wep) and wep:GetClass())

		local to = (class == "weapon_physgun" and ((input.IsMouseDown(MOUSE_LEFT) and not vgui.CursorVisible() and 140) or 240) ) or 250
		lastpos = ent:LocalToWorld(ent:OBBCenter())

		dist = math.max(lastpos:Distance(trace.StartPos) - 96, 0)
		lastent = ent
		EntHP = ent:Health()
		EntMaxHP = math.max(ent:GetMaxHealth(), 0)

		name = ent.PrintName or "wat"

		if dist < 108 then anims:To("Alpha", to, 0.3, 0, 0.3) else anims:To("Alpha", 0, 0.3, 0, 0.3) end
	end

	alpha = anims.Alpha or 0
	backcol.a = alpha
	hdcol.a = alpha

	local ts = lastpos:ToScreen()

	if not ts.visible or alpha < 1 or not IsValid(lastent) then return end

	local scale = math.max(200 - dist, 75) / 200

	local x, y = ts.x, ts.y 	--middle of the window's XY
	local sx, sy = x, y 		--top left XY

	vm:SetScale(Vector(scale, scale, 1))
	vm:SetTranslation(Vector(x, y))

	vm:Translate(Vector(-w/2, -h/2))


	sx, sy = sx - w/2 * scale, sy - h/2 * scale

	local hpfrac = (EntHP / EntMaxHP)

	if not anims.EntHPs[lastent:EntIndex()] then
		anims.EntHPs[lastent:EntIndex()] = hpfrac
	end

	anims:MemberLerp(anims.EntHPs, lastent:EntIndex(), hpfrac, 0.3, 0, 0.3)
	local HPFrac = anims.EntHPs[lastent:EntIndex()]

	local hpw = HPFrac * (w-12)

	local bary = headerH + 8

	local hpW = math.floor(math.max(hpw, 8))			--for nice rounding

	local hph = math.ceil(14*scale)

	--[[
		Height Calculation
	]]

		local toH = h

		local rebooting
		local dead = not lastent:GetPowered()

		if lastent.GetRebootTime and lastent:GetRebootTime() ~= 0 then
			rebooting = true
		end

		if dead or rebooting then
			toH = toH + 18
		end
	
		anims:MemberLerp(anims, "Height", toH, 0.3, 0, 0.3)

		local h = anims.Height or toH


	render.PushFilterMin(TEXFILTER.ANISOTROPIC)

	local ok, err = pcall(function()

		cam.PushModelMatrix(vm)

			local ok, err = pcall(function()

				local x, y = 0, 0

				local scale = 1

				local round = math.min(6, headerH/2)

				AlphaColors(alpha, hdcol, backcol, HPBG, HPFG, PWFG, white, gray)

				draw.RoundedBoxEx(round, 0, 0, w, headerH, hdcol, true, true)
				draw.RoundedBoxEx(6, 0, 0 + headerH, w, h - headerH, backcol, nil, nil, true, true)

				draw.SimpleText(name, "TW24", w/2, 0, white, 1, 5)

			end)

			if not ok then
				print("err #1 >:(", err)
			end

			draw.RoundedBox(6, 6, headerH + 8, w - 13, 14, HPBG)

			--render.SetScissorRect(sx + 6, bary - 1, sx + 6 + hpw - (1 - scale) * 4, bary + hph + 1, true)

				draw.RoundedBox(6, 6, headerH + 8, hpW, 14, HPFG)
			--render.SetScissorRect(0, 0, 0, 0, false)

		cam.PopModelMatrix()

		--Prepare for new bar (Power)

		cam.PushModelMatrix(vm)
			local ok, err = pcall(function()

				local x, y = 0, 0
				local tx = Language("Health", EntHP, EntMaxHP)

				draw.Masked(function()
					draw.RoundedPolyBox(6, 4, headerH + 3, hpW + 1, 24, HPFG)
				end, function()
					draw.SimpleText(tx, "OSB18", 4 + w/2, headerH + 14, white, 1, 1)
				end, nil, function()
					draw.SimpleText(tx, "OSB18", 4 + w/2, headerH + 14, gray, 1, 1)
				end)

				local tY = headerH + 26

				if rebooting then
					draw.SimpleText("Rebooting" .. ("."):rep((CurTime() * 3) % 2 + 1), "OS18", w/2, tY, white, 1, 5)
					tY = tY + 18
				elseif dead then
					anims.NoPowerCol = anims.NoPowerCol or Color(200, 60, 60)
					local colh, cols, colv = 0, 0.7, 0.78 --values for Color(200, 60, 60)
					draw.ColorModHSV(anims.NoPowerCol, colh, cols, colv + math.sin(CurTime() * 8) * 0.08)
					anims.NoPowerCol.a = alpha

					draw.SimpleText("Insufficient power!", "OSB18", w/2, tY, anims.NoPowerCol, 1, 5)

					tY = tY + 18

				end

			end)



		cam.PopModelMatrix()
		if not ok then 
			print("err #2 >:(", err)
		end

	end)
	
	if not ok then 
		print("Err #3 >:(", err)
	end
	render.PopFilterMin()
end

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