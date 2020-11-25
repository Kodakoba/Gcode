__HookID = __HookID or 0

-- difference between this and hook.Add(event, object) is that
-- you are guaranteed a unique hook which won't overwrite other hooks
-- with the same object and name (or get overwritten)

function hook.Object(hookname, hookobj, cb)
	local id = "hookObject" .. __HookID

	hook.Add(hookname, id, function(...)
		if not hookobj:IsValid() then hook.Remove(hookname, id) return end
		cb(hookobj, ...)
	end)

	return id
end

function hook.Once(hookname, hookid, cb)

	if isfunction(hookid) then
		cb = hookid
		hookid = "hookOnce" .. __HookID
		__HookID = __HookID + 1
	end

	local canIndex = isentity(hookid) or ispanel(hookid) or istable(hookid)

	if canIndex and hookid.IsValid then -- if we were given an object, create a unique object hook

		local id
		local func = function(self, ...)
			hook.Remove(hookname, id)
			cb(self, ...)
		end

		id = hook.Object(hookname, hookid, func)

		return
	end

	hook.Add(hookname, hookid, function(...)
		hook.Remove(hookname, hookid)
		cb(...)
	end)

end


function hook.OnceRet(hookname, hookid, cb)

	if isfunction(hookid) then
		cb = hookid
		hookid = "hookOnceRet" .. __HookID
		__HookID = __HookID + 1
	end

	local canIndex = isentity(hookid) or ispanel(hookid) or istable(hookid)

	if canIndex and hookid.IsValid then

		local id
		local func = function(self, ...)
			local ok, ret = pcall(cb, self, ...)

			if ret ~= false then
				hook.Remove(hookname, id)
				if not ok then
					error(ret, 2)
				end
			end
		end

		id = hook.Object(hookname, hookid, func)

		return
	end

	hook.Add(hookname, hookid, function(...)
		local ok, ret = pcall(cb, ...)

		if not ok or ret ~= false then
			hook.Remove(hookname, hookid)
			if not ok then
				error(ret, 2)
			end
		end

	end)

end