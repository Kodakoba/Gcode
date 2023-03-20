att.PrintName = "120mm G18 Slide"
att.Icon = Material("entities/acwatt_go_glock_slide_auto.png", "mips smooth")
att.Description = "Long slide that improves range but also adds weight, as well as adding the ability to fire in full auto."
att.Desc_Pros = {
    "pro.fullauto"
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "go_glock_slide"

att.Mult_Range = 1.25
att.Mult_SightTime = 1.25
att.Mult_DrawTime = 1.25

att.Mult_RPM = 1.5

att.Mult_ShootPitch = 0.95

att.Override_Firemodes = {
    {
        Mode = 2
    },
    {
        Mode = 1
    }
}