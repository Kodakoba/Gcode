AddCSLuaFile()
ENT.Base = "bw_base_electronics"

ENT.Model = "models/grp/rack/rack.mdl"
ENT.Skin = 0

ENT.Capacity 		= 10000
ENT.Money 			= 0
ENT.MaxPaper		= 2500
ENT.PrintInterval 	= 1
ENT.PrintAmount		= 10
ENT.MaxLevel 		= 25
ENT.PowerCapacity = 50000

ENT.PrintName 		= "Printer Rack"

ENT.IsValidRaidable = false

local Clamp = math.Clamp

function ENT:GSAT(slot, name,  min, max)

	self:NetworkVar("Float", slot, name)

end

function ENT:DerivedDataTables()
	self:GSAT(2, "Capacity")
	self:GSAT(3, "Money", 0, "GetCapacity")
	self:NetworkVar("String", 1, "Printers")
end
