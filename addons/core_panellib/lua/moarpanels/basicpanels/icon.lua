--[[
	Icon

	Icon.Rotation = num

	Icon.Icon = mat
		OR
	Icon.IconURL = url
	Icon.IconName = name
]]


local I = {}

local err = Material("__error")

function I:Init()
	self.Icon = err

	self.IconURL = nil
	self.IconName = nil
	self.Color = color_white:Copy()

	self.Rotation = 0
end

function I:Paint(w, h)
	local mat = self.Icon or err

	surface.SetDrawColor(self.Color)

	if self.IconURL and self.IconName then
		surface.DrawMaterial(self.IconURL, self.IconName, w/2, h/2, w, h, self.Rotation)
	else
		surface.SetMaterial(mat)
		surface.DrawTexturedRectRotated(w/2, h/2, w, h, self.Rotation)
	end
end

vgui.Register("Icon", I, "InvisPanel")