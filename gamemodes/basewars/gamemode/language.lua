AddCSLuaFile()

local CURRENCY = "$" --"£"
Language = Language or {}

Language.Price = function(str)
	if isnumber(str) then
		return CURRENCY .. BaseWars.NumberFormat(str)
	else
		return CURRENCY .. str
	end
end

Language.eval = function(self, key, ...)
	local val = Language[key]
	if val then
		return val(...), true
	end

	return ("[Invalid language: %s]"):format(key), false
end

Language.__index = function(self, key)
	return ("[Invalid language: %s]"):format(key)
end
Language.__call = Language.eval


local Strings = {}


Strings.Currency = CURRENCY
Strings.CURRENCY = CURRENCY

Strings.NoPower 		= "No power!"
Strings.NoCharges 		= "No charges!"
Strings.NoHealth 		= "Low health!"
Strings.NoPrinters 	= "Target does not have enough printers!"

Strings.PayOutOwner 	= function(s, c)
	if isnumber(s) then s = BaseWars.NumberFormat(s) end
	return string.format("You got %s%s for the destruction of your %s",
		Strings.Currency, s, c or "Something")
end

Strings.PayOut 		= function(s, c)
	if isnumber(s) then s = BaseWars.NumberFormat(s) end
	return string.format("You got %s%s for destroying a %s!",
		Strings.Currency, s, c or "Something")
end


Strings.You 			= "You"

Strings.Level 			= function(str)
	if str then
		return ("Level %d"):format(str)
	else
		return "Level"
	end
end

Strings.WelcomeBackCrash 	= "Welcome back!"
Strings.Refunded			= function(s)
	if isnumber(s) then s = BaseWars.NumberFormat(s) end
	return ("You were refunded %s%s after a crash."):format(CURRENCY, s)
end

Strings.RaidStart 			= "%s has started a raid against %s!"

Strings.Health 			= "Health: %s/%s"
Strings.Power 				= "Power: %s/%s"

Strings.SpawnMenuConf 		= "Confirm Purchase"
Strings.SpawnMenuBuyConfirm = "Are you sure you want to purchase %s for " .. Strings.Currency .. "%s?"

Strings.Yes = "Yes"
Strings.No = "No"

Strings.Tip = "Tip!"
Strings.PrinterUpgradeTip = "Type /upg or /upgrade while looking at\n" ..
	"something to upgrade it.\n" ..
	"You can specify how many levels " ..
	"you want to upgrade something by.\nTry it now!"

Strings.PrinterUpgradeTipFont = "OS28"

Strings.ChargesCounter = "Charges: %s"
Strings.NextCharge = "next charge in %.1fs."
Strings.StimsLevel = "stims are only generated at level 2+"

Strings.BPNextPrint = "Next print in:"
Strings.BPNextPrintTime = "%.1fs."
Strings.BPNextPrintNextTime = "LV%d.: %.1fs."


Strings.Inv_StatSpread    = "Spread"
Strings.Inv_StatHipSpread = "Hip Spread"
Strings.Inv_StatMoveSpread  = "Moving Spread"
Strings.Inv_StatDamage      = "Damage"
Strings.Inv_StatRPM         = "RPM"
Strings.Inv_StatRange       = "Range"
Strings.Inv_StatReloadTime  = "Reload Time"
Strings.Inv_StatMagSize     = "Mag Size"
Strings.Inv_StatRecoil      = "Recoil"
Strings.Inv_StatHandling    = "Sight Time"
Strings.Inv_StatMoveSpeed   = "Movement Speed"
Strings.Inv_StatDrawTime    = "Draw Time"

Strings.UpgradeNoMoney		= "You don't have enough money!"
Strings.SpawnMenuMoney		= "You don't have enough money to buy this!"

setmetatable(Language, Language)

LocalString = Object:callable()
LocalString.All = LocalString.All or {}

function LocalString:Initialize(str, id)
	self._IsLang = true
	self.Str = str
	self.ID = id

	local crc = tonumber(util.CRC(id))
	local old = LocalString.All[crc]
	if old and old.ID ~= id then
		errorNHf("LocalString hash collision: hash %d, IDs: %s & %s",
			crc, id, old.ID)
	end

	LocalString.All[crc] = self
	self.NumID = crc
	self.IsString = isstring(str)
end

function LocalString:__tostring()
	if self.IsString then return self.Str end
	return self.Str()
end

function LocalString:__call(...)
	if self.IsString then return self.Str:format(...) end
	return self.Str(...)
end

function LocalString.__concat(a, b)
	return tostring(a) .. tostring(b)
end

function LocalString:Write()
	net.WriteUInt(self.NumID, 32)
end

function net.ReadLocalString()
	local id = net.ReadUInt(32)
	return LocalString.All[id]
end

function IsLanguage(what)
	return istable(what) and what._IsLang
end
IsLocalString = IsLanguage

for k,v in pairs(Strings) do
	Language[k] = LocalString(v, k)
end

--[[
	Raids.
]]

BaseWars.LANG = Language
