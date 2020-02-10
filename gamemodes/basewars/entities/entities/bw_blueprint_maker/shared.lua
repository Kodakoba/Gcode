AddCSLuaFile()

ENT.Base = "bw_base_electronics"
ENT.Type = "anim"
ENT.PrintName = "Blueprint Maker"

ENT.Model = "models/grp/bpmachine/bpmachine.mdl"
ENT.Skin = 0

ENT.Connectable = true 
ENT.Cableable = true
ENT.BlueprintMaker = true 

function ENT:DerivedDataTables()

	self:NetworkVar("Float", 0, "NextFinish")

end