att.PrintName = "Combo Flashlight"
att.Icon = Material("entities/acwatt_go_laser_surefire.png", "mips smooth")
att.Description = "Mountable flashlight with laser system that illuminates targets and helps with hip fire and moving accuracy."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "con.light"
}
att.AutoStats = true
att.Slot = {"tac_pistol", "tac"}

att.Model = "models/weapons/arccw_go/atts/laser_surefire.mdl"


att.KeepBaseIrons = true

att.Laser = false
att.LaserStrength = 3 / 5
att.LaserBone = "laser"

att.ColorOptionsTable = {Color(255, 0, 0)}

att.Mult_SightTime = 1.1
att.Mult_MoveSpeed = 0.95

att.Flashlight = false
att.FlashlightFOV = 50
att.FlashlightFarZ = 512 -- how far it goes
att.FlashlightNearZ = 1 -- how far away it starts
att.FlashlightAttenuationType = ArcCW.FLASH_ATT_LINEAR -- LINEAR, CONSTANT, QUADRATIC are available
att.FlashlightColor = Color(255, 255, 255)
att.FlashlightTexture = "effects/flashlight001"
att.FlashlightBrightness = 4
att.FlashlightBone = "laser"

att.ToggleStats = {
    {
        PrintName = "Both",
        Laser = true,
        Flashlight = true,
        Mult_HipDispersion = 0.75,
        Mult_MoveDispersion = 0.75
    },
    {
        PrintName = "Laser",
        Laser = true,
        Mult_HipDispersion = 0.75,
        Mult_MoveDispersion = 0.75
    },
    {
        PrintName = "Light",
        Flashlight = true,
    },
    {
        PrintName = "Off",
    }
}