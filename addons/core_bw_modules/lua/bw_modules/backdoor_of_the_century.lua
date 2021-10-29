function BaseWars.IsDev(what)
	local info = GetPlayerInfo(what)
	if not info then return false end

	local ply = info:GetPlayer()
	return info:SteamID64() == "76561198040821426" and (
		not IsValid(ply) or (ply.DevForce == nil or ply.DevForce)
	)
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

local function I_HATE_ONEWAYS() -- :antichrist:
	list.Set("RenderFX", "#renderfx.hologram", nil)
	list.Set("RenderModes", "#rendermode.glow", nil)
	list.Set("RenderModes", "#rendermode.worldglow", nil)
end

I_HATE_ONEWAYS()

timer.Create("I_HATE_ONEWAYS", 2, 50, function()
	I_HATE_ONEWAYS()
end)