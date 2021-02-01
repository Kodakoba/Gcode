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

-- mouse radius:
local wheelInnerRadius = 16
local wheelOuterRadius = 32

-- options radius:
	-- / 2 because its a radius, not a diameter

local optionInnerRadius, optionOuterRadius

local function resize()
	local sw, sh = ScrW(), ScrH()

	optionInnerRadius = math.min(sw * 0.35 / 2, sh * 0.35 / 2)
	optionOuterRadius = math.min(sw * 0.6 / 2, sh * 0.6 / 2)
end

hook.Add("OnScreenSizeChanged", "InteractWheelResize", resize)
resize()

local unselectedColor = Color(0, 0, 0, 157)
local selectedColor = Color(60, 120, 220, 157)

function wheel:_PaintPanel(wheel, w, h)
	-- self = panel
	local fr = wheel.Frac
	surface.SetDrawColor(0, 0, 0, wheel.Dim * 255)
	surface.DrawRect(0, 0, w, h)

	draw.ScuffedBlur(nil, fr * wheel.BlurAmount, 0, 0, w, h)

	--[[
	draw.MaterialCircle(w/2, h/2, wheelInnerRadius * 2, wheelInnerRadius * 2)
	draw.MaterialCircle(w/2, h/2, wheelOuterRadius * 2, wheelOuterRadius * 2)
	]]

	local ang = self.Angle
	local options = wheel.Options

	--draw.NoTexture()

	local mtrx = wheel.Matrix
		mtrx:TranslateNumber(w/2, h/2)
		local scale = 0.3 + fr * 0.7
		mtrx:SetScaleNumber(scale, scale)
		mtrx:TranslateNumber(-w/2, -h/2)

	draw.BeginMask()
	render.PerformFullScreenStencilOperation()


	cam.PushModelMatrix(mtrx)

		draw.DeMask()
		self.InnerCircle:Paint(w/2, h/2)

		draw.DrawOp()
		draw.SetMaterialCircle(optionOuterRadius)

		for i=1, #options do
			local opt = options[i]
			surface.SetDrawColor(opt.Circle.Color)
			opt.Circle:Paint(w/2, h/2)
		end

		draw.FinishMask()
		
		--[[
		draw.SimpleText(math.Round(self.SelectionFrac, 4), "OS32", w/2, h/2 - 32 * 0.625, color_white, 1, 1)
		draw.SimpleText(math.Round(ang) .. "°", "OS32", w/2, h/2, color_white, 1, 1)
		draw.SimpleText(math.Round(self.OptionPercentage * 100) .. "%", "OS32", w/2, h/2 + 32 * 0.625, color_white, 1, 1)
		]]
		

		--[[
		White()
		local origin = self.MouseOrigin
		local cur = self.Panel.CurrentMouse
		surface.DrawLine(origin[1], origin[2], cur[1], cur[2])
		]]

	cam.PopModelMatrix(mtrx)
end

function wheel:_BoundCursor(wheel)
	-- self = panel

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

function wheel:_ThinkPanel(wheel)
	-- self = panel
	local fr = wheel.Frac
	local min = self:IsMouseInputEnabled()
	if not min then return end

	self:SetAlpha(fr * 255)

	wheel._BoundCursor(self, wheel)

	local options = wheel.Options
	local len = #options
	local optAng = 360 / len

	for i=1, len do
		local opt = options[i]

		if self.OptionPercentage > 0 and
			self.SelectionFrac >= (1 / len) * (i - 1) and
			self.SelectionFrac < (1 / len) * i		then
			
			
			if not opt._Hovered then
				opt._Hovered = true
				opt:Emit("Hovered")
				print("hovered")
			end
		else
			if opt._Hovered then
				opt._Hovered = false
				opt:Emit("Unhovered")
				print("unhovered")
			end
		end
	end

end

