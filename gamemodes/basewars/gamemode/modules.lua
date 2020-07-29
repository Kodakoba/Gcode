AddCSLuaFile()

local path = "basewars/gamemode/modules/"

Modules = Modules or {}

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

	MsgC(Color(40, 140, 255), "[Modules]", Color(255, 255, 255), " Loaded " .. modules .. " modules " .. ((CLIENT and "clientside") or "serverside") .. " in " .. math.Round(s, 3) .. "s! \n" )
end

Modules.Log = Log --e.