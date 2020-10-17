lazy = {}
lazy.__vars = {}

function lazy.Get(k)
	return lazy.__vars[k]
end

function lazy.Set(k, v)
	lazy.__vars[k] = v
	return v
end

function lazy.GetSet(k, setter, ...)
	local ret = lazy.__vars[k]

	if not ret then
		local v = setter(...)
		lazy.__vars[k] = v
		return v
	end

	return ret
end