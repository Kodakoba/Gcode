-- ugh

if SERVER then
	util.AddNetworkString("TeamChangedNotify")

	hook.Add("PlayerChangedTeam", "NotifyChange", function(ply, old, new)
		net.Start("TeamChangedNotify")
			net.WriteEntity(ply)
			net.WriteUInt(old, 32)
			net.WriteUInt(new, 32)
		net.Broadcast()
	end)

else
	net.Receive("TeamChangedNotify", function()
		local ply, old, new = net.ReadEntity(), net.ReadUInt(32), net.ReadUInt(32)
		hook.Run("CLPlayerChangedTeam", ply, old, new)
	end)
end