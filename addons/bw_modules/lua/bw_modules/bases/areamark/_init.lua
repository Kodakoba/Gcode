if _wAODIJAHOD then return end

_wAODIJAHOD = true

AddCSLuaFile()

StartTool("AreaMark")
BaseWars.Bases.MarkTool = TOOL
EndTool(TOOL)

FInc.FromHere("*.lua", _SH, false, FInc.RealmResolver():SetDefault(true), clprint)

FInc.OnStates(function()
	-- mfw including with mysqloo anywhere on the stack causes relative pathing to die
	include(file.Here() .. "areamark_sh.lua")
	include(file.Here() .. "areamark_" .. Rlm():lower() .. ".lua")
end, CLIENT or "BW_SQLAreasFetched")

_wAODIJAHOD = nil