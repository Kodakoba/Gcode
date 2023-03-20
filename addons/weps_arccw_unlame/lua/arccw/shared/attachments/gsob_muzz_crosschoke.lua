att.PrintName = "(CS+) Cross Choke"
att.Icon = Material("entities/acwatt_muzz_crosschoke.png")
att.Description = "Shotgun choke producing a cross-shaped pattern."
att.Desc_Pros = {
    "pro.muzz_crosschoke",
}
att.Desc_Cons = {
    "con.situational"
}
att.AutoStats = false
att.Slot = "muzzle"
att.InvAtt = "muzz_crosschoke"
att.SortOrder = 20

att.Mult_AccuracyMOA = 0.2

att.Override_ShotgunSpreadPattern = true
att.Override_ShotgunSpreadDispersion = false

att.Hook_ShotgunSpreadOffset = function(wep, data)
    if math.random(0, 1) >= 0.5 then
        data.ang = Angle(0, math.Rand(-3, 3), 0)
    else
        data.ang = Angle(math.Rand(-3, 3), 0, 0)
    end

    return data
end

att.Hook_Compatible = function(wep)
    if !wep:GetIsShotgun() then return false end
end