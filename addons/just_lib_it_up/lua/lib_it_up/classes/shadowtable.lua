LibItUp.ShadowTable = LibItUp.ShadowTable or Object:extend()
local shad = LibItUp.ShadowTable

LibItUp.Shadows = LibItUp.Shadows or setmetatable({}, {__mode = "k"})
local shadows = LibItUp.Shadows

function shad:Initialize(t)
	if t then self = setmetatable(t, getmetatable(self)) end
	shadows[self] = {}
	if t ~= nil then
		return self
	end
end

function shad:GetShadow()
	return shadows[self]
end