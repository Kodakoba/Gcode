AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.PrintName = "AI Base Bot"

ENT.Model = "models/player/swat.mdl"
ENT.Skin = 0
ENT.Spawnable = true
ENT.IsAIBaseBot = true

ENT.EngageSpeed = 160
ENT.PatrolSpeed = 70
ENT.MoveSpeed = ENT.PatrolSpeed

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "CurrentWeapon")
	self:NetworkVar("Angle", 0, "NWAimAngle")
end

function ENT:GetActiveWeapon()
	return self:GetCurrentWeapon()
end

list.Set( "NPC", "aib_bot", {
	Name = "MoveToPos",
	Class = "aib_bot",
	Category = "NextBot Demos - NextBot Functions"
} )


local PLAYER = FindMetaTable("Player")
PLAYER._aibAimVector = PLAYER._aibAimVector or PLAYER.GetAimVector

function PLAYER:GetAimVector()
	if self.IsAIBaseBot then
		return self:GetAngles():Forward()
	end

	return self._aibAimVector(self)
end

function ENT:OnKilled( dmginfo )
	hook.Run( "OnNPCKilled", self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self:BecomeRagdoll( dmginfo )
	if IsValid(self:GetActiveWeapon()) then
		self:GetActiveWeapon():Remove()
	end

	--self:Remove()
end