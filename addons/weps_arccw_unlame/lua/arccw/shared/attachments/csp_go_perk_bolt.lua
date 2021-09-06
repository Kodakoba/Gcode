att.PrintName = "(GSO) Deft Hands"
att.Icon = Material("entities/acwatt_go_perk_bolt.png", "mips smooth")
att.Description = "Cycling the weapon is 25% faster."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "perk"
att.InvAtt = "go_perk_bolt"

att.Mult_CycleTime = 0.75

att.Hook_Compatible = function(wep)
    if !wep.ManualAction then return false end
end