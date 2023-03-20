att.PrintName = "31-Round 9mm G18"
att.Icon = Material("entities/acwatt_go_glock_mag_28.png", "mips smooth")
att.Description = "Extended magazine for the Glock pistol. Heavy, but may be worth the extra ammo."
att.Desc_Pros = {
    "pro.magcap"
}
att.Desc_Cons = {
}
att.SortOrder = 31
att.AutoStats = true
att.Slot = "go_glock_mag"

att.Override_ClipSize_Priority = 2
att.Override_ClipSize = 31

att.Mult_MoveSpeed = 0.95
att.Mult_SightTime = 1.15
att.Mult_ReloadTime = 1.25

att.Hook_SelectReloadAnimation = function(wep, anim)
    if anim == "reload" then
        return "reload_long"
    elseif anim == "reload_empty" then
        return "reload_long_empty"
    end
end