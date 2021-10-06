att.PrintName = "(CSExtras) Airbender"
att.Icon = Material("entities/acwatt_perk_push.png", "smooth mips")
att.Description = "Specialized internals generate a gust of air as the bullet flies, physically punching the target with force proportional to damage. The firing force will push the user back proportional to recoil."
att.Desc_Pros = {
    "+ Push force on target",
    "+ Disorients target"
}
att.Desc_Cons = {
    "- Push force on self",
}
att.Slot = "go_perk"
att.InvAtt = "perk_push"

att.NotForNPC = true

att.AutoStats = true

att.Mult_Damage = 0.85
att.Mult_Recoil = 1.25

att.Hook_PostFireBullets = function(wep)
    if CLIENT then return end

    local dir = wep.Owner:GetForward()
    if wep.Owner:IsPlayer() and wep.Owner:GetPhysicsObject():IsValid() then
        local v = dir * (wep.Owner:IsOnGround() and -3 or -1) * math.Clamp(math.sqrt(wep.Recoil), 0.5, 3) * 60
        if GetConVar("arccw_extra_nofly"):GetBool() and not wep.Owner:IsOnGround() then v = v * 0.25 end
        wep.Owner:SetVelocity( v )
    end
end

att.Hook_BulletHit = function(wep, data)
    if CLIENT then return end
    local ent = data.tr.Entity

    -- Debounce for one tick to block shotgun shots
    if (ent.ArcCW_AirbenderNext or 0) >= CurTime() then return end
    ent.ArcCW_AirbenderNext = CurTime() + 0.01

    local dir = data.tr.Normal:GetNormalized()
    -- Use full damage on shotguns
    local damage = math.min(120, wep:GetDamage(data.range))
    if ent and ent:GetPhysicsObject():IsValid() then
        if ent:IsNPC() or ent:IsNextBot() then
            if ent:OnGround() then
                dir.z = 0.25
                dir = dir:GetNormalized()
                ent:SetVelocity( ent:GetVelocity() + dir * damage * 15 )
            end
        elseif ent:IsPlayer() then
            dir.z = 1
            ent:SetVelocity( dir * (ent:IsOnGround() and 6 or 2) * damage )
            local r = math.Clamp(damage / 12, 0.5, 10)
            local punch = AngleRand(-r, r)
            punch.r = 0
            ent:SetEyeAngles(ent:EyeAngles() + punch)
            ent:ViewPunch(punch * 2)
        else
            dir.z = 0.25
            dir = dir:GetNormalized()
            ent:GetPhysicsObject():AddVelocity(dir * damage * 4)
        end
    end

end