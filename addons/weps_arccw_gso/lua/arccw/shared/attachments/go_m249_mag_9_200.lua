att.PrintName = "200-Round 9mm Belt"
att.Icon = Material("entities/acwatt_go_m249_mag_9_200.png", "mips smooth")
att.Description = "9mm conversion, turning the LMG into a submachine gun with a massive capacity, similar to the SMG 08/18."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.SortOrder = 200
att.AutoStats = true
att.Slot = "go_m249_mag"

att.Mult_Range = 0.5
att.Mult_Penetration = 0.5
att.Mult_Recoil = 0.9
att.Mult_RPM = 1.5
att.Mult_AccuracyMOA = 2
att.Override_ClipSize = 200
att.Mult_Damage = 0.75
att.Mult_DamageMin = 0.75
att.Mult_HeatCapacity = 2

att.Override_Ammo = "pistol"

att.Override_ShellModel = "models/shells/shell_9mm.mdl"

att.Override_Trivia_Class = "Pistol Machine Gun"
att.Override_Trivia_Calibre = "9x19mm Parabellum"

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == "arccw_go/m249/m249-1.wav" then return "arccw_go/bizon/bizon_02.wav" end
    if fsound == "arccw_go/m4a1/m4a1_silencer_01.wav" then return "arccw_go/mp5/mp5_01.wav" end
end