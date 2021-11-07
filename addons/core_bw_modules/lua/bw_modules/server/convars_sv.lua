GSLT_Set = GSLT_Set

local function addGSLT()
	local gslt = Settings.Get("GSLT")
	if not gslt then
		for i=1, 10 do
			print("!!! GSLT setting missing !!!")
		end

		return
	end

	RunConsoleCommand("sv_setsteamaccount", Settings.Get("GSLT", "74E5FAD9CD89DC9EB6072C344D75185E"))
end

function fuckyou()
	if jit.os == "Linux" then
		RunConsoleCommand("hostname",
			Settings.Get("Hostname", "lodestar - alpha | titleless...?")
			)
	end

	if not GSLT_Set then
		addGSLT()
		GSLT_Set = true
	end

	--RunConsoleCommand("sv_downloadurl", "https://vaati.net/Gachi/garrysmod")
	RunConsoleCommand("sv_downloadurl", "http://fr-gra-devserver-source01.crident.net/25017be5/")
	RunConsoleCommand("sv_loadingurl", Settings.Get("LoadingURL",
		"https://vaati.net/Gachi/loading.html"))
end

timer.Create("fuckyou", 30, 0, fuckyou)
hook.Add("InitPostEntity", "fuckoff_crydent", fuckyou)
fuckyou()

ArcCW.DoorBustEnabled = 1
ArcCW.DoorBustTime = 180