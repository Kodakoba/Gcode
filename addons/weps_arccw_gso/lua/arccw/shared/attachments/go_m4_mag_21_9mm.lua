att.PrintName = "21-Round 9mm Colt"
att.Icon = Material("entities/acwatt_go_m4_mag_21_9mm.png", "mips smooth")
att.Description = "9mm magazine conversion, turning the rifle into a submachine gun. Lighter magazines improve handling."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "con.magcap"
}
att.SortOrder = 21
att.AutoStats = true
att.Slot = "go_m4_mag"

att.Mult_MoveSpeed = 1.1
att.Mult_ReloadTime = 0.9

att.Mult_Range = 0.5
att.Mult_Penetration = 0.5
att.Mult_Recoil = 0.9
att.Mult_SightTime = 0.7
att.Mult_RPM = 1.5
att.Mult_AccuracyMOA = 2
att.Override_ClipSize = 21
att.Mult_Damage = 0.75
att.Mult_DamageMin = 0.75

att.Override_Ammo = "pistol"

att.Override_ShellModel = "models/shells/shell_9mm.mdl"

att.Override_Trivia_Class = "Submachine Gun"
att.Override_Trivia_Calibre = "9x19mm Parabellum"

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == "arccw_go/m4a1/m4a1_03.wav" then return "arccw_go/bizon/bizon_02.wav" end
    if fsound == "arccw_go/m4a1/m4a1_01.wav" then return "arccw_go/bizon/bizon_02.wav" end
    if fsound == "arccw_go/m4a1/m4a1_02.wav" then return "arccw_go/bizon/bizon_02.wav" end
    if fsound == "arccw_go/m4a1/m4a1_04.wav" then return "arccw_go/bizon/bizon_02.wav" end
    if fsound == "arccw_go/m4a1/m4a1_silencer_01.wav" then return "arccw_go/mp5/mp5_01.wav" end
end

att.Hook_SelectReloadAnimation = function(wep, anim)
    if anim == "reload" then
        return "reload_smallmag"
    elseif anim == "reload_empty" then
        return "reload_smallmag_empty"
    end
end