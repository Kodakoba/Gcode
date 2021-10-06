att.PrintName = "(CSExtras) Airsoft"
att.Icon = Material("entities/acwatt_ammo_airsoft.png", "smooth mips")
att.Description = "Replace weapon internals to fire tiny plastic BB pellets, effectively making the gun a toy. While the projectile does minimal damage, the weapon can load a lot more pellets and handles incredibly well.\nRemember, no full auto in the buildings!"
att.Desc_Pros = {
    "Shoot BB pellets",
    "Large magazine capacity",
    "Great handling and no recoil"
}
att.Desc_Cons = {
    "Minimal damage"
}
att.Desc_Neutrals = {
    "Uses BB Pellets ammo",
    "By default, players w/ this can instakill each other"
}
att.Slot = {"go_ammo_bullet", "go_ammo"}
att.InvAtt = "ammo_airsoft"

att.AutoStats = false

att.Mult_Recoil = 0.1
att.Mult_HipDispersion = 0.6
att.Mult_MoveDispersion = 0.75
att.Mult_AccuracyMOA = 2
att.Mult_Damage = 0.1
att.Mult_DamageMin = 0.1
att.Mult_RPM = 1.25
att.Mult_CycleSpeed = 1.25

att.Override_ShootEntity = "arccw_bb"
att.Mult_MuzzleVelocity = 300

att.Override_Ammo = "airsoft"

att.Hook_GetCapacity = function(wep, cap)
    local cs = wep.RegularClipSize or wep.Primary.ClipSize
    if wep.ShotgunReload or wep.ManualAction then
        return cs * 2
    elseif wep.RevolverReload or cs <= 2 then
        return cs
    else
        return cs * 4
    end
end

att.Hook_SelectInsertAnimation = function(wep, data)
    data.count = data.count * 2
    return data
end

att.Hook_PreDoEffects = function(wep, fx)
    return true
end

att.Hook_GetShootSound = function(wep, sound)
    return "weapons/arccw/airsoft2.wav"
end
att.Hook_GetDistantShootSound = function(wep, sound)
    return false
end

game.AddAmmoType({
    name = "airsoft"
})

if CLIENT then
    language.Add("airsoft_ammo", "BB Pellets")
end