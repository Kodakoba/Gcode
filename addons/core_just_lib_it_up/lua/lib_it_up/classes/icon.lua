LibItUp.SetIncluded()
if not CLIENT then
	Icon = Icon or Object:callable()
	return
end

--[[
	Icon:

	Icon(URL or IMaterial or path to material, name)
		create an Icon object; it's white by default
		if you give it a URL you hafta give it a name as well

	ic:SetColor(col)
		duh

	ic:Paint(x, y, w, h[, rotation])
		duh
		be careful, if you're using rotation then it uses surface.DrawTexturedRectRotated instead of just texturedrect
		this means xy will be not the top left but the middle of the icon now
]]

Icon = Icon or Animatable:callable()
Icon.AutoInitialize = false

local doGet = function(...) return draw.GetMaterial(...) end -- index on call
LibItUp.IncludeIfNeeded("extensions/player.lua")

function Icon:Initialize(url, name, flags, cb)
	if not url then error("Icon.Initialize: expected IMaterial in arg #1 or URL + name, got nothing instead") return end
	if flags then CheckArg(3, flags, isstring, "string") end
	if cb then CheckArg(4, cb, isfunction, "function") end

	local is_url = isstring(url) and url:match("^https?://")

	if is_url and not isstring(name) then error("Icon.Initialize: got URL as arg #1, expected name as arg #2 as well, got nothing instead") return end

	if IsMaterial(url) then
		self.Material = url
	else

		if is_url then
			self.URL = url
			self.Name = name

			-- start downloading before we actually need it
			if CLIENT then
				-- wait for ISteamHTTP
				OnFullyLoaded(doGet, url, name, flags, cb)
			end
		else
			local mat = draw.GetMaterialInfo(url) or Material(url)

			MoarPanelsMats[url] = mat
			self.Material = mat.mat
		end

	end

	self._SizeInitialized = false
	self.W, self.H = 16, 16

	self.Filter = nil
	self.Color = color_white:Copy()

	self.__parent.Initialize(self, false)
end

ChainAccessor(Icon, "Color", "Color", true)

function Icon:AssignColor(col)
	self.Color = col -- literally set the color by reference
end

function Icon:SetColor(col, g, b, a)
	if not col then
		self.Color = nil
		return
	end

	if IsColor(col) then
		self.Color:Set(col)
		return
	end

	local c = self.Color
	c.r = col or 70
	c.g = g or 70
	c.b = b or 70
	c.a = a or 255
end


ChainAccessor(Icon, "Filter", "Filter")
ChainAccessor(Icon, "_Debug", "Debug")

function Icon:SetSize(w, h)
	self.W = w or self.W
	self.H = h or self.H
	self._SizeInitialized = true
	return self
end

function Icon:GetSize()
	local w, h = self.W, self.H

	if self:GetPreserveRatio() then
		local nw, nh = self:_WHPreseveRatio(w, h)
		w, h = nw or w, nh or h
	end

	return w, h
end

function Icon:GetSizeSet()
	if not self._SizeInitialized then return false end
	return self:GetSize()
end

function Icon:GetWide()
	return (self:GetSize())
end

function Icon:GetTall()
	local _, h = self:GetSize()
	return h
end

ChainAccessor(Icon, "_Autosize", "Autosize")
ChainAccessor(Icon, "_Autosize", "AutoResize")
ChainAccessor(Icon, "_Autosize", "AutoSize")

ChainAccessor(Icon, "_Align", "Align")
ChainAccessor(Icon, "_Align", "Alignment")
ChainAccessor(Icon, "_PreserveRatio", "PreserveRatio")

function Icon:PaintIcon(x, y, w, h, rot, xA, yA)
	x = x - math.floor(w * xA)
	y = y - math.floor(h * yA)

	if not self.Material then
		local mat = surface.DrawMaterial(self.URL, self.Name, x, y, w, h, rot)

		if mat and mat.mat and not mat.failed then 	--cache the downloaded material as an IMaterial asap
			self.Material = mat.mat
			if self:GetAutosize() and not self._SizeInitialized then
				local tex = mat.mat:GetTexture("$basetexture")
				self:SetSize(tex:GetMappingWidth(), tex:GetMappingHeight())
			end
		end

	else
		surface.SetMaterial(self.Material)

		local dx, dy = x, y

		if rot then
			surface.DrawTexturedRectRotated(x, y, w, h, rot)
			dx = x - w / 2
			dy = y - h / 2
		else
			surface.DrawTexturedRect(x, y, w, h)
		end

		if self:GetDebug() then
			surface.DrawOutlinedRect(dx, dy, w, h)
		end

		if self:GetAutosize() and not self._SizeInitialized then
			local tex = self.Material:GetTexture("$basetexture")
			self:SetSize(tex:GetMappingWidth(), tex:GetMappingHeight())
		end
	end

end

function Icon:GetMaterial()
	if not self.Material then
		local mat = draw.GetMaterial(self.URL, self.Name)

		if mat and mat.mat and not mat.failed then 			--cache the downloaded material as an IMaterial asap
			self.Material = mat.mat
			return mat.mat
		end

		return false -- no material /shrug
	else
		return self.Material
	end
end

