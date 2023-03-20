att.PrintName = "M24-K (FMJ)"
att.Icon = Material("entities/arccw_fml_fas1_ubgl_m24.png")
att.Description = "Obrez bolt-action underbarrel snipe rifle. Decent accuracy and range. Double tap +ZOOM to equip/dequip."
att.Desc_Pros = {
    "+ Selectable underbarrel sniper rifle",
}
att.Desc_Cons = {
}

att.Slot = "ubgl"

att.AutoStats = true

att.LHIK = true
att.LHIK_Animation = true

att.MountPositionOverride = 0

att.Model = "models/weapons/arccw/fml/fas1/atts/ubgl_m24.mdl"

att.UBGL = true

att.UBGL_PrintName = "UB (M24)"
att.UBGL_Automatic = false
att.UBGL_MuzzleEffect = "muzzleflash_m3"
att.UBGL_ClipSize = 1
att.UBGL_Ammo = "357"
att.UBGL_RPM = 60
att.UBGL_Recoil = 3
att.UBGL_Capacity = 1

local function Ammo(wep)
    return wep.Owner:GetAmmoCount("357")
end


att.UBGL_Fire = function(wep, ubgl)
    if wep:Clip2() <= 0 then return end

    wep:DoLHIKAnimation("fire", 1)

    wep.Owner:FireBullets({
        Src = wep.Owner:EyePos(),
        Num = 1,
        Damage = 120,
        Force = 2,
        Attacker = wep.Owner,
        Dir = wep.Owner:EyeAngles():Forward(),
        Spread = Vector(0.008, 0.008, 0.008),
        Callback = function(_, tr, dmg)
            local dist = (tr.HitPos - tr.StartPos):Length() * ArcCW.HUToM

            local dmgmax = 120
            local dmgmin = 40

            local delta = dist / 100

            delta = math.Clamp(delta, 0, 1)

            local amt = Lerp(delta, dmgmax, dmgmin)

            dmg:SetDamage(amt)
        end
    })

    wep:EmitSound("weapons/arccw_fml/sniper_m24/m24_fire1.wav", 120)

    wep:SetClip2(wep:Clip2() - 1)

    wep:DoEffects()
end

att.UBGL_Reload = function(wep, ubgl)
    if wep:Clip2() >= 1 then return end

    if Ammo(wep) <= 0 then return end

    wep:DoLHIKAnimation("reload", 2.5)

    wep:SetNextSecondaryFire(CurTime() + 2.5)

    wep:PlaySoundTable({
        {s = "weapons/arccw_fml/sniper_m24/m24_bolt_up.wav", t = 20/60},
        {s = "weapons/arccw_fml/sniper_m24/m24_bolt_back.wav", t = 35/60},
        {s = "weapons/arccw_fml/sniper_m24/m24_load1.wav", t = 87/60},		
        {s = "weapons/arccw_fml/sniper_m24/m24_bolt_forward.wav", t = 120/60},
        {s = "weapons/arccw_fml/sniper_m24/m24_bolt_down.wav", t = 131/60},		
    })

    local reserve = Ammo(wep)

    reserve = reserve + wep:Clip2()

    local clip = 1

    local load = math.Clamp(clip, 0, reserve)

    wep.Owner:SetAmmo(reserve - load, "357")

    wep:SetClip2(load)
end

att.Mult_SightTime = 1.15
att.Mult_MoveSpeed = 0.8
att.Mult_SightedSpeedMult = 0.75