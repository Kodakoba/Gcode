include('shared.lua')
 
 SWEP.PrintName        = "Dash SWEP"			
 SWEP.Slot		= 4
 SWEP.SlotPos		= 0
 SWEP.DrawAmmo		= false
 SWEP.DrawCrosshair	= false

--Color(240,40,40)
--Color(40,40,240)

local CurrentColor = Color(240,40,40)
local snapTime = CurTime()

local snap = false 
local snapped = false 

local snapCols = {
	[0] = Color(50, 100, 250),
	[1] = Color(250, 60, 60),
}

local snapTo = 0

function SWEP:Initialize()

end


local oldCharges=0
local newCharges=0

local snapDur = 0.25
local flashDur = 0.2

local dir = 0
local size = 64 

function SWEP:DrawHUD()

	oldCharges = newCharges
	newCharges = self:GetDashCharges()

	if oldCharges ~= newCharges and not snap then 
		snap = true 
		snapped = false
		snapTo = newCharges
		snapTime = CurTime() 
		dir = newCharges - oldCharges
	end

	if snap and CurTime() - snapTime > snapDur then 
		snap = false 
		--dir = 0
	end

	if CurTime() - snapTime > flashDur then 
		dir = 0
	end



	local to = (snap and Color(255, 255, 255)) or snapCols[newCharges]

	local fr = math.min(math.TimeFraction(snapTime, snapTime + flashDur, CurTime()), 1)

	fr = (dir == 1 and 1 - fr) or (dir==-1 and fr^0.6) or 0

	local int = 1
	local spr = 5 * fr
	local blur = 2

	CurrentColor = LC(CurrentColor, to, 25, true)

	local tosize = (dir==-1 and 48) or (dir==1 and 64) or (newCharges == 0 and 48) or (snap and size) or 64
	size = L(size, tosize, 15)


	local a = (1 - fr) * 1000

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

