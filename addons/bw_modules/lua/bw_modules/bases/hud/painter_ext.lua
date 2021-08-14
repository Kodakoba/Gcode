local bw = BaseWars.Bases
local nw = bw.NW
local hud = bw.HUD

hud.ActivePainters = hud.ActivePainters or {} 	-- [seqid] = painter
hud.BaseToPaint = hud.BaseToPaint or {}		-- [baseid] = painter

hud.Painter = hud.Painter or Emitter:extend()
hud.PaintOps = hud.PaintOps or {}

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
	assert(bw.IsBase(base))

	self._PaintIter = {} -- seq table
	self._Paints = {}	 -- [{tbl, name}] = prio
	self._Base = base

	self.AppearFrac = 0
	self.DisappearFrac = 0

	self:SetSize(64, 64)

	hud.BaseToPaint[base] = self

	table.insert(hud.ActivePainters, self)
	hook.Run("BW_BasePainterCreate", self)

	for k,v in pairs(hud.PaintOps) do
		self:AddPaint(v[2], k, v[1])
	end
end

ChainAccessor(ptr, "_Base", "Base")

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

	an:RemoveMemberLerp(self, "W")
	an:RemoveMemberLerp(self, "H")

	if w ~= -1 then
		an:MemberLerp(self, "W", w, time, del, ease)
	end

	if h ~= -1 then
		an:MemberLerp(self, "H", h, time, del, ease)
	end
end

function ptr:Delete()
	table.RemoveByValue(hud.ActivePainters, self)
	local base = self:GetBase()

	if hud.BaseToPaint[base] == self then
		hud.BaseToPaint[base] = nil
	end
end

function ptr:Appear()
	self.Disappearing = false

	if self.Disappeared then
		self.DisappearFrac = 0
		self.AppearFrac = 0
		self.Disappeared = false
	end

	local an = hud.Anims

	local anim, new = an:MemberLerp(self, "AppearFrac", 1, 0.3, 0, 0.3)
	an:MemberLerp(self, "DisappearFrac", 0, 0.3, 0, 0.3)

	timer.Remove("PainterInvalidate" .. ("%p"):format(self))
end

function ptr:Disappear()
	if self.Disappeared or self.Disappearing then return end
	self.Disappearing = true

	local an = hud.Anims
	local anim, new = an:MemberLerp(self, "DisappearFrac", 1, 0.2, 0, 2.8)
	if new then
		anim:Then(function()
			self.AppearFrac = 0
			self.DisappearFrac = 1
			self.Disappeared = true

			timer.Create("PainterInvalidate" .. ("%p"):format(self), 3, 0, function()
				self:Delete()
			end)
		end)
	end
	-- disappear doesnt stop appear frac
end

local mx = Matrix()

function ptr:_GenMatrix()
	local infr, outfr = self.AppearFrac, self.DisappearFrac

	local cx = Lerp(infr, self.AppearFromX, self.AppearToX)
	local cy = Lerp(infr, self.AppearFromY - self:GetTall(), self.AppearToY)

	cx = Lerp(outfr, cx, self.DisappearToX - self:GetWide())
	cy = Lerp(outfr, cy, self.DisappearToY)

	mx:Identity()
	mx:TranslateNumber(cx, cy)
end

local errer = GenerateErrorer("BasePainter")

function ptr:Paint()
	local cury = 0

	self:_GenMatrix()

	cam.PushModelMatrix(mx, true)
		for _, dat in ipairs(self._PaintIter) do
			local ok, ret = xpcall(dat[2][dat[1]], errer, self, cury)
			if isnumber(ret) then
				cury = cury + ret
			end
		end
	cam.PopModelMatrix()

	self:SizeTo(-1, cury, 0.3, 0, 0.3)
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


function hud.CreateBasePainter(base)
	return ptr:new(base)
end

function hud.GetBasePainter(base)
	if not hud.BaseToPaint[base] then
		hud.CreateBasePainter(base)
	end

	return hud.BaseToPaint[base]
end

function hud.AddPaintOp(prio, name, tbl)
	if (not tbl or not tbl[name]) and not ptr[name] then
		errorf("ptr:AddPaint() : tbl.%s and ptr.%s didn't exist.", name, name)
		return
	end

	for k,v in pairs(hud.BaseToPaint) do
		v:AddPaint(prio, name, tbl)
	end

	hud.PaintOps[name] = {tbl, prio}
end

function hud.RestartPainters()
	table.Empty(hud.ActivePainters)
	table.Empty(hud.BaseToPaint)
end

function hud.DoPainters(base, zone)
	local ptr = base and hud.GetBasePainter(base)

	if base then
		ptr:Appear()
	end

	for i=#hud.ActivePainters, 1, -1 do
		local ptr = hud.ActivePainters[i]
		if ptr:GetBase() ~= base then
			ptr:Disappear()
		end
		ptr:Paint()
	end
end

FInc.FromHere("*.lua", _CL, false, FInc.RealmResolver():SetDefault(true))

hud.RestartPainters()