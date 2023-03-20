att.PrintName = "Extended Mags"
att.Icon = Material("entities/arccw_fml_fas1_exmag.png")
att.Description = "Did you really expect anything else ?"
att.Desc_Pros = {
    "+More bullets per mag",
}
att.Desc_Cons = {	
}

att.AutoStats = true

att.Slot = "perk_fas_extended"
att.MagExtender = true

att.Mult_SightTime = 1.175
att.Mult_AccuracyMOA = 1.125
att.Mult_HipDispersion = 1.125
att.Mult_SpeedMult = 0.85
att.Mult_SightedSpeedMult = 0.8
att.Mult_DrawTime = 1.45

att.ActivateElements = {"drum_mag"}

att.Hook_TranslateAnimation = function(wep, anim)
    if anim == "reload_empty" then
        return "reload_empty_drum"
    elseif anim == "reload" then
        return "reload_drum"
    end
end