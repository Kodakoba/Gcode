AddCSLuaFile()
include('shared.lua')
ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.Model 		= "models/hunter/blocks/cube025x025x025.mdl"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local function LC(col, dest, vel)
	local v = 10
	if not IsColor(col) or not IsColor(dest) then return end
	if isnumber(vel) then v = vel end
	local r = Lerp(FrameTime()*v, col.r, dest.r)
	local g = Lerp(FrameTime()*v, col.g, dest.g)
	local b = Lerp(FrameTime()*v, col.b, dest.b)
	local a = Lerp(FrameTime()*v, col.a or 255, dest.a or 255)
	return Color(r,g,b,a)
end

local function L(s,d,v)
	if not v then v = 5 end
	if not s then s = 0 end
	return Lerp(FrameTime()*v, s, d)
end

function ENT:Initialize()
	self:SetModel(self.Model)
	local name = self:GetZoneName()
	local pos = SafezonePoints[name]

	self:SetRenderBoundsWS(pos[1], pos[2],Vector(2,2,2))

	self.min = pos[1]
	self.max = pos[2]
	print(pos[1], pos[2])
	self.BoxCol = Color(25,225,25,0)
end

local a = 0
local ba = 0

local drawDist = 2048
function ENT:Draw()		--shhhh sneaky workaround
	local pos = self:GetPos()

	local min = self.min
	local max = self.max
	local mepos = EyePos()

	local bmin = min - pos
	local bmax = max - pos


	local rbmin, rbmax = self:GetRenderBounds()

	local rbsum = math.abs(rbmin.x + rbmin.y + rbmin.z) --totally not how vectors work but who cares?
	local bsum = math.abs(bmin.x + bmin.y + bmin.z)		--also this is to set renderbounds if they're not what they're supposed to be: Initialize() seems to..not work?
	if rbsum - bsum < 6 then
		self:SetRenderBoundsWS(min, max,Vector(2,2,2))
	end

	render.SetColorMaterial()

	render.DrawBox(pos, Angle(0,0,0), bmin, bmax, self.BoxCol)	--render outwards
	render.DrawBox(pos, Angle(0,0,0), bmax, bmin, self.BoxCol)	--render inwards
	local desCol = Color(5, 5, 5, ba*2)

	if mepos:WithinAABox(min, max) then ba = math.min(L(ba, 30, 15), 30) desCol = Color(25,225,25, ba) self.BoxCol = LC(self.BoxCol, desCol) return end 

	self.BoxCol = LC(self.BoxCol, desCol)

	local vec, dir, frac = 	util.IntersectRayWithOBB(mepos, LocalPlayer():EyeAngles():Forward()*drawDist, pos, Angle(0,0,0), bmin, bmax )
		
	if vec then 
		ba = L(ba, 60, 15)
		local ang = dir:Angle()

		ang.p = 0
		ang:RotateAroundAxis(ang:Up(),90)
		ang:RotateAroundAxis(ang:Forward(),90)
		--ang:RotateAroundAxis(ang:Right(),90)
		cam.Start3D2D(vec, ang, 0.1)
			local dist = frac * 2048
			 if dist < 512 and dist > 256 then 
			 	a=math.max(frac*50, L(a, 255, 15))
			 else
			 	a=math.min(frac*1000, L(a, 0, 25))
			 end
			--surface.SetDrawColor(20, 20, 20, 50)
			--surface.DrawRect(0,0,64,64)
			draw.SimpleText("SAFEZONE","A128", 0, 0, ColorAlpha(color_white, a),1,1)
		cam.End3D2D()

	 else 

	 	ba = L(ba, 0, 2)

	 end

end
