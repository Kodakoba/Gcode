AddCSLuaFile()

SWEP.PrintName 				= "Healgun"
SWEP.Author 				= "Masterbrian123"
SWEP.Instructions 			= "Heal Objects and Players"
SWEP.Purpose 				= "Heals"

SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= false

SWEP.ViewModelFOV 			= 65
SWEP.ViewModel 				= "models/weapons/v_superphyscannon.mdl"
SWEP.WorldModel 			= "models/weapons/w_physics.mdl"

SWEP.AutoSwitchTo 			= true
SWEP.AutoSwitchFrom 		= false

SWEP.Slot 					= 5
SWEP.SlotPos 				= 1

SWEP.HoldType 				= "smg"
SWEP.FiresUnderwater 		= true
SWEP.Weight 				= 20
SWEP.DrawCrosshair 			= true
SWEP.Category 				= "Masterbrian123's SWEPs"
SWEP.DrawAmmo 				= false
SWEP.Base 					= "weapon_base"

SWEP.HealAmount 			= 2

SWEP.Primary.Damage     	= 0
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.Ammo 			= "none"
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Spread 		= 0.25
SWEP.Primary.NumberofShots 	= 1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Recoil 		= 0.01
SWEP.Primary.Delay 			= 0.15
SWEP.Primary.Force 			= 1

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= true
SWEP.Secondary.Ammo 		= "none"

SWEP.Range					= 2^16

function SWEP:Initialize()

    self:SetHoldType(self.HoldType)

end

function GenBullet(self)
	local bullet = {}
	bullet.Num = self.Primary.NumberofShots
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = self.Primary.Spread
	bullet.Tracer = 1
	bullet.TracerName = "ToolTracer"
	bullet.Force = self.Primary.Force
	bullet.Damage = self.Primary.Damage
	bullet.AmmoType = self.Primary.Ammo

	return bullet
end


function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if not IsFirstTimePredicted() then return end
	--if self.Owner:InRaid() then return end

	local tr = util.TraceLine({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Range,
		filter = self.Owner
	})

	local ent = tr.Entity

	if not IsValid(ent) then return end 

	local maxHP = ent:GetMaxHealth()
	if maxHP <= 0 then return end 

	if ent:Health() >= ent:GetMaxHealth() then return end

	local bullet = GenBullet(self)

	if ent:GetClass()=="prop_physics" or ent.IsBaseWars then

		self.Owner:FireBullets(bullet)

		if SERVER then

			ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + self.HealAmount))

			local color = ent:Health() / ent:GetMaxHealth()*255
            ent:SetColor(Color(color,color,color))

		end

	elseif IsPlayer(ent) then

		self.Owner:FireBullets(bullet)

		if SERVER then

			ent:SetHealth(30, math.min(ent:GetMaxHealth(), ent:Health() + self.HealAmount))

		end

	end


end
