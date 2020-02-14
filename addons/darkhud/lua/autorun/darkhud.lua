AddCSLuaFile()

local path = "darkhud/"

local load = function()
	IncludeFolder(path .. "*.lua", _CL)
end
dload = load 

if HexLib then 
	load()
else
	hook.Add("HexLibLoaded", "DarkHUD", load)
end

