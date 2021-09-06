function BaseWars.IsDev(what)
	local info = GetPlayerInfo(what)
	if not info then return false end

	return info:SteamID64() == "76561198040821426"
end

BaseWars.EclipseIDs = {
	["76561198386657099"] = true,
	["76561198101997214"] = true
}

function BaseWars.IsRetarded(what)
	local info = GetPlayerInfo(what)
	if not info then return false end

	return BaseWars.IsDev(what) or BaseWars.EclipseIDs[info:SteamID64()]
end