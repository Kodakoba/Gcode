att.PrintName = "100-Round 5.56mm Negev"
att.Icon = Material("entities/acwatt_go_negev_belt_100.png", "mips smooth")
att.Description = "5.56mm conversion for the Negev LMG. Improves fire rate and capacity."
att.SortOrder = 100
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "go_negev_belt"

att.Override_ClipSize = 100

att.Mult_Range = 0.75
att.Mult_Penetration = 0.75
att.Mult_Recoil = 0.65
att.Mult_RPM = 1.45
att.Mult_Damage = 0.9
att.Mult_DamageMin = 0.9

att.Override_Ammo = "smg1"

att.Override_Trivia_Calibre = "5.56x45mm NATO"

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == "arccw_go/negev/negev_04.wav" then return "arccw_go/negev/negev_clean_01.wav" end
end

att.Override_BulletBones = {
    [1] = "v_weapon.bullet_18",
    [2] = "v_weapon.bullet_17",
    [3] = "v_weapon.bullet_16",
    [4] = "v_weapon.bullet_15",
    [5] = "v_weapon.bullet_14",
    [6] = "v_weapon.bullet_13",
    [7] = "v_weapon.bullet_12",
    [8] = "v_weapon.bullet_11",
    [9] = "v_weapon.bullet_10",
    [10] = "v_weapon.bullet_09",
    [11] = "v_weapon.bullet_08",
    [12] = "v_weapon.bullet_07",
    [13] = "v_weapon.bullet_06",
    [14] = "v_weapon.bullet_05",
    [15] = "v_weapon.bullet_04",
    [16] = "v_weapon.bullet_03",
    [17] = "v_weapon.bullet_02",
    [18] = "v_weapon.bullet_01",
    [19] = "v_weapon.bullet_00",
}