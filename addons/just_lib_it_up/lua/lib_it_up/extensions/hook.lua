function hook.Once(hookname, hookid, cb)

    hook.Add(hookname, hookid, function(...)
        hook.Remove(hookname, hookid)
        cb(...)
    end)

end