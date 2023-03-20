att.PrintName = "32-Round 9mm Mag"
att.Icon = Material("entities/acwatt_go_aug_ammo_9mm.png", "mips smooth")
att.Description = "Conversion that makes the AUG into a 9mm submachine gun. Reduces weight and improves fire rate, at the cost of range."
att.SortOrder = 32
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "go_aug_9mm"

att.Mult_Range = 0.5
att.Mult_Penetration = 0.5
att.Mult_Recoil = 0.75
att.Mult_SightTime = 0.8
att.Mult_RPM = 1.1
att.Mult_AccuracyMOA = 2
att.Override_ClipSize = 32

att.Override_Ammo = "pistol"

att.Override_ShellModel = "models/shells/shell_9mm.mdl"

att.Override_Trivia_Class = "Submachine Gun"
att.Override_Trivia_Calibre = "9x19mm Parabellum"

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == "arccw_go/aug/aug_01.wav" then return "arccw_go/bizon/bizon_02.wav" end
    if fsound == "arccw_go/aug/aug_03.wav" then return "arccw_go/bizon/bizon_01.wav" end
    if fsound == "arccw_go/m4a1/m4a1_silencer_01.wav" then return "arccw_go/mp5/mp5_01.wav" end
end