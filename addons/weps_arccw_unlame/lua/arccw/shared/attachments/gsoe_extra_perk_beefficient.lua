att.PrintName = "(CSExtras) Be Efficient"
att.Icon = Material("entities/acwatt_perk_beefficient.png", "smooth mips")
att.Description = "Headshots have a chance to load one bullet from your reserve into your chamber.\nRemember to also be polite, and have a plan to kill everyone you meet."
att.Desc_Pros = {
    "Load round on headshot"
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
    "100% chance to load on player hit",
    "75% chance to load on NPC hit"
}
att.Slot = "go_perk"
att.InvAtt = "perk_beefficient"

att.NotForNPC = true

att.AutoStats = true

att.Hook_Compatible = function(wep)
    if wep.Num ~= 1 or not wep.ManualAction then return false end
end

att.Hook_BulletHit = function(wep, data)
    if CLIENT then return end

    if data.tr.Entity and data.tr.HitGroup == HITGROUP_HEAD and (data.tr.Entity:IsPlayer() or math.random() <= 0.75) then
        if wep:GetOwner():IsPlayer() then
            wep:GetOwner():RemoveAmmo(1, wep.Primary.Ammo)
        end
        wep:SetClip1(wep:Clip1() + 1)
    end
end