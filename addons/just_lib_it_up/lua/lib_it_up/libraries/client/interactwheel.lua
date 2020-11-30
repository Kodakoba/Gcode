InteractWheel = Animatable:new("InteractWheel")
local wheel = InteractWheel
wheel.Matrix = Matrix()
wheel.Options = {}

local vec = Vector()
wheel.Frac = 0

function wheel:Show()
	self:To("Frac", 1, 0.3, 0, 0.3)
end

function wheel:Hide()
	self:To("Frac", 0, 0.3, 0, 0.3)
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