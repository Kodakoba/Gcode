
local hud = BaseWars.HUD

hud.Anims = hud.Anims or Animatable("painter_anims")
hud.Painter = hud.Painter or Emitter:extend()
hud.RegisteredPainters = hud.RegisteredPainters or muldim:new()

hud.MaxY = 0

local ptr = hud.Painter

function ptr:_GenRes()
	ptr.AppearFromX = math.ceil(ScrW() * 0.03)
	ptr.AppearFromY = -math.ceil(ScrH() * 0.03) -- bottom-aligned

	ptr.AppearToX = math.ceil(ScrW() * 0.03)
	ptr.AppearToY = math.ceil(ScrH() * 0.03) -- top-aligned

	ptr.DisappearToX = -math.ceil(ScrW() * 0.03) -- right-aligned
	ptr.DisappearToY = math.ceil(ScrH() * 0.03) -- top-aligned
end

ptr:_GenRes()

hook.Add("OnScreenSizeChanged", "Painters", function()
	ptr:_GenRes()
end)

function ptr:Initialize(base)
	self._PaintIter = {} -- seq table
	self._Paints = {}	 -- [{tbl, name}] = prio

	self.AppearFrac = 0
	self.DisappearFrac = 0

	self.AppearTime = 0.3
	self.AppearDelay = 0
	self.AppearEase = 0.3

	self.DisappearTime = 0.2
	self.DisappearDelay = 0
	self.DisappearEase = 2.8

	self:SetSize(64, 64)

	hook.Run("BW_PainterCreate", self)
end

function ptr:FillPainters(tbl)
	for k,v in pairs(tbl) do
		self:AddPaint(v[2], k, v[1])
	end
end

function ptr:AddPaint(prio, name, tbl)
	if (not tbl or not tbl[name]) and not ptr[name] then
		errorf("ptr:AddPaint() : tbl.%s and ptr.%s didn't exist.", name, name)
		return
	end

	self._Paints[name] = {tbl or self, prio}
	self:_RebuildIter()
end

function ptr:SetSize(w, h)
	self.W = w or self.W
	self.H = h or self.H
	return self
end

function ptr:GetSize()
	return self.W, self.H
end

ChainAccessor(ptr, "W", "Wide")
ChainAccessor(ptr, "H", "Tall")

function ptr:SizeTo(w, h, time, del, ease)
	local an = hud.Anims

	if w ~= -1 then
		an:MemberLerp(self, "W", w, time, del, ease)
	end

	if h ~= -1 then
		an:MemberLerp(self, "H", h, time, del, ease)
	end
end

function ptr:Delete()
	-- for override
end

function ptr:Appear()
	self.Disappearing = false

	if self.Disappeared then
		self.DisappearFrac = 0
		self.AppearFrac = 0
		self.Disappeared = false
	end

	local an = hud.Anims

	local anim, new = an:MemberLerp(self, "AppearFrac", 1,
		self.AppearTime, self.AppearDelay, self.AppearEase)
	an:MemberLerp(self, "DisappearFrac", 0,
		self.AppearTime, self.AppearDelay, self.AppearEase)

	timer.Remove("PainterInvalidate" .. ("%p"):format(self))
end

function ptr:Disappear()
	if self.Disappeared or self.Disappearing then return end
	self.Disappearing = true

	local an = hud.Anims
	local anim, new = an:MemberLerp(self, "DisappearFrac", 1,
		self.DisappearTime, self.DisappearDelay, self.DisappearEase)

	if new then
		anim:Then(function()
			self.AppearFrac = 0
			self.DisappearFrac = 1
			self.Disappeared = true

			timer.Create("PainterInvalidate" .. ("%p"):format(self), 2, 1, function()
				self:Delete()
			end)
		end)
	end
	-- disappear doesnt stop appear frac
end


ptr.Matrix = Matrix()
local mx = ptr.Matrix

function ptr:_GenMatrix(mx)
	local infr, outfr = self.AppearFrac, self.DisappearFrac
	-- for override
end

local errer = GenerateErrorer("Painter")

function ptr:Paint()
	if self.DisappearFrac == 1 then return 0 end

	local cury = 0
	local sizey = 0

	mx:Reset()
	self:_GenMatrix(mx)

	--White()
	--surface.DrawLine(0, cury, 1000, cury)

	cam.PushModelMatrix(mx, true)
		for _, dat in ipairs(self._PaintIter) do
			--White()
			--surface.DrawLine(0, cury, 1000, cury)
			local ok, yCur, yTo = xpcall(dat[2][dat[1]], errer, self, cury)
			if isnumber(yCur) then
				cury = cury + yCur
				if isnumber(yTo) then
					sizey = sizey + yTo
				else
					sizey = sizey + yCur
				end
			end
		end

		--White()
		--surface.DrawLine(0, cury, 1000, cury)

	cam.PopModelMatrix()

	self:SizeTo(-1, sizey, 0.3, 0, 0.3)

	return (cury + mx:GetField(2, 4)) * Ease(1 - self.DisappearFrac, 0.3)
end

function ptr:GetFrac()
	return self.AppearFrac - self.DisappearFrac
end

function ptr:_RebuildIter()
	table.Empty(self._PaintIter)
	local cpy = {}
	for k,v in pairs(self._Paints) do
		cpy[#cpy + 1] = {k, v}
		-- {name, {tbl, prio}}
	end

	table.sort(cpy, function(a, b) return a[2][2] > b[2][2] end)

	for k,v in ipairs(cpy) do
		self._PaintIter[k] = {v[1], v[2][1]}
	end
end

function hud.AddPainter(ptr, prio)
	if not hud.RegisteredPainters:Get(prio, ptr) then
		hud.RegisteredPainters:Set(true, ptr, prio)
	end
end