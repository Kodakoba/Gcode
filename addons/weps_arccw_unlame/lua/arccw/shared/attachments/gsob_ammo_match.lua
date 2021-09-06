att.PrintName = "(CS+) Match Ammo"
att.Icon = Material("entities/acwatt_ammo_match.png")
att.Description = "High-quality competition-grade ammunition. Consistent power loads allow for greater accuracy. Custom-tooled bullets cut rifling more smoothly and keep energy for longer. Such bullets cannot be used in bulk."
att.Desc_Pros = {"+Due to GSO not having support for Reduced Mags,", "you get to use this at max capacity!"
}
att.Desc_Cons = { "-Reload speed penalty to compensate"
}
att.AutoStats = true
att.Slot = "go_ammo"
att.InvAtt = "ammo_match"

att.Mult_DamageMin = 1.15
att.Mult_SightTime = 0.9
att.Mult_Precision = 0.25
att.Mult_Recoil = 0.85
att.Mult_ReloadTime = 1.5

att.Hook_Compatible = function(wep)
    if wep:GetIsShotgun() then return false end
end