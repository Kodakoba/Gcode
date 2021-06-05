local PLAYER = debug.getregistry().Player

-- reminder to use `XP` and not `EXP`

BaseWars.PlayerLevel = BaseWars.PlayerLevel or {}
local MODULE = BaseWars.PlayerLevel

local startXP = 10

local Requirements = {
	NewXP = {},
	TotalXP = {},

	NewMoney = {},
	TotalMoney = {}
}

BaseWars.LevelXP = Requirements

local total_xp = 0
local total_money = 0

for i=1, 5000 do
	local xp = startXP + math.min(i*50, i^3)
	total_xp = total_xp + xp

	Requirements.NewXP[i] = xp
	Requirements.TotalXP[i] = total_xp
end

Requirements.NewXP[5001] = math.huge
Requirements.TotalXP[5001] = math.huge

local firstLevelsBonus = 20		-- first 20 levels get better conversion
local firstLevelsMult = 8 		-- first levels get an x4 multiplier

function MODULE.CalculateDiv(lv)
	local bonusIntensity = 1 - math.Clamp(lv / firstLevelsBonus, 0, 1) ^ 0.3 -- 0-1
	return 300 * ( 1 / Lerp(bonusIntensity, 1, firstLevelsMult) )
end

function MODULE.XPAtLevel(lv)
	return Requirements.NewXP[lv]
end

-- give the current total exp to also calculate starter EXP padding
function MODULE.MoneyToXP(money, lv, curxp)
	local div = 300
	local retxp = 0

	if lv and curxp then
		if lv < firstLevelsBonus then
			for i=lv, firstLevelsBonus do
				local div = MODULE.CalculateDiv(i)
				local add_xp = math.min(math.floor(money / div), MODULE.XPAtLevel(i + 1) - curxp)
				retxp = retxp + add_xp
				money = money - (add_xp * div)
				if money == 0 then break end
				
				curxp = 0
			end
		end
	end

	local addxp, keep_the_change_you_filthy_animal = math.floor(money / div), money % div
	retxp = math.Round(retxp + addxp)
	return retxp, keep_the_change_you_filthy_animal
end

function MODULE.XPToMoney(xp, lv, curxp)
	local div = 300
	local money = 0

	if lv and curxp then
		if lv < firstLevelsBonus then

			for i=lv, firstLevelsBonus do
				local div = MODULE.CalculateDiv(i)
				local sub_xp = math.min(xp, MODULE.XPAtLevel(lv) - curxp)
				xp = xp - sub_xp
				money = money + (sub_xp * div)

				curxp = 0
			end
		end
	end

	money = math.Round(money + xp * div)
	return money
end

local function isPlayer(ply)
	return (IsValid(ply) and ply:IsPlayer())
end


function PLAYER.GetLevel(ply)
	return SERVER and ply._level or tonumber(ply:GetNWInt("BW_Level", 0))
end


function PLAYER.GetXP(ply)
	return SERVER and ply._xp or tonumber(ply:GetNWString("BW_XP", 0))
end

function PLAYER.GetXPNextLevel(ply)
	local n = ply:GetLevel()
	return Requirements.NewXP[n + 1]
end

function PLAYER.HasLevel(ply, level)
	local plylevel = ply:GetLevel()
	return (plylevel >= level)
end