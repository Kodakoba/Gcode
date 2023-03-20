SWEP.Base = "arccw_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - ForTuna" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Combat Axe"
SWEP.Trivia_Class = "Melee"
SWEP.Trivia_Desc = "\"Ancient\" melee weapon with a hollow core for alternative longer range lunge."
SWEP.Trivia_Manufacturer = "XLR Munitions"
SWEP.Trivia_Country = "New Ullia"
SWEP.Trivia_Year = "2140"

SWEP.TrueName = "Knife"
SWEP.True_Country = "China"
SWEP.True_Manufacturer = "Caveman Industry"
SWEP.True_Class = "Gun"
if GetConVar("arccw_truenames"):GetBool() then
    SWEP.PrintName = SWEP.TrueName
    SWEP.Trivia_Country = SWEP.True_Country
	SWEP.Trivia_Manufacturer = SWEP.True_Manufacturer
	SWEP.Trivia_Class = SWEP.True_Class	
end

SWEP.Slot = 0

SWEP.NPCWeaponType = "weapon_crowbar"
SWEP.NPCWeight = 250

SWEP.CamAttachment = 1

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/slog_osi_suck/c_axe.mdl"
SWEP.WorldModel = "models/weapons/arccw/slog_osi_suck/c_axe.mdl"
SWEP.ViewModelFOV = 70

SWEP.PrimaryBash = true
SWEP.CanBash = true
SWEP.MeleeDamage = 80
SWEP.MeleeRange = 25
SWEP.MeleeDamageType = DMG_SLASH + DMG_AIRBOAT

SWEP.MeleeSwingSound = nil
SWEP.MeleeMissSound = nil
SWEP.MeleeHitSound = nil
SWEP.MeleeHitNPCSound = nil

SWEP.MeleeGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE

SWEP.NotForNPCs = true

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "Slash"
    },
}

SWEP.WorldModelOffset = {
    pos = Vector(-10.5, 9, -8),
    ang = Angle(-10, 0, 180+5)
}

SWEP.MirrorVMWM = true

SWEP.MeleeTime = 0.575
SWEP.MeleeAttackTime = 0.35*0.75
SWEP.Delay = 60 / 600 

SWEP.Melee2 = true
SWEP.Melee2Damage = 50
SWEP.Melee2DamageBackstab = 180
SWEP.Melee2Range = 75
SWEP.Melee2Time = 0.55
SWEP.Melee2Gesture = nil
SWEP.Melee2AttackTime = 0.4*0.75

SWEP.Backstab = true
SWEP.BackstabMultiplier = 1.5

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "melee"
SWEP.DrawCrosshair = false

SWEP.Primary.ClipSize = -1

SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
        Time = 25/60,
        SoundTable = {{s = "weapons/arccw/knife/knife_deploy.wav", t = 0}}
    },
    ["ready"] = {
        Source = "draw",
        Time = 25/60,
    },
    ["bash"] = {
        Source = {"slash1","slash2","slash3"},
		Mult = 0.75,
    },
    ["bash2"] = {
        Source = {"stab"},
		Mult = 0.75,		
    },	
}

SWEP.IronSightStruct = false

SWEP.ActivePos = Vector(0, 5, 1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.BashPreparePos = Vector(0, 0, 0)
SWEP.BashPrepareAng = Angle(0, 5, 0)

SWEP.BashPos = Vector(0, 0, 0)
SWEP.BashAng = Angle(10, -10, 0)

SWEP.HolsterPos = Vector(0, 2, 0)
SWEP.HolsterAng = Angle(-40, -10, 0)