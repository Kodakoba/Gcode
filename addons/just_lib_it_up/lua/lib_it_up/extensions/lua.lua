
function Curry(f, ...)
	local args = {...}
	local len = #args

	return function(...)
		local len2 = select('#', ...)

		for i=len + 1, len + len2 + 1 do
			args[i] = select(i - len, ...)
		end

		args[len + len2 + 2] = nil
		f(unpack(args))
	end
end

function Carry(...)
	local args = {...}
	return function(...)
		return unpack(args)
	end
end