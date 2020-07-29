DeriveGamemode("sandbox")

local function IncludeCS(File)

	include(File)

	if SERVER then

		AddCSLuaFile(File)

	end

end

local function LoadFileCS(File)

	if CLIENT then

		include(File)

	else

		AddCSLuaFile(File)

	end

end

local function IncludeSV(file)

	if SERVER then

		include(file)

	end

end

do

	IncludeCS("shared.lua")
	IncludeCS("language.lua")
	IncludeCS("config.lua")

	IncludeCS("shared/spawnmenu.lua")
	IncludeCS("shared/sh_perks.lua")

	if BaseWars.Config.ExtraStuff then
		IncludeCS("shared/playuhr.lua")
		IncludeCS("shared/customnick.lua")
	end

	if ulib or ulx then
		IncludeCS("integration/bw_admin_ulx.lua")
	end

end

local path = "basewars/gamemode/"

local function shouldInclude(fn)
	if fn:match("_ext") then return false, false end
end

FInc.Recursive(path .. "shared/*", _SH, nil, shouldInclude)
FInc.Recursive(path .. "client/*", _CL, nil, shouldInclude)
FInc.Recursive(path .. "server/*", _SV, nil, shouldInclude)

include("modules.lua")
AddCSLuaFile("modules.lua")

--[[do

	LoadFileCS("client/cl_items.lua")
	LoadFileCS("client/cl_bwmenu.lua")

	LoadFileCS("client/cl_status.lua")

	LoadFileCS("client/cl_font_disaster.lua")
	LoadFileCS("client/cl_perks.lua")
	LoadFileCS("client/cl_suggestions.lua")

	LoadFileCS("client/cl_playmus.lua")

	for k,v in pairs(file.Find("basewars/gamemode/client/*.lua", "LUA")) do 
		LoadFileCS("basewars/gamemode/client/" .. v)
	end
end

do
    IncludeSV("server/antifaggot.lua")
	IncludeSV("server/commands.lua")
	IncludeSV("server/hooks.lua")

	IncludeSV("server/printers.lua")
	IncludeSV("server/morelang.lua")
end]]