function Icon:_WHPreseveRatio(w, h)
	local mat = self:GetMaterial()
	local info = draw.GetMaterialInfo(mat)

	if info then
		local mw, mh
		if self._ratioSize then
			mw, mh = unpack(self._ratioSize)
		else
			mw, mh = info.w, info.h
		end

		local sc = 1

		if w and not h then
			sc = w / mw
		elseif h and not w then
			sc = h / mh
		else

			if mw >= mh then
				if w > h then
					return h * (mw / mh), h
				else
					return w, w * (mh / mw)
				end
			else
				-- untested
				if w > h then
					return h, h * (mh / mw)
				else
					return w * (mw / mh), w
				end
			end
		end

		return mw * sc, mh * sc
	end
end

function Icon:SetRatioSize(w, h)
	self._ratioSize = {w, h}
	return self
end

function Icon:GetRatioSize()
	if not self._ratioSize then return false end
	return unpack(self._ratioSize)
end

function Icon:RatioSize(w, h)
	local sw, sh = self:GetSize()
	w = w or sw
	h = h or sh

	local nw, nh = self:_WHPreseveRatio(w, h)
	return nw, nh
end

local xAligns = {}
local yAligns = {}

for i=0, 8 do
	xAligns[i + 1] = (i * 0.5) % 1.5
	yAligns[i + 1] = math.floor(i / 3) * 0.5
end

function Icon:__tostring()
	return ("Icon	[%s]	[%gx%g]"):format(self.Name or self.Material or "!?", self:GetWide() or -1, self:GetTall() or -1)
end

function Icon:Paint(x, y, w, h, rot)
	self:AnimationThink()

	-- size priority: 	#1 provided in paint
	-- 					#2 preserved ratio
	-- 					#3 icon width/height

	rot = rot or self.Rotation

	if (w or h) and self:GetPreserveRatio() then
		w, h = self:_WHPreseveRatio(w, h)
	end

	w = math.floor(w or self.W)
	h = math.floor(h or self.H)

	local xA, yA = 0, 0
	local alNum = self:GetAlignment()

	if alNum then
		xA, yA = xAligns[alNum], yAligns[alNum]
	end

	if not w and not h then
		error("Width and Height not given!")
		return
	end

	if not x or not y then
		error("X and/or Y not given!")
		return
	end

	local col = self.Color
	if col then
		surface.SetDrawColor(col.r, col.g, col.b, col.a)
	end

	if self.Filter then
		draw.EnableFilters()
			local ok, err = pcall(self.PaintIcon, self, x, y, w, h, rot, xA, yA)
		draw.DisableFilters()

		if not ok then
			error(err)
		end
	else
		self:PaintIcon(x, y, w, h, rot, xA, yA)
	end

	return w, h
end

function Icon:Copy()
	local new = Icon(self.Material or self.URL, self.Name)
	new:SetColor(self.Color)
	new:SetFilter(self:GetFilter())
	new:SetPreserveRatio(self:GetPreserveRatio())
	new:SetAlign(self:GetAlign())
	new:SetAutoSize(self:GetAutoSize())

	if self:GetSizeSet() then
		new:SetSize(self:GetSize())
	end

	if self:GetRatioSize() then
		new:SetRatioSize(self:GetRatioSize())
	end

	return new
end

function IsIcon(t)
	return getmetatable(t) == Icon
end


Icons = Icons or {}
Icons.Plus = Icon("https://i.imgur.com/dO5eomW.png", "plus.png")
Icons.Dickbutt = Icon("https://i.imgur.com/z3SWemE.png", "dbutt_icon.png")
Icons.TrashCan = Icon("https://i.imgur.com/hTA3WB7.png", "trash.png")
Icons.Save = Icon("https://i.imgur.com/zcw7NQQ.png", "save64.png")
Icons.Edit = Icon("https://i.imgur.com/ZhVoxFk.png", "edit.png")
Icons.Flag128 = Icon("https://i.imgur.com/DMgRjSC.png", "flag128.png")
Icons.MagnifyingGlass128 = Icon("https://i.imgur.com/8NayKhl.png", "mag_glass128.png")
Icons.Electricity = Icon("https://i.imgur.com/poRxTau.png", "electricity.png")
Icons.Clock64 = Icon("https://i.imgur.com/KW4Pbbd.png", "clk64.png")
Icons.Clock = Icon("https://i.imgur.com/H455Xz3.png", "clk32_3.png")
Icons.Coins = Icon("https://i.imgur.com/vzrqPxk.png", "coins_pound64.png")
Icons.CoinAdd = Icon("https://i.imgur.com/cjrTOrv.png", "coin_add.png")
Icons.Star = Icon("https://i.imgur.com/YYXglpb.png", "star.png")
Icons.Reload = Icon("https://i.imgur.com/Kr2xpAj.png", "refresh.png")

-- https://www.flaticon.com/free-icon/money_61584?term=money&page=1&position=16&page=1&position=16&related_id=61584&origin=tag
Icons.Money64 = Icon("https://i.imgur.com/NVl7wuF.png", "moneybag_64.png")
Icons.Money32 = Icon("https://i.imgur.com/lRpS2NE.png", "moneybag_32.png")
Icons.Unsafe = Icon("https://i.imgur.com/Xq0xmuF.png", "unsafe.png")
Icons.RadGradient = Icon("https://i.imgur.com/uk9gDB8.png", "radial2.png")
Icons.Arrow = Icon("https://i.imgur.com/jFHSu7s.png", "arr_right.png")

Icons.Lodestar = Icon("https://i.imgur.com/rkdDDb0.png", "ldstar128.png")