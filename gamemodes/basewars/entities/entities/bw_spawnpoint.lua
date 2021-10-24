ENT.Base = "bw_base_electronics"
ENT.Type = "anim"

ENT.PrintName = "SpawnPoint"
ENT.Model = "models/props_trainstation/trainstation_clock001.mdl"

ENT.PowerRequired = 15
ENT.PowerCapacity = 5000
ENT.MaxHealth = 200
ENT.AlwaysRaidable = true

if SERVER then

	AddCSLuaFile()

	local ForceAngle = Angle(-90, 0, 0)

	function ENT:Init()
		self:SetAngles(ForceAngle)
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		--self:EnableCustomCollisions(true)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end

		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	end

	--[[function ENT:TestCollision()
		return false
	end]]

	function ENT:BW_PostBuy(ply, tr, class)
		local pos = ply:GetPos()

		self:SetPos(pos)
		self.SpawnAngle = ply:EyeAngles()
		self:Spawn()
		self:Activate()

		self:EmitSound("buttons/blip1.wav")
		if IsValid(ply.SpawnPoint) then
			ply.SpawnPoint.OwningPly = false
			ply.SpawnPoint:EmitSound("ambient/machines/thumper_shutdown1.wav")
		end

		self.OwningPly = ply
		ply.SpawnPoint = self
	end

	function ENT:OnRemove()
		if IsPlayer(self.OwningPly) then
			self.OwningPly.SpawnPoint = nil
		end
	end

end


hook.Add("PlayerDeath", "RespawnTime", function(ply, by, atk)
	local side = ply:GetSide()

	local cfg = BaseWars.Config
	local base = cfg.RespawnTime -- base respawn time

	local sideCd = {cfg.RespawnRaider, cfg.RespawnRaided}

	if side then
		-- raider = 1, raided = 2
		local delay = sideCd[side] or base
		ply:SetRespawnTime(delay)
	else
		ply:SetRespawnTime(base)
	end
end)