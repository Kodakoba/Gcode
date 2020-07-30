
local tag = "BaseWarsMoney"
local tag_escaped = "basewars_money"

BaseWars.Money = {}
local MODULE = BaseWars.Money

local PLAYER = debug.getregistry().Player


local function isPlayer(ply)

	return (IsValid(ply) and ply:IsPlayer())

end
local CDs = {}

function MODULE.GetMoney(ply)

	if SERVER then

		local puid = MODULE.InitMoney(ply)
		local money = sql.Check("SELECT money FROM bw_plyData WHERE puid=="..puid, true ) --maybe it's a little resource expensive...?
		return tonumber(money[1].money) --pepega sqlite

	elseif CLIENT then

		return tonumber(ply:GetNWString(tag)) or 0

	end

end
PLAYER.GetMoney = MODULE.GetMoney

local q = "CREATE TABLE IF NOT EXISTS bw_plyData(puid INTEGER PRIMARY KEY, money INTEGER, lvl INTEGER, xp INTEGER, plvl INTEGER, ppts INTEGER);"
sql.Check(q)

function MODULE:Dump()
	sql.Check("DROP TABLE bw_plyData")
	sql.Check(q)
	for k,v in pairs(player.GetAll()) do
		MODULE.InitMoney(v)
	end
end

function MODULE.FirstMoney(ply)
	local puid = ply:GetUID()
	if not puid then error('Failed to get PUID for ' .. ply) return end

	local q = "INSERT INTO bw_plyData(puid, money, lvl, xp, plvl, ppts) VALUES (%s, %s, %s, %s, %s, %s)"
	q = string.format(q, ply:GetUID(), BaseWars.Config.StartMoney, 0, 0, 0, 0)
	sql.Check(q)
	ply:SetNWString(tag, BaseWars.Config.StartMoney)
end

BaseWars.FirstEntry = MODULE.FirstMoney
PLAYER.FirstEntry = MODULE.FirstMoney

function MODULE.InitMoney(ply)

	local puid = ply:GetUID()
	if not puid then error('Failed to get PUID for ' .. ply) return end

	local data = sql.Check("SELECT * FROM bw_plyData WHERE puid=="..puid, true )

	if not data then
		MODULE.FirstMoney(ply)
		return puid
	end
	data = data[1]

	ply:SetNWString(tag, tonumber(data.money))

	return puid

end

PLAYER.InitMoney = MODULE.InitMoney

for k, v in ipairs(player.GetAll()) do
	v:InitMoney()
end

function MODULE.SaveMoney(ply, amount)

	local puid = ply:InitMoney()
	if not puid then return end
	amount = amount or ply:GetMoney()
	local q = "UPDATE bw_plyData SET money = %s WHERE puid==%s"
	q = q:format(amount, puid)

	sql.Check(q)

end

PLAYER.SaveMoney = MODULE.SaveMoney

function MODULE.LoadMoney(ply)

	ply:InitMoney()
	ply:SetNWString(tag, ply:GetMoney())

end

PLAYER.LoadMoney = MODULE.LoadMoney

function MODULE.SetMoney(ply, amount)

	if not isnumber(amount) or amount < 0 then amount = 0 end
	if amount > 2^63 then amount = 2^63 end

	if amount ~= amount then amount = 0 end

	amount = math.Round(amount)
	ply:SaveMoney(amount)

	ply:SetNWString(tag, amount)

end
PLAYER.SetMoney = MODULE.SetMoney

function MODULE.GiveMoney(ply, amount)

	ply:SetMoney(ply:GetMoney() + amount)

end
PLAYER.GiveMoney = MODULE.GiveMoney

function MODULE.TakeMoney(ply, amount)

	ply:SetMoney(ply:GetMoney() - amount)

end
PLAYER.TakeMoney = MODULE.TakeMoney

hook.Add("PlayerAuthed", tag .. ".Load", MODULE.LoadMoney)
hook.Add("PlayerDisconnected", tag .. ".Save", MODULE.SaveMoney)

