att.PrintName = "(CS+) Diver"
att.Icon = Material("entities/acwatt_perk_underwater.png")
att.Description = "Allows gun to shoot underwater."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "go_perk"
att.InvAtt = "perk_underwater"

att.Override_CanFireUnderwater = true

att.Hook_Compatible = function(wep)
    if wep.CanFireUnderwater then return false end
end