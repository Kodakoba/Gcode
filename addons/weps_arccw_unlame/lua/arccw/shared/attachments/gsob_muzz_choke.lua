att.PrintName = "(CS+) Tight Choke"
att.Icon = Material("entities/acwatt_muzz_choke.png")
att.Description = "Shotgun choke which reduces pellet spread, at the cost of directly worsening clump dispersion while hip firing. Also increases felt recoil."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "muzzle"
att.InvAtt = "muzz_choke"

att.SortOrder = 30

att.Mult_Recoil = 1.35
att.Mult_HipDispersion = 1.5
att.Mult_AccuracyMOA = 0.6

att.Hook_Compatible = function(wep)
    if !wep:GetIsShotgun() then return false end
end