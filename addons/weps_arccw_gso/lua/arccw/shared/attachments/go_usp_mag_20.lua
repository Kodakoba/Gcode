att.PrintName = "20-Round .45 USP"
att.Icon = Material("entities/acwatt_go_usp_mag_20.png", "mips smooth")
att.Description = "Extended magazine for the USP-45 pistol. Medium length balances increased capacity with increased weight."
att.Desc_Pros = {
    "pro.magcap"
}
att.Desc_Cons = {
}
att.SortOrder = 20
att.AutoStats = true
att.Slot = "go_usp_mag"

att.Override_ClipSize = 20

att.Mult_MoveSpeed = 0.99
att.Mult_SightTime = 1.05
att.Mult_ReloadTime = 1.05

att.Hook_SelectReloadAnimation = function(wep, anim)
    if anim == "reload" then
        return "reload_med"
    elseif anim == "reload_empty" then
        return "reload_med_empty"
    end
end