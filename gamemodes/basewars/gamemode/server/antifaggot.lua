net.Receive("AnalProbing", function(len, ply)
    if not ply.Probing then print("Player attempted to return probe without actually being probed") return end 
    
    local acl = net.ReadString()
    local src = net.ReadString()
    print(ply, "\nsv_allowcslua:", acl,"\ndebug.getinfo render.Capture:", src)

end)
--------

--[[
	PAC Fix
	Restrict PAC to VIP's, this time properly
]]

hook.Add("PrePACConfigApply", "PACDust", function(ply) 
	if not table.HasValue(BaseWars.Config.VIPRanks,ply:GetUserGroup()) and not ply:IsAdmin() and not ply:IsSuperAdmin() then return false,"Not enough privileges!" end
end)
hook.Add("CanWearParts", "PACStop", function(ply)
	if not table.HasValue(BaseWars.Config.VIPRanks,ply:GetUserGroup()) and not ply:IsAdmin() and not ply:IsSuperAdmin() then return false,"Not enough privileges!" end
end)