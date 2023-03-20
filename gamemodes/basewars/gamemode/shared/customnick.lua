local Tag = "nname"
local Tag_remove = "nname_destroy"
local Tag_pdata = "playernname"

local select        = select

local string_byte   = string.byte
local string_gmatch = string.gmatch
local string_gsub   = string.gsub
local string_sub    = string.sub

local PLY = debug.getregistry().Player

PLY.OldNick = PLY.OldNick or PLY.Nick
PLY.RealName = PLY.OldNick
PLY.RealNick = PLY.OldNick
PLY.EngineNick = PLY.EngineNick

local Nicks = {}

if SERVER then

	AddCSLuaFile()

	util.AddNetworkString(Tag)
	util.AddNetworkString(Tag_remove)

else

end
