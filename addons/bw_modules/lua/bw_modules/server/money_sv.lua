
BaseWars.Money = BaseWars.Money or {}
local MODULE = BaseWars.Money

MODULE.Log = Logger("BW-Money", Color(80, 230, 80))

MODULE.Functions = {}
local FUNCS = MODULE.Functions

local PLAYER = debug.getregistry().Player

-- attempting to use money before the player data is fetched would error
-- so, instead, we use pre-init money as a wallet
-- attempts to add or take money will instead take from pre-init money
-- which will, eventually, be added into the real wallet

-- setting money before the data loads will most likely result in a race condition, and will error

local function applyPreInit(ply)
	if ply._money_preinit then
		local amt = ply._money_preinit
		MODULE.Log("Adding preinit money ( %d ) to %s (%s)", amt, ply:Nick(), ply:SteamID64())
		ply:AddMoney(amt)
		ply._money_preinit = nil
	end
end

local function addPreInit(ply, amt)
	ply._money_preinit = (ply._money_preinit or 0) + amt
end

function FUNCS:SyncMoney()
	self:GetPublicNW():Set(BaseWars.Money.NWKey, self:GetMoney())
end

-->  ==========
function FUNCS:SetMoney(amt, no_write)
	self = GetPlayerInfoGuarantee(self)

	if not self._money and not no_write then
		errorf("attempting to set money to a player before their wallet initializes! ( %s (%s) -> %d )",
			self:Nick(), self:SteamID64(), amt)
		return
	end

	self._money = math.Round(amt)
	self:SyncMoney()

	if not no_write then
		self:SetBWData("money", amt)
	end
end

--> +++++++++++
function FUNCS:AddMoney(amt, no_write)
	self = GetPlayerInfoGuarantee(self)

	if not self._money then
		addPreInit(self, -amt)
		MODULE.Log("Attempt to modify a player's wallet before init.\n	(%s (%s) : +%d)\n	Trace:\n%s",
			self:Nick(), self:SteamID64(), amt, debug.traceback())
		return
	end

	self._money = math.Round(self._money + amt)
	self:SyncMoney()

	if not no_write then
		self:AddBWData("money", amt)
	end
end

FUNCS.GiveMoney = FUNCS.AddMoney

--> -----------
function FUNCS:TakeMoney(amt, no_write)
	self = GetPlayerInfoGuarantee(self)

	if not self._money then
		addPreInit(self, -amt)
		MODULE.Log("Attempt to modify a player's wallet before init.\n	(%s (%s) : -%d)\n	Trace:\n%s",
			self:Nick(), self:SteamID64(), amt, debug.traceback())
		return
	end

	self._money = math.Round(self._money - amt)
	self:SyncMoney()

	if not no_write then
		self:SubBWData("money", amt)
	end
end
FUNCS.SubMoney = FUNCS.TakeMoney

function FUNCS:LoadMoney(dat, write)
	local money = dat.money

	if not money then --bruh
		money = BaseWars.Config.StartMoney

		MODULE.Log("Reset money for \"%s\" (%s) to starting money (%s)",
			self:Nick(), self:SteamID64(), Language.Price(money))
	end

	self:InitBWData("money", money)
	self:SetMoney(money, true)
	applyPreInit(self)
end

FUNCS.ReloadMoney = FUNCS.LoadMoney


--hook.Add("BW_SavePlayerData", tag .. ".Save", MODULE.SaveMoney)

local PInfo = LibItUp.PlayerInfo

for k,v in pairs(FUNCS) do
	PLAYER[k] = function(self, ...)
		local pin = GetPlayerInfoGuarantee(self)
		return v (pin, ...)
	end

	PInfo[k] = function(...)
		return v (...)
	end
end

hook.Add("BW_LoadPlayerData", "BWMoney.Load", PLAYER.LoadMoney)