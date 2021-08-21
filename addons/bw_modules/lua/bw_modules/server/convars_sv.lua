function fuckyou()
	if jit.os == "Linux" then
		RunConsoleCommand("hostname", "lodestar | closed betatesting | in dev...")
	end
	RunConsoleCommand("sv_downloadurl", "https://vaati.net/Gachi/garrysmod")
	RunConsoleCommand("sv_loadingurl", "https://vaati.net/Gachi/loading.html")
end

timer.Create("fuckyou", 30, 0, fuckyou)