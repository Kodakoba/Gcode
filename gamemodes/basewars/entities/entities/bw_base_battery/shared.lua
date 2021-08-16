AddCSLuaFile()
ENT.Base = "bw_base"
ENT.Type = "anim"
ENT.PrintName = "Base Battery"

ENT.Model = "models/items/car_battery01.mdl"
ENT.Skin = 0

ENT.IsBattery = true
ENT.PowerType = "Battery"
ENT.PowerCapacity = 1000

function ENT:DerivedDataTables()

end

if not LibItUp then
	hook.Add("LibbedItUp", "PowerGrid", function()
		include("power_grid.lua")
	end)
else
	include("power_grid.lua")
end