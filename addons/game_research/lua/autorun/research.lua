
local path = "research"


Research = {}
Research.IDs = {}
Research.CurID = 1

local function IncludeCategories()
	local cats = file.Find("research/cats/*.lua", "LUA")

	for k,v in pairs(cats) do 
		local incpath = path .. "/cats/" .. v 
		include(incpath)
		AddCSLuaFile(incpath)
	end

end

local function IncludePerks()

	local cats = file.Find("research/perks/*.lua", "LUA")

	for k,v in pairs(cats) do 
		local incpath = path .. "/perks/" .. v 
		include(incpath)
		AddCSLuaFile(incpath)
	end


end

local function IncludeAll()
	IncludeFolder("research/client/*.lua", _CL)
	IncludeFolder("research/server/*.lua", _SV)
	IncludeFolder("research/*.lua", _SH)


	IncludeCategories()
	IncludePerks()

	IncludeFolder("research/perks/*", _SH)
end

hook.Add("PostGamemodeLoaded", "Research", IncludeAll)

if CLIENT and FullLoadRan then 
	IncludeAll()
end
if SERVER and CurTime() > 60 then 
	IncludeAll()
end