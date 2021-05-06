local prios = {} -- [prio] = {values}
local arr = {}	-- sorted array of priority numbers existing in `prios`

local function add(val, prio)
	if not prios[prio] then
		-- this prio is not in array; add it to arr
		local prev = 0

		for k,v in ipairs(arr) do
			if prio > v then
				table.insert(arr, k, prio)
				goto ins
			end
		end

		arr[1] = prio -- the array was empty to begin with
		::ins::
		prios[prio] = {val}
	else
		local t = prios[prio]
		t[#t + 1] = val
	end
end

local function remove(val)
	-- optional: add `prio` argument for quick find

	for pkey, pnum in ipairs(arr) do
		for k,v in ipairs(prios[pnum]) do
			if val == v then
				table.remove(prios[pnum], k)
				if #prios[pnum] == 0 then
					prios[pnum] = nil
					table.remove(arr, pkey)
				end

				break
			end
		end
	end
end

local function sortedIter()
	local k = 0
	local curprioTable 
	local subk = 0

	return function()

		local val

		if curprioTable then
			subk = subk + 1
			local val = curprioTable[subk]
			if val ~= nil then
				return subk, val
			else
				curprioTable = nil
			end
		end

		if not curprioTable then
			k = k + 1
			curprioTable = arr[k] and prios[arr[k]]
			subk = 1
			if not curprioTable then return nil end -- we ran out of all values

			return subk, curprioTable[subk]
		end

	end
end

add("Value 1", 1)
add("Value 2", 2)
add("Value 5", 5)

add("Value 1000", 1000)
add("Value 1000.5", 1000)
add("Value 1000.999", 1000)

remove("Value 5")

p(arr)
p(prios)

print("-------")
for k,v in sortedIter() do
	print(k, v)
	if v == "Value 2" then
		add("hehehehhee", 2)
	end
end