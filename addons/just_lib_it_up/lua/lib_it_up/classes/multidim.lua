if LibItUp then LibItUp.SetIncluded() end

--rip your RAM
setfenv(0, _G)

muldim = muldim or Class:callable()
if LibItUp then LibItUp.MulDim = muldim end
local weak = muldim:callable()
weak.__mode = "kv"

function muldim:Get(...)
	local ks = {...}
	local curvar = self

	for k,v in ipairs(ks) do
		if curvar[v] == nil then return end
		curvar = curvar[v]
	end

	return curvar
end

function muldim:GetOrSet(...)
	local ks = {...}
	local curvar = self

	for k,v in ipairs(ks) do
		if curvar[v] == nil then curvar[v] = muldim:new() end
		curvar = curvar[v]
	end

	return curvar
end

function muldim:Set(val, ...)
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

function muldim:Insert(val, ...)
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
		if not mode == "k" or mode == "v" or mode == "kv" then
			errorf("muldim takes mode as `k` or `v` or `kv`, not %s (`%s`)", mode, type(mode))
		end
		return weak()
	end
end