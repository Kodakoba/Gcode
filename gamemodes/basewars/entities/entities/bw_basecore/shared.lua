AddCSLuaFile()

ENT.Base = "bw_base"
ENT.Type = "anim"
ENT.PrintName = "Base Core"

ENT.Model = "models/props/de_prodigy/wall_console1.mdl"
ENT.Skin = 0
ENT.IsBaseCore = true

function ENT:DerivedDataTables()
	self:NetworkVar("Int", 0, "BaseID")

	self:NetworkVar("Int", 1, "ClaimedID")
	self:NetworkVar("Bool", 0, "ClaimedByFaction")

	self:SetClaimedID(-1)
end

function ENT:GetBase()
	if SERVER then
		return self.BWBase
	else
		local bID = self:GetDTInt(0)	-- You Can't Stop Me
		return bID and BaseWars.Bases.GetBase(bID)
	end
end

function ENT:GetClaimed()
	if SERVER then
		return self.ClaimedBy, self:GetClaimedByFaction()
	else
		local fac = self:GetClaimedByFaction()
		local id = self:GetClaimedID()
		if fac then
			return Factions.GetFaction(id), true
		elseif id > 0 then
			local ply = Player(id)
			return ply:IsValid() and ply, false
		end
	end
end