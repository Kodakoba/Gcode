att.PrintName = "(CSExtras) Greased Bolt"
att.Icon = Material("entities/acwatt_perk_fastbolt.png", "smooth mips")
att.Description = "A well oiled bolt and a steadfast hand improves weapon cycling rate."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Slot = "go_perk"
att.InvAtt = "perk_fastbolt"

att.NotForNPC = true

att.AutoStats = true
att.Mult_CycleTime = 0.85

att.Hook_Compatible = function(wep)
    if wep.Num ~= 1 or not wep.ManualAction then return false end
end