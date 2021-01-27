AddCSLuaFile()
AddCSLuaFile("areamark_sh.lua")
AddCSLuaFile("areamark_cl.lua")

include("areamark_sh.lua")

if SERVER then
	include("areamark_sv.lua")
else
	include("areamark_cl.lua")
end
