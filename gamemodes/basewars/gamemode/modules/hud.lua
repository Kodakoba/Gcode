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




local RuneDurs = {

	["invis"] = { time = 30, pic = Material("vgui/prestige/Empty.png"), p = 0, o = 0, name = "Invisibility"},
	["haste"] = { time = 20, pic = Material("vgui/runes/timer.png"), p = 0, o = 0, pic2 = Material("vgui/runes/arrow.png"), name = "Haste"},
	["regen"] = { time = 15, pic = Material("vgui/prestige/Empty.png"), p = 0, o = 0, name = "Regeneration"},
	
}

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

local function AlphaColors(alpha, ...)
	local cols = {...}

	for k,v in ipairs(cols) do 
		v.a = alpha
	end
end

local HPBG = Color(75, 75, 75)
local HPFG = Color(200, 75, 75)

local white = Color(255, 255, 255)

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
	
	if not ts.visible then return end 

	local w, h = w, h 

	local scale = math.max(200 - dist, 75) / 200

	local x, y = ts.x, ts.y
	local sx, sy = x, y
	vm:SetScale(Vector(scale, scale, 1))
	vm:SetTranslation(Vector(x, y))

	vm:Translate(Vector(-w/2, -h/2))


	cam.PushModelMatrix(vm)

	local ok, err = pcall(function() 

		local x, y = 0, 0

		local scale = 1

		local headerH = math.ceil(headerH * scale)

		local round = math.min(6, headerH/2)

		AlphaColors(alpha, hdcol, backcol, HPBG, HPFG, PWFG, white)

		draw.RoundedBoxEx(round, 0, 0, w, headerH, hdcol, true, true)
		draw.RoundedBoxEx(6, 0, 0 + headerH, w, h - headerH, backcol, nil, nil, true, true)

		draw.SimpleText(name, "TW24", w/2, 0, white, 1, 5)

	end) 

	

	cam.PopModelMatrix()

	sx, sy = sx - w/2 * scale, sy - h/2 * scale

	local hpfrac = (EntHP / EntMaxHP) 
	HPFrac = L(HPFrac, hpfrac, 15)

	local hpw = HPFrac * (w-12)

	local bary = y - 6*scale

	local boxw = math.max(hpw, 8)*scale			--for nice rounding

	local hph = math.ceil(14*scale)

	DrawScalingBox(6, sx + 6, bary - 1, w*scale - 12, hph, HPBG)

	render.SetScissorRect(sx + 6, bary - 1, sx + 6 + hpw, bary + hph + 1, true)

		DrawScalingBox(6, sx + 6, bary - 1, boxw, hph, HPFG)	--HP Bar

	render.SetScissorRect(0, 0, 0, 0, false)
	
	--Prepare for new bar (Power)

	bary = bary + hph + 6*scale


	local pwfrac = (EntPW / EntMaxPW)
	PWFrac = L(PWFrac, pwfrac, 15)

	local pww = PWFrac * (w-12)
	boxw = math.min(math.max(pww, 8) * scale, w-13)

	DrawScalingBox(6, sx + 6, bary - 1, w*scale - 12, hph, HPBG)

	render.SetScissorRect(sx + 6, bary - 1, sx + 6 + pww, bary + hph + 1, true)

		DrawScalingBox(6, sx + 6, bary - 1, boxw, hph, PWFG)	--HP Bar

	render.SetScissorRect(0, 0, 0, 0, false)

	if not ok then 
		print("err >:(", err)
	end
	--[[
	surface.SetDrawColor(shade)
	surface.SetFont(Font)
	w, h = surface.GetTextSize(name)

	draw.SimpleText(name, Font, oldx - w / 2 - offx, cury, shade)
	draw.SimpleText(name, Font, oldx - w / 2 - offx, cury, Color(160, 190, 255, (20-offx)*13 - physd))

	if ent:Health() > 0 then

		cury = cury + H

		local MaxHealth = ent:GetMaxHealth() or 100

		local HealthStr = ent:Health() .. "/" .. MaxHealth .. " HP"
		oldEHP = L(oldEHP, ent:Health())
		local HPLen = math.Clamp(W * (oldEHP / MaxHealth), 0, W)
		

		draw.RoundedBox(6, curx + Padding - 3, cury + Padding - 3, W - 5, H + EndPad + 4, Color(200,200,200,(20-offx)*10 - physd*1.3)  )	  --Frame

		draw.RoundedBox(6, curx + Padding - 1, cury + Padding - 1, W - 9, H + EndPad  , Color(120,120,120,(20-offx)*13 - physd*1.5)  ) --Background
		
		draw.RoundedBox(6, curx + Padding - 1, cury + Padding - 1, math.Max(HPLen + EndPad + 1,0) , H + EndPad, Color(235, 0  , 0  , (20-offx)*10 - physd) )	--Health

		

		

	
		surface.SetFont(Font2)
		w, h = surface.GetTextSize(HealthStr)

		draw.SimpleText(HealthStr, Font2, oldx - w / 2, cury + Padding - 2, shade)
		draw.SimpleText(HealthStr, Font2, oldx - w / 2, cury + Padding - 2, whoite)

	end

	if ent.GetPower then

		cury = cury + H

		--surface.SetDrawColor(shade)
		--surface.DrawRect(curx, cury, W, H)

		local MaxPower = ent:GetMaxPower() or 100
		
		local PowerStr = (ent:GetPower() > 0 and ent:GetPower() .. "/" .. MaxPower .. " PW") or Language.NoPower

		local PWLen = math.Clamp(W * (ent:GetPower() / MaxPower), 0, W)

		oldEPW = L(oldEPW, PWLen)

		draw.RoundedBox(6, curx + Padding - 3, cury + Padding - 3, W - 4, H + EndPad + 4, Color(200,200,200,(20 - offx) * 10 - physd*1.3 )  )	  --Frame

		draw.RoundedBox(6, curx + Padding - 1, cury + Padding - 1, W - 9, H + EndPad  , Color(120,120,120,(20 - offx) * 13 - physd*1.5) ) --Background

		draw.RoundedBox(6, curx + Padding, cury + Padding - 1, math.max(oldEPW - 10,0), H + EndPad , Color(0  , 0  , 215, (20 - offx) * 10 - physd) )

		surface.SetFont(Font2)
		w, h = surface.GetTextSize(PowerStr)

		draw.SimpleText(PowerStr, Font2, oldx - w / 2, cury + Padding - 2, shade)
		draw.SimpleText(PowerStr, Font2, oldx - w / 2, cury + Padding - 2, whoite)

	end

	if IsValid(ent) and ent:GetClass() ~= "prop_physics" and ent:BadlyDamaged() then

		cury = cury + H + 1

		surface.SetDrawColor(shade)
		surface.DrawRect(curx, cury, W, H)

		local Str = Language.NoHealth

		surface.SetFont(Font2)
		w, h = surface.GetTextSize(Str)

		draw.SimpleText(Str, Font2, oldx - w / 2, cury + Padding - 1, shade)
		draw.SimpleText(Str, Font2, oldx - w / 2, cury + Padding - 1, whoite)

	end
	]]
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
