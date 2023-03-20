att.PrintName = "Regulator"
att.Icon = Material("entities/acwatt_fcg_regulator.png")
att.Description = "Fire control device that allows the selection of varying fire rates."
att.Desc_Pros = {
    "pro.regulator",
}
att.Desc_Cons = {
    "con.regulator"
}
att.Slot = "fcg"

att.Override_Firemodes = {
    {
        Mode = 2,
        PrintName = "80%",
        Mult_RPM = 0.8
    },
    {
        Mode = 2,
        PrintName = "60%",
        Mult_RPM = 0.60,
    },
    {
        Mode = 2,
        PrintName = "40%",
        Mult_RPM = 0.4
    },
}