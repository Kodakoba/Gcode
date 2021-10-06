att.PrintName = "24-Round 9mm P2000"
att.Icon = Material("entities/acwatt_go_p2000_mag_24.png", "mips smooth")
att.Description = "Extended magazine for the P2000 pistol. Medium length balances increased capacity with increased weight."
att.Desc_Pros = {
    "pro.magcap"
}
att.Desc_Cons = {
}
att.SortOrder = 24
att.AutoStats = true
att.Slot = "go_p2000_mag"

att.Override_ClipSize = 24

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