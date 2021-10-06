att.PrintName = "3mW Laser"
att.Icon = Material("entities/acwatt_go_laser_surefire.png", "mips smooth")
att.Description = "Medium-power laser pointer. Improves hip fire and sight time."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "con.beam"
}
att.AutoStats = true
att.Slot = {"tac_pistol", "tac"}

att.Model = "models/weapons/arccw_go/atts/laser_surefire.mdl"

att.KeepBaseIrons = true

att.Laser = false
att.LaserStrength = 3 / 5
att.LaserBone = "laser"

att.Mult_MoveSpeed = 0.95

att.Mult_SightTime = 1.1

att.ToggleStats = {
    {
        PrintName = "Red",
        Laser = true,
        LaserColor = Color(255, 0, 0),
        Mult_HipDispersion = 0.75,
        Mult_MoveDispersion = 0.75,
    },
    {
        PrintName = "Green",
        Laser = true,
        LaserColor = Color(0, 255, 0),
        Mult_HipDispersion = 0.75,
        Mult_MoveDispersion = 0.75,
    },
    {
        PrintName = "Blue",
        Laser = true,
        LaserColor = Color(0, 0, 255),
        Mult_HipDispersion = 0.75,
        Mult_MoveDispersion = 0.75,
    },
    {
        PrintName = "Off",
    }
}