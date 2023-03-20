att.PrintName = "9-Round .50 Deagle"
att.Icon = Material("entities/acwatt_go_deagle_mag_9.png", "mips smooth")
att.Description = "Extended magazine for the Desert Eagle pistol. Heavy, but may be worth the extra ammo."
att.Desc_Pros = {
    "pro.magcap"
}
att.Desc_Cons = {
}
att.SortOrder = 9
att.AutoStats = true
att.Slot = "go_deagle_mag"

att.Override_ClipSize = 9

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