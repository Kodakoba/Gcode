AddCSLuaFile()

local CURRENCY = "£"

Language = Language or {}

Language.Currency = "£"
Language.CURRENCY = Language.Currency 

Language.eval = function(self, key, ...)
	if Language[key] then 
		return Language[key]:format(...)
	end
	return ("[Invalid language: %s]"):format(key)
end

Language.__index = function(self, key)
	return ("[Invalid language: %s]"):format(key)
end
Language.__call = Language.eval 


Language.NoPower 		= "No power!"
Language.NoHealth 		= "Low health!"
Language.NoPrinters 	= "Target does not have enough printers!"

Language.PayOutOwner 	= "You got " .. Language.Currency .. "%s for the destruction of your %s"
Language.PayOut 		= "You got " .. Language.Currency .. "%s for destroying a %s!"

Language.Level 			= "Level"

Language.WelcomeBackCrash = "Welcome back!"
Language.Refunded		= "You were refunded %s after a crash."

Language.RaidStart 		= "%s has started a raid against %s!"

Language.Health = "Health: %s/%s"
Language.Power = "Power: %s/%s"

Language.SpawnMenuConf = "Confirm Purchase"
Language.SpawnMenuBuyConfirm = "Are you sure you want to purchase %s for " .. Language.Currency .. "%s?"

Language.Yes = "Yes"
Language.No = "No"

setmetatable(Language, Language)
--[[
	Raids.
]]

BaseWars.LANG = Language 
