att.PrintName = "40-Round 7.62mm Poly"
att.Icon = Material("entities/acwatt_go_ak_mag_40.png", "mips smooth")
att.Description = "7.62mm conversion turning rifle into Galil ACE 34. Superior range and damage at the cost of recoil. Large magazine has inferior handling."
att.Desc_Pros = {
    "pro.magcap"
}
att.Desc_Cons = {
}
att.SortOrder = 40
att.AutoStats = true
att.Slot = "go_ace_mag"

att.InvAtt = "go_ak_mag_40"

att.Override_Ammo = "ar2"

att.Override_ClipSize = 40
att.Mult_Range = 1.25
att.Mult_Damage = 1.1
att.Mult_DamageMin = 1.1
att.Mult_Recoil = 1.5
att.Mult_RPM = 0.75

att.Mult_MoveSpeed = 0.95
att.Mult_SightTime = 1.1
att.Mult_ReloadTime = 1.1

att.Override_Trivia_Calibre = "7.62x39mm Soviet"

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == "arccw_go/galilar/galil_03.wav" then return "arccw_go/galilar/galil_02.wav" end
    if fsound == "arccw_go/galilar/galil_04.wav" then return "arccw_go/galilar/galil_02.wav" end
end