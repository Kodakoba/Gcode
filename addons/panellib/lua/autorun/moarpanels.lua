
--moshi moshi calling all retards
if not HexLib then require("autorun/!!libitup") end

AddCSLuaFile()

MoarPanelsLoaded = true

function eval(var, ...)

	if isfunction(var) then
		return var(...)
	else
		return var
	end

end


local path = "moarpanels/"



--[[if CLIENT then 

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

	    ["DejaVu Sans"] = "DV",
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


end]]
--[[
IncludeFolder(path .. "*", _CL, true)
IncludeFolder("moarpanels/deltatext/*", _CL)]]
print("cum")
FInc.Recursive("moarpanels/*", _CL)