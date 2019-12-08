local color_red = Color(225, 0, 0, 255)
local color_greentext = Color(0, 240, 0, 255)
local color_green = Color(0, 200, 0, 255)

chatexp.Devs = {
	--Owners
	["STEAM_0:1:74836666"] = "Trixter",
	["STEAM_0:1:62445445"] = "Q2F2",
	["STEAM_0:0:133411986"] = "CakeShaked", --Trixter alt acc

	--Devs
	["STEAM_0:0:80669850"] = "user4992",
	["STEAM_0:0:42138604"] = "Liquid",
	["STEAM_0:0:62588856"] = "Ghosty",
	["STEAM_0:1:29543208"] = "Zeni",
}

local tagParse
do
	local gray = Color(128,128,128)
	local red, blu, green = Color(225,0,0), Color(80, 200, 255), Color(133,208,142)
	local orange = Color(255,160,30)

	local showranks = CreateConVar("bw_chat_showranks", "1", { FCVAR_ARCHIVE }, "Should we show player ranks when they talk? ex. \"[Owners] Q2F2: imgay\"")

	local function NiceFormat(str)
		local nice = str:lower()
		nice = str:gsub("^%l", string.upper)

		return nice
	end

	local ranks_tags = {
		["some_rank"] = {
			color = red,
			title = "Some Rank",
		},
		["some_other_rank"] = {
			color = blu,
			title = "Some Other Rank",
		},
	}

	-- ported from chitchat2
	function tagParse(tbl, ply)
		
	end
end
