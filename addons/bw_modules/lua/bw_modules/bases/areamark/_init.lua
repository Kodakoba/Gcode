AddCSLuaFile()
AddCSLuaFile("areamark_sh.lua")
AddCSLuaFile("areamark_cl.lua")

FInc.OnStates(function()
	-- mfw including with mysqloo anywhere on the stack causes relative pathing to die
	include(file.Here() .. "areamark_sh.lua")
	include(file.Here() .. "areamark_" .. Rlm():lower() .. ".lua")
end, CLIENT or "BW_SQLAreasFetched")
