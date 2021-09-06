att.PrintName = "Mag-fed M3 (BUCK)"
att.Icon = Material("entities/arccw_fml_fas1_ubgl_m3.png")
att.Description = "Magazine-fed semi-auto 12 gauge underbarrel shotgun. Double tap +ZOOM to equip/dequip."
att.Desc_Pros = {
    "+ Selectable underbarrel shotgun",
}
att.Desc_Cons = {
}

att.Slot = "ubgl"

att.AutoStats = true

att.LHIK = true
att.LHIK_Animation = true

att.MountPositionOverride = 0

att.Model = "models/weapons/arccw/fml/fas1/atts/ubgl_m3_fed.mdl"

att.UBGL = true

att.UBGL_PrintName = "UB (BUCK)"
att.UBGL_Automatic = false
att.UBGL_MuzzleEffect = "muzzleflash_m3"
att.UBGL_ClipSize = 3
att.UBGL_Ammo = "buckshot"
att.UBGL_RPM = 150
att.UBGL_Recoil = 2
att.UBGL_Capacity = 3

local function Ammo(wep)
    return wep.Owner:GetAmmoCount("buckshot")
end

att.UBGL_Fire = function(wep, ubgl)
    if wep:Clip2() <= 0 then return end

    wep:DoLHIKAnimation("fire", 1)

    wep.Owner:FireBullets({
        Src = wep.Owner:EyePos(),
        Num = 12,
        Damage = 15,
        Force = 1,
        Attacker = wep.Owner,
        Dir = wep.Owner:EyeAngles():Forward(),
        Spread = Vector(0.065, 0.065, 0.065),
        Callback = function(_, tr, dmg)
            local dist = (tr.HitPos - tr.StartPos):Length() * ArcCW.HUToM

            local dmgmax = 15
            local dmgmin = 0

            local delta = dist / 40

            delta = math.Clamp(delta, 0, 1)

            local amt = Lerp(delta, dmgmax, dmgmin)

            dmg:SetDamage(amt)
        end
    })

    wep:EmitSound("weapons/arccw_fml/shotgun_m3s90p/m3s90_fire1.wav", 120)

    wep:SetClip2(wep:Clip2() - 1)

    wep:DoEffects()
end

att.UBGL_Reload = function(wep, ubgl)
    if wep:Clip2() >= 3 then return end
    if Ammo(wep) <= 0 then return end

    if wep:Clip2() == 0 then

        wep:DoLHIKAnimation("reload", 130/50)

        wep:SetNextSecondaryFire(CurTime() + 130/50)

        wep:PlaySoundTable({
            {s = "weapons/arccw/mag7/mag7_clipout.wav", t = 15/50},
            {s = "weapons/arccw/mag7/mag7_clipin.wav", t = 55/50},
            {s = "weapons/arccw/mag7/mag7_pump_back.wav", t = 91/50},
            {s = "weapons/arccw/mag7/mag7_pump_forward.wav", t = 105/50},
        })

    else

        wep:DoLHIKAnimation("reload_part", 90/50)

        wep:SetNextSecondaryFire(CurTime() + 90/50)

        wep:PlaySoundTable({
            {s = "weapons/arccw/mag7/mag7_clipout.wav", t = 15/50},
            {s = "weapons/arccw/mag7/mag7_clipin.wav", t = 55/50},
        })

    end

    local reserve = Ammo(wep)

    reserve = reserve + wep:Clip2()

    local clip = 3

    local load = math.Clamp(clip, 0, reserve)

    wep.Owner:SetAmmo(reserve - load, "buckshot")

    wep:SetClip2(load)
end

att.Mult_SightTime = 1.35
att.Mult_MoveSpeed = 0.75
att.Mult_SightedSpeedMult = 0.675