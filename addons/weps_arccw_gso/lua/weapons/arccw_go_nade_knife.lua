SWEP.Base = "arccw_base_nade"
SWEP.Spawnable = true -- this obviously has to be set to true
SWEP.Category = "ArcCW - GSO (Gear)" -- edit this if you like
SWEP.AdminOnly = false

SWEP.PrintName = "Throwing Knife"
SWEP.Trivia_Class = "Knife"
SWEP.Trivia_Desc = "Skeletonized knife intended for throwing. It's all in the wrist."
SWEP.Trivia_Manufacturer = "Cold Steel"
SWEP.Trivia_Calibre = "N/A"
SWEP.Trivia_Mechanism = "Sharp Edge"
SWEP.Trivia_Country = "USA"
SWEP.Trivia_Year = 2004

SWEP.Slot = 4

SWEP.NotForNPCs = true

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/arccw_go/v_eq_throwingknife.mdl"
SWEP.WorldModel = "models/weapons/arccw_go/w_eq_throwingknife_thrown.mdl"
SWEP.ViewModelFOV = 60

SWEP.WorldModelOffset = {
    pos = Vector(3, 2, -1),
    ang = Angle(-10, 0, 180)
}

SWEP.FuseTime = false

SWEP.Throwing = true

SWEP.Primary.ClipSize = 1

SWEP.MuzzleVelocity = 2000
SWEP.ShootEntity = "arccw_thr_go_knife"

game.AddAmmoType({
    name = "arccw_go_nade_knife",
})
if CLIENT then
    language.Add("arccw_go_nade_knife_ammo", SWEP.PrintName)
end

SWEP.Primary.Ammo = "arccw_go_nade_knife"

SWEP.TTTWeaponType = "weapon_ttt_confgrenade"
SWEP.NPCWeaponType = "weapon_grenade"
SWEP.NPCWeight = 25

SWEP.PullPinTime = 0.1

SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetCrouch = nil
SWEP.BarrelOffsetHip = Vector(0, 0, 0)

SWEP.Animations = {
    ["draw"] = {
        Source = "deploy",
        SoundTable = {
            {
                s = "arccw_go/knife/knife_deploy1.wav",
                t = 0
            }
        }
    },
    ["pre_throw"] = {
        Source = "swing_build",
        Time = 0.15
    },
    ["throw"] = {
        Source = "swing_throw",
        TPAnim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
        Time = 0.1,
        SoundTable = {
            {
                s = "arccw_go/knife/knife_slash1.wav",
                t = 0
            }
        }
    }
}