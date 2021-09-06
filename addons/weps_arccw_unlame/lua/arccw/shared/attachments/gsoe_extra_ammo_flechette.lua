att.PrintName = "(CSExtras) Flechette"
att.Icon = Material("entities/acwatt_ammo_flechette.png", "smooth mips")
att.Description = "Thin, sharp pointed projectiles provide better performance over range and superior penetration."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Slot = "go_ammo"
att.InvAtt = "ammo_flechette"

att.AutoStats = true

att.Mult_Damage = 0.8
att.Mult_DamageMin = 1.4
att.Mult_Range = 1.5
att.Mult_AccuracyMOA = 0.6
att.Mult_MoveDispersion = 1.3
att.Mult_Penetration = 8

att.Hook_Compatible = function(wep)
    if !wep:GetIsShotgun() then return false end
end