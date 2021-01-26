
BaseWars.Money = BaseWars.Money or {}
local MODULE = BaseWars.Money

MODULE.Log = Logger("BW-Money", Color(80, 230, 80))

local PLAYER = debug.getregistry().Player



function MODULE:SyncMoney()
	self:SetNWString("BW_Money", self._money)
end

function MODULE:SetMoney(amt, no_write)
	self._money = math.Round(amt)
	self:SyncMoney()

	if not no_write then
		self:SetBWData("money", amt)
	end
end

function MODULE:TakeMoney(amt, no_write)
	self._money = math.Round(self._money - amt)
	self:SyncMoney()

	if not no_write then
		self:SubBWData("money", amt)
	end
end

function MODULE:AddMoney(amt, no_write)
	self._money = math.Round(self._money + amt)
	self:SyncMoney()

	if not no_write then
		self:AddBWData("money", amt)
	end
end

PLAYER.SetMoney = MODULE.SetMoney
PLAYER.AddMoney = MODULE.AddMoney
PLAYER.GiveMoney = MODULE.AddMoney
PLAYER.SubMoney = MODULE.TakeMoney
PLAYER.TakeMoney = MODULE.TakeMoney
PLAYER.SyncMoney = MODULE.SyncMoney

function MODULE:LoadMoney(dat, write)
	local money = dat.money

	if not money then --bruh
		money = BaseWars.Config.StartMoney

		MODULE.Log("Reset money for \"%s\" (%s) to starting money (%s)",
			self:Nick(), self:SteamID64(), Language.Price(money))
	end

	self:SetMoney(money, true)

end

hook.Add("BW_LoadPlayerData", "BWMoney.Load", MODULE.LoadMoney)
--hook.Add("BW_SavePlayerData", tag .. ".Save", MODULE.SaveMoney)