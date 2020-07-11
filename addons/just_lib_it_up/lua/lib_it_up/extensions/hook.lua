function hook.Once(hookname, hookid, cb)

    hook.Add(hookname, hookid, function(...)
        hook.Remove(hookname, hookid)
        cb(...)
    end)

end


function hook.OnceRet(hookname, hookid, cb)

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