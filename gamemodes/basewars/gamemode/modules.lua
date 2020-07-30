AddCSLuaFile()

local path = "basewars/gamemode/modules/"
local rlm = Realm(true, true)

Modules = Modules or {}
Modules.Log = Logger("BW-Modules", Colors.Sky)

Modules.Register = function(name, col)
	return {name = name, col = col}
end

local modules = 0
function IncludeModules()

	modules = 0

	local s = SysTime()

	FInc.Recursive(path .. "*.lua", _SH, true)
	FInc.Recursive(path .. "server/*.lua", _SV)
	FInc.Recursive(path .. "client/*.lua", _CL)

	s = SysTime() - s

	Modules.Log("Loaded %d modules %s in %.2f s!", modules, rlm, s )
end

