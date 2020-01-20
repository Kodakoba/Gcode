
AddCSLuaFile()

local PANEL = {}
local BLANK = {}
local BlankFunc = function() end 
local blankfunc = BlankFunc 

MoarPanelsLoaded = true

function eval(var, ...)
	if isfunction(var) then 
		return var(...)
	else 
		return var
	end
end


local path = "moarpanels"

local _CL = 1 
local _SH = 2
local _SV = 3

function IncludeFolder(name, realm, nofold)
	local file, folder = file.Find( path .. "/" .. name, "LUA" )
	local tbl = string.Explode("/", name)
	tbl[#tbl] = ""
	local fname = table.concat(tbl,"/")

	for k,v in pairs(file) do
		local name = path .. "/"

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
			ErrorNoHalt("Could not include file " .. fname .. "; fucked up realm?")
			continue
		end

		local rstr = (realm==_CL and "Client") or (realm==_SH and 'Shared') or (realm==_SV and 'Server') or "WHAT THE FUCK?"

	end
	
	if not nofold then
		for k,v in pairs(folder) do
			IncludeFolder(name..v, realm)
		end
	end
	
end


IncludeFolder("*", _CL, true)

if CLIENT then 

	local families = {
	    ["Roboto"] = "R",
	    ["Roboto Light"] = "RL",

	    ["Titillium Web"] = "TW",
	    ["Titillium Web SemiBold"] = "TWB",

	    ["Open Sans"] = "OS",
	    ["Open Sans SemiBold"] = "OSB",
	    ["Open Sans Light"] = "OSL",

	    ["Arial"] = "A",
	    ["Helvetica"] = "HL",

	    ["Montserrat"] = "MR",
	    ["Montserrat Medium"] = "MRM",
	    ["Montserrat-Bold"] = "MRB",	--bruh.....
	    --["Montserrat SemiBold"] = "MRSB",

	    ["SnareDrum Zero NBP"] = "SDZ",
	    ["SnareDrum Two NBP"] = "SDT",

	    ["BreezeSans"] = "BS",
	    ["BreezeSans Medium"] = "BSSB",
	    ["BreezeSans Light"] = "BSL",
	    ["BreezeSans Bold"] = "BSB",
	}

	FontFamilies = families
	local sizes = {12, 14, 16, 18, 20, 24, 28, 32, 36, 48, 64, 72, 128}

	for k,v in pairs(families) do 

	    for _, size in pairs(sizes) do
	        surface.CreateFont(v .. size, {
	            font = k,
	            size = size,
	            weight = 400,
	        })
	    end

	end

	local MakeDeltaText = function()
		IncludeFolder("deltatext/*.lua", _CL)
	end

	if HexLib then 
		MakeDeltaText()
	else 
		hook.Add("HexlibLoaded", "DeltaText", MakeDeltaText)
	end
end