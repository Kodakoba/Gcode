local path = "bw_modules/"

function IncludeBasewarsModules()
	local modules = 0

	local function incrementModule()
		MODULE = {}
		modules = modules + 1
	end

	local rlm = Realm(true, true)

	Modules = Modules or {}
	Modules.Log = Logger("BW-Modules", Colors.Sky)

	Modules.Register = function(name, col)
		return {name = name, col = col}
	end

	local s = SysTime()

		FInc.Recursive(path .. "*.lua", _SH, true, incrementModule)
		FInc.Recursive(path .. "server/*.lua", _SV, nil, incrementModule)
		FInc.Recursive(path .. "client/*.lua", _CL, nil, incrementModule)

	s = SysTime() - s

	Modules.Log("Loaded %d modules %s in %.2f s!", modules, rlm, s )
end