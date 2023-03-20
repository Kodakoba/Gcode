easylua.StartWeapon("emp_nade")

SWEP.PrintName 				= "EMP nade"
SWEP.Author 				= "gachay"

SWEP.Purpose 				= "Asplode yo mats"

SWEP.Slot					= 5
SWEP.SlotPos				= 3

SWEP.Spawnable				= true
SWEP.Category 				= "BaseWars"

SWEP.ViewModel				= Model("models/weapons/c_grenade.mdl")
SWEP.WorldModel				= Model("models/weapons/w_npcnade.mdl")
SWEP.ViewModelFOV			= 65
SWEP.UseHands				= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:PrimaryAttack()

	if CLIENT then return end

	local ent = ents.Create("empnade_ent")

	local pos = self.Owner:EyePos()


	ent:SetPos(pos)
	ent:SetOwner(self.Owner)
	ent:SetPhysicsAttacker(self.Owner)

	ent:Spawn()
	ent:Activate()

	self:Remove()

	self:SetNextPrimaryFire(CurTime() + 1)

end

easylua.EndWeapon()