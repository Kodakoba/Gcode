att.PrintName = "(CSExtras) F-Choke"
att.Icon = Material("entities/acwatt_muzz_fchoke.png", "smooth mips")
att.Description = "Curious shotgun choke producing a F-shaped pattern."
att.Desc_Pros = {
    "+ No need to type F in the chat",
}
att.Desc_Cons = {
    "- The F might be for you"
}
att.AutoStats = false
att.Slot = "muzzle"
att.InvAtt = "muzz_choke"

att.Mult_AccuracyMOA = 0.2

att.Override_ShotgunSpreadPattern = true
att.Override_ShotgunSpreadDispersion = false

att.Hook_ShotgunSpreadOffset = function(wep, data)
    local rand = math.random()
    if rand <= 0.4 then
        data.ang = Angle(math.Rand(-3, 3), 2, 0)
    elseif rand <= 0.7 then
        data.ang = Angle(-3, math.Rand(-1, 2), 0)
    else
        data.ang = Angle(0, math.Rand(-1, 2), 0)
    end

    return data
end

att.Hook_Compatible = function(wep)
    if !wep:GetIsShotgun() then return false end
end