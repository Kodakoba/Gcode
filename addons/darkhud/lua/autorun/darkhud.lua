AddCSLuaFile()

local path = "darkhud/"

local load = function()
	FInc.Recursive(path .. "*.lua", _CL)
end
dload = load

if LibItUp then
	load()
else
	hook.Add("LibbedItUp", "DarkHUD", load)
end

