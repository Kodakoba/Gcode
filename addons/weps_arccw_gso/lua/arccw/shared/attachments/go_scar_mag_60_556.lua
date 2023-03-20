att.PrintName = "50-Round 5.56mm Quad"
att.Icon = Material("entities/acwatt_go_556_ammo_60round.png", "mips smooth")
att.Description = "5.56mm conversion makes gun effectively into an HK33 pattern, improving fire rate and recoil at the cost of damage. Quad stack magazine improves capacity."
att.Desc_Pros = {
    "pro.magcap"
}
att.Desc_Cons = {
}
att.SortOrder = 50
att.AutoStats = true
att.Slot = "go_scar_mag"

att.Override_Ammo = "smg1"

att.InvAtt = "go_556_ammo_60round"

att.Override_Ammo = "smg1"

att.Override_ClipSize = 50
att.Mult_Damage = 0.6
att.Mult_DamageMin = 0.9
att.Mult_Range = 0.8
att.Mult_Recoil = 0.35

att.Mult_MoveSpeed = 0.95
att.Mult_SightTime = 1.15
att.Mult_ReloadTime = 1.25

att.Override_Trivia_Class = "Assault Rifle"
att.Override_Trivia_Calibre = "5.56x45mm NATO"

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == "arccw_go/scar20/scar20_02.wav" then return "arccw_go/m4a1/m4a1_us_04.wav" end
    if fsound == "arccw_go/scar20/scar20_01.wav" then return "arccw_go/m4a1/m4a1_us_02.wav" end
end

att.Hook_SelectReloadAnimation = function(wep, anim)
    if anim == "reload" then
        return "reload_longmag"
    elseif anim == "reload_empty" then
        return "reload_longmag_empty"
    end
end