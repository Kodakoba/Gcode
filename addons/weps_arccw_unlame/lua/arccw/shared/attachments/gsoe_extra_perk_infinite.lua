att.PrintName = "(CSExtras) Infinity"
att.Icon = Material("entities/acwatt_perk_infinite.png", "smooth mips")
att.Description = "An attempt to replicate the infinity-shaped drum magazine used by the mother of special forces. Each shot will drain a round from reserves with a 60% chance of replenishing the magazine. The heavy weight of the system impacts performance severely."
att.Desc_Pros = {
    "+ Chance to refill magazine"
}
att.Desc_Cons = {
}
att.Slot = "go_perk"
att.InvAtt = "perk_infinite"
att.NotForNPC = true

att.AutoStats = true

att.Mult_SightTime = 1.25
att.Mult_MoveSpeed = 0.85
att.Mult_SightedMoveSpeed = 0.7
att.Mult_MoveDispersion = 1.3
att.Mult_ReloadTime = 1.3

att.Hook_Compatible = function(wep)
    if wep.Primary.ClipSize <= 6 or wep.ShotgunReload then return false end
end

att.Hook_FireBullets = function(wep, data)
    if CLIENT then return end
    if not wep:GetOwner():IsPlayer() then wep:SetClip1(wep:Clip1() + 1) return end

    if wep:GetOwner():GetAmmoCount(wep.Primary.Ammo) <= 0 then return end
    wep:GetOwner():RemoveAmmo(1, wep.Primary.Ammo)

    if math.random() <= 0.6 then
        wep:SetClip1(wep:Clip1() + 1)
    end
end