
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
local libTbl = LibItUp

libTbl.DependenciesFolder = "lib_deps"

local path = "lib_it_up/"

local _CL = 1
local _SH = 2
local _SV = 3

local loading = true

local files = 0

local includes = {
	[_CL] = function(name)
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

local realmExclusive = {
	["mysql_emitter.lua"] = _SV,
	["sql_arglist.lua"] = _SV,
	["rtpool.lua"] = _CL,
}

function IncludeFolder(name, realm, nofold)	--This function will be used both by addons and by LibItUp,
											-- so we'll only count files when we're loading
	local file, folder = file.Find( name, "LUA" )

	local pathname = name:match("(.+/).+")

	--[[
		Include all found lua files
	]]
	local curRealm = SERVER and _SV or _CL

	for k,v in pairs(file) do
		if not v:match(".+%.lua$") then continue end --if file doesn't end with .lua, ignore it
		local name = pathname .. v

		if realmExclusive[v] and realmExclusive[v] ~= curRealm then
			if SERVER then
				includes[realmExclusive[v]] (name) -- sv has to AddCSLuaFile it
			end
			continue
		end

		if loading then files = files + 1 end

		

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

local initCallbacks = {}



function libTbl.OnInitEntity(cb, ...)
	if EntityInitted then
		cb(...)
	else
		initCallbacks[#initCallbacks + 1] = {cb, ...}
	end
end

hook.Add("InitPostEntity", "InittedGlobal", function()
	EntityInitted = true

	for _, v in ipairs(initCallbacks) do
		v[1](unpack(v, 2))
	end

	initCallbacks = {}
end)

libTbl.LoadedDeps = libTbl.LoadedDeps or {}
libTbl.DepsCallbacks = libTbl.DepsCallbacks or {}

local depsCallback = libTbl.DepsCallbacks

function libTbl.OnLoaded(file, cb, ...)
	if libTbl.LoadedDeps[file] then
		cb(...)
	else
		local t = depsCallback[file] or {}
		depsCallback[file] = t
		t[#t + 1] = {cb, ...}
	end
end

include(path .. "classes.lua") -- base class goes first

local t1 = SysTime()

-- then we include everything

IncludeFolder(path .. "extensions/*", _SH) -- then extensions
IncludeFolder(path .. "classes/*", _SH)

IncludeFolder(path .. "libraries/*.lua", _SH)
IncludeFolder(path .. "libraries/client/*", _CL)
IncludeFolder(path .. "libraries/server/*", _SV)

IncludeFolder(path .. "thirdparty/*.lua", _SH)
IncludeFolder(path .. "thirdparty/client/*", _CL)
IncludeFolder(path .. "thirdparty/server/*", _SV)

loading = false

local t2 = SysTime()

local deps_t1 = SysTime()

hook.Run("LibbedItUp", libTbl)
hook.Run("LibItUp", libTbl)

local function onLoad(s)
	--printf("Loaded %s %s %.2fs. after start...", s, Realm(true, true), SysTime() - s1)
	local fn = file.GetFile(s)

	if depsCallback[fn] then
		for k,v in ipairs(depsCallback[fn]) do
			v[1](unpack(v, 2))
		end

		depsCallback[fn] = nil
	end

	libTbl.LoadedDeps[fn] = true
end

FInc.Recursive("lib_deps/sh_*.lua", _SH, true, nil, onLoad)
FInc.Recursive("lib_deps/*.lua", _SH, true, function(s) --decider
	s = file.GetFile(s)
	if s:match("^cl_") or s:match("^sh_") or s:match("^sv_") then return false, false end
end, onLoad)

FInc.Recursive("lib_deps/cl_*.lua", _CL, true, nil, onLoad)
FInc.Recursive("lib_deps/sv_*.lua", _SV, true, nil, onLoad)

FInc.Recursive("lib_deps/client/*", _CL, false, nil, onLoad)
FInc.Recursive("lib_deps/server/*", _SV, false, nil, onLoad)


local deps_t2 = SysTime()

-- centering the fancy loaded text

local l1 = "LibItUp loaded!"
local l2 = "%d lib files included in %.2fs."
local l3 = "Dependencies included in %.2fs."

l2 = l2:format(files, t2 - t1)
l3 = l3:format(deps_t2 - deps_t1)

local longest_line = math.ceil(math.max(#l1, #l2, #l3) / 2) * 2 + 2

local function calcWidth(tx)
	local amt1 = math.floor( (longest_line - #tx) / 2 )
	local amt2 = math.ceil( (longest_line - #tx) / 2 )
	local spaces1 = (" "):rep(amt1)
	local spaces2 = (" "):rep(amt2)

	return "\n|" 	.. spaces2 .. tx .. spaces1 .. "|"
end


local str = calcWidth(l1)
			.. calcWidth(l2)
			.. calcWidth(l3)

local top = "□" .. ("―"):rep(longest_line) .. "□"
local bottom = "□" .. ("―"):rep(longest_line) .. "□"

MsgC(Color(230, 230, 110), "\n",

	top,
		str, 	"\n",
	bottom, 		"\n\n")