att.PrintName = "(CS+) Sabot Slug"
att.Icon = Material("entities/acwatt_ammo_sabot.png")
att.Description = "Shell containing a subcaliber projectile with discarding sabot. This enables superior muzzle velocity on the armor-piercing projectile, allowing it to deal more damage at range and penetrate a lot of armor. However, it is not as powerful as a full-caliber slug round."
att.Desc_Pros = {"+Due to GSO not having support for Reduced Mags,", "you get to use this at max capacity!"
}
att.Desc_Cons = { "-Reload speed penalty to compensate"
}
att.AutoStats = true
att.Slot = "go_ammo"
att.InvAtt = "ammo_sabot"

att.Override_Num = 1

att.Mult_ShootPitch = 1.2
att.Mult_Damage = 0.7
att.Mult_DamageMin = 1.8
att.Mult_Penetration = 5
att.Mult_AccuracyMOA = 0.15
att.Mult_Range = 2
att.Mult_ReloadTime = 1.5

att.Hook_Compatible = function(wep)
    if !wep:GetIsShotgun() then return false end
end