att.PrintName = "\"HE\" FRAG-12"
att.Icon = Material("entities/att/arccw_uc_ammo_shotgun_generic.png", "mips smooth")
att.Description = [[Shotgun slug with a small high-explosive warhead. On impact, the round saturates its surroundings with shrapnel like a frag grenade.
Meant for breaching, but it can also useful for applying damage over an area.
Beware: the explosion doesn't care who it hurts.]]
att.Desc_Pros = {
    "uc.explode"
}
att.Desc_Cons = {
    "uc.alwaysphys",
}
att.Desc_Neutrals = {
    "uc.oneprojectile"
}
att.SortOrder = 2

att.Slot = {"ud_ammo_shotgun","uc_ammo"}

att.Mult_Penetration = 0.1
att.Mult_Damage = 0.5
att.Mult_DamageMin = 0.5
att.Mult_Range = .5
att.Mult_HipDispersion = 1.5
att.Override_Num = 1
att.Override_Num_Priority = 99
att.AutoStats = true

att.Override_HullSize = 0

att.GivesFlags = {"uc_slug"}

att.Override_AlwaysPhysBullet = true
att.Mult_PhysBulletGravity = 1.5
att.Override_PhysBulletImpact = false

--[[]
local function BulletHit(wep, data)
    if data.damage then
        util.BlastDamage(wep, wep:GetOwner(), data.tr.HitPos, 128, data.damage)

        local eff = EffectData()
        eff:SetOrigin(data.tr.HitPos)
        util.Effect("Explosion", eff)
        util.Decal("Scorch", data.tr.HitPos - data.tr.HitNormal, data.tr.HitPos + data.tr.HitNormal, ents.GetAll())
    end
end
att.Hook_BulletHit = BulletHit
]]

att.Hook_PhysBulletHit = function(wep, data)
    if SERVER then
    local delta = data.bullet.Travelled / (data.bullet.Range / ArcCW.HUToM)
    delta = math.Clamp(delta, 0, 1)
    local dmg = Lerp(delta, data.bullet.DamageMax, data.bullet.DamageMin)

    util.BlastDamage(wep, wep:GetOwner(), data.tr.HitPos, 128, dmg)

    local eff = EffectData()
    eff:SetOrigin(data.tr.HitPos)
    eff:SetMagnitude(4)
    eff:SetScale(0.5)
    eff:SetRadius(4)
    util.Effect("Sparks", eff)
    util.Effect("Explosion", eff)
    util.Decal("Scorch", data.tr.HitPos - data.tr.HitNormal, data.tr.HitPos + data.tr.HitNormal, ents.GetAll())
    end
end

att.Hook_Compatible = function(wep)
    if !wep:GetIsShotgun() then
        return false
    end
end