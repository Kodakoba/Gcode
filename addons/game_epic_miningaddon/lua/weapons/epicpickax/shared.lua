AddCSLuaFile()

SWEP.PrintName              = "Harvester"
SWEP.Spawnable              = true
SWEP.AdminSpawnable         = false

SWEP.ViewModelFOV           = 65
SWEP.ViewModel              = "models/weapons/c_irifle.mdl"
SWEP.WorldModel             = "models/weapons/w_irifle.mdl"

SWEP.AutoSwitchTo           = false
SWEP.AutoSwitchFrom         = false

SWEP.Slot                   = 5
SWEP.SlotPos                = 1

SWEP.HoldType               = "ar2"
SWEP.FiresUnderwater        = true
SWEP.Weight                 = 20
SWEP.DrawCrosshair          = true
SWEP.Category               = "BaseWars"
SWEP.DrawAmmo               = false
SWEP.Base                   = "weapon_base"


SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.Ammo           = "none"
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Spread         = 0.0

SWEP.Primary.Automatic      = true

SWEP.Primary.Delay          = 0.2
SWEP.Primary.Force          = 1

SWEP.MineChance = 0.5
SWEP.FailChance = 1 - SWEP.MineChance	-- dont touch

local function CheckOre(ply)

	local tr = ply:GetEyeTrace()

	if not IsValid(tr.Entity) or not tr.Entity.IsOre or tr.Fraction > 256/32768 then return false end --geteyetrace is 32768 units

	return tr.Entity, tr.HitPos, tr.HitNormal
end

function SWEP:Initialize()
	self:SetHoldType( "ar2" )
end

local parts = {
	"impact_concrete",
	"impact_concrete_b",
	"impact_concrete_c",
	"impact_concrete_d",
}

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation(PLAYER_ATTACK1)

		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return
	end


	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local ow = (CLIENT and LocalPlayer()) or self:GetOwner()
	if not IsValid(ow) then return end

 	local ore, pos, norm = CheckOre(ow)
 	if not ore then return end


	if SERVER then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:GetOwner():SetAnimation(PLAYER_ATTACK1)

		self:SVPrimaryAttack(ow, ore)
	else
		self:CLPrimaryAttack()
	end

	--local p = parts[math.random(#parts)]
	--ParticleEffect(p, pos, norm:Angle())

	local ed = EffectData()
	ed:SetOrigin(pos)
	ed:SetNormal(norm)
	util.Effect("oreimpact", ed)

	--[[local em = ParticleEmitter(pos)

	local nang = Vector(norm)
	local dir = Vector()]]

	
end

function SWEP:SecondaryAttack()

end