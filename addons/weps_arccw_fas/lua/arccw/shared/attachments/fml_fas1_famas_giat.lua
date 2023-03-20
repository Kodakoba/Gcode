att.PrintName = "GIAT Grenadier"
att.Icon = Material("entities/arccw_fml_fas1_famas_rocket.png")
att.Description = "Anti armoured vehicle rifle grenade."
att.Desc_Pros = {
    "+ Selectable grenade launcher",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "fas1_famas_grenadier"

att.UBGL = true
att.SortOrder = 2000

att.ExcludeFlags = {"ubgl"}

att.UBGL_BaseAnims = true

att.UBGL_PrintName = "UB (AT)"
att.UBGL_Automatic = false
att.UBGL_MuzzleEffect = "muzzleflash_m79"
att.UBGL_ClipSize = 1
att.UBGL_Ammo = "smg1_grenade"
att.UBGL_RPM = 1200
att.UBGL_Recoil = 2
att.UBGL_Capacity = 1

local function Ammo(wep)
    return wep.Owner:GetAmmoCount("smg1_grenade")
end

att.UBGL_Fire = function(wep, ubgl)
    if (wep:Clip2() <= 0 or wep:Clip1() <= 0) then return end

    wep:PlayAnimation("fire")

    wep:FireRocket("arccw_gl_rocket", 30000)

    wep:EmitSound("weapons/grenade_launcher1.wav", 100)

    wep:SetClip2(wep:Clip2() - 1)
    wep:SetClip1(wep:Clip1() - 1)	

    wep:DoEffects()
end

att.UBGL_Reload = function(wep, ubgl)
    if wep:Clip2() >= 1 then return end

    if Ammo(wep) <= 0 then return end

    wep:SetNextSecondaryFire(CurTime() + 120/60)

    wep:PlayAnimation("enter_ubgl2")

    local reserve = Ammo(wep)

    reserve = reserve + wep:Clip2()

    local clip = 1

    local load = math.Clamp(clip, 0, reserve)

    wep.Owner:SetAmmo(reserve - load, "smg1_grenade")

    wep:SetClip2(load)
end

att.Mult_SightTime = 1.1
att.Mult_SpeedMult = 0.95