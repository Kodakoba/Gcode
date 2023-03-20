att.PrintName = "(GSO) Deep Sea"
att.Icon = Material("entities/acwatt_go_perk_diver.png", "mips smooth")
att.Description = "Enables the weapon to keep firing while underwater with specially sealed internal parts."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "perk"
att.InvAtt = "go_perk_diver"

att.Override_CanFireUnderwater = true

att.Hook_Compatible = function(wep)
    if wep.CanFireUnderwater then return false end
end