att.PrintName = "MP5K Conversion"
att.Icon = Material("entities/arccw_fml_fas1_mp5k.png")
att.Description = "Conversion allowing for an extra compact MP5."

att.Slot = "fas1_mp5k"

att.SortOrder = 1000

att.AutoStats = true

att.MountPositionOverride = 0

att.ModelOffset = Vector(2, 0, 0)

att.LHIK = true

att.Model = "models/weapons/arccw/fml_atts/fas1_grip_mp5k.mdl"

att.ActivateElements = {"kurz_cum"}  

att.Mult_Recoil = 0.775
att.Mult_SightTime = 0.9

att.Mult_Damage = 0.95
att.Mult_DamageMin = 0.8

att.Mult_AccuracyMOA = 1.1
att.Mult_HipDispersion = 0.8

att.Hook_SelectReloadAnimation = function(wep, anim)
    if anim == "reload_empty" then
        return "reload_kurz_empty"
    elseif anim == "reload_empty_soh" then
        return "reload_empty_kurz_soh"
    elseif anim == "reload" then
        return "reload_kurz"	
    elseif anim == "reload_soh" then
        return "reload_kurz_soh"			
    end
end