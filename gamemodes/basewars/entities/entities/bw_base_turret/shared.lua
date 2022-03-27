AddCSLuaFile()

ENT.Base = "bw_base_electronics"
ENT.Type = "anim"

ENT.PrintName = "Turret"
ENT.Model = "models/Combine_turrets/Floor_turret.mdl"

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.PowerRequired = 10
ENT.PowerMin = 1000
ENT.PowerCapacity = 2500

ENT.Drain = 35

ENT.Damage = 2
ENT.Radius = 750

ENT.ShootingDelay = 0.08
ENT.ScanDelay = 0.1
ENT.HiFreqScanDelay = 0.025

ENT.Ammo = -1
ENT.Angle = math.rad(90)
ENT.LaserColor = Color(0, 255, 0)

ENT.EyePosOffset 	= Vector(0, 0, 0)
ENT.Sounds 			= Sound("npc/turret_floor/shoot1.wav")
ENT.NoAmmoSound		= Sound("weapons/pistol/pistol_empty.wav")

ENT.PresetMaxHealth = 500

ENT.AlwaysRaidable = true
ENT.ShootingOffset = Vector(9.7, 4.8, 53)
ENT.LaserOffset = Vector(-3.2, 25.3, 7.6)
ENT.GlareOffset = Vector(-3.7, 25, 7.6)
ENT.BoneIndex = 1

ENT.CanTakeDamage = true
ENT.NoHUD = false

ENT.States = {
	IDLE = 0,
	FRIENDLY = 1,
	WATCHING = 2, -- todo: implement visitors system
	AGGRO = 3,
	FIRING = 4,

	CACHED_ENEMY = 5,
	CACHED_FRIEND = 6,
	SCANNING = 7
}

local backStates

function ENT:DerivedDataTables()
	self:NetworkVar("Int", 1, "TurretState")
	self:NetworkVar("Entity", 1, "Target")
	self:NetworkVar("Float", 1, "NextScan")
end

function ENT:GetState() return self:GetTurretState() end
function ENT:SetState(n) return self:SetTurretState(isnumber(n) and n or self.States[n]) end
function ENT:GetStateEnum()
	backStates = backStates or table.KeysToValues(self.States)
	return backStates[self:GetState()]
end

function ENT:IsState(a)
	local cur = self:GetTurretState() -- lol V

	if isstring(a) then
		backStates = backStates or table.KeysToValues(self.States)
		cur = backStates[cur]
	end

	return a == cur
end