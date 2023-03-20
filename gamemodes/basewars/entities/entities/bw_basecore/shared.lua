AddCSLuaFile()

ENT.Base = "bw_base"
ENT.Type = "anim"
ENT.PrintName = "Base Core"

ENT.Model = "models/props/de_prodigy/wall_console1.mdl"
ENT.Skin = 0
ENT.IsBaseCore = true
ENT.CanTakeDamage = false
ENT.NoHUD = true

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
	local base = self:GetBase()
	if not base then return false end

	return base:GetClaimed()
end

function ENT:GetOwners()
	local base = self:GetBase()
	if not base then return false end

	local fac, ows = base:GetOwner()
	return fac, ows
end

hook.Add("PhysgunPickup", "DontPickUpBasecores", function(ply, ent)
	if ent.IsBaseCore then return false end
end)