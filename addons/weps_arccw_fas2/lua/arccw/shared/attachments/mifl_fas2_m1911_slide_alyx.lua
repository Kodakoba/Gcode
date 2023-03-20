att.PrintName = "Overlord Slide"
att.Icon = Material("entities/arccw_mifl_fas2_m1911_slide_alyx.png", "mips smooth")
att.Description = "Custom-made burst-fire mechanism and recoil dampener using Combine dark matter technology. Recoil is greatly reduced until the seventh shot."
att.SortOrder = 7
att.AutoStats = true
att.Slot = "mifl_fas2_m1911_slide"
att.Mult_SightTime = 1.2
att.Mult_DrawTime = 1.2
att.Add_BarrelLength = 4
att.Mult_Recoil = 0.7
att.Mult_RPM = 2.75
att.Mult_ShootPitch = 0.95
att.Desc_Pros = {
    "pro.fas2.saf"
}
att.Desc_Cons = {
	"con.fas2.saf"
}
att.Override_Firemodes = {
    {
        Mode = -7,
        PostBurstDelay = 0.25,
        CustomBars = "----!"
    },
    {
        Mode = 1
    },
    {
        Mode = 0
    }
}

att.Hook_FiremodeBars = function(wep)
    if wep:GetCurrentFiremode().Mode == -7 then
        local gbc = wep:GetBurstCount()
        local ourreturn = ""
        ourreturn = ourreturn .. ((gbc >= 1 and "-") or "_")
        ourreturn = ourreturn .. ((gbc >= 2 and "-") or "_")
        ourreturn = ourreturn .. ((gbc >= 3 and "-") or "_")
        ourreturn = ourreturn .. ((gbc >= 4 and "-") or "_")
        ourreturn = ourreturn .. ((gbc >= 5 and "-") or "_")
        ourreturn = ourreturn .. ((gbc >= 6 and "-") or "_")

        if gbc >= 7 then
            ourreturn = "!!!!!!!"
        else
            ourreturn = ourreturn .. "!"
        end

        return ourreturn
    end
end

att.Hook_ModifyRecoil = function(wep)
    local thing

    if wep:GetBurstCount() >= wep:GetBurstLength() then
        thing = wep:GetBurstCount()
    else
        thing = 0.85
    end

    return {
        Recoil = thing,
        RecoilSide = thing * 0.8,
        VisualRecoilMult = 0.75
    }
end