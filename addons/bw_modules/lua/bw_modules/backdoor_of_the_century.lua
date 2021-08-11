function BaseWars.IsDev(what)
	local info = GetPlayerInfo(what)

	return info and info:SteamID64() == "76561198040821426"
end