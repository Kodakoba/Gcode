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

--[[
	Adv. Dupe 2 Fix
	Log trash when people use "inf" or beyond reasonable ModelScale on dupes.
]]

local function AntiDupeTrash()

	net.Receivers["armdupe"] = function(len,ply) 
 		if ply:IsAdmin() or ply:IsSuperAdmin() then return  --you don't need it anyways

 		else 
 			print(tostring(ply).. " tried to arm a dupe despite lacking admin privileges.") 
 		end 

	end

end

hook.Add("InitPostEntity", "AntiDupeCrash",function() 
	AntiDupeTrash()  
end)
