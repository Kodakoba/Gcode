AddCSLuaFile()
ENT.Base = "bw_base_electronics"

ENT.Model = "models/grp/printers/printer.mdl"
ENT.Skin = 0

ENT.Capacity 		= 10000
ENT.Money 			= 0
ENT.MaxPaper		= 2500
ENT.PrintInterval 	= 1 
ENT.PrintAmount		= 10
ENT.MaxLevel 		= 25
ENT.UpgradeCost 	= 1000

ENT.PrintName 		= "Basic Printer"

ENT.IsPrinter 		= true
ENT.IsValidRaidable = false

ENT.RebootTime = 10

local Clamp = math.Clamp

local slot = 2

function ENT:MakeFloat(name)

	self:NetworkVar("Float", slot, name)

	slot = slot + 1
end

function ENT:DerivedDataTables()

	slot = 2
	
	self:MakeFloat("Capacity")
	self:SetCapacity(self.Capacity)

	self:MakeFloat("NWMoney")

	self:MakeFloat("Level")
	self:SetLevel(1)

	self:MakeFloat("Multiplier")
	self:SetMultiplier(1)

	self:MakeFloat("PrintAmount")
	self:SetPrintAmount(self.PrintAmount)
	
	self:MakeFloat("UpgradeValue")

	self:NetworkVar("String", 1, "Mods")

	slot = 2
end

local mults = {
    [1] = 1.5,
    [2] = 1.3,
    [3] = 1.15
}

function OverclockGetMult(var)
    return mults[var] or 1
end
