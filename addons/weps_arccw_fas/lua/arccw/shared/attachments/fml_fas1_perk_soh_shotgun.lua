att.PrintName = "Sleight Of Hand"
att.Icon = Material("entities/arccw_fml_fas1_slam.png")
att.Description = "Improves pumping and reloading speed."
att.Desc_Pros = {
    "+ Faster Pumping",
}
att.Desc_Cons = {
}
att.Slot = "perk_fas_shotgun"

att.InvAtt = "perk_fastreload"

att.Mult_DrawTime = 0.8
att.Mult_SightTime = 0.95
att.Mult_ReloadTime = 0.9
att.Mult_RPM = 1.2

att.Hook_SelectCycleAnimation = function(wep, anim)
    if anim == "cycle" then
        return "slam"
    end
end

att.AutoStats = true
