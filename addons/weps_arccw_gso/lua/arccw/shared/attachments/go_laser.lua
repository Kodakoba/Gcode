att.PrintName = "1mW Laser"
att.Icon = Material("entities/acwatt_go_laser.png", "mips smooth")
att.Description = "Low-power laser pointer. Improves hip-fire accuracy."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "con.beam"
}
att.AutoStats = true
att.Slot = {"tac_pistol", "tac"}

att.Model = "models/weapons/arccw_go/atts/laser.mdl"

att.KeepBaseIrons = true

att.Laser = false
att.LaserStrength = 0.2
att.LaserColor = Color(255, 0, 0)
att.LaserBone = "laser"
-- att.Mult_MoveDispersion = 0.5
--att.Mult_SightTime = 0.9

att.Mult_MoveSpeed = 0.95

att.Mult_SightTime = 1.1

att.ToggleStats = {
    {
        PrintName = "Red",
        Laser = true,
        LaserColor = Color(255, 0, 0),
        Mult_HipDispersion = 0.75,
    },
    {
        PrintName = "Green",
        Laser = true,
        LaserColor = Color(0, 255, 0),
        Mult_HipDispersion = 0.75,
    },
    {
        PrintName = "Blue",
        Laser = true,
        LaserColor = Color(0, 0, 255),
        Mult_HipDispersion = 0.75,
    },
    {
        PrintName = "Off",
    }
}