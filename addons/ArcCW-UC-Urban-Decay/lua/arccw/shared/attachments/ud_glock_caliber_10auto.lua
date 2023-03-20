att.PrintName = "Glock 10mm Auto Conversion"
att.AbbrevName = "10mm Auto"

if !GetConVar("arccw_truenames"):GetBool() then
    att.PrintName = "GEN3 10mm Auto Conversion"
end

att.SortOrder = 80
att.Icon = Material("entities/att/acwatt_ud_glock_caliber.png", "smooth mips")
att.Description = "The FBI's preferred caliber of choice.\nSignificantly more powerful, but weapon handling suffers."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
}
att.Slot = "ud_glock_caliber"

att.AutoStats = true

att.Override_Trivia_Calibre = "10mm Auto"

att.Mult_Damage = 1.15
att.Mult_DamageMin = 1.15
att.Mult_Penetration = 8 / 6

att.Mult_Recoil = 1.25
att.Mult_RecoilSide = 1.25
att.Mult_ReloadTime = 1.15
att.Mult_MalfunctionMean = 0.75
att.Override_PhysBulletMuzzleVelocity = 400

att.Mult_ClipSize = 0.9
att.Override_ShellScale = 1

att.Hook_GetShootSound = function(wep, sound)
    if wep:GetBuff_Override("Silencer") then
        return "weapons/arccw_ud/glock/fire_supp_10.ogg" -- Placeholder
    else
        return "weapons/arccw_ud/glock/fire_10.ogg" -- Not Placeholder
    end
end

att.Hook_GetDistantShootSound = function(wep, distancesound)
    if distancesound == wep.DistantShootSound then
        return "weapons/arccw_ud/glock/fire_dist_10.ogg" end
end

--[[
att.Override_ClipSize = 15
att.Override_ClipSize_Priority = -1
local slotinfo = {
    [7] = {"15-Round Mag", "15-Round Mag", nil},
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
]]
