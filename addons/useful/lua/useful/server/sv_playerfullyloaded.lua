--123
util.AddNetworkString("FullLoad")

FullyLoaded = {}

net.Receive("FullLoad", function(_, ply)
	if FullyLoaded[ply] then print("denied") return end 

	FullyLoaded[ply] = true 
	hook.Run("PlayerFullyLoaded", ply)
end)