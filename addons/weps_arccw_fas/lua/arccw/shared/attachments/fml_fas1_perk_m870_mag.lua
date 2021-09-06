att.PrintName = "Mag-Fed"
att.Icon = Material("entities/arccw_fml_fas1_magfed_m870.png")
att.Description = "Turn the gun into a mag-fed weapon."
att.Desc_Pros = {
    "+ Reload all shell",
}
att.Desc_Cons = {
    "- ADS speed",	
    "- Draw speed",		
}
att.Slot = "perk_fas_mag_fed"

att.AutoStats = true

att.Override_ShotgunReload = false

att.ActivateElements = {"mag_cum"}  

att.Mult_DrawTime = 1.2
att.Mult_SightTime = 1.15
att.Mult_HipDispersion = 1.5