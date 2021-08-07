LibItUp.SetIncluded()
if not CLIENT then return end

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

function Icon:Initialize(url, name)
	if not url then error("Icon.Initialize: expected IMaterial in arg #1 or URL + name, got nothing instead") return end

	local is_url = isstring(url) and url:match("^https?://")

	if is_url and not isstring(name) then error("Icon.Initialize: got URL as arg #1, expected name as arg #2 as well, got nothing instead") return end

	if IsMaterial(url) then
		self.Material = url
	else

		if is_url then
			self.URL = url
			self.Name = name
		else
			local mat = MoarPanelsMats[url] or Material(url)

			MoarPanelsMats[url] = mat
			self.Material = mat
		end

	end

	self._SizeInitialized = false
	self.W, self.H = 16, 16

	self.Filter = nil
	self.Color = color_white:Copy()

	self.__parent.Initialize(self, false)
end

ChainAccessor(Icon, "Color", "Color")
ChainAccessor(Icon, "Filter", "Filter")
ChainAccessor(Icon, "_Debug", "Debug")

function Icon:SetSize(w, h)
	self.W = w or self.W
	self.H = h or self.H
	self._SizeInitialized = true
	return self
end

function Icon:GetSize()
	return self.W, self.H
end

function Icon:GetWide()
	return self.W
end

function Icon:GetTall()
	return self.H
end

ChainAccessor(Icon, "_Autosize", "Autosize")
ChainAccessor(Icon, "_Autosize", "AutoResize")
ChainAccessor(Icon, "_Autosize", "AutoSize")

function Icon:PaintIcon(x, y, w, h, rot)

	if not self.Material then
		local mat = surface.DrawMaterial(self.URL, self.Name, x, y, w, h, rot)

		if mat then 			--cache the downloaded material as an IMaterial asap
			self.Material = mat.mat
			if self:GetAutosize() and not self._SizeInitialized then
				local tex = mat.mat:GetTexture("$basetexture")
				self:SetSize(tex:GetMappingWidth(), tex:GetMappingHeight())
			end
		end

	else
		surface.SetMaterial(self.Material)

		if rot then
			surface.DrawTexturedRectRotated(x, y, w, h, rot)
		else
			surface.DrawTexturedRect(x, y, w, h)
		end

		if self:GetAutosize() and not self._SizeInitialized then
			local tex = self.Material:GetTexture("$basetexture")
			self:SetSize(tex:GetMappingWidth(), tex:GetMappingHeight())
		end
	end

end

function Icon:Paint(x, y, w, h, rot)
	self:AnimationThink()

	w = w or self.W
	h = h or self.H
	rot = rot or self.Rotation

	if not w or not h then
		error("Width or Height not given!")
		return
	end

	local col = self.Color
	surface.SetDrawColor(col.r, col.g, col.b, col.a)

	if self.Filter then
		render.PushFilterMag(TEXFILTER.ANISOTROPIC)
		render.PushFilterMin(TEXFILTER.ANISOTROPIC)
			local ok, err = pcall(self.PaintIcon, self, x, y, w, h, rot)
		render.PopFilterMag()
		render.PopFilterMin()

		if not ok then
			error(err)
		end
	else
		self:PaintIcon(x, y, w, h, rot)
	end

	if self:GetDebug() then
		surface.DrawOutlinedRect(x, y, w, h)
	end
end

function Icon:Copy()
	local new = Icon(self.Material or self.URL, self.Name)
	new:SetColor(self.Color)
	new:SetFilter(self:GetFilter())
	new:SetSize(self:GetSize())

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