AddCSLuaFile()
ENT.Base = "bw_base_electronics"
ENT.Type = "anim"
ENT.PrintName = "Base Dispenser"

ENT.Model = "models/props_wasteland/laundry_washer003.mdl"
ENT.Skin = 0

function ENT:DerivedDispDataTables()

end

function ENT:DerivedDataTables()
	self:DerivedDispDataTables()
end