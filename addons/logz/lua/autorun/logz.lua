
AddCSLuaFile()


local _CL = 1
local _SH = 2
local _SV = 3

logz = {}

local function IncludeFolder(name, realm)
	local file, folder = file.Find( name, "LUA" )
	local tbl = string.Explode("/", name)
	tbl[#tbl] = ""
	local fname = table.concat(tbl,"/")
	if not realm then realm=_SH end 
	
	for k,v in SortedPairs(file) do
		local name = ""
		if realm==_CL then 

			if SERVER then 
				AddCSLuaFile(fname..v)
			end

			if CLIENT then 
				include(fname..v)
			end

		elseif realm == _SH then 

			include(fname..v)
			AddCSLuaFile(fname..v)

		elseif realm == _SV and SERVER then 
			
			include(fname..v)
		else
			ErrorNoHalt("Could not include file " .. fname .. "; fucked up realm?")
			continue
		end

		local rstr = (realm==_CL and "Client") or (realm==_SH and 'Shared') or (realm==_SV and 'Server') or "WHAT THE FUCK?"
		print('Included '..fname..v..' in realm ' .. rstr)

	end

	for k,v in pairs(folder) do
		IncludeFolder(name..v, realm)
	end
	
end

IncludeFolder("logs/server/*.lua", _SV)
IncludeFolder("logz/client/*.lua", _CL)
IncludeFolder("logz/*.lua", _SH)
