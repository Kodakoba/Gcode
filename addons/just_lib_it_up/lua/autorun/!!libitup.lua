AddCSLuaFile()

--[[

	Coding is 300 bucks!

	And usually the server is pretty much high on popper
	to really get relaxed and I have this long keyboard, that goes almost all the way across my table.
	And then I put on my gachi mix and sublime text and

		just lib it up, and uh...

	It's a long process, you know, to get your whole code in there.
	But it's an intense feeling for the other dev; I think for myself too.

]]

__LibName = "libitup"

PLAYER = FindMetaTable("Player")
ENTITY = FindMetaTable("Entity")
PANEL = FindMetaTable("Panel")
WEAPON = FindMetaTable("Weapon")

LibItUp = {}

local path = "lib_it_up/"

local _CL = 1
local _SH = 2
local _SV = 3

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

	local pathname = name:match("(.+/).+")

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

local t1 = SysTime()

include(path .. "classes.lua") -- base class goes first

IncludeFolder(path .. "extensions/*", _SH) -- then extensions
IncludeFolder(path .. "classes/*", _SH)

loading = false


hook.Run("LibbedItUp")
hook.Run("LibItUp")

FInc.Recursive("lib_deps/sh_*.lua", _SH, true)

FInc.Recursive("lib_deps/cl_*.lua", _CL, true)
FInc.Recursive("lib_deps/sv_*.lua", _SV, true)

FInc.Recursive("lib_deps/client/*", _CL)
FInc.Recursive("lib_deps/server/*", _SV)


hook.Add("InitPostEntity", "InittedGlobal", function()
	EntityInitted = true
end)

local t2 = SysTime()


-- centering the fancy loaded text

local l1 = "LibItUp loaded!"
local l2 = "%d files included."
local l3 = "Took %.3fs."

l2 = l2:format(files)
l3 = l3:format(t2 - t1)

local longest_line = math.ceil(math.max(#l1, #l2, #l3) / 2) * 2 + 2

local function calcWidth(tx)
	local amt1 = math.floor( (longest_line - #tx) / 2 )
	local amt2 = math.ceil( (longest_line - #tx) / 2 )
	local spaces1 = (" "):rep(amt1)
	local spaces2 = (" "):rep(amt2)

	return "\n|" 	.. spaces2 .. tx .. spaces1 .. "|"
end


local str = calcWidth(l1)
str = str .. calcWidth(l2)
str = str .. calcWidth(l3)

local top = "□" .. ("―"):rep(longest_line) .. "□"
local bottom = "□" .. ("―"):rep(longest_line) .. "□"

MsgC(Color(230, 230, 110), "\n",

	top,
		str, 	"\n",
	bottom, 		"\n\n")