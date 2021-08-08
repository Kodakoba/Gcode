BaseWars.PlayerLevel = BaseWars.PlayerLevel or {}
local MODULE = BaseWars.PlayerLevel
MODULE.Log = Logger("BW-Level", Color(80, 230, 80))

function PLAYER:SyncLevel()
	self:SetNWString("BW_Level", self._level)
	self:SetNWString("BW_XP", self._xp)
end


function PLAYER:SetLevel(amt, no_write)
	self._level = math.Round(amt)
	self:SyncLevel()

	if not no_write then
		self:SetBWData("lvl", amt)
	end
end

function PLAYER:AddLevel(amt, no_write)
	self._level = math.Round(self._level + amt)
	self:SyncLevel()

	if not no_write then
		self:AddBWData("lvl", amt)
	end
end

function PLAYER:SetXP(amt, no_write)
	self._xp = math.Round(amt)
	self:CheckLevels()
	self:SyncLevel()

	if not no_write then
		self:SetBWData("xp", self._xp) -- xp can change in :CheckLevels()
	end
end

function PLAYER:AddXP(amt, no_write)
	self._xp = math.Round(self._xp + amt)
	self:CheckLevels()
	self:SyncLevel()

	if not no_write then
		self:SetBWData("xp", self._xp)
	end
end


function PLAYER:LoadLevel(dat, write)
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

function PLAYER:AwardEXPForMoney(money)
	self._xp_money_leftover = self._xp_money_leftover or 0
	local add, leftover = MODULE.MoneyToXP(money + self._xp_money_leftover, self:GetLevel(), self:GetXP())
	self._xp_money_leftover = leftover


	self:AddXP(add)
end

function PLAYER:CheckLevels()
	local curxp = self:GetXP()	-- player's current lv/xp
	local curlvl = self:GetLevel()

	local curtotalxp = 	(BaseWars.LevelXP.TotalXP[curlvl] or 0) + curxp		
	local lvs = curlvl	-- what level they should be

	for i=curlvl, #BaseWars.LevelXP.TotalXP do
		local req = BaseWars.LevelXP.TotalXP[i+1]
		
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

hook.Add("BW_LoadPlayerData", "BWLevel.Load", PLAYER.LoadLevel)
--hook.Add("BW_SavePlayerData", tag .. ".Save", MODULE.SaveMoney)