local ID = 0

function hook.Once(hookname, hookid, cb)

	if isfunction(hookid) then
		cb = hookid
		hookid = "hookOnce" .. ID
		ID = ID + 1
	end

	hook.Add(hookname, hookid, function(...)
		hook.Remove(hookname, hookid)
		cb(...)
	end)

end


function hook.OnceRet(hookname, hookid, cb)

	if isfunction(hookid) then
		cb = hookid
		hookid = "hookOnceRet" .. ID
		ID = ID + 1
	end

	hook.Add(hookname, hookid, function(...)
		local ok, ret = pcall(cb, ...)
		if ret ~= false then
			hook.Remove(hookname, hookid)
			if not ok then
				error(ret, 2)
			end
		end
	end)

end