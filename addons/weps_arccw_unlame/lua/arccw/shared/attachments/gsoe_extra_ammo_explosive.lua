att.PrintName = "(CSExtras) Devil's Lance"
att.Icon = Material("entities/acwatt_ammo_explosive.png")
att.Description = "A bullet with an explosive charge, used originally for calibrating aircraft weapons. \nIn WWII, elite snipers of the Eastern Front reserved these extremely rare ammo for high value targets. Its effects can only be described as grotesque - and very effective."
att.Desc_Pros = {
    "+ Explosion on hit dealing additional 100% damage"
}
att.Desc_Cons = {
    "-80% Magazine capacity",
}
att.Desc_Neutrals = {
    "Manual/break action and rifle/sniper ammo only",
    "Blast radius is 96 HU / 2.4m",
}
att.AutoStats = true
att.Slot = "go_ammo"
att.InvAtt = "ammo_explosive"

att.Mult_ShootPitch = 0.8
att.Mult_ShootVol = 1.3
att.Mult_Penetration = 0
att.Mult_Damage = 0.7
att.Mult_Range = 0.7

att.Override_DamageType = DMG_BURN
att.ActivateElements = {"reducedmag"}

att.Hook_Compatible = function(wep)
    if not (wep.ManualAction or (wep:GetChamberSize() == 0 and (wep.RegularClipSize or wep.Primary.ClipSize) <= 2)) then return false end
    local tbl = engine.ActiveGamemode() == "terrortown" and {"357"} or {"ar2", "SniperPenetratedRound"}
    if not table.HasValue(tbl, wep.Primary.Ammo or "") then return false end
end

att.Hook_GetCapacity = function(wep, cap)
    return math.Clamp(math.Round(wep.RegularClipSize * 0.2), 1, 5)
end

att.Hook_BulletHit = function(wep, data)
    local ent = data.tr.Entity
    util.BlastDamage(wep, wep:GetOwner(), data.tr.HitPos, 96, wep:GetDamage(data.range))
    if ent:IsValid() and ent:GetClass() == "npc_helicopter" then
        data.dmgtype = DMG_AIRBOAT
    end
end