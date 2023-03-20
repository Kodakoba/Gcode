AddCSLuaFile()
include("upgrade.lua")

ENT.Base = "bw_base_electronics"
ENT.Type = "anim"
ENT.PrintName = "Blueprint Printer"

ENT.Model = "models/props_lab/plotter.mdl"
ENT.Skin = 0

ENT.Connectable = true
ENT.Cableable = true
ENT.BlueprintPrinter = true

ENT.ConnectPoint = Vector(22.7, 5.37, 36.6)

ENT.ScrollSpeed = 0
ENT.PrintTime = 60

ENT.Slots = 2
ENT.TotalSlots = 8

function ENT:CalculateScrollSpeed()
	-- the scrolling texture has 3 blueprints on it
	-- 1 blueprint is 0.333 of the texture
	-- the scroll should be (0.333 / print_time) per second
	self.ScrollSpeed = 0.333 / self.PrintTime
end

function ENT:DerivedDataTables()
	self:NetworkVar("Float", 1, "NextFinish")
	self:NetworkVar("Int", 1, "Level")
	self:NetworkVar("Bool", 2, "Jammed")

	self:SetLevel(1)

	self:UseNetDTNotify()
end

function ENT:SHInit()
	self:SetSubMaterial(1, "!BlueprintPrinter_Line")
	self.Inventory = {Inventory.Inventories.Entity:new(self)}

	self.Storage = self.Inventory[1]
	self.Storage.MaxItems = self.Slots
	self.Storage.UseOwnership = true

	self:CalculateScrollSpeed()

	self.Storage:On("CanAddItem", "NoMoving", function(self, it)
		return false
	end)

	self.Storage:On("CanMoveItem", "NoMoving", function(self, it)
		return false
	end)

	self.Storage.ActionCanCrossInventoryFrom = true
	self.Storage.ActionCanCrossInventoryTo = false
	self.Storage.SupportsSplit = false

	--timer.Simple(0, function() self:SetSubMaterial(1, "!BlueprintPrinterPaper") end)
end