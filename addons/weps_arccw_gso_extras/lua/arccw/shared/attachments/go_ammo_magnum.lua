att.PrintName = "Magnum Rounds"
att.Icon = Material("entities/acwatt_go_ammo_magnum.png")
att.Description = "Load cartridges with a dangerous amount of powder, exchanging ballistics for raw close-up power.\nCannot be used with suppressors."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = "go_ammo"

att.Mult_Sway = 1
att.Mult_Damage = 1.2
att.Mult_AccuracyMOA = 2
att.Mult_Recoil = 1.5
att.Mult_RecoilSide = 1.5
att.Mult_Range = 0.75
att.Mult_ShootVol = 1.15

att.Hook_Compatible = function(wep)
    if wep.Primary.Ammo ~= "pistol" or wep.Damage > 35 or wep:GetBuff_Override("Silencer") then return false end
end

--att.Override_Jamming = true
--att.Override_HeatLockout = true
--[[]
att.O_Hook_Override_HeatDelayTime = function(wep, data)
    local cfm = wep:GetCurrentFiremode()
    local t = 1
    if cfm.Mode == 1 then
        mult = 1.5
    elseif cfm.Mode < 0 then
        mult = (cfm.PostBurstDelay or 0.1) * 10
    end
    data.current = t
end
]]
--[[]
att.Override_HeatDelayTime = 0.75
att.O_Hook_Override_HeatDissipation = function(wep, data)
    data.current = (wep.RegularClipSize or wep.Primary.ClipSize) * (wep:GetReloading() and 0.25 or 1) * (wep:GetHeatLocked() and 0.25 or 0.75)
end
att.O_Hook_Override_HeatCapacity = function(wep, data)
    data.current = (wep.RegularClipSize or wep.Primary.ClipSize) * 0.6
end
att.Hook_Overheat = function(wep, heat)
    wep:EmitSound("physics/metal/metal_barrel_impact_hard6.wav", 90, 150)
    wep:EmitSound("physics/metal/metal_box_break1.wav", 80, 130, 0.5)
end

att.Hook_Compatible = function(wep)
    if wep.Jamming or (wep:GetBuff_Override("Override_ManualAction") or wep.ManualAction) or wep:GetIsShotgun() then return false end
end
]]