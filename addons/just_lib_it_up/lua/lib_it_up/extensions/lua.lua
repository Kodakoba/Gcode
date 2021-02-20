LibItUp.SetIncluded()

TrueFunc = function() return true end
FalseFunc = function() return false end

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

function RotateArgs(...)
	local args = {...}
	local len = select('#', ...)

	for i=1, len / 2 do
		local temp = args[i]
		args[i] = args[len - i + 1]
		args[len - i + 1] = temp
	end

	return unpack(args, 1, len)
end

function CheckArg(num, arg, check, expected_type)
	if isfunction(check) then
		if not check(arg) then
			local err = (expected_type and
							"expected '" .. expected_type .. "', got '" .. type(arg) .. "' instead")
						or
							"failed check function on '" .. type(arg) .. "'"
			errorf("bad argument #%d (%s)", num, err)
		end
	elseif isstring(check) then
		if type(arg) ~= check then
			local err = "expected '" .. (expected_type or check) .. "', got '" .. type(arg) .. "' instead"
			errorf("bad argument #%d (%s)", num, err)
		end
	end
end

function util.gary()
	error("gary")
end