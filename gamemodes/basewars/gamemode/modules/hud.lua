MODULE = BaseWars.HUD or {}
MODULE.Name 	= "HUD"
MODULE.Author 	= "Q2F2 & Ghosty"
MODULE.Realm 	= 2
MODULE.Credits 	= "Based on geist by ghosty; https://github.com/TrenchFroast/ghostys-server-stuff/blob/master/lua/autorun/client/geist_hud.lua"

BaseWars.HUD = {} 
local MODULE = BaseWars.HUD
local tag = "BaseWars.HUD"
----[[
local function Curry(func)
		local function Fuck(...)
			return func(...)
		end
	return Fuck
end
--]]
if SERVER then return end
function MODULE:__INIT()

	surface.CreateFont(tag, {
		font = "Roboto",
		size = 16,
		weight = 800,
	})

	surface.CreateFont(tag .. ".Large", {
		font = "Roboto",
		size = 20,
		weight = 1200,
	})

	surface.CreateFont(tag .. ".Time", {
		font = "Roboto",
		size = 28,
		weight = 800,
	})

end

local clamp = math.Clamp
local floor = math.floor
local round = math.Round


local shade = Color(0, 0, 0, 150)
local shape = Color(15,60,120,255)
local trans = Color(255, 255, 255, 150)
local textc = Color(100, 150, 200, 255)
local hpbck = Color(125, 0  , 0  , 200)
local pwbck = Color(0  , 0  , 125, 200)
local red	= Color(255, 0  , 0	 , 255)
local HasteRot = 0
local draw = draw 
local function Circ(x, y, radius, seg, perc)

	local cir = {}
    local times = (seg / 100 * (math.min(perc or 100, 100)) )
    draw.NoTexture()

    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )

    for i = 0, times do
        local a = math.rad( ( i / seg ) * -360 )
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = 0.5} )--math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end

    --local a = math.rad( 0 ) -- This is needed for non absolute segment counts
    --table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    surface.DrawPoly( cir )

end
local function DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )

	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )

	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s

	surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )

end

local function Calc(real, max, min, w)

	real = clamp(real,min or 0,max)
	real = real / max

	if w then

		local calw = w * real

		return calw, w - calw

	else

		return real

	end

end

local current
local prevent 

local oldhW = 0
local oldHP = 0
local oldEHP = 0
local oldEPW = 0
local oldaW = 0
local oldAM = 0

local offx=0
local physd = 0

local RuneDurs = {

	["invis"] = { time = 30, pic = Material("vgui/prestige/Empty.png"), p = 0, o = 0, name = "Invisibility"},
	["haste"] = { time = 20, pic = Material("vgui/runes/timer.png"), p = 0, o = 0, pic2 = Material("vgui/runes/arrow.png"), name = "Haste"},
	["regen"] = { time = 15, pic = Material("vgui/prestige/Empty.png"), p = 0, o = 0, name = "Regeneration"},
	
}
local function DrawStructureInfo()

	local me = LocalPlayer()
	local Ent = me:GetEyeTrace().Entity
	local Draw = false
	offx=offx or 0
	if !Ent:IsValid() then oldEHP = 100 prevent = nil end

	if IsValid(Ent) and Ent:GetPos():DistToSqr(me:GetPos()) < 0x00010000 	--thanks cake
	and (Ent.IsElectronic or Ent.IsGenerator or Ent.DrawStructureDisplay) then

		ent=Ent
		Draw=true
	end



	if not Draw then offx = L(offx, 20) else offx = L(offx, 0) end
	if not ent or not ent:IsValid() then ent=LocalPlayer() end
	prevent = current or nil
	current = ent
	if current~=prevent or prevent == nil then offx=20 end
	local Pos = ent:GetPos()
	Pos.z = Pos.z + 14 - offx/8
	
	Pos = Pos:ToScreen()

	local name = ((ent.PrintName or (ent.GetName and ent:GetName()) or (ent.Nick and ent:Nick()) or ent:GetClass()):Trim()) or ""
	local W = BaseWars.Config.HUD.EntW
	local H = BaseWars.Config.HUD.EntH

	local oldx, oldy = Pos.x, Pos.y
	local curx, cury = Pos.x, Pos.y
	local w, h
	local Font = BaseWars.Config.HUD.EntFont
	local Font2 = BaseWars.Config.HUD.EntFont2
	local Padding = 5
	local EndPad = -Padding * 2
	local wep = LocalPlayer():GetActiveWeapon()
	local physc = 0
	if (IsValid(wep) and wep:GetClass() == "weapon_physgun") then 
		if LocalPlayer():KeyDown(IN_ATTACK) then 
			physc = 220
		else
			physc = 40
		end
	end
	physd = L(physd, physc)
	curx = curx - W / 2
	cury = cury - H / 2

local shade = Color(0, 0, 0, (20-offx)*7 		)
local shape = Color(15,60,120,(20-offx)*13 		- physd)
local trans = Color(255, 255, 255, (20-offx)*8  - physd)
local textc = Color(100, 150, 200, (20-offx)*13 - physd)
local hpbck = Color(125, 0  , 0  , (20-offx)*10 - physd)
local pwbck = Color(0  , 0  , 125, (20-offx)*10 - physd)
local red	= Color(255, 0  , 0	 , (20-offx)*13 - physd)
local whoite = Color(255,255,255, (20-offx)*15 - physd )
local gradient = Color(40,90,180, (20-offx)*11 - physd )

	draw.RoundedBox(4,curx,cury,W,H*3,gradient)

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
		
		local PowerStr = (ent:GetPower() > 0 and ent:GetPower() .. "/" .. MaxPower .. " PW") or BaseWars.LANG.PowerFailure

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

	if !ent:GetClass()=="prop_physics" && ent:BadlyDamaged() then

		cury = cury + H + 1

		surface.SetDrawColor(shade)
		surface.DrawRect(curx, cury, W, H)

		local Str = BaseWars.LANG.HealthFailure

		surface.SetFont(Font2)
		w, h = surface.GetTextSize(Str)

		draw.SimpleText(Str, Font2, oldx - w / 2, cury + Padding - 1, shade)
		draw.SimpleText(Str, Font2, oldx - w / 2, cury + Padding - 1, whoite)

	end

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
