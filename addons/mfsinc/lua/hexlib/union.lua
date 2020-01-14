--[[
	A union table:
		Calling methods on it will call the methods on its' children instead.

		Can only have numbered keys.
]]

UnionTable = Class:extend()

local meta = UnionTable.Meta

function meta.__index(self, key)
	if isnumber(key) then 
		return rawget(self, key)
	end

	--[[
		we have to construct a closure each time, i can't think of an another way :(
	]]

	local func = function(...)
		local outs = {}

		for k,v in pairs(self) do 
			if isfunction(v[key]) then 
				outs[v] = v[key](...)
			end
		end

		return outs
	end

	return func
end