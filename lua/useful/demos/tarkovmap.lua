file.CreateDir("krakov/")
file.CreateDir("krakov/icons/")
file.CreateDir("krakov/maps/")

setfenv(0, _G)

local url = "https://tarkovtile.ru/rezerv/3/%d/%d.jpg"
local fn = "krakov/maps/reserve_%d_%d.jpg"

local XSegs = 5
local YSegs = 4
local segSize = 256

local mats = muldim:new()

local prom = Emitter:new()

local iconsText = "▪ PMC.png ▪ armor.png ▪ avtoaccum.png barrel.png ▪ bulletboxlow.png ▪ bulletcase.png ▪ buttongrey.png buttonred.png buttonyellow.png chemodan.png ▪ electroniclow.png ▪ foodlow.png ▪ gazan.png ▪ grenade.png ▪ grenadecase.png ▪ gun.png ▪ hoz.png ▪ jewel.png ▪ jewellow.png ▪ kartoteki.png ▪ kassa.png ▪ keysic.png ▪ killa.png ▪ klyc.png ▪ kurtka.png ▪ ledx.png ▪ medcase.png ▪ medslow.png ▪ medsumka.png ▪ mods.png ▪ modslow.png ▪ pc.png ▪ prisadka.png ▪ rublow.png ▪ safegun.png ▪ scav.png ▪ scavs.png ▪ shron.png ▪ sumka.png ▪ tkan.png ▪ toolbox.png ▪ wearlow.png ▪ wood.png ▪ zamok.png"
local icons = {}
local iconMats = {}

