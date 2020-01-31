--[[
	=== HeXLib, by HeX - Make it easy! ===
	A whole load of useful functions for GMod.
]]

AddCSLuaFile()

PLAYER = FindMetaTable("Player")
ENTITY = FindMetaTable("Entity")
PANEL = FindMetaTable("Panel")
WEAPON = FindMetaTable("Weapon")

HexLib = "HexlibLoaded"

HEX = {
	VERSION	= "HX002",
	
	GREY	= Color(175,175,175),
	WHITE	= Color(255,255,255),
	WHITE2	= Color(254,254,254),
	BLUE	= Color(51,153,255),
	YELLOW	= Color(255,200,0),
	RED		= Color(255,0,11),
	GREEN	= Color(66,255,96),
	PINK	= Color(255,0,153),
}


//Tell
MsgC(
	HEX.GREY, 	"[",
	HEX.BLUE,	"HeXLib",
	HEX.GREY, 	"] ",
	HEX.PINK,	"Loading.. ",
	HEX.GREY,	"(version "..HEX.VERSION..")"
)

//Load
local files = file.Find("hexlib/*.lua", "LUA")

for k, v in pairs(files) do
	include("hexlib/" .. v)
	AddCSLuaFile("hexlib/" .. v)
	
	v = v:gsub("hx_", ""):sub(0, -5)
	MsgC(HEX.YELLOW, "\n  "..v.."\t")
end

include("readme_dumdum.lua")
AddCSLuaFile("readme_dumdum.lua")

//Done
MsgC(
	HEX.GREY, 	"\n[",
	HEX.BLUE,	"HeXLib",
	HEX.GREY, 	"] ",
	HEX.GREEN,	"Ready\n"
)

hook.Run("HexlibLoaded")

















