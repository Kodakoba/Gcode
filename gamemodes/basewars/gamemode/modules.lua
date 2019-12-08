local path = "basewars/gamemode/modules"

local _CL = 1 
local _SH = 2
local _SV = 3

Modules = Modules or {}

Modules.Register = function(name, col)
	return {name = name, col = col}
end

local modules = 0
local modtbl = {}

local function IncludeFolder(name, realm, nofold)

	local file, folder = file.Find( path .. "/" .. name, "LUA" )

	local tbl = string.Explode("/", name)
	tbl[#tbl] = ""

	local fname = path .. "/" .. table.concat(tbl,"/")

	for k,v in pairs(file) do
		local name = fname

		if realm==_CL then 

			if SERVER then 
				AddCSLuaFile(name..v)
			end

			if CLIENT then 
				include(name..v)
			end

		elseif realm == _SH then 

			include(name..v)
			AddCSLuaFile(name..v)

		elseif realm == _SV and SERVER then 
			
			include(name..v)
		else
			ErrorNoHalt("Could not include file " .. name .. "; fucked up realm?")
			continue
		end

		modules = modules + 1
	end

	if not nofold then
		for k,v in pairs(folder) do
			IncludeFolder(name..v, realm)
		end
	end
	
end

function IncludeModules()

	modules = 0
	local s = SysTime()

	IncludeFolder("*.lua", _SH, true)
	IncludeFolder("server/*.lua", _SV)
	IncludeFolder("client/*.lua", _CL)

	s = SysTime() - s

	MsgC(Color(40, 140, 255), "[Modules]", Color(255, 255, 255), " Loaded " .. modules .. " modules " .. ((CLIENT and "clientside") or "serverside") .. " in " .. math.Round(s, 3) .. "s! \n" )
end
