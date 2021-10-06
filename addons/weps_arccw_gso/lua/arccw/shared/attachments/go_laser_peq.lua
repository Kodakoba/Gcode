att.PrintName = "5mW Laser"
att.Icon = Material("entities/acwatt_go_laser_peq.png", "mips smooth")
att.Description = "High-power laser pointer. Improves hip fire, moving accuracy, and sight time."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "con.beam"
}
att.AutoStats = true
att.Slot = "tac"

att.Model = "models/weapons/arccw_go/atts/laser_peq.mdl"

att.KeepBaseIrons = true

att.Laser = false
att.LaserStrength = 1
att.LaserBone = "laser"

att.Mult_MoveSpeed = 0.95

att.ToggleStats = {
    {
        PrintName = "Red",
        Laser = true,
        LaserColor = Color(255, 0, 0),
        Mult_HipDispersion = 0.75,
        Mult_MoveDispersion = 0.75,
        Mult_SightTime = 0.9,
    },
    {
        PrintName = "Green",
        Laser = true,
        LaserColor = Color(0, 255, 0),
        Mult_HipDispersion = 0.75,
        Mult_MoveDispersion = 0.75,
        Mult_SightTime = 0.9,
    },
    {
        PrintName = "Blue",
        Laser = true,
        LaserColor = Color(0, 0, 255),
        Mult_HipDispersion = 0.75,
        Mult_MoveDispersion = 0.75,
        Mult_SightTime = 0.9,
    },
    {
        PrintName = "Off",
    }
}