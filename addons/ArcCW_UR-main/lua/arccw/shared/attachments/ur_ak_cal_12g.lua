att.PrintName = "Saiga-12 12 Gauge Receiver"
att.AbbrevName = "12G Receiver"
att.Icon = Material("entities/att/ur_ak/recievers/12.png", "mips smooth")
--att.Icon = Material("entities/att/obsolete.png", "mips smooth") not obsolete anymore
att.Description = "Turns the rifle into a semi-automatic, mag-fed combat shotgun."

att.Desc_Pros = {
    "ur.ak.12g.1"
}
att.Desc_Cons = {
    "uc.semionly",
    "ur.ak.12g.2",
    "uc.jam"
}
att.Desc_Neutrals = {
}
att.Slot = "ur_ak_cal"

att.AutoStats = true
att.SortOrder = -100

-- Recycled USAS code top kek
att.Override_ClipSize_Priority = -1
att.Override_ClipSize = 8

--att.Mult_HipDispersion = 1.25
att.Mult_RPM = 0.4




att.Override_Malfunction = true
att.Mult_MalfunctionMean = 0.8
att.Mult_MalfunctionVariance = 1.5




att.Override_AccuracyMOA_Priority = -1
att.Override_AccuracyMOA = 40
att.Override_Num_Priority = -1 -- shotgun ammo may need to overwrite this
att.Override_Num = 8
att.Mult_Damage = 3
att.Mult_DamageMin = 3
att.Mult_Range = 0.2
att.Mult_RangeMin = .5
--att.Mult_PhysBulletMuzzleVelocity = 3 -- revert velocity changes by range
att.Mult_PhysBulletMuzzleVelocity = .75
--att.Mult_RangeMin = 0.75
att.Mult_Recoil = 3
att.Mult_RecoilSide = 2
att.Mult_ShootSpeedMult = 0.75

att.Mult_SpeedMult = 0.925
att.Mult_ReloadTime = 1.15

att.Override_Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

att.LHIK = true

att.Override_IsShotgun = true
att.Override_IsShotgun_Priority = 999
att.Override_Ammo = "buckshot"
att.Override_Trivia_Calibre = "12 Gauge"
att.Override_Trivia_Class = "Shotgun"
att.Override_ShellModel = "models/weapons/arccw/uc_shells/12g.mdl"
att.Override_ShellScale = 1
att.Override_ShellSounds = ArcCW.ShotgunShellSoundsTable

att.GivesFlags = {"cal_12g"}
att.ActivateElements = {"mag_12g"}

att.Hook_GetShootSound = function(wep, fsound)
    if fsound == wep.ShootSound or fsound == wep.FirstShootSound then return "weapons/arccw_ud/m1014/fire.ogg" end
    if fsound == wep.ShootSoundSilenced then return "weapons/arccw_ud/m1014/fire_supp.ogg" end
end

att.Hook_GetDistantShootSound = function(wep, distancesound)
    if distancesound == wep.DistantShootSound then return "weapons/arccw_ud/870/fire_dist.ogg" end
end

att.Hook_SelectReloadAnimation = function(wep, anim)
    return anim .. "_12g"
end
-- att.Hook_GetDefaultAttIcon = function(wep, slot)
--     if slotinfo[slot] then
--         return slotinfo[slot][3]
--     end
-- end

-- att.Hook_TranslateAnimation = function(wep, anim)
--     if (anim == "fire" or anim == "fire_empty") then
--         return anim .. "_usas"
--     end
-- end
local slotinfo = {
    [5] = {"8-Round Mag", "8-Round Mag", Material("entities/att/ur_ak/magazines/12_8.png", "mips smooth")},
    [11] = {"\"BUCK\" #00 Buckshot", "\"BUCK\" #00 Buckshot", Material("entities/att/arccw_uc_ammo_shotgun_generic.png", "mips smooth")},
}
att.Hook_GetDefaultAttName = function(wep, slot)
    if slotinfo[slot] then
        return GetConVar("arccw_truenames"):GetBool() and slotinfo[slot][2] or slotinfo[slot][1]
    end
end
att.Hook_GetDefaultAttIcon = function(wep, slot)
    if slotinfo[slot] then
        return slotinfo[slot][3]
    end
end