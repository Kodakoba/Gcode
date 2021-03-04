include("shared.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_init.lua")

function ENT:Init(me)
	self:PhysicsInit(SOLID_VPHYSICS)

	self.ClaimedBy = nil
	self.BWBase = nil
	self.ClaimedPlayer = {}
end

function ENT:SetBase(base)
	self.BWBase = base
	self:SetBaseID(base:GetID())
end

function ENT:GetBase()
	return self.BWBase
end

function ENT:Think()
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
end

function ENT:UpdateTransmitState()
	if not self:GetClaimed() then
		return TRANSMIT_ALWAYS -- unclaimed bases are always transmitted
	end

	return TRANSMIT_PVS
end

function ENT:RequestClaim(ply)
	-- see: bw_modules/bases/baseview/ actions
	if self:GetClaimed() then return end
	self:Claim(ply)
end

function ENT:Claim(ply)
	local fac = ply:GetFaction()
	if fac then
		self:SetClaimedID(fac:GetID())
		self:SetClaimedByFaction(true)
		self.ClaimedFaction = fac
	else
		self:SetClaimedID(ply:UserID())
		self:SetClaimedByFaction(true)
	end

	--self.ClaimedPlayer = {ply, ply:SteamID64()}
end

function ENT:Unclaim()
	self.ClaimedPlayer = {}
	self.ClaimedFaction = nil

	self:SetClaimedID(-1)
	self:SetClaimedByFaction(false)
end

function ENT:Use(ply)

end
