att.PrintName = "30-Round 7.62mm SCAR"
att.Icon = Material("entities/acwatt_go_scar_mag_30.png", "mips smooth")
att.Description = "Extended magazine improves capacity at the cost of handling."
att.Desc_Pros = {
    "pro.magcap"
}
att.Desc_Cons = {
}
att.SortOrder = 30
att.AutoStats = true
att.Slot = "go_scar_mag"

att.Mult_MoveSpeed = 0.95
att.Mult_SightTime = 1.1
att.Override_ClipSize = 30
att.Mult_ReloadTime = 1.1

att.Hook_SelectReloadAnimation = function(wep, anim)
    if anim == "reload" then
        return "reload_longmag"
    elseif anim == "reload_empty" then
        return "reload_longmag_empty"
    end
end