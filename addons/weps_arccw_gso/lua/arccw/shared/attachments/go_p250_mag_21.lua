att.PrintName = "21-Round .357 P250"
att.Icon = Material("entities/acwatt_go_p250_mag_21.png", "mips smooth")
att.Description = "Extended magazine for the P250 pistol. Medium length balances increased capacity with increased weight."
att.Desc_Pros = {
    "pro.magcap"
}
att.Desc_Cons = {
}
att.SortOrder = 21
att.AutoStats = true
att.Slot = "go_p250_mag"

att.Override_ClipSize_Priority = 2
att.Override_ClipSize = 21

att.Mult_MoveSpeed = 0.99
att.Mult_SightTime = 1.05
att.Mult_ReloadTime = 1.05

att.Hook_SelectReloadAnimation = function(wep, anim)
    if anim == "reload" then
        return "reload_long"
    elseif anim == "reload_empty" then
        return "reload_long_empty"
    end
end