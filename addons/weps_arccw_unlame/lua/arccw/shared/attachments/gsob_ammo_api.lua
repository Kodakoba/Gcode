att.PrintName = "(CS+) Fire and Brimstone"
att.Icon = Material("entities/acwatt_ammo_api.png")
att.Description = "Load weapon with armor-piercing incendiary ammo, which deals extra damage, ignites targets within its effective range, and has superior penetration. However, due to reliability issues, reduced-capacity magazines are used."
att.Desc_Pros = {
    "pro.ignite", "+Due to GSO not having support for Reduced Mags,", "you get to use this at max capacity!"
}
att.Desc_Cons = { "-Reload speed penalty to compensate"
}
att.AutoStats = true
att.Slot = "go_ammo"
att.InvAtt = "ammo_api"

att.Mult_Damage = 1.1
att.Mult_DamageMin = 1.2
att.Mult_Penetration = 2
att.Mult_Recoil = 1.15
att.Mult_ReloadTime = 1.5

att.Override_DamageType = DMG_BURN

att.Hook_Compatible = function(wep)
    if wep:GetIsShotgun() then return false end
end