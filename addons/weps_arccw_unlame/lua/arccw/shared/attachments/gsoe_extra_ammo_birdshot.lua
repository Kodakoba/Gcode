att.PrintName = "(CSExtras) Birdshot"
att.Icon = Material("entities/acwatt_ammo_birdshot.png", "mips")
att.Description = "Small projectiles loaded in large quantities intended for hunting small game. Has considerably less recoil but is less lethal."
att.Desc_Pros = {
    "+4 pellets per shot",
}
att.Desc_Cons = {
}
att.Slot = "go_ammo"
att.InvAtt = "ammo_birdshot"

att.AutoStats = true

att.Add_Num = 4
att.Mult_AccuracyMOA = 1.3
att.Mult_Recoil = 0.5
att.Mult_Damage = 0.9
att.Mult_DamageMin = 0.65

att.Hook_Compatible = function(wep)
    if !wep:GetIsShotgun() then return false end
end