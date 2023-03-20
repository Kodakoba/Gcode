LibItUp.SetIncluded()
LibItUp.SQLArgList = LibItUp.SQLArgList or Object:callable()

local al = LibItUp.SQLArgList
al.IsArgList = true

function IsArgList(t)
	return istable(t) and t.IsArgList
end

function al:Initialize()
	self.Args = {}
end

function al:AddArg(name, type)
	self.Args[#self.Args + 1] = {name, type}
	return self
end

function al:RemoveArg(name)
	for k,v in ipairs(self.Args) do
		if name == v[1] then
			table.remove(self.Args, k)
			return self
		end
	end

	return self
end

function al:GetArgs()
	return self.Args
end

function al:GetArgNames()
	local t = {}
	for i=1, #self.Args do t[i] = self.Args[i][1] end

	return t
end

function al:__tostring()
	local ret = ""
	for k,v in ipairs(self.Args) do
		ret = ret .. table.concat(v, " ") .. ", \n"
	end
	ret = ret:sub(1, -4)

	return ret
end