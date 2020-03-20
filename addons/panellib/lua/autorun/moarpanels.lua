
--moshi moshi calling all retards

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


local path = "moarpanels/"



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


end

local Load = function()
	IncludeFolder(path .. "*", _CL, true)
	IncludeFolder("moarpanels/deltatext/*", _CL)
end

if HexLib then 
	Load()
else 
	hook.Add("HexlibLoaded", "LoadMorePanels", Load)
end