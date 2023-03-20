AddCSLuaFile()


ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Safezone Dummy"

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 1, "MinsZone")
	self:NetworkVar("Vector", 2, "MaxsZone")
end
