att.PrintName = "(CSExtras) Street Justice"
att.Icon = Material("entities/acwatt_perk_streetjustice.png", "smooth mips")
att.Description = "Concentrate all your fury into every bash, creating a strong push force and knocking ammo from the target to you (how does that work?)."
att.Desc_Pros = {
    "+ Ammo steal on bash",
    "+ Knockback force on bash"
}
att.Desc_Cons = {
}
att.Slot = "go_perk"
att.InvAtt = "perk_streetjustice"

att.NotForNPC = true

att.AutoStats = true
att.Mult_MeleeDamage = 1.25
att.Mult_MeleeTime = 1.25
att.Mult_DrawTime = 1.25

att.Hook_PostBash = function(wep, data)
    local ent = data.tr.Entity
    local dir = data.tr.Normal:GetNormalized()

    if IsValid(ent) then
        if (ent.ArcCW_StreetJustice or 0) < CurTime() and (ent:IsNPC() or ent:IsPlayer()) then
            local otherWep = ent:GetActiveWeapon()
            if ent:IsPlayer() and IsValid(otherWep) and otherWep:Clip1() > 0 then
                ent:GetActiveWeapon():SetClip1(math.ceil(otherWep:Clip1() / 4))
                wep:SetClip1(math.min(wep:GetCapacity() + wep:GetChamberSize(), math.ceil(wep:Clip1() + wep.RegularClipSize * 0.5)))
                ent.ArcCW_StreetJustice = CurTime() + 10
                ent:EmitSound("ambient/alarms/warningbell1.wav", 90, 110)
            elseif ent:IsNPC() and IsValid(otherWep) then
                ent:GetActiveWeapon():SetClip1(0)
                wep:SetClip1(math.min(wep:GetCapacity() + wep:GetChamberSize(), math.ceil(wep:Clip1() + wep.RegularClipSize * 0.25)))
                ent.ArcCW_StreetJustice = CurTime() + 3
            end
        end
        if ent:IsNPC() or (ent:IsNextBot() and ent:GetPhysicsObject():IsValid()) then
            dir.z = 0.15
            dir = dir:GetNormalized()
            ent:SetVelocity( ent:GetVelocity() + dir * 2000 * (ent:IsOnGround() and 1 or 0.1) )
        elseif ent:IsPlayer() then
            dir.z = 0.75
            ent:SetVelocity( dir * (ent:IsOnGround() and 5 or 3) * 50 )
            local punch = AngleRand(-30, 30)
            punch.r = 0
            ent:SetEyeAngles(ent:EyeAngles() + punch)
            ent:ViewPunch(punch * 2)
        elseif IsValid(ent) and ent:GetPhysicsObject():IsValid() then
            dir.z = 0.25
            dir = dir:GetNormalized()
            ent:GetPhysicsObject():AddVelocity(dir * 90 * 4)
        end
    end
end