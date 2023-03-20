att.PrintName = "5-Round .50 Beowulf"
att.Icon = Material("entities/acwatt_go_m4_mag_20.png", "mips smooth")
att.Description = "Magazine that converts weapon to .50 Beowulf ammunition. Heavier bullets deal more damage but are not as good at long range. Small mags are lighter weight."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "con.magcap"
}
att.SortOrder = 5
att.AutoStats = true
att.Slot = "go_m4_mag"

att.InvAtt = "go_m4_mag_20"

att.Mult_MoveSpeed = 1.1
att.Mult_SightTime = 0.85
att.Mult_ReloadTime = 0.9

att.Override_ClipSize = 5
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

att.ActivateElements = {"go_m4_mag_20"}