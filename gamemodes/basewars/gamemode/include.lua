
AddCSLuaFile()

BaseWars = BaseWars or {}
BW = BaseWars
Basewars = BW 

BaseWars.LoadLog = Logger("BW-Load", Color(220, 100, 100))
local rlm = Realm(true, true)
BaseWars.LoadLog("Beginning inclusion %s", rlm)

local t1 = SysTime()


BaseWars.LoadLog("	Deriving...")
DeriveGamemode("sandbox")


local function includeCS(File)
	include(File)
	if SERVER then
		AddCSLuaFile(File)
	end
end


BaseWars.LoadLog("	Including shared...")

	includeCS("shared.lua")
	includeCS("language.lua")
	includeCS("config.lua")

	if ulib or ulx then
		includeCS("integration/bw_admin_ulx.lua")
	end



local path = "basewars/gamemode/"

local function shouldInclude(fn)
	if fn:match("_ext") then return false, false end
end


BaseWars.LoadLog("	Recursive including realm folders...")

	FInc.Recursive(path .. "shared/*", _SH, nil, shouldInclude)
	FInc.Recursive(path .. "client/*", _CL, nil, shouldInclude)
	FInc.Recursive(path .. "server/*", _SV, nil, shouldInclude)

BaseWars.LoadLog("	Loading module includer")

	include("modules.lua")
	AddCSLuaFile("modules.lua")

local t2 = SysTime()

BaseWars.LoadLog("Included %s all in %.3fs!", rlm, t2 - t1)


BaseWars.Loaded = true