att.PrintName = "(CS+) Deer Slug"
att.Icon = Material("entities/acwatt_ammo_slug.png")
att.Description = "Shell containing a single heavy lead slug. More accurate, and more effective at range, but at the cost of being only a single projectile."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "con.projectilecount"
}
att.AutoStats = true
att.Slot = "go_ammo"
att.InvAtt = "ammo_slug"

att.Override_Num = 1

att.Mult_ShootPitch = 1.15
att.Mult_Damage = 0.8
att.Mult_DamageMin = 2
att.Mult_Penetration = 1.5
att.Mult_AccuracyMOA = 0.35

att.Hook_Compatible = function(wep)
    if !wep:GetIsShotgun() then return false end
end