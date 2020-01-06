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

local w, h = 180, 75
local headerH = 24

local lastpos = Vector()
local lastX, lastY = 0, 0

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


local function DrawStructureInfo()

	local me = LocalPlayer()

	local trace = me:GetEyeTrace()
	local ent = trace.Entity

	local valid = IsValid(ent) and ent.IsBaseWars

	local dist = math.max(lastpos:Distance(trace.StartPos) - 96, 0)

	if not valid then
		alpha = L(alpha, 0, 15)
	else 

		local wep = ply:GetActiveWeapon()
		local class = (IsValid(wep) and wep:GetClass())

		local to = (class == "weapon_physgun" and ((input.IsMouseDown(MOUSE_LEFT) and 140) or 240) ) or 250
		lastpos = ent:GetPos() + Vector(0, 0, 8)

		dist = math.max(lastpos:Distance(trace.StartPos) - 96, 0)

		EntHP = ent:Health()
		EntMaxHP = ent:GetMaxHealth()

		EntPW = ent:GetPower()
		EntMaxPW = ent:GetMaxPower()

		name = ent.PrintName or "wat"

		if dist < 96 then alpha = L(alpha, to, 15) else alpha = L(alpha, 0, 15) end
		
	end

	backcol.a = alpha 
	hdcol.a = alpha

	local ts = lastpos:ToScreen()
	
	if not ts.visible or alpha < 1 then return end 

	local w, h = w, h 

	local scale = math.max(200 - dist, 75) / 200

	local x, y = ts.x, ts.y 	--middle of the window's XY
	local sx, sy = x, y 		--top left XY

	vm:SetScale(Vector(scale, scale, 1))
	vm:SetTranslation(Vector(x, y))

	vm:Translate(Vector(-w/2, -h/2))


	sx, sy = sx - w/2 * scale, sy - h/2 * scale

	local hpfrac = (EntHP / EntMaxHP) 
	HPFrac = L(HPFrac, hpfrac, 15)

	local hpw = HPFrac * (w-12)

	local bary = sy + headerH*scale + 8*scale

	local hpW = math.max(hpw, 8)*scale			--for nice rounding

	local hph = math.ceil(14*scale)

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


		cam.PopModelMatrix()

		

		DrawScalingBox(6, sx + 6, bary - 1, w*scale - 13, hph, HPBG)

		render.SetScissorRect(sx + 6, bary - 1, sx + 6 + hpw, bary + hph + 1, true)

			DrawScalingBox(6, sx + 6, bary - 1, hpW, hph, HPFG) --HP Bar

		render.SetScissorRect(0, 0, 0, 0, false)
		
		--Prepare for new bar (Power)

		bary = bary + hph + 6*scale


		local pwfrac = (EntPW / EntMaxPW)
		PWFrac = L(PWFrac, pwfrac, 15)

		local pww = PWFrac * (w-12)
		local pwW = math.min(math.max(pww, 8) * scale, w-13)

		DrawScalingBox(6, sx + 6, bary - 1, w*scale - 12, hph, HPBG)

		render.SetScissorRect(sx + 6, bary - 1, sx + 6 + pww, bary + hph + 1, true)

			DrawScalingBox(6, sx + 6, bary - 1, pwW, hph, PWFG)	--PW Bar

		render.SetScissorRect(0, 0, 0, 0, false)

		cam.PushModelMatrix(vm)
			local ok, err = pcall(function() 

				local x, y = 0, 0
				local tx = Language("Health", EntHP, EntMaxHP)

				draw.Masked(function()
					DrawScalingPolyBox(6, 4, headerH + 3, hpW/scale, 24, HPFG)	
				end, function()
					draw.SimpleText(tx, "OSB18", 4 + w/2, headerH + 13, white, 1, 1)
				end, nil, function()
					draw.SimpleText(tx, "OSB18", 4 + w/2, headerH + 13, gray, 1, 1)
				end)


				local tx = Language("Power", EntPW, EntMaxPW)

				draw.Masked(function()
					DrawScalingPolyBox(6, 4, headerH + 20, pwW/scale, 24, HPFG)	
				end, function()
					draw.SimpleText(tx, "OSB18", 4 + w/2, headerH + 34, white, 1, 1)
				end, nil, function()
					draw.SimpleText(tx, "OSB18", 4 + w/2, headerH + 34, gray, 1, 1)
				end)

			end) 



		cam.PopModelMatrix()
		if not ok then 
			print("err >:(", err)
		end

	end)
	
	if not ok then 
		print("Err >:(", err)
	end
	render.PopFilterMin()
end


local StuckTime

function MODULE:Paint()

	local me = LocalPlayer()
	if not me:IsPlayer() or not IsValid(me) then return end

	
end

hook.Add("HUDPaint", "StructureInfoPaint", DrawStructureInfo)

function HideHUD(name)

    for k, v in next, {"CHudHealth", "CHudBattery", --[["CHudAmmo", "CHudSecondaryAmmo"]]} do

        if name == v then

			return false

		end

    end

end
hook.Add("HUDShouldDraw", tag .. ".HideOldHUD", HideHUD)
