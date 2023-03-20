att.PrintName = "Felin Conversion"
att.Icon = Material("entities/arccw_fml_fas1_felin.png")
att.Description = "Conversion allowing for a rapid three-round burst in rapid succession."
att.Desc_Pros = {
    "+3 Round Burst",
}

att.SortOrder = 1000

att.Desc_Cons = {
    "-Burst delay",
}

att.Slot = {"fas1_felin"}

att.AutoStats = true

att.ActivateElements = {"felin_cum"}  

att.Override_Firemodes = {
    {
        Mode = -3,
        Mult_RPM = 1.85,
        Mult_AccuracyMOA = 1.275,
        RunawayBurst = true,
        PostBurstDelay = 0.175
    },
    {
        Mode = 1,
    },	
    {
        Mode = 0
    }
}

att.Mult_Recoil = 0.925
att.Mult_SightTime = 1.15

att.Hook_SelectReloadAnimation = function(wep, anim)
    if anim == "reload_empty" then
        return "reload_empty_felin"
    elseif anim == "reload_empty_soh" then
        return "reload_empty_soh_felin"
    end
end