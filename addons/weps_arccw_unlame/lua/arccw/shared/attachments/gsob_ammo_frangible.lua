att.PrintName = "(CS+) Hollow Point"
att.Icon = Material("entities/acwatt_ammo_frangible.png")
att.Description = "Bullets with a frangible hollow tip penetrating far less, but have better stopping power up-close."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "go_ammo"
att.InvAtt = "ammo_frangible"
att.Mult_Damage = 1.1
att.Mult_DamageMin = 0.6
att.Mult_Penetration = 0.25

att.Hook_Compatible = function(wep)
    if wep:GetIsShotgun() then return false end
end