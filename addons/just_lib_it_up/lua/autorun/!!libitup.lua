AddCSLuaFile()

--[[

	Coding is 300 bucks!

	And usually the server is pretty much high on popper
	to really get relaxed and I have this long keyboard, that goes almost all the way across my table.
	And then I put on my gachi mix and sublime text and

		just lib it up, and uh...

	It's a long process you know to get your whole code in there.
	But it's an intense feeling for the other dev; I think for myself too.

]]

PLAYER = FindMetaTable("Player")
ENTITY = FindMetaTable("Entity")
PANEL = FindMetaTable("Panel")
WEAPON = FindMetaTable("Weapon")

HexLib = "HexlibLoaded"
LibItUp = "LibbedItUp"

local path = "lib_it_up/"

_CL = 1
_SH = 2
_SV = 3

local loading = true

local files = 0

local includes = {
	[_CL] = function()
		if SERVER then
			AddCSLuaFile(name)
		else
			include(name)
		end
	end,

	[_SH] = function(name)
		AddCSLuaFile(name)
		include(name)
	end,


	[_SV] = function(name)
		include(name)
	end,

}


function IncludeFolder(name, realm, nofold)	--This function will be used both by addons and by LibItUp,
											-- so we'll only count files when we're loading
	local file, folder = file.Find( name, "LUA" )

	local tbl = string.Explode("/", name)	
	tbl[#tbl] = nil	--strip the last path

	local pathname = table.concat(tbl, "/")
	if #tbl > 0 then pathname = pathname .. "/" end 	--if table length is > 0, then we are currently including a folder

	--[[
		Include all found lua files
	]]

	for k,v in pairs(file) do
		if not v:match(".+%.lua$") then continue end --if file doesn't end with .lua, ignore it

		if loading then files = files + 1 end

		local name = pathname .. v

		if includes[realm] then 
			includes[realm] (name)
		else
			ErrorNoHalt("Could not include file " .. name .. "; fucked up realm?\n")
			continue
		end

	end
		
	--[[
		Recursively add folders
	]]

	if not nofold then
		for k,v in pairs(folder) do
			IncludeFolder(pathname .. v .. "/*", realm)
		end
	end
	
end

IncludeFolder(path .. "*", _SH)	--add all files then folders within lib_it_up/

loading = false 

local str = "\n/------------\n Lib-it-up loaded!\n %d files included. \n-------------/\n\n"

MsgC(Color(230, 230, 110), str:format(files))

hook.Run("LibbedItUp")
hook.Run("LibItUp")

hook.Run("HexlibLoaded")	--legacy

