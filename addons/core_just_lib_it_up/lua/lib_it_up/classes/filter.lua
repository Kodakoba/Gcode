LibItUp.SetIncluded()
Filter = Class:Callable()

-- usage:

-- Filter(some_table) - for unsequential tables; keys will be preserved
-- or
-- Filter(some_sequential_table, true) - for sequential tables; keys will be sequential

local shadow = setmetatable({}, {__mode = "k"}) --we ain't keepin the filter referenced

-- we keep internal variables in the shadow table so
-- iterating over Filter won't give unnecessary values

-- 1 is the iter function
-- 2 is table.remove or rem which is just a niller

local function rem(t, k)
	t[k] = nil
end

local function reverseipairs(t)
	local i = #t + 1
	return function()
		i = i - 1

		local v = t[i]
		if not v then return end

		return i, v
	end
end

function Filter:Initialize(t, seq, isunion)
	t = table.Copy(t)
	shadow[t] = {seq and reverseipairs or pairs, seq and table.remove or rem}
	return setmetatable(t, isunion and UnionFilter or Filter)
end

-- usage:

-- Filter({1, 2, "3", "4", 5}, true):Filter(isstring)

-- OR

-- Filter(ents.GetAll(), true):Filter("IsPlayer", true) => for every entity it'll check ent:IsPlayer()

function Filter:Filter(f, ismethod)
	local shad = shadow[self]
	local func = f

	if ismethod then func = function(v) return v[f](v) end end

	for k,v in shad[1](self) do
		if func(v) == false then
			shadow[self][2](self, k)
		end
	end
	return self
end

function Filter:Invert(f, ismethod)
	local shad = shadow[self]
	local func = f

	if ismethod then func = function(v) return v[f](v) end end

	for k,v in shad[1](self) do
		if func(v) ~= false then
			shadow[self][2](self, k)
		end
	end
	return self
end

function Filter:Free() --optional
	shadow[self] = nil
	return self
end

if not UnionTable then include("union.lua") end

UnionFilter = UnionTable:Callable()
UnionFilter.Free = Filter.Free
UnionFilter.Invert = Filter.Invert
UnionFilter.Filter = Filter.Filter

function UnionFilter:Initialize(t, seq)
	shadow[t] = {seq and reverseipairs or pairs, seq and table.remove or rem}
	return setmetatable(table.Copy(t), UnionFilter)
end

UnionFilter.__index = function(self, k)
	if UnionFilter[k] then return UnionFilter[k] else return UnionTable.__index(self, k) end
end

