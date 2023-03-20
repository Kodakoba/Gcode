att.PrintName = "20-Round 4.6mm MP7 Mag"
att.Icon = Material("entities/acwatt_go_mp7_mag_20.png", "mips smooth")
att.Description = "Small magazine with lighter load. Improves handling."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "con.magcap"
}
att.SortOrder = 20
att.AutoStats = true
att.Slot = "go_mp7_mag"

att.Mult_MoveSpeed = 1.1
att.Mult_SightTime = 0.85
att.Override_ClipSize = 20
att.Mult_ReloadTime = 0.9

att.Hook_SelectReloadAnimation = function(wep, anim)
    if anim == "reload" then
        return "reload_smallmag"
    elseif anim == "reload_empty" then
        return "reload_smallmag_empty"
    end
end