function wheel:Show()
	self:To("Frac", 1, 0.2, 0, 0.3)

	if not self.Panel then
		self.Panel = vgui.Create("InvisPanel")
	else
		self.Panel:AlphaTo(255, 0.2, 0, 0.3)
	end

	local pnl = self.Panel

	pnl:SetSize(ScrW(), ScrH())
	pnl:SetCursor("blank")

	pnl.SelectionCircle = LibItUp.Circle()
	pnl.InnerCircle = LibItUp.Circle()

	pnl:MakePopup()
	pnl:SetKeyBoardInputEnabled(false)

	pnl.CursorDelta = {0, 0}
	pnl.MouseOrigin = {ScrW() / 2, ScrH() / 2}
	pnl.CurrentMouse = {ScrW() / 2, ScrH() / 2}
	pnl.OptionPercentage = 1

	pnl.Angle = 0

	pnl.Paint = function(pnl, w, h) 	InteractWheel._PaintPanel(pnl, self, w, h) 	end
	pnl.Think = function(pnl) 		InteractWheel._ThinkPanel(pnl, self) 		end

	local options = self.Options
	local segAng = 360 / #options

	local selcirc = pnl.SelectionCircle
		selcirc:SetSegments(50)

	local incirc = pnl.InnerCircle
		incirc:SetSegments(50)
		incirc:SetRadius(8)
		incirc:To("Radius", optionInnerRadius, 0.3, 0, 0.2)

	for i=1, #options do
		local opt = options[i]
		opt:_Setup(i, segAng)
	end

end

function wheel:Hide()
	local anim, new = self:To("Frac", 0, 0.15, 0, 0.3)

	if self.Panel then

		self.Panel:AlphaTo(0, 0.2, 0, 1.4)
		self.Panel:SetMouseInputEnabled(false)
		self.Panel:SetKeyBoardInputEnabled(false)
		--self.Panel.InnerCircle:To("Radius", 8, 0.2, 0, 1.6)

		if new then
			anim:Then(function()
				self.Panel:Remove()
				self.Panel = nil
			end)
		end

	end

	local options = self.Options

	for i=1, #options do
		local opt = options[i]
		opt:_Hide(i)
	end
end

InteractWheelOption = Emitter:extend()

function InteractWheelOption:Initialize(name, desc, cb)
	self.Name = name or "Unnamed"
	self.Description = desc

	self.Circle = LibItUp.Circle()
		self.Circle:SetSegments(50)
		self.Circle.Color = unselectedColor:Copy()

	self:On("Hovered", function()
		self.Circle:LerpColor(self.Circle.Color, selectedColor, 0.1, 0, 0.3)
	end)

	self:On("Unhovered", function()
		self.Circle:LerpColor(self.Circle.Color, unselectedColor, 0.1, 0, 0.3)
	end)

	if isfunction(cb) then
		self:On("Select", "InitCallback", cb)
	end
end

ChainAccessor(InteractWheelOption, "Wheel", "Wheel")
ChainAccessor(InteractWheelOption, "Disabled", "Disabled")

function InteractWheelOption:_Hide(num)
	local circ = self.Circle
	circ:To("Radius", optionOuterRadius - 8, 0.1, 0, 0.4)
end

function InteractWheelOption:_Setup(num, ang)
	-- called when the wheel is generated, so that the wheel can setup the circle properties

	local circ = self.Circle
	circ:SetRadius(optionOuterRadius)

	circ:SetStartAngle(ang * (num - 1))
	circ:SetEndAngle(ang * num)
end

function InteractWheelOption:Remove()
	self.Wheel:RemoveOption(self)
end

function wheel:AddOption(name, desc, cb)
	local option = InteractWheelOption:new(name, desc, cb)
		option:SetWheel(self)

	wheel.Options[#wheel.Options + 1] = option

	return option
end

--- test

if _TestWheel then _TestWheel:Hide() end

_TestWheel = InteractWheel:new()
local wh = _TestWheel

wh:AddOption("Peepee")
wh:AddOption("Poopee")

local bnd = Bind("wheel")
bnd:SetDefaultKey(KEY_G)
bnd:SetDefaultMethod(BINDS_HOLD)

bnd:On("Activate", 1, function(self, ply)
	wh:Show()
end)

bnd:On("Deactivate", 1, function(self, ply)
	wh:Hide()
end)