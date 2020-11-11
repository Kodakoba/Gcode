function bit.GetLast(num, n)
	return num % (2^n)
end

function bit.GetFirst(num, n)
	local len = bit.GetLen(num)

	return bit.rshift(num, math.max(len - n, 0))
end

function bit.GetLen(num)
	return math.max(0, math.floor(math.log(math.abs(num), 2) + 1))
end

local select = select


-- returns whether every bit in ... is present in num
-- can take either multiple bits as varargs or one sum of those bits
-- useful for checking against masks
function bit.Has(num, ...)
	local bor = bit.bor(...)
	return bit.band(num, bor) == bor
end