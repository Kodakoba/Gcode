att.PrintName = "(CSExtras) Z-Choke"
att.Icon = Material("entities/acwatt_muzz_zchoke.png", "smooth mips")
att.Description = "Curious shotgun choke producing a Z-shaped pattern."
att.Desc_Pros = {
    "+ Zorro reference?",
}
att.Desc_Cons = {
    "- Or is it something else..."
}
att.AutoStats = false
att.Slot = "muzzle"
att.InvAtt = "muzz_choke"

att.SortOrder = 20
att.Mult_AccuracyMOA = 0.2

att.Override_ShotgunSpreadPattern = true
att.Override_ShotgunSpreadDispersion = false

att.Hook_ShotgunSpreadOffset = function(wep, data)
    local rand = math.random()
    if rand <= 0.333 then
        data.ang = Angle(3, math.Rand(-3, 3), 0)
    elseif rand <= 0.666 then
        data.ang = Angle(-3, math.Rand(-3, 3), 0)
    else
        local sqrt3 = 1.73205
        local line = math.Rand(-sqrt3, sqrt3)
        data.ang = Angle(line, line, 0)
    end

    return data
end

att.Hook_Compatible = function(wep)
    if !wep:GetIsShotgun() then return false end
end