local ct
local avg = 0
local amt = 0

hook.OnceRet("Think", "Test", function()
    if not ct then ct = SysTime() return false end
    local cur = ct
    ct = SysTime()

    if amt == 100 then
        avg = avg / 100
        print(GLib.FormatDuration(avg))
        return
    end

    amt = amt + 1
    avg = avg + (ct - cur)
    return false
end)