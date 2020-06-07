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