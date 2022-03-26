AddCSLuaFile()

ENT.Base = "bw_base_turret"
ENT.Type = "anim"

ENT.PrintName = "Ballistic Turret"
ENT.Model = "models/Combine_turrets/Floor_turret.mdl"

ENT.PowerRequired = 10
ENT.PowerMin = 1000
ENT.PowerCapacity = 2500

ENT.Drain = 15

ENT.Spread = 25
ENT.Damage = 12
ENT.Radius = 350
ENT.ShootingDelay = 0.35
ENT.Ammo = -1

ENT.Sounds = {
	Sound("npc/turret_floor/shoot1.wav"),
	Sound("npc/turret_floor/shoot2.wav"),
	Sound("npc/turret_floor/shoot3.wav"),
}