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
	
	Inventory = Inventory or {}
	Items = Items or {}
	function Items:Get(name)
		for k,v in pairs(Items) do 
			if istable(v) and v.name and (v.name == name or v.name:lower() == name) then 
				return k, v 
			end
		end
		return false
	end

	for k,v in pairs(file.Find("basewars_free/gamemode/shared/inventory/*.lua","LUA")) do 
		IncludeCS('shared/inventory/'..v)
		print('included',v)
	end
	hook.Run("OnInvLoad")
end

do

	LoadFileCS("client/cl_items.lua")
	LoadFileCS("client/cl_bwmenu.lua")

	LoadFileCS("client/cl_weaponcrafter.lua")
	LoadFileCS("client/cl_status.lua")

	LoadFileCS("client/cl_font_disaster.lua")
	LoadFileCS("client/cl_perks.lua")
	LoadFileCS("client/cl_suggestions.lua")
	
	LoadFileCS("client/cl_rules.lua")
	LoadFileCS("client/cl_playmus.lua")

	LoadFileCS("client/cl_prestige.lua")

end

do
    IncludeSV("server/antifaggot.lua")
	IncludeSV("server/commands.lua")
	IncludeSV("server/hooks.lua")

	IncludeSV("server/printers.lua")
	IncludeSV("server/morelang.lua")
end
