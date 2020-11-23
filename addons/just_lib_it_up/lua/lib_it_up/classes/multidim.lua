--rip your RAM
setfenv(0, _G)

muldim = muldim or Class:callable()
local mmeta = muldim.Meta

local weak = muldim:Callable()
weak.__mode = "kv"

function mmeta:Get(...)
	local ks = {...}
	local curvar = self

	for k,v in ipairs(ks) do
		if curvar[v] == nil then return end
		curvar = curvar[v]
	end

	return curvar
end

function mmeta:GetOrSet(...)
	local ks = {...}
	local curvar = self

	for k,v in ipairs(ks) do
		if curvar[v] == nil then curvar[v] = muldim:new() end
		curvar = curvar[v]
	end

	return curvar
end

function mmeta:Set(val, ...)
	local ks = {...}
	local curvar = self

	for k,v in ipairs(ks) do
		local nextkey = ks[k + 1]

		if curvar[v] == nil then

			if nextkey ~= nil then --if next key in ... exists
				curvar[v] = muldim:new() --recursively create new dim objects
			else
				curvar[v] = val --or just set the value
				return val, curvar
			end

		else

			if nextkey == nil then
				curvar[v] = val
			end

		end

		curvar = curvar[v]
	end

	return val, curvar
end

function mmeta:Insert(val, ...)
	local ks = {...}
	local curvar = self

	for k,v in ipairs(ks) do
		local nextkey = ks[k + 1]

		if curvar[v] == nil then

			if nextkey ~= nil then
				curvar[v] = muldim:new()
			else
				curvar[v] = muldim:new()
				curvar[v][1] = val
				return val, curvar
			end

		else

			if nextkey == nil then
				curvar[v][#curvar[v] + 1] = val
			end

		end

		curvar = curvar[v]
	end

	return val, curvar
end

function muldim:Initialize(mode)
	if mode then
		return weak()
	end
end