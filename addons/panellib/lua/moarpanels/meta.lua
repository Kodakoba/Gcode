local META = FindMetaTable("Panel")
local COLOR = FindMetaTable("Color")

function META:GetCenter(xfrac, yfrac)
	xfrac = xfrac or 0.5 
	yfrac = yfrac or 0.5 

	local w,h = self:GetParent():GetSize()

	local x = w * xfrac 
	local y = h * yfrac 

	local w,h = self:GetSize()

	x = x - w/2 
	y = y - h/2 

	return x, y
end

function META:Lerp(key, val, dur, del, ease)
	local anims = self.__Animations or {}
	self.__Animations = anims 

	local anim
	local from = self[key]

	if anims[key] then 
		local anim = anims[key]
		if anim.ToVal == val then return end --don't re-create animation if we're already lerping to that anyways

		anim:Swap(dur, del, ease)

	else 
		local anim = self:NewAnimation(dur, del, ease)
	end

	anim.Think = function(anim, self, fr)
		self[key] = Lerp(fr, from, val)
	end

end

META.To = META.Lerp

function META:PopIn(dur, del, func)
	self:SetAlpha(0)
	return self:AlphaTo(255, dur or 0.1, del or 0, (isfunction(func) and func) or function() end)
end

function META:PopOut(dur, del, rem)
	local func = (not rem and function(_, self) if IsValid(self) then self:Remove() end end) or rem
	return self:AlphaTo(0, dur or 0.1, del or 0, func)
end

function META:SpringIn(accel, dist, x, y, len, ease, func)
	local anim = self:NewAnimation(len or 0.5, del or 0, ease or -1, func or function() end)
	if x==-1 then x = self.X end 
	if y==-1 then y = self.Y end
	
									--easeOutElastic: function (t) { return .04 * t / (--t) * Math.sin(25 * t) },
	local px, py = self.X, self.Y
	local dx, dy = px - x, py - y

	accel = accel or 3
	dist = (dist and -dist) or -10


	anim.Think = function(self, pnl, frac)
		local t = frac 
		local p = ( 2 * math.pi ) / 3;

		local mult = ( 2 ^ (dist * t) ) * math.sin( ( t * accel - 0.75 ) * p) + 1

		
		pnl:SetPos(px - dx*mult, py - dy*mult)
	end


end

function META:InElastic(dur, del, func, funcend, ease, int, dist)

	local anim = self:NewAnimation(dur or 0.5, del or 0, ease or -1, funcend or function() end)
	anim.func = func 
	if not func then return end --k

	dist = dist or 1
	int = int or 1 

	local from = math.pi*3/2
	local to = from/3

	anim.Think = function(self, pnl, frac)
		
		local var = math.sin(Lerp(frac^int*int, from, to)) * (dist-frac*(dist-1)) * frac

		func(self, pnl, var)
	end

end
local gu = Material("vgui/gradient-u")
local gd = Material("vgui/gradient-d")
local gr = Material("vgui/gradient-r")
local gl = Material("vgui/gradient-l")

function META:DrawGradientBorder(w, h, gw, gh)
	if gh > 0 then 
		surface.SetMaterial(gu)
		surface.DrawTexturedRect(0, 0, w, gh)

		surface.SetMaterial(gd)
		surface.DrawTexturedRect(0, h - gh, w, gh)
	end

	if gw > 0 then
		surface.SetMaterial(gr)
		surface.DrawTexturedRect(w - gw, 0, gw, h)

		surface.SetMaterial(gl)
		surface.DrawTexturedRect(0, 0, gw, h)
	end
end

Animations = {}

anims = {}



animmeta = {}

local function AnimationThink(self, ab)

	local systime = SysTime()
	if self.Finished then return false end 
	
	if ( systime >= self.StartTime ) then

		local Fraction = math.TimeFraction( self.StartTime, self.EndTime, systime )
		Fraction = math.Clamp( Fraction, 0, 1 )

		if ( self.Think ) then

			local Frac = Fraction ^ self.Ease

			-- Ease of -1 == ease in out
			if ( self.Ease < 0 ) then
				Frac = Fraction ^ ( 1.0 - ( ( Fraction - 0.5 ) ) )
			elseif ( self.Ease > 0 && self.Ease < 1 ) then
				Frac = 1 - ( ( 1 - Fraction ) ^ ( 1 / self.Ease ) )
			end

			self.Animate( Frac )
		end

		if ( Fraction == 1 ) then

			if ( self.OnEnd ) then self:OnEnd( self ) end

			anims[k] = nil  
			self.Finished = true

		end

	end

