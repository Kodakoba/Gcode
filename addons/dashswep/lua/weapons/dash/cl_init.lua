
include('shared.lua')

SWEP.PrintName        = "Dash SWEP"
SWEP.Slot		= 4
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false


local CurrentColor = Color(240, 40, 40)
local dimmedCurCol = Color(0, 0, 0)

local snap = false

local snapCols = {
	[0] = Color(50, 100, 250),
	[1] = Color(250, 60, 60),
}

local oldCharges = 0
local newCharges = 0

local size = 64

local anim

function SWEP:DrawHUD()
	anim = anim or Animatable()

	oldCharges = newCharges
	newCharges = self:GetDashCharges()

	if oldCharges ~= newCharges and not snap then
		if newCharges > oldCharges then
			anim:To("Frac", 1, 0.2, 0, 0.2, true)
			anim.Dir = 1
			CurrentColor:Set(color_white)
			anim:LerpColor(CurrentColor, snapCols[1], 0.3, 0.1, 2, true)
		else
			anim:To("Frac", 0, 0.3, 0, 0.2, true)
			anim.Dir = -1
			CurrentColor:Set(color_white)
			anim:LerpColor(CurrentColor, snapCols[0], 0.15, 0, 2, true)
		end

		anim.RecentChangeFrac = 1
		anim:To("RecentChangeFrac", 0, anim.Dir == -1 and 0.2 or 0.4, 0, 0.3, true)
	end

	local cdDur = self.CooldownDuration
	local cdNext = self.CooldownEndsWhen

	local cdFrac = math.Clamp(
		(cdDur ~= 0 and cdNext == 0 and 0)
		or (CurTime() - cdNext) / cdDur + 1
		, 0, 1)
	--print(CurTime(), cdNext, cdDur)
	local fr = cdFrac

	if cdFrac < 0.2 then
		cdFrac = cdFrac ^ 4
	else
		local f = cdFrac ^ 4
		cdFrac = f + (cdFrac ^ 32) * (1 - f)
	end

	--print(cdFrac, fr)

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

		surface.SetDrawColor(dimmedCurCol:Unpack())
		draw.DrawMaterialCircle(ScrW()/2, ScrH() * 0.9 - 64, size*2, 20)

		surface.SetDrawColor(CurrentColor:Unpack())
		draw.DrawMaterialCircle(ScrW()/2, ScrH() * 0.9 - 64, size*2 * cdFrac)
		--draw.NoTexture()
		--draw.DrawCircle(ScrW()/2, ScrH() * 0.9 - 64, size - 2, 20)

	if a > 5 and spr > 0 then
		BSHADOWS.EndShadow(int, spr, blur, a, nil, nil, nil, Color(255, 255, 255))
	end

	dimmedCurCol:Set(CurrentColor)
	dimmedCurCol:ModHSV(0, 0, (cdFrac < 1 and -(1.25 - cdFrac) * 0.3) or 0)

	surface.SetDrawColor(dimmedCurCol:Unpack())
	

end
