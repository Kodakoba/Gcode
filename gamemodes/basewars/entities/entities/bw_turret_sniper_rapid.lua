AddCSLuaFile()

ENT.Base = "bw_base_turret"
ENT.Type = "anim"

ENT.PrintName = "Sniper Turret"
ENT.Model = "models/Combine_turrets/Floor_turret.mdl"

ENT.PowerRequired = 10
ENT.PowerMin = 1000
ENT.PowerCapacity = 2500

ENT.Drain = 250

ENT.Damage = 35
ENT.Radius = 1250
ENT.ShootingDelay = 0.8
ENT.Ammo = -1

ENT.Sound = Sound("npc/sniper/echo1.wav")

ENT.Spread = 2

function ENT:ModifyBullet(bullet, pos)
	--bullet.TracerName = "ToolTracer"
end

function ENT:PlaySound(b)
	self:EmitSound(self.Sound, 65, math.random(95, 110))
end