
local path = "research"


Research = {}
Research.IDs = {}
Research.CurID = 1

local _CL = 1 
local _SH = 2
local _SV = 3

function IncludeFolder(name, realm)
	local file, folder = file.Find( path .. "/" .. name, "LUA" )
	local tbl = string.Explode("/", name)	--not necessarily efficient
	tbl[#tbl] = ""
	local fname = table.concat(tbl,"/")

	for k,v in pairs(file) do
		local name = path .. "/" .. fname .. v

		if realm==_CL then 

			if SERVER then 
				AddCSLuaFile(name)
			end

			if CLIENT then 
				include(name)
			end

		elseif realm == _SH then 

			include(name)
			AddCSLuaFile(name)

		elseif realm == _SV and SERVER then 
			
			include(name)
		else
			ErrorNoHalt("Could not include file " .. fname .. "; fucked up realm?")
			continue
		end

		local rstr = (realm==_CL and "Client") or (realm==_SH and 'Shared') or (realm==_SV and 'Server') or "WHAT THE FUCK?"

	end

	for k,v in pairs(folder) do
		IncludeFolder(name..v, realm)
	end
	
end

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
	IncludeFolder("client/*.lua", _CL)
	IncludeFolder("server/*.lua", _SV)
	IncludeFolder("*.lua", _SH)


	IncludeCategories()
	IncludePerks()

	IncludeFolder("research/perks")
end

hook.Add("PostGamemodeLoaded", "Research", IncludeAll)

if CLIENT and FullLoadRan then 
	IncludeAll()
end
if SERVER and CurTime() > 60 then 
	IncludeAll()
end