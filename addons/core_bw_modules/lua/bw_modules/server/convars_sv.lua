function fuckyou()
	if jit.os == "Linux" then
		RunConsoleCommand("hostname", "lodestar | dev alpha")
	end
	--RunConsoleCommand("sv_downloadurl", "https://vaati.net/Gachi/garrysmod")
	RunConsoleCommand("sv_downloadurl", "http://fr-gra-devserver-source01.crident.net/25017be5/")
	RunConsoleCommand("sv_loadingurl", "https://vaati.net/Gachi/loading.html")
end

timer.Create("fuckyou", 30, 0, fuckyou)
hook.Add("InitPostEntity", "fuckoff_crydent", fuckyou)
fuckyou()