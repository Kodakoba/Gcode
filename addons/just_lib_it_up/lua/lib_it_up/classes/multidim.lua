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
		local nxt = rawget(curvar, v)
		if nxt == nil then return end
		curvar = nxt
	end

	return curvar
end

function muldim:GetOrSet(...)
	local ks = {...}
	local curvar = self

	for k,v in ipairs(ks) do
		if rawget(curvar, v) == nil then
			local new = muldim:new()
			rawset(curvar, v, new)
			curvar = new
		else
			curvar = rawget(curvar, v)
		end
	end

	return curvar
end

function muldim:Set(val, ...)
	local ks = {...}
	local curvar = self

	for k,v in ipairs(ks) do
		local nextkey = rawget(ks, k + 1)
		local nextval = rawget(curvar, v)
		if nextval == nil then

			if nextkey ~= nil then --if next key in ... exists
				nextval = muldim:new()
				rawset(curvar, v, nextval) --recursively create new dim objects
			else
				rawset(curvar, v, val) --or just set the value
				return val, curvar
			end

		else

			if nextkey == nil then
				rawset(curvar, v, val)
				nextval = val
			end

		end

		curvar = nextval
	end

	return val, curvar
end

-- insert value at #tbl + 1, like table.insert
function muldim:Insert(val, ...)
	local ks = {...}
	local curvar = self

	for k,v in ipairs(ks) do
		local nextkey = rawget(ks, k + 1)
		local nextval = rawget(curvar, v)

		if nextval == nil then

			if nextkey ~= nil then
				nextval = muldim:new()
				rawset(curvar, v, nextval)
			else
				nextval = muldim:new()
				rawset(curvar, v, nextval)
				rawset(rawget(curvar, v), 1, val)
				return val, curvar
			end

		else

			if nextkey == nil then
				local into = rawget(curvar, v)
				rawset(into, #into + 1, val)
			end

		end

		curvar = nextval
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