
function Curry(f, ...)
	local args = {...}
	return function(...)
		f(unpack(args), ...)
	end
end

function Carry(...)
	local args = {...}
	return function(...)
		return unpack(args)
	end
end