for s in iconsText:gmatch("(%w+)%.?png") do
	icons[#icons + 1] = s
end


local icurl = "https://tarkov.help/map/maps/%s.png"
local icpath = "krakov/%s.png"

local function fetch()

	for y=0, YSegs - 1 do
		for x=0, XSegs - 1 do
			local path = fn:format(x, y)

			if file.Exists(path, "DATA") then
				local mat = Material( "data/" .. path )
				mats:Set(mat, x, y)
				prom:Emit("fetch", mat, x, y)
			else
				http.Fetch(url:format(x, y), function(dat)
					file.Write(path, dat)
					local mat = Material( "data/" .. path )
					mats:Set(mat, x, y)
					prom:Emit("fetch", mat, x, y)
				end)
			end

		end
	end

end

timer.Simple(0, fetch)

local atlas = GetRenderTargetEx("1krakov_rt:" .. segSize, segSize * XSegs, segSize * YSegs,
	RT_SIZE_NO_CHANGE, MATERIAL_RT_DEPTH_NONE, 16, 0, 0)

local atlasMat = CreateMaterial("1krakov_mat:" .. segSize, "UnlitGeneric", {
	["$translucent"] = 1,
	["$basetexture"] = atlas:GetName(),
})

local fetched = 0
prom:On("fetch", function(self, mat, xseg, yseg)
	fetched = fetched + 1
	local x, y = xseg * segSize, yseg * segSize
	render.PushRenderTarget(atlas)
	cam.Start2D()
		local ok, err = pcall(function()
			surface.SetMaterial(mat)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(x, y, segSize, segSize)
		end)
	cam.End2D()
	render.PopRenderTarget()

	if not ok then
		error("retard " .. err)
	end

	if fetched == XSegs * YSegs then
		prom:Emit("CreateMap", atlasMat)
	end
end)

local mapRatio = YSegs / XSegs	-- height:width ratio



prom:On("CreateMap", function(self, mat)
	if IsValid(KrakovMap) then KrakovMap:Remove() end

	local f = vgui.Create("FFrame")
	local sw, sh = ScrW(), ScrH()
	local scale = sh / 900

	f:SetSize(scale * (900 + 16), scale * (640 + f.HeaderSize + 8))
	f:SetSizable(true)
	f:Center()
	f:MakePopup()
	f:PopIn()
	f.Label = "эшкеп фрём Краков"
	KrakovMap = f

	local map = vgui.Create("InvisPanel", f)
	map:Dock(FILL)
	map:Debug()

	map.Viewport = {0, 0}

	map.Zoom = 1
	map.Wheels = 1

	function map:ViewportToXY(vx, vy)
		return self:GetWide() * vx, self:GetTall() * vy
	end

	-- unscaled XY to scaled
	function map:ScaleXY(x, y)
		local scale = 1 / self.Zoom
		local w, h = self:GetSize()
		local vx, vy = self.Viewport[1] * w, self.Viewport[2] * h

		return (x - vx) / scale, (y - vy) / scale
	end

	function map:ScaledViewportToXY(vx, vy)
		local scale = 1 / self.Zoom
		return self:GetWide() * vx / scale, self:GetTall() * vy / scale
	end

	function map:XYToViewport(x, y)
		local w, h = self:GetSize()
		local vx = math.Clamp(x / w, 0, 1)
		local vy = math.Clamp(y / h, 0, 1)

		return vx, vy
	end

	function map:XYToScaledViewport(x, y)
		local vx, vy = self:XYToViewport(x, y)
		local scale = self.Zoom
		vx, vy = vx * scale, vy * scale

		return vx, vy
	end

	-- global mouse position, global viewport
	function map:MouseToViewport(mx, my)
		local scale = 1 / self.Zoom
		local lx, ly = self:ScreenToLocal(mx, my)
		local vxf, vyf = unpack(self.Viewport)

		return vxf + (lx / self:GetWide()) * scale, vyf + (ly / self:GetTall()) * scale
	end

	function map:GetScale()
		return 1 / self.Zoom
	end

	function map:MouseToScaledViewport(mx, my)
		local lx, ly = self:ScreenToLocal(mx, my)
		return lx / self:GetWide(), ly / self:GetTall()
	end

	local sel = vgui.Create("FFrame")
	sel:Bond(f)
	sel:SetHeaderSize(0)
	sel:SetCloseable(false, true)
	sel:SetWide(96)
	sel:SetPos(f.X + f:GetWide() - 4, f.Y)
	sel:SetTall(f:GetTall())
	sel.Shown = 0
	sel:DockPadding(4, 8, 4, 8)
	sel:Hide()

	f:On("Resized", function(_, newx, newy)
		sel:SetTall(newy)
	end)

	sel:On("Think", function(self)
		if not f:IsValid() then return end

		local fr = self.Shown
		sel.X = f.X + f:GetWide() - 12 + (24 * fr)
		sel.Y = f.Y
	end)


	local yeet = sel:Add("FButton")
	yeet:Dock(TOP)
	yeet:SetTall(48)
	yeet.Label = "Delete"

	local scr = sel:Add("FScrollPanel")
	scr:Dock(FILL)
	scr:DockMargin(0, 4, 0, 0)

	local fic = scr:Add("FIconLayout")
	fic:Dock(FILL)

	for k,v in pairs(icons) do
		local fbtn = fic:Add("FButton")
		fbtn:SetIcon(icurl:format(v), icpath:format(v), 24, 24)

		fbtn:SetSize(32, 32)
	end

	local markers = {}
	local activeMarker

	function map:OpenMarkerSelection(btn)
		if not sel:IsVisible() then
			sel:To("Shown", 1, 0.3, 0, 0.3)
			sel:PopInShow()
		end

		if activeMarker then
			activeMarker:LerpColor(activeMarker.Col, Colors.LightGray, 0.1, 0, 2.3)
		end

		if activeMarker == btn then activeMarker = nil return end

		activeMarker = btn
		activeMarker:LerpColor(activeMarker.Col, color_white, 0.2, 0, 0.3)
	end

	local wtf = Color(1, 1, 1)
	local t3c1, t3c2 = Color(25, 25, 25), Color(3, 3, 3)

	function map:AddMarker(vx, vy)
		-- viewport global positions
		local b = vgui.Create("DButton", map)
		local markerSize = 24

		b:SetSize(markerSize / 4, markerSize / 4)
		b.RBRadius = 4

		b.IconURL = "https://tarkov.help/map/maps/buttonred.png"
		b.IconName = "krakov/buttonred.png"
		b:SetText("")
		b:SizeTo(markerSize, markerSize, 0.2, 0, 0.3)
		b.Col = Colors.LightGray:Copy()
		markers[#markers + 1] = btn

		function b:Think()
			local vx2, vy2 = map:ViewportToXY(vx, vy)
			local x, y = map:ScaleXY(vx2, vy2)

			local w, h = self:GetSize()

			self:SetPos(x - w / 2, y - w / 2)
		end

		b.Sel = 0
		function b:Paint(w, h)
			local x, y = 0, 0
			if activeMarker == self then
				self:To("Sel", 1, 0.3, 0, 0.3)
			else
				self:To("Sel", 0, 0.16, 0, 2.3)
			end

			if self.Sel > 0 then
				BSHADOWS.BeginShadow()
				x, y = self:LocalToScreen(0, 0)
			end

				surface.SetDrawColor(self.Col:Unpack())
				surface.DrawMaterial(self.IconURL, self.IconName, x, y, w, h)

			if self.Sel > 0 then
				BSHADOWS.EndShadow(1 + self.Sel * 2, 2 + self.Sel * 0.3, 1, 255,
					nil, nil, nil, t3c1, t3c2)
			end
		end

		function b:DoClick()
			map:OpenMarkerSelection(self)
		end
	end

	function map:Paint(w, h)
		local vxf, vyf = unpack(self.Viewport)

		local scale = 1 / self.Zoom

		-- bounded fracs
		local vx = vxf * w
		local vy = vyf * h
		local vw, vh = w * scale, h * scale

		surface.SetMaterial(mat)

		local u0, v0 = vxf, vyf
		local u1, v1 = math.min(vxf + scale, 1), math.min(vyf + scale, 1)

		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRectUV(0, 0, w, h, u0, v0, u1, v1)

		local mx, my = self:MouseToScaledViewport(gui.MousePos())
		surface.SetDrawColor(Colors.Red)
		surface.DrawRect(mx * w - 2, my * h - 2, 4, 4)
	end

	local lmx, lmy = 0, 0

	function map:OnMousePressed(key)
		if key == MOUSE_LEFT then
			self.Dragging = true
			lmx, lmy = gui.MousePos()
		elseif key == MOUSE_RIGHT then
			local vx, vy = self:MouseToViewport(gui.MousePos())
			self:AddMarker(vx, vy)
		end
	end

	function map:OnMouseReleased(key)
		self.Dragging = false
	end

	function map:Think()
		self.Dragging = self.Dragging and input.IsMouseDown(MOUSE_LEFT)

		if self.Dragging then
			local mx, my = gui.MousePos()
			local dmx, dmy = lmx - mx, lmy - my
			local ratio = 1 / self.Zoom

			self.Viewport[1] = math.Clamp(self.Viewport[1] + dmx / self:GetWide() * ratio, 0, 1 - ratio)
			self.Viewport[2] = math.Clamp(self.Viewport[2] + dmy / self:GetTall() * ratio, 0, 1 - ratio)

			lmx, lmy = mx, my
		end
	end

	local maxZoom = 5
	local minZoom = 1

	function map:OnMouseWheeled(dir)

		local old = self.Wheels
		self.Wheels = math.Clamp(self.Wheels + dir * 0.7, minZoom, maxZoom)

		if old == self.Wheels then return end

		local ax, ay = self:ScreenToLocal(gui.MouseX(), gui.MouseY())

		local prevRatio = 1 / self.Zoom

		local axFrac = self.Viewport[1] + ax / self:GetWide() * prevRatio
		local ayFrac = self.Viewport[2] + ay / self:GetTall() * prevRatio

		local zoom = 1 * self.Wheels
		local ratio = 1 / zoom

		self:To("Zoom", zoom, 0.3, 0, 0.3)

		-- calculate viewport origin XY as 0-1
		local vx = math.max(axFrac - 0.5 * ratio, 0)
		local vy = math.max(ayFrac - 0.5 * ratio, 0)

		local bvx = vx - math.max((vx + ratio) - 1, 0)
		local bvy = vy - math.max((vy + ratio) - 1, 0) -- bounded frac

		self:MemberLerp(self.Viewport, 1, bvx, 0.3, 0, 0.3)
		self:MemberLerp(self.Viewport, 2, bvy, 0.3, 0, 0.3)
	end

	f:On("Resize", function(self, nw, nh)
		local min = math.min(nw * mapRatio, nh)

		if min == nh then
			local r1, r2 = nw, nw * mapRatio
			sel:SetTall(r2)
			return r1, r2
		else
			local r1, r2 = nh / mapRatio, nh
			sel:SetTall(r2)
			return r1, r2
		end
	end)
end)
