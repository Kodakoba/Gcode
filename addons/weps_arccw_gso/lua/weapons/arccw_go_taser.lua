SWEP.Base = "arccw_base"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - GSO (Pistols)" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Advanced Taser M26"
SWEP.Trivia_Class = "Stun Gun"
SWEP.Trivia_Desc = "Less-lethal weapon designed to incapacitate attackers with a high voltage electric shock. I know there's blood pooling from their lifeless body, their choombas all act as if you just murdered their bro, and they never get up, but rest assured, they are merely knocked out."
SWEP.Trivia_Manufacturer = "Axon"
SWEP.Trivia_Calibre = "Taser Cartridge M26"
SWEP.Trivia_Mechanism = "Compressed CO2"
SWEP.Trivia_Country = "USA"
SWEP.Trivia_Year = 1999

SWEP.Slot = 1

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw_go/v_eq_taser.mdl"
SWEP.WorldModel = "models/weapons/arccw_go/v_eq_taser.mdl"
SWEP.ViewModelFOV = 60

SWEP.DefaultBodygroups = "000000000000"

SWEP.Damage = 150
SWEP.DamageMin = 0 -- damage done at maximum range
SWEP.RangeMin = 5
SWEP.Range = 5 -- in METRES
SWEP.Penetration = 0
SWEP.DamageType = DMG_SHOCK
SWEP.ShootEntity = nil -- entity to fire, if any
-- IN M/S
SWEP.ChamberSize = 0 -- how many rounds can be chambered.
SWEP.Primary.ClipSize = 1 -- DefaultClip is automatically set.

SWEP.AlwaysPhysBullet = true
SWEP.PhysTracerProfile = 6
SWEP.PhysBulletMuzzleVelocity = 250

SWEP.Recoil = 0.100
SWEP.RecoilSide = 0.100
SWEP.RecoilRise = 0.1
SWEP.RecoilPunch = 2.5

SWEP.Delay = 60 / 600 -- 60 / RPM.
SWEP.Num = 1 -- number of shots per trigger pull.
SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "SNGL"
    },
    {
        Mode = 0
    }
}

SWEP.NPCWeaponType = "weapon_pistol"
SWEP.NPCWeight = 5

SWEP.AccuracyMOA = 10 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 125 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 25

SWEP.Primary.Ammo = "arccw_go_taser"

SWEP.Disposable = true -- when all ammo is expended, the gun will remove itself when holstered

SWEP.DoNotEquipmentAmmo = true

SWEP.AutoReload = true

SWEP.ShootVol = 75 -- volume of shoot sound
SWEP.ShootPitch = 100 -- pitch of shoot sound

SWEP.ShootSound = "arccw_go/taser/taser_shoot.wav"

SWEP.MeleeSwingSound = "arccw_go/m249/m249_draw.wav"
SWEP.MeleeMissSound = "weapons/iceaxe/iceaxe_swing1.wav"
SWEP.MeleeHitSound = "arccw_go/knife/knife_hitwall1.wav"
SWEP.MeleeHitNPCSound = "physics/body/body_medium_break2.wav"

SWEP.MuzzleEffectAttachment = 1 -- which attachment to put the muzzle on
SWEP.CaseEffectAttachment = 2 -- which attachment to put the case effect on

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.75
SWEP.SightTime = 0.200

SWEP.IronSightStruct = {
    Pos = Vector(-4.9, 0, 2.15),
    Ang = Angle(1, -0.075, 0),
    Magnification = 1.1,
    SwitchToSound = "", -- sound that plays when switching to this sight
    CrosshairInSights = false
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.ActivePos = Vector(-1, 2, -1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CrouchPos = Vector(-4, 0, -1)
SWEP.CrouchAng = Angle(0, 0, -10)

SWEP.HolsterPos = Vector(3, 3, 0)
SWEP.HolsterAng = Angle(-7.036, 30.016, 0)

SWEP.BarrelOffsetSighted = Vector(0, 0, -1)
SWEP.BarrelOffsetHip = Vector(2, 0, -2)
SWEP.BarrelOffsetCrouch = Vector(0, 0, -2)

SWEP.CustomizePos = Vector(8, 0, 1)
SWEP.CustomizeAng = Angle(5, 30, 30)

SWEP.BarrelLength = 24

SWEP.AttachmentElements = {
}

SWEP.ExtraSightDist = 10
SWEP.GuaranteeLaser = true

SWEP.WorldModelOffset = {
    pos = Vector(-18, 6, -3),
    ang = Angle(-10, 0, 180)
}

SWEP.MirrorVMWM = true

SWEP.Attachments = {
    {
        PrintName = "Perk",
        Slot = {"go_perk", "go_perk_pistol"}
    },
    {
        PrintName = "Charm",
        Slot = "charm",
        FreeSlot = true,
        Bone = "v_weapon.parent", -- relevant bone any attachments will be mostly referring to
        Offset = {
            vpos = Vector(0.75, -0.5, 5), -- offset that the attachment will be relative to the bone
            vang = Angle(90, 0, -90),
        },
        VMScale = Vector(0.5, 0.5, 0.5)
    },
}

SWEP.Animations = {
    ["draw"] = {
        Source = "draw",
    },
    ["fire"] = {
        Source = "shoot1",
    },
    ["reload"] = {
        Source = "draw",
    },
}

sound.Add({
    name = "ARCCW_GO_TASER.Draw",
    channel = 16,
    volume = 1.0,
    sound = "arccw_go/glock18/glock_draw.wav"
})

game.AddAmmoType({
    name = "arccw_go_taser"
})

if CLIENT then
    language.Add("arccw_go_taser_ammo", "M26 Taser Cartridge")
end