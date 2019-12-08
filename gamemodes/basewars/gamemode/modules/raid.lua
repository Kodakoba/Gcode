
local PLAYER = debug.getregistry().Player

RaidCoolDown = 900 --15 min

BaseWars.Raid = BaseWars.Raid or {}
local raid = BaseWars.Raid

raid.Cooldowns = raid.Cooldowns or {}

function PLAYER:InRaid()
	return self:GetNWBool("Raided", false)
end