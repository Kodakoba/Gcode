GSLT_Set = false

function fuckyou()
	if jit.os == "Linux" then
		RunConsoleCommand("hostname", "lodestar | dev alpha")
		if not GSLT_Set then
		    RunConsoleCommand("sv_setsteamaccount", "6F077E7730DE463EDF6E19BC4D343E4C")
		    GSLT_Set = true
		end
	else
		if not GSLT_Set then
		    RunConsoleCommand("sv_setsteamaccount", "74E5FAD9CD89DC9EB6072C344D75185E")
		    GSLT_Set = true
		end
	end

	--RunConsoleCommand("sv_downloadurl", "https://vaati.net/Gachi/garrysmod")
	RunConsoleCommand("sv_downloadurl", "http://fr-gra-devserver-source01.crident.net/25017be5/")
	RunConsoleCommand("sv_loadingurl", "https://vaati.net/Gachi/loading.html")
end

timer.Create("fuckyou", 30, 0, fuckyou)
hook.Add("InitPostEntity", "fuckoff_crydent", fuckyou)
fuckyou()