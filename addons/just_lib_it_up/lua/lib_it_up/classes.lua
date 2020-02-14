--[[
	Idea shamelessly stolen from Luvit
]]

Class = {}
Class.Meta = {__index = Class}


function Class:extend()
	local new = {}
	new.Meta = table.Copy(self.Meta)	-- copy the parent's meta...
	new.Meta.__index = new 			-- ...but this time, __index points to the copied meta

	new.__index = new.Meta
	new.__parent = self 

	return setmetatable(new, new)
end

function Class:new(...)
	local obj = {}

	setmetatable(obj, self)

	local func = self.Initialize or self.initialize 

	if isfunction(func) then 
		local new = func(obj, ...)
		if new then return new end --overwrite?
	end

	return obj
end

Class.Meta.extend = Class.extend 
Class.Meta.Extend = Class.extend 

Class.Meta.new = Class.new

Object = Class