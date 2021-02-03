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


-- animation settings:
local wheelAppearTime = 0.2
local wheelDisappearTime = 0.1

-- mouse radius:
local wheelInnerRadius = 12
local wheelOuterRadius = 48

-- options radius:
local optionInnerRadius, optionOuterRadius

local function resize()
	local sw, sh = ScrW(), ScrH()

	-- / 2 because its a radius, not a diameter
	optionInnerRadius = math.min(sw * 0.45 / 2, sh * 0.45 / 2)
	optionOuterRadius = math.min(sw * 0.7 / 2, sh * 0.7 / 2)
end

hook.Add("OnScreenSizeChanged", "InteractWheelResize", resize)
resize()

local unselectedColor = Color(0, 0, 0, 157)
local selectedColor = Color(60, 120, 220, 77)
local arrowColor = Color(250, 250, 250, 180)

local function normalize(x, y)
	local len = math.sqrt(x^2 + y^2)
	return x / len, y / len
end

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
		

		for i=1, #options do
			local opt = options[i]
			draw.SetMaterialCircle(optionOuterRadius)
			opt:_Paint(w/2, h/2, w, h)
		end

		draw.FinishMask()
			
		local origin = self.MouseOrigin
		local cur = self.Panel.CurrentMouse
		local ox, oy = cur[1] - origin[1], cur[2] - origin[2]
		local nx, ny = normalize(ox, oy)

		surface.SetDrawColor(arrowColor:Unpack())

		local certainty = self.OptionPercentage

		local arad = (optionInnerRadius - 16) * (0.8 + (certainty) * 0.2)

		local ax = origin[1] + nx * arad
		local ay = origin[2] + ny * arad

		local aw = 32 * (certainty ^ 0.5)
		local ah = 52 * (certainty ^ 0.2)

		draw.EnableFilters()

			surface.DrawMaterial("https://i.imgur.com/jFHSu7s.png", "arr_right.png", 
				ax, ay, aw, ah, -self.Angle + 90)

		draw.DisableFilters()
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

local function isSelected(fr, bottom, upper, sel)
	local inArea = false

	if sel then
		-- expand selection area by either 1% of the wheel or 5% of the option,
		-- whichever one will result in a smaller expansion
		local total = upper - bottom
		bottom = bottom - math.min(total * 0.05, 0.01)
		upper = upper + math.min(total * 0.05, 0.01)

		local aboveBottom, belowTop

		aboveBottom = fr > bottom
		belowTop = fr < upper

		if upper > 1 then
			aboveBottom = aboveBottom or fr < (upper - 1)
		end
		if bottom < 0 then
			belowTop = belowTop or fr > (1 + bottom)
		end

		inArea = aboveBottom and belowTop
	else
		inArea = fr > bottom and fr <= upper
	end

	return inArea
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

	local sel = self.SelectionFrac
	local curSel = self._CurHovered
	local gotSel = false		-- got a selection already

	if curSel then
		local i = curSel:GetOptionNumber()
		local bottomBound = (1 / len) * (i - 1)
		local upperBound = (1 / len) * i

		if self.OptionPercentage > 0.3 and
			isSelected(sel, bottomBound, upperBound, true) then
			gotSel = true
		else
			curSel = false
		end
	end

	for i=1, len do
		local opt = options[i]
		if opt == curSel then continue end -- already calculated

		local bottomBound = (1 / len) * (i - 1)
		local upperBound = (1 / len) * i

		if self.OptionPercentage > 0.3 and not gotSel and
			isSelected(sel, bottomBound, upperBound, false) then
			
			gotSel = opt
			if not opt:GetHovered() then
				self._CurHovered = opt
				opt:_Hover()
			end
		else
			if opt:GetHovered() then
				if self._CurHovered == opt then
					self._CurHovered = nil
					curSel = nil
				end
				opt:_Unhover()
			end
		end
	end

end

function wheel:Show()
	self:To("Frac", 1, wheelAppearTime, 0, 0.3)

	if not self.Panel then
		self.Panel = vgui.Create("InvisPanel")
	else
		self.Panel:AlphaTo(255, wheelAppearTime, 0, 0.3)
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
		incirc:To("Radius", optionInnerRadius, wheelAppearTime + 0.1, 0, 0.2)

	for i=1, #options do
		local opt = options[i]
		opt:_Setup(i, segAng)
	end

end

function wheel:Hide()
	local anim, new = self:To("Frac", 0, 0.15, 0, 0.3)

	if self.Panel then

		self.Panel:AlphaTo(0, wheelDisappearTime, 0, 1.4)
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
InteractWheelOption.Matrix = Matrix()

function InteractWheelOption:Initialize(name, desc, icon, cb)
	self.Title = name or "Unnamed"
	self.Description = desc

	self.DescriptionFont = "OS20"
	self.TitleFont = "OSB32"

	self:_WrapTitle()
	self:_WrapDescription()

	self.Icon = icon

	self.HoveredFrac = 0

	self.Circle = LibItUp.Circle()
		self.Circle:SetSegments(50)
		self.Circle.UnselectedColor = unselectedColor:Copy()
		self.Circle.SelectedColor = selectedColor:Copy()

	if isfunction(cb) then
		self:On("Select", "InitCallback", cb)
	end
end

ChainAccessor(InteractWheelOption, "Wheel", "Wheel")
ChainAccessor(InteractWheelOption, "Disabled", "Disabled")
ChainAccessor(InteractWheelOption, "OptionNumber", "OptionNumber")

function InteractWheelOption:_WrapDescription()
	if isstring(self.Description) then
		self.Description = string.WordWrap2(self.Description, (optionInnerRadius * 2) - 16, self.DescriptionFont)
	end
end

function InteractWheelOption:_WrapTitle()
	if isstring(self.Title) then
		self.Title = string.WordWrap2(self.Title, (optionInnerRadius * 2) - 32, self.TitleFont)
	end
end

function InteractWheelOption:SetTitleFont(f)
	self.TitleFont = f
	self:_WrapTitle()
end

function InteractWheelOption:SetTitle(s)
	self.Title = s
	self:_WrapTitle()
end

function InteractWheelOption:SetDescriptionFont(f)
	self.DescriptionFont = f
	self:_WrapDescription()
end

function InteractWheelOption:SetDescription(s)
	self.Description = s
	self:_WrapDescription()
end

function InteractWheelOption:_Select()
	self:Emit("Select")
end

function InteractWheelOption:_Hover()
	self.Circle:MemberLerp(self, "HoveredFrac", 1, 0.2, 0, 0.3)
	self.Circle:LerpColor(self.Circle.Color, selectedColor, 0.1, 0, 0.3)

	self._Hovered = true
	self:Emit("Hovered")
end

function InteractWheelOption:_Unhover()
	self.Circle:MemberLerp(self, "HoveredFrac", 0, 0.1, 0, 0.2)
	self.Circle:LerpColor(self.Circle.Color, unselectedColor, 0.1, 0, 0.3)

	self._Hovered = false
	self:Emit("Unhovered")
end

function InteractWheelOption:_Hide(num)
	local circ = self.Circle

	circ:MemberLerp(self, "HoveredFrac", 0, 0.1, 0, 0.2)
	circ:To("Radius", optionOuterRadius - 8, wheelDisappearTime, 0, 0.4)
end

ChainAccessor(InteractWheelOption, "_Hovered", "Hovered")

function InteractWheelOption:_Paint(x, y, w, h)
	local circ = self.Circle

	surface.SetDrawColor(circ.Color:Unpack())
	circ:Paint(x, y)

	if self.HoveredFrac == 0 then return end

	local fr = self.HoveredFrac

	local infoH = 0, 0
	local iconMargin = 8
	local titleMargin = 4
	local ic = self.Icon

	if ic then
		local iw, ih = ic:GetSize()
		infoH = infoH + ih
	end

	local title = self.Title
	if title then
		local nls = amtNewlines(title) + 1
		local hgt = nls * draw.GetFontHeight(self.TitleFont)
		infoH = infoH + (ic and iconMargin or 0) + hgt
	end

	local desc = self.Description
	if desc then
		local nls = amtNewlines(desc) + 1
		local hgt = nls * draw.GetFontHeight(self.DescriptionFont)
		infoH = infoH + hgt
		if title then
			infoH = infoH + titleMargin
		elseif ic then
			infoH = infoH + iconMargin
		end
	end

	local amult = surface.GetAlphaMultiplier()
	surface.SetAlphaMultiplier(fr ^ 0.3 * amult)

	local segMid = circ:GetStartAngle() + (circ:GetEndAngle() - circ:GetStartAngle()) / 2 - 90
	local rad = optionInnerRadius / 2

	segMid = math.rad(segMid)
	local smX, smY = math.cos(segMid) * rad, math.sin(segMid) * rad

	local trX, trY = x + smX * (1 - fr), y + smY * (1 - fr)

	local mtrx = self.Matrix
		mtrx:Reset()
		mtrx:TranslateNumber(trX, trY)
		local scale = 0.3 + (fr ^ 0.7) * 0.7
		mtrx:SetScaleNumber(scale, scale)
		mtrx:TranslateNumber(-trX, -trY)

	render.SetStencilEnable(false)

	cam.PushModelMatrix(mtrx, true)

	local cy = y - infoH / 2 - (ic and select(2, ic:GetSize()) / 2 or 0)
	local cy2 = cy

	if ic then
		local iw, ih = ic:GetSize()
		ic:Paint(x - iw/2, cy, iw, ih)
		cy = cy + ih + iconMargin
	end

	if title then
		surface.SetFont(self.TitleFont)
		surface.SetDrawColor(color_white)
		local hgt = draw.GetFontHeight(self.TitleFont)

		for s, line in eachNewline(title) do
			draw.SimpleText(s, self.TitleFont, x, cy, color_white, 1, 5)
			cy = cy + hgt
		end

	end

	if desc then

		surface.SetFont(self.DescriptionFont)
		surface.SetDrawColor(color_white)
		local hgt = draw.GetFontHeight(self.DescriptionFont)

		for s, line in eachNewline(desc) do
			draw.SimpleText(s, self.DescriptionFont, x, cy, color_white, 1, 5)
			cy = cy + hgt
		end

	end

	--surface.DrawOutlinedRect(x - 8, cy2, 16, infoH)
	cam.PopModelMatrix()

	render.SetStencilEnable(true)
	surface.SetAlphaMultiplier(amult)
end

function InteractWheelOption:_Setup(num, ang)
	-- called when the wheel is generated, so that the options can setup the circle properties

	local circ = self.Circle
	circ:SetRadius(optionOuterRadius)

	circ:SetStartAngle(ang * (num - 1))
	circ:SetEndAngle(ang * num)

	if circ.Color then
		circ.Color:Set(circ.UnselectedColor)
	else
		circ.Color = circ.UnselectedColor:Copy()
	end
end

function InteractWheelOption:Remove()
	self.Wheel:RemoveOption(self)
end

function wheel:AddOption(name, desc, icon, cb)
	local option = InteractWheelOption:new(name, desc, icon, cb)
		option:SetWheel(self)
		option:SetOptionNumber(#wheel.Options + 1)
	wheel.Options[option:GetOptionNumber()] = option

	return option
end

--- test

if _TestWheel then _TestWheel:Hide() end

_TestWheel = InteractWheel:new()
local wh = _TestWheel

wh:AddOption("Peepee", "Funny poop poop funny mm yes veri funi",
	Icon("https://i.imgur.com/z3SWemE.png", "dbutt_icon.png"):SetSize(64, 72))

wh:AddOption("Poopee")

wh:AddOption("NaM VERYLONGTITLESPAM NaM", "NaM NAM THE WEEBS AWAY NaM NAM THE WEEBS AWAY NaM NAM THE WEEBS AWAY NaM NAM THE WEEBS AWAY ",
	Icon("https://i.imgur.com/z3SWemE.png", "dbutt_icon.png"):SetSize(64, 72))

local bnd = Bind("wheel")
bnd:SetDefaultKey(KEY_G)
bnd:SetDefaultMethod(BINDS_HOLD)
bnd:CreateConcommands()

bnd:On("Activate", 1, function(self, ply)
	wh:Show()
end)

bnd:On("Deactivate", 1, function(self, ply)
	wh:Hide()
end)