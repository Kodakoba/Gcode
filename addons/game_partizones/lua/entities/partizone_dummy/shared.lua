AddCSLuaFile()


ENT.Base = "base_gmodentity"
ENT.Type = "anim"
 
ENT.PrintName = "Safezone Dummy"

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "ZoneName")
end
