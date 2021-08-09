BaseWars.PlayerLevel = BaseWars.PlayerLevel or {}
local MODULE = BaseWars.PlayerLevel
MODULE.Log = Logger("BW-Level", Color(80, 230, 80))

MODULE.Functions = {}
local FUNCS = MODULE.Functions

local PInfo = LibItUp.PlayerInfo

function FUNCS:SyncLevel()
	self:GetPublicNW():Set("lvl", self:GetLevel())
	self:GetPublicNW():Set("xp", self:GetXP())
end

function FUNCS:SetLevel(amt, no_write)
	self._level = math.Round(amt)
	self:SyncLevel()

	if not no_write then
		self:SetBWData("lvl", amt)
	end
end

function FUNCS:AddLevel(amt, no_write)
	self._level = math.Round(self._level + amt)
	self:SyncLevel()

	if not no_write then
		self:AddBWData("lvl", amt)
	end
end

function FUNCS:SetXP(amt, no_write)
	self._xp = math.Round(amt)
	self:CheckLevels()
	self:SyncLevel()

	if not no_write then
		self:SetBWData("xp", self._xp) -- xp can change in :CheckLevels()
	end
end

function FUNCS:AddXP(amt, no_write)
	self._xp = math.Round(self._xp + amt)
	self:CheckLevels()
	self:SyncLevel()

	if not no_write then
		self:SetBWData("xp", self._xp)
	end
end


function FUNCS:LoadLevel(dat, write)
	local lv = dat.lvl
	local xp = dat.xp

	if not lv then
		lv = 1
		xp = 0
		MODULE.Log("Reset level for \"%s\" (%s) to 1",
			self:Nick(), self:SteamID64())
	end

	self:SetLevel(lv, true)
	self:SetXP(xp, true)
end

function FUNCS:AwardEXPForMoney(money)
	self._xp_money_leftover = self._xp_money_leftover or 0
	local add, leftover = MODULE.MoneyToXP(money + self._xp_money_leftover, self:GetLevel(), self:GetXP())
	self._xp_money_leftover = leftover

	self:AddXP(add)
end

function FUNCS:CheckLevels()
	local curxp = self:GetXP()	-- player's current lv/xp
	local curlvl = self:GetLevel()

	local curtotalxp = 	(BaseWars.LevelXP.TotalXP[curlvl] or 0) + curxp
	local lvs = curlvl	-- what level they should be

	for i=curlvl, #BaseWars.LevelXP.TotalXP do
		local req = BaseWars.LevelXP.TotalXP[i + 1]

		if curtotalxp < req then
			lvs = i
			curxp = curtotalxp - (BaseWars.LevelXP.TotalXP[i] or 0)
			--printf("[%d] %d < [!%d!] %d < [%d] %d", i, BaseWars.LevelXP.TotalXP[i] or 0, i, curtotalxp, i+1, req)
			break
		end
	end

	self._xp = curxp
	self:SetLevel(lvs)
end

for k,v in pairs(FUNCS) do
	PLAYER[k] = function(self, ...)
		local pin = GetPlayerInfoGuarantee(self)
		return v (pin, ...)
	end

	PInfo[k] = function(...)
		return v (...)
	end
end

hook.Add("BW_LoadPlayerData", "BWLevel.Load", function(ply, ...)
	local pin = GetPlayerInfoGuarantee(ply)
	pin:LoadLevel(...)
end)
--hook.Add("BW_SavePlayerData", tag .. ".Save", MODULE.SaveMoney)