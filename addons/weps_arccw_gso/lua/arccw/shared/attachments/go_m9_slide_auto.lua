att.PrintName = "210mm 93R Slide"
att.Icon = Material("entities/acwatt_go_m9_slide_auto.png", "mips smooth")
att.Description = "Slide with integral compensator that improves recoil and adds the ability to fire in full auto."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "go_m9_slide"

att.Mult_Recoil = 0.95

att.Mult_RPM = 1.5

att.Mult_ShootPitch = 0.95

att.Override_Firemodes = {
    {
        Mode = 2
    },
    {
        Mode = 1
    },
    {
        Mode = 0
    },
}