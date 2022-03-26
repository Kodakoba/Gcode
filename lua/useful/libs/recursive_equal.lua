local function istable(t)
	return type(t) == "table"
end

local function hex(t, t2)
	return ("%p%p"):format(t, t2)
end

local function recurEq(t1, t2, comp)
	local n1 = 0
	for k,v in pairs(t1) do
		n1 = n1 + 1
		local iv1 = istable(v)
		local iv2 = istable(t2[k])

		if iv1 ~= iv2 then return false end

		if iv1 and iv2 then
			local hx = hex(v, t2[k])
			if not comp[hx] then
				comp[hex(v, t2[k])] = true
				if not recurEq(v, t2[k], comp) then return false end
			end
		end
	end

	local n2 = 0
	for k,v in pairs(t2) do
		n2 = n2 + 1
	end

	return n1 == n2
end

local function isEqual(t, t2)
	return recurEq(t, t2, {})
end