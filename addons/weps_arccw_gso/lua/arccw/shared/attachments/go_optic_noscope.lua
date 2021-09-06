att.PrintName = "No Scope"
att.Icon = Material("entities/acwatt_go_optic_noscope.png", "mips smooth")
att.Description = "Remove iron sights and aim down the rail. Could be useful in combination with laser sights."

att.SortOrder = -1

att.Desc_Pros = {
}
att.Desc_Cons = {
    "con.noscope"
}
att.AutoStats = true
att.Slot = "optic"

att.Free = true

att.AdditionalSights = {
    {
        Pos = Vector(0, 15, -1),
        Ang = Angle(0, 0, 0),
        Magnification = 1.25,
        IgnoreExtra = true
    },
}

att.Mult_SightTime = 0.975