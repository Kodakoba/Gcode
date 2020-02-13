AddCSLuaFile()

PLAYER = FindMetaTable("Player")
ENTITY = FindMetaTable("Entity")
PANEL = FindMetaTable("Panel")
WEAPON = FindMetaTable("Weapon")

HexLib = "HexlibLoaded"

local path = "hexlib/"

local _CL = 1 
local _SH = 2
local _SV = 3

function IncludeFolder(name, realm, nofold)
	local file, folder = file.Find( path .. "/" .. name, "LUA" )
	local tbl = string.Explode("/", name)
	tbl[#tbl] = ""
	local fname = table.concat(tbl,"/")

	for k,v in pairs(file) do
		local name = path
		fname = name
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

	end
	
	if not nofold then
		for k,v in pairs(folder) do
			IncludeFolder(name..v, realm)
		end
	end
	
end

IncludeFolder("*")	--add all files then folders within hexlib/

hook.Run("HexlibLoaded")

















