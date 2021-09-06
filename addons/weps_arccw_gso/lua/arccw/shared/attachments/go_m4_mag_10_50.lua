att.PrintName = "10-Round .50 Beowulf"
att.Icon = Material("entities/acwatt_go_m4_mag_10_50.png", "mips smooth")
att.Description = "Magazine that converts weapon to .50 Beowulf ammunition. Heavier bullets deal more damage but are not as good at long range. They also kick much more, and not as many can be fit into a magazine."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.SortOrder = 10
att.AutoStats = true
att.Slot = "go_m4_mag"

att.Override_ClipSize = 10
att.Mult_Damage = 1.5
att.Mult_DamageMin = 1.15
att.Mult_Range = 0.45
att.Mult_Recoil = 3
att.Mult_ShootPitch = 0.85

att.Override_Ammo = "357"

att.Override_Trivia_Calibre = ".50 Beowulf"

att.Hook_GetShootSound = function(wep, ss)
    if ss == "arccw_go/m4a1/m4a1_02.wav" or ss == "arccw_go/m4a1/m4a1_03.wav" then
        return "arccw_go/m4a1/m4a1-1-single.wav"
    elseif ss == "arccw_go/m4a1/m4a1_silencer_01.wav" then
        return "arccw_go/usp/usp_02.wav"
    end
end