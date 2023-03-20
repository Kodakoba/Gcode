att.PrintName = "(CSExtras) 8-Choke"
att.Icon = Material("entities/acwatt_muzz_8choke.png", "smooth mips")
att.Description = "Curious shotgun choke producing an 8-shaped pattern."
att.Desc_Pros = {
    "+ 8-shaped pattern",
}
att.Desc_Cons = {
    "- Numbers are for nerds"
}
att.AutoStats = false
att.Slot = "muzzle"
att.InvAtt = "muzz_choke"

att.SortOrder = 21
att.Mult_AccuracyMOA = 0.2

att.Override_ShotgunSpreadPattern = true
att.Override_ShotgunSpreadDispersion = false

att.Hook_ShotgunSpreadOffset = function(wep, data)

    local a1 = Angle(0, math.Rand(-360, 360), 0)
    local v1 = a1:Forward() * 1.8

    if math.random(0, 1) >= 0.5 then
        v1.x = v1.x + 2
    else
        v1.x = v1.x - 2
    end
    data.ang = Angle(v1.x, v1.y, 0)

    return data
end

att.Hook_Compatible = function(wep)
    if !wep:GetIsShotgun() then return false end
end