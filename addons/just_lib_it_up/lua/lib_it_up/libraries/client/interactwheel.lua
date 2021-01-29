InteractWheel = Animatable:extend()
local wheel = InteractWheel
wheel.Matrix = Matrix()
wheel.Options = {}

local vec = Vector()
wheel.Frac = 0

function wheel:Initialize()
	self.Frac = 0

	self.BlurAmount = 2
	self.Dim = 0.7
end

function wheel:_PaintPanel(wheel, w, h)
	-- self = panel
	local fr = wheel.Frac
	surface.SetDrawColor(0, 0, 0, wheel.Dim * 255)
	surface.DrawRect(0, 0, w, h)

	draw.ScuffedBlur(nil, fr * wheel.BlurAmount, 0, 0, w, h)

	local ang = self.Angle
	draw.SimpleText(math.Round(self.SelectionFrac, 4), "OS32", w/2, h/2 - 32 * 0.625, color_white, 1, 1)
	draw.SimpleText(math.Round(ang) .. "°", "OS32", w/2, h/2, color_white, 1, 1)
	draw.SimpleText(math.Round(self.OptionPercentage * 100) .. "%", "OS32", w/2, h/2 + 32 * 0.625, color_white, 1, 1)

	White()
	local origin = self.MouseOrigin
	local cur = self.Panel.CurrentMouse
	surface.DrawLine(origin[1], origin[2], cur[1], cur[2])
end

local wheelInnerRadius = 16
local wheelOuterRadius = 64

function wheel:_ThinkPanel(wheel)
	-- self = panel
	local fr = wheel.Frac
	local min = self:IsMouseInputEnabled()
	if not min then return end

	self:SetAlpha(fr * 255)
	
	local mx, my = input.GetCursorPos()

	local origin = self.MouseOrigin
	local ox, oy = origin[1], origin[2]

	local cur = self.Panel.CurrentMouse
	local curx, cury = cur[1], cur[2]

	local ocx, ocy = ox - mx, oy - my 	-- off-center mousepos

	local cdist = math.sqrt(ocx^2 + ocy^2)
	

	if cdist <= wheelInnerRadius then
		self.OptionPercentage = 0
	else

		local len = math.sqrt(ocx^2 + ocy^2)

		-- bound the mouse to the outer wheel if necessary

		-- by adding some radius we give wiggling room for diagonal moving
		-- it doesn't hurt to add it since the only reason we're doing this is window bounds
		-- and lets be real, they're probably not running the game @ 128x128
		if cdist > wheelOuterRadius + 8 then
			

			-- normalize XY and multiply by outer radius
			local nmx = ocx / len * wheelOuterRadius
			local nmy = ocy / len * wheelOuterRadius

			ocx, ocy = math.floor(ox + nmx), math.floor(oy + nmy)
			gui.SetMousePos(ox - nmx, oy - nmy)

			cur[1], cur[2] = ox - nmx, oy - nmy

			self.Angle = math.deg( -math.atan2(nmy, nmx) + math.pi / 2 )
			if self.Angle > 0 then
				self.Angle = 90 + (270 - self.Angle)
			end
			self.Angle = math.abs(self.Angle)
			self.SelectionFrac = self.Angle / 360
		else
			if len > wheelOuterRadius then
				ocx = ocx / len * wheelOuterRadius
				ocy = ocy / len * wheelOuterRadius
			end

			cur[1], cur[2] = ox - ocx, oy - ocy
			self.Angle = math.deg( -math.atan2(ocy, ocx) + math.pi / 2 )
			if self.Angle > 0 then
				self.Angle = 90 + (270 - self.Angle)
			end
			self.Angle = math.abs(self.Angle)
			self.SelectionFrac = self.Angle / 360
		end

		self.OptionPercentage = math.min( (len - wheelInnerRadius) / (wheelOuterRadius - wheelInnerRadius), 1 )
	end

	
end

function wheel:Show()
	self:To("Frac", 1, 0.2, 0, 0.3)

	if not self.Panel then
		self.Panel = vgui.Create("InvisPanel")
	end

	self.Panel:SetSize(ScrW(), ScrH())

	self.Panel:MakePopup()
	self.Panel:SetKeyBoardInputEnabled(false)

	self.Panel.CursorDelta = {0, 0}
	self.Panel.MouseOrigin = {ScrW() / 2, ScrH() / 2}
	self.Panel.CurrentMouse = {ScrW() / 2, ScrH() / 2}
	self.Panel.OptionPercentage = 1

	self.Panel.Angle = 0

	self.Panel.Paint = function(pnl, w, h) 	InteractWheel._PaintPanel(pnl, self, w, h) 	end
	self.Panel.Think = function(pnl) 		InteractWheel._ThinkPanel(pnl, self) 		end
end

function wheel:Hide()
	local anim, new = self:To("Frac", 0, 0.15, 0, 0.3)

	if self.Panel then
		self.Panel:AlphaTo(0, 0.15, 0, 0.3)
		self.Panel:SetMouseInputEnabled(false)
		self.Panel:SetKeyBoardInputEnabled(false)

		if new then
			anim:Then(function()
				self.Panel:Remove()
				self.Panel = nil
			end)
		end

	end

end

function wheel:GenerateOptions()
	self:Emit("GenerateOptions", self)
end

InteractWheelOption = Emitter:extend()

function InteractWheelOption:Initialize(name, desc, cb)
	self.Name = name or "Unnamed"
	self.Description = desc


	if isfunction(cb) then
		self:On("Select", "InitCallback", cb)
	end
end

function wheel:AddOption(name, desc, cb)
	local option = InteractWheelOption:new(name, desc, cb)
	wheel.Options[#wheel.Options + 1] = option

	return option
end

--- test

if _TestWheel then _TestWheel:Hide() end

_TestWheel = InteractWheel:new()
local wh = _TestWheel

wh:Show()

timer.Create("interactwheel", 1, 1, function()
	--[[timer.Create("interactwheel", 3, 1, function()
		wh:Hide()
	end)]]
end)