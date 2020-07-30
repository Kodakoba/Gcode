
include('shared.lua')

 SWEP.PrintName        = "Dash SWEP"
 SWEP.Slot		= 4
 SWEP.SlotPos		= 0
 SWEP.DrawAmmo		= false
 SWEP.DrawCrosshair	= false

--Color(240,40,40)
--Color(40,40,240)
local CurrentColor = Color(240, 40, 40)
local snapTime = CurTime()

local snap = false
local snapped = false

local snapCols = {
	[0] = Color(50, 100, 250),
	[1] = Color(250, 60, 60),
}

local snapTo = 0

local oldCharges=0
local newCharges=0

local snapDur = 0.25
local flashDur = 0.2

local dir = 0
local size = 64


local dbgFr = 0

local col = color_white:Copy()

local anim

function SWEP:DrawHUD()
	anim = anim or Animatable()

	oldCharges = newCharges
	newCharges = self:GetDashCharges()

	if oldCharges ~= newCharges and not snap then
		if newCharges > oldCharges then
			anim:To("Frac", 1, 0.2, 0, 0.2)
			anim.Dir = 1
			CurrentColor:Set(color_white)
			anim:LerpColor(CurrentColor, snapCols[1], 0.3, 0.1, 2)
		else
			anim:To("Frac", 0, 0.3, 0, 0.2)
			anim.Dir = -1
			CurrentColor:Set(color_white)
			anim:LerpColor(CurrentColor, snapCols[0], 0.15, 0.0, 2)
		end

		anim.RecentChangeFrac = 1
		anim:To("RecentChangeFrac", 0, anim.Dir == -1 and 0.2 or 0.4, 0, 0.3, true)
	end


	local fr = anim.Frac or 0
	local recfr = anim.RecentChangeFrac or 0

	local int = 2
	local spr = 5 * (anim.Dir == -1 and 1 - recfr or recfr)
	local blur = 4

	size = 48 + fr * 16

	local a = recfr * 600

	if a > 5 and spr > 0 then
		BSHADOWS.BeginShadow()
	end

		surface.SetDrawColor(CurrentColor)

		draw.NoTexture()
		draw.DrawCircle(ScrW()/2, ScrH() * 0.9 - 64, size - 2, 20)

	if a > 5 and spr > 0 then
		BSHADOWS.EndShadow(int, spr, blur, a, nil, nil, nil, Color(255, 255, 255))
	end

	draw.DrawMaterialCircle(ScrW()/2, ScrH() * 0.9 - 64, size*2)

end
