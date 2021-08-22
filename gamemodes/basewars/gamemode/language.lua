AddCSLuaFile()

local CURRENCY = "$" --"£"

Language = Language or {}

Language.Currency = CURRENCY
Language.CURRENCY = CURRENCY
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
		if isstring(val) then
			return val:format(...), true
		else
			return val(...), true
		end
	end

	return ("[Invalid language: %s]"):format(key), false
end

Language.__index = function(self, key)
	return ("[Invalid language: %s]"):format(key)
end
Language.__call = Language.eval



Language.NoPower 		= "No power!"
Language.NoCharges 		= "No charges!"
Language.NoHealth 		= "Low health!"
Language.NoPrinters 	= "Target does not have enough printers!"

Language.PayOutOwner 	= "You got " .. Language.Currency .. "%s for the destruction of your %s"
Language.PayOut 		= "You got " .. Language.Currency .. "%s for destroying a %s!"

Language.You 			= "You"

Language.Level 			= function(str)
	if str then
		return ("Level %d"):format(str)
	else
		return "Level"
	end
end

Language.WelcomeBackCrash = "Welcome back!"
Language.Refunded		= "You were refunded %s after a crash."

Language.RaidStart 		= "%s has started a raid against %s!"

Language.Health = "Health: %s/%s"
Language.Power = "Power: %s/%s"

Language.SpawnMenuConf = "Confirm Purchase"
Language.SpawnMenuBuyConfirm = "Are you sure you want to purchase %s for " .. Language.Currency .. "%s?"

Language.Yes = "Yes"
Language.No = "No"

Language.Tip = "Tip!"
Language.PrinterUpgradeTip = "Type /upg or /upgrade while looking at\n" ..
	"something to upgrade it.\n" .. 
	"You can specify how many levels " ..
	"you want to upgrade something by.\nTry it now!"

Language.PrinterUpgradeTipFont = "OS28"

Language.ChargesCounter = "Charges: %s"
Language.NextCharge = "next charge in %.1fs."
Language.StimsLevel = "stims are only generated at level 2+"

setmetatable(Language, Language)

LocalString = Object:callable()

function LocalString:Initialize(str, id)
	self.Str = str
	self.ID = id
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

function LocalString:Write()
	net.WriteUInt(self.ID, 8)
end

function net.ReadLocalString(lang)
	if not lang then error("ReadLocalString requires a language table!") return end
	local id = net.ReadUInt(8)
	return lang[id]
end

--[[
	Raids.
]]

BaseWars.LANG = Language 
