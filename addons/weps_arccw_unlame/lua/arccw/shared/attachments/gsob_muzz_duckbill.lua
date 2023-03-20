att.PrintName = "(CS+) Duckbill Choke"
att.Icon = Material("entities/acwatt_muzz_duckbill.png")
att.Description = "Shotgun choke which produces a wide horizontal dispersion pattern. Potentially good for crowd control."
att.Desc_Pros = {
    "pro.muzz_duckbill",
}
att.Desc_Cons = {
    "con.muzz_duckbill"
}
att.AutoStats = false
att.Slot = "muzzle"
att.InvAtt = "muzz_duckbill"
att.SortOrder = 20

att.Mult_AccuracyMOA = 0.25

att.Override_ShotgunSpreadPattern = true
att.Override_ShotgunSpreadDispersion = false

att.Hook_ShotgunSpreadOffset = function(wep, data)
    data.ang = Angle(0, math.Rand(-5, 5), 0)

    return data
end

att.Hook_Compatible = function(wep)
    if !wep:GetIsShotgun() then return false end
end