SWEP.Base = "arccw_base_melee"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - FA:S1" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Gator Claw"
SWEP.TrueName = "Machete"
SWEP.Trivia_Class = "Melee Weapon"
SWEP.Trivia_Desc = "A sharp blade cuts deeper."
SWEP.Trivia_Calibre = "Air"
SWEP.Trivia_Mechanism = "Newton's laws of physics"

SWEP.Slot = 0

if GetConVar("arccw_truenames"):GetBool() then SWEP.PrintName = SWEP.TrueName end

SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw/fml/fas1/c_machete.mdl"
SWEP.WorldModel = "models/weapons/arccw/fml/fas1/w_machete.mdl"
SWEP.ViewModelFOV = 70

SWEP.PrimaryBash = true
SWEP.CanBash = true
SWEP.MeleeDamage = 72
SWEP.MeleeRange = 50
SWEP.MeleeDamageType = DMG_SLASH

SWEP.MeleeSwingSound = "weapons/arccw/knife/knife_slash1.wav"
SWEP.MeleeHitSound = "weapons/arccw/knife/knife_hitwall3.wav"
SWEP.MeleeHitNPCSound = "weapons/arccw/knife/knife_hit2.wav"

SWEP.MeleeGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE

SWEP.NotForNPCs = true

SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "MELEE"
    },
}

SWEP.MeleeTime = 0.7	
SWEP.MeleeAttackTime = 0.3
SWEP.Delay = 60 / 600 

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "melee"
SWEP.DrawCrosshair = false

SWEP.Attachments = {
    {
        PrintName = "Charm",
        DefaultAttName = "None",
        Slot = {"fml_charm", "charm"},
        Bone = "Weapon_Main",
        Offset = {
            vpos = Vector(0.2, -4, 0),
            vang = Angle(90, 0, -90),
            wpos = Vector(5, 1, -3),
            wang = Angle(-9, 0, 180)
        },
		FreeSlot = true,
    },		
}

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
        Source = {"attack_heavy", "attack_heavy2", "attack_heavy3", "attack_heavy4", "attack_heavy5", "attack_heavy6"},
        Time = 1,
    },
}

SWEP.IronSightStruct = false

SWEP.ActivePos = Vector(0, 4, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.BashPreparePos = Vector(0, 0, 0)
SWEP.BashPrepareAng = Angle(0, 5, 0)

SWEP.BashPos = Vector(0, 0, 0)
SWEP.BashAng = Angle(10, -10, 0)

SWEP.HolsterPos = Vector(0, 2, 0)
SWEP.HolsterAng = Angle(-40, -10, 0)