att.PrintName = "(CS+) Total Metal Jacket"
att.Icon = Material("entities/acwatt_ammo_tmj.png")
att.Description = "Bullets with a total copper coating which keep energy better at long range, improving damage at distance but overpenetrating targets which are too close."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "go_ammo"
att.InvAtt = "ammo_tmj"

att.Mult_Damage = 0.9
att.Mult_DamageMin = 1.2
att.Mult_Penetration = 2

att.Hook_Compatible = function(wep)
    if wep:GetIsShotgun() then return false end
end