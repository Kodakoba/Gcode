FullLoadSent = FullLoadSent or false 
FullLoadRan = FullLoadRan or false

hook.Add("CalcView", "FullyLoaded", function()
	if FullLoadSent then 
		hook.Remove("CalcView", "FullyLoaded")
		return
	end

	net.Start("FullLoad")
	net.SendToServer()

	FullLoadSent = true 

	hook.Remove("CalcView", "FullyLoaded")

	hook.Run("PlayerFullyLoaded", LocalPlayer())

	FullLoadRan = true

end)




net.Receive("FullLoad", function(len)
	if FullLoadRan then return end 

	FullLoadSent = true 
	FullLoadRan = true
	hook.Run("PlayerFullyLoaded", LocalPlayer())

end)

