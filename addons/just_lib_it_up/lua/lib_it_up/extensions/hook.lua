local ID = 0

function hook.Once(hookname, hookid, cb)

	local args = {}

	if isfunction(hookid) then
		cb = hookid
		hookid = "hookOnce" .. ID
		ID = ID + 1
	end

	local canIndex = isentity(hookid) or ispanel(hookid) or istable(hookid)

	if canIndex and hookid.IsValid then
		args[1] = hookid

		hookid = ("hookOnce:%p"):format(hookid) .. ":" .. ID
		ID = ID + 1
	end

	hook.Add(hookname, hookid, function(...)
		table.InsertVararg(args, ...)
		hook.Remove(hookname, hookid)
		cb(unpack(args))
	end)

end


function hook.OnceRet(hookname, hookid, cb)

	local args = {}

	if isfunction(hookid) then
		cb = hookid
		hookid = "hookOnceRet" .. ID
		ID = ID + 1
	end

	local canIndex = isentity(hookid) or ispanel(hookid) or istable(hookid)

	if canIndex and hookid.IsValid then
		args[1] = hookid

		hookid = ("hookOnce:%p"):format(hookid) .. ":" .. ID
		ID = ID + 1
	end

	hook.Add(hookname, hookid, function(...)
		table.InsertVararg(args, ...)

		local ok, ret = pcall(cb, unpack(args))
		if ret ~= false then
			hook.Remove(hookname, hookid)
			if not ok then
				error(ret, 2)
			end
		end
	end)

end