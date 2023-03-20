att.PrintName = "(CS+) Dragon's Breath"
att.Icon = Material("entities/acwatt_ammo_dragon.png")
att.Description = "Incendiary load shotgun shells deal extra damage at both close and long range, as well as igniting targets within its effective range. However, a reduced magazine is equipped."
att.Desc_Pros = {
    "pro.ignite", "+Due to GSO not having support for Reduced Mags,", "you get to use this at max capacity!"
}
att.Desc_Cons = { "-Reload speed penalty to compensate"
}
att.AutoStats = true
att.Slot = "go_ammo"
att.InvAtt = "ammo_dragon"

att.Mult_PrecisionMOA = 2
att.Mult_ShootPitch = 0.85
att.Mult_Damage = 1.25
att.Mult_DamageMin = 1.25
att.Mult_ReloadTime = 1.5

att.Override_DamageType = DMG_BURN

att.Hook_Compatible = function(wep)
    if !wep:GetIsShotgun() then return false end
end