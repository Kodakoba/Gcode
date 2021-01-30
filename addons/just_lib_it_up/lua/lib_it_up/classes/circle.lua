-- YOU MAY HAVE DA STENCILS, BUT I HAVE DA ANIMATIONS

if not LibItUp.Animatable then include("animatable.lua") end
setfenv(0, _G)
LibItUp.Circle = LibItUp.Circle or LibItUp.Animatable:callable()

local sin = math.sin
local cos = math.cos
local mrad = math.rad

local circ = LibItUp.Circle
circ.AutoInitialize = false

function circ:Initialize()
	self._Polies = {}
	self._Template = nil	-- new templates generated whenever the segment count changes

	self._SegmentCount = 60 -- 60 usually suffices

	-- intentionally not marked as `internal` so you can use :To on these mfers
	self.StartAngle = 0
	self.EndAngle = 360
	self.Radius = 64
end

function circ:_GenerateSubPoly(ang, x, y, rad, frac)
	local s, c = cos( mrad(ang) - math.pi / 2 ), sin( mrad(ang) - math.pi / 2 )

	local ret = {
		x = x + s * rad,
		y = y + c * rad,
		u = s/2 + 0.5,
		v = c/2 + 0.5
	}

	return ret
end


function circ:_GenerateTemplate()
	local circ = {}
	self._Template = circ

	local seg = self._SegmentCount

	local segAngle = 360 / seg 	-- how many deg 1 poly covers
	local segRad = mrad(segAngle)

	for i=1, seg+1 do
		local ang = segRad * (i-1) - math.pi/2 -- in radians
		local s = cos(ang)
		local c = sin(ang)

		local p = {
			x = s,
			y = c,
			u = s/2 + 0.5,
			v = c/2 + 0.5
		}

		circ[i] = p
	end

end

function circ:_RegeneratePolies(x, y)

	local startAngle = self.StartAngle
	local endAngle = self.EndAngle

	local rad = self.Radius

	local seg = self._SegmentCount
	local segAngle = 360 / seg

	local sa = math.min(endAngle, startAngle)
	local ea = math.max(endAngle, startAngle)

	local poly = self._Polies or {}

	poly[1] = {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	}

	local curPoly = 2

	local skipFirst = math.ceil(sa / segAngle)
	local useSegs = math.abs(ea - sa) / segAngle

	if useSegs % 1 ~= 0 then
		poly[curPoly] = self:_GenerateSubPoly(sa, x, y, rad)
		curPoly = curPoly + 1
		useSegs = math.floor(useSegs)
	end
	

	for i=0, useSegs-1 do
		local t = self._Template[skipFirst + i + 1]

		poly[curPoly + i] = {
			x = t.x * rad + x,
			y = t.y * rad + y,
			u = t.u,
			v = t.v
		}

	end
	
	poly[curPoly + useSegs] = self:_GenerateSubPoly(ea, x, y, rad)
	poly[curPoly + useSegs + 1] = nil

	self._Polies = poly
end

function circ:Paint(x, y)
	if not self._Template then self:_GenerateTemplate() end

	if self._LastX ~= x or self._LastY ~= y or self._SettingsChanged then
		self:_RegeneratePolies(x, y)
		self._LastX = x
		self._LastY = y
		self._SettingsChanged = false
	end

	surface.DrawPoly(self._Polies)
end

local function ChangeAccessor(k, requireRetemplate)

	circ["Get" .. k] = function(s)
		return s[k]
	end

	circ["Set" .. k] = function(s, v)
		CheckArg(1, v, isnumber, "number")
		s[k] = v
		s._SettingsChanged = true

		return s
	end

end

ChangeAccessor("Radius")
ChangeAccessor("EndAngle")
ChangeAccessor("StartAngle")
ChangeAccessor("Segments", true)

function circ:SetSegments(amt)
	CheckArg(1, amt, isnumber, "number")

	if self._SegmentCount ~= amt then
		self._SegmentCount = amt
		self._SettingsChanged = true
		self._Template = nil
	end
end