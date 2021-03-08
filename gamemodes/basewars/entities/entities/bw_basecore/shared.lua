AddCSLuaFile()

ENT.Base = "bw_base"
ENT.Type = "anim"
ENT.PrintName = "Base Core"

ENT.Model = "models/props/de_prodigy/wall_console1.mdl"
ENT.Skin = 0
ENT.IsBaseCore = true

function ENT:DerivedDataTables()
	self:NetworkVar("Int", 0, "BaseID")

	self:NetworkVar("String", 0, "ClaimedID") -- gah!
	self:NetworkVar("Bool", 0, "ClaimedByFaction")

	self:SetClaimedID("")
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
		local base = self:GetBase()
		return base and base:GetClaimed(), self:GetClaimedByFaction()
	else
		return self:GetClaimedID() ~= ""
	end
end

function ENT:GetOwners()
	if SERVER then
		return self:GetBase():GetOwner()
	else
		local fac = self:GetClaimedByFaction()
		local id = self:GetClaimedID()
		if fac then
			fac = Factions.GetFaction( tonumber(id) )
			return fac, fac:GetMembersInfo()
		elseif id ~= "" then
			local ply = GetPlayerInfo(id, true)
			if ply then
				return nil, {ply}
			else
				return false, false
			end
		end
	end
end