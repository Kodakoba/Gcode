AddCSLuaFile()

ENT.Base = "bw_base"
ENT.Type = "anim"
ENT.PrintName = "Base Core"

ENT.Model = "models/props/de_prodigy/wall_console1.mdl"
ENT.Skin = 0

function ENT:DerivedDataTables()
	self:NetworkVar("Bool", 0, "Claimed")

	self:NetworkVar("Int", 0, "BaseID")
end

function ENT:GetBase()
	if SERVER then
		return self.BWBase
	else
		local bID = self:GetDTInt(0)	-- You Can't Stop Me
		return bID and BaseWars.Bases.GetBase(bID)
	end
end