end

animmeta.Think = AnimationThink 

function animmeta:SetThinkManually(b)
	b = (b==nil and true) or b
	if b then
		anims[self.AnimIndex] = nil 
		self.ThinkManually = true
	else 
		anims[self.AnimIndex] = self 
		self.ThinkManually = false 
	end
end

animobj = {}
animobj.__index = animmeta 

local pi2by3 = (2*math.pi)/3
local piby2 = math.pi / 2
local pi3by2 = math.pi * 3 / 2

function Animations.SpringIn(accel, dist, len, ease, func, callback, delay)
	local anim = NewAnimation(len, delay, ease, callback)
	accel = accel or 5
	dist = (dist and -dist) or -10

	anim.Animate = function(frac)
		local t = frac 

		local mult = ( 2 ^ (dist * t) ) * math.sin( ( t * accel - 0.5 ) * pi2by3) + 1

		func(mult)
	end

	return anim
end

function Animations.SpringOut(accel, strength, len, ease, func, callback)
	local anim = NewAnimation(len, 0, ease, callback)

	local p = math.pi * 3 / 2
	local p2 = math.pi * 2

	local lf = 0
	local lt = SysTime()
	anim.Animate = function(frac)
		--print("diff:", (lf-frac) / (SysTime() - lt))

		lf = frac 
		lt = SysTime()

		local mult = math.sin( p2 - (p * frac^accel)) * frac^(1/strength)

		func(mult)
	end

	return anim
end

function Animations.InElastic(dur, del, func, funcend, ease, int, dist)
	local anim = NewAnimation(dur or 0.5, del or 0, ease or -1, funcend or function() end)

	dist = dist or 1
	int = int or 1 

	local from = math.pi*3/2
	local to = from/3

	anim.Animate = function(frac)
		
		local var = math.sin(Lerp(frac^int*int, from, to)) * (dist-frac*(dist-1)) * frac

		func(var)
	end

	return anim
end

function NewAnimation(len, del, ease, callback)
	if ( del == nil ) then del = 0 end
	if ( ease == nil ) then ease = -1 end

	del = del + SysTime()
	
	local anim = {
		EndTime = del + len,
		StartTime = del,
		Ease = ease,
		OnEnd = callback,
		ThinkManually = false
	}

	setmetatable(anim, animobj)
	anim.AnimIndex = table.insert( anims, anim )
	return anim
end


local function AnimationsThink()

	local systime = SysTime()

	for k, anim in pairs( anims ) do

		if ( systime >= anim.StartTime ) then

			local Fraction = math.TimeFraction( anim.StartTime, anim.EndTime, systime )
			Fraction = math.min( Fraction, 1 )

			if ( anim.Animate ) then

				local Frac = Fraction ^ anim.Ease

				-- Ease of -1 == ease in out
				if ( anim.Ease < 0 ) then
					Frac = Fraction ^ ( 1.0 - ( ( Fraction - 0.5 ) ) ) ^ -anim.Ease 
				elseif ( anim.Ease > 0 && anim.Ease < 1 ) then
					Frac = 1 - ( ( 1 - Fraction ) ^ ( 1 / anim.Ease ) )
				end

				anim.Animate( Frac, anim )
			end

			if ( Fraction == 1 ) then

				if ( anim.OnEnd ) then anim:OnEnd( self ) end
				anims[k] = nil  

			end

		end

	end

end

hook.Add("Think", "Animations", AnimationsThink)



function COLOR:Set(col, g, b, a)

	if IsColor(col) then 
		self.r = col.r 
		self.g = col.g 
		self.b = col.b 
		self.a = col.a 
	else 
		self.r = col or self.r
		self.g = g or self.g
		self.b = b or self.b 
		self.a = a or self.a 
	end

end

function COLOR:Copy()
	return Color(self.r, self.g, self.b, self.a)
end