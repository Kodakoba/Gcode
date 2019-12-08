print('hi')

plogs.Register('SimplAC', true, Color(204,0,153))

local codes = {
	SC = "Seed check (attempted nospread?)",
	MC = "Mouse check (snapped without actually moving mouse?)",
	AF = "AutoFire check",
	AN = "Aimbot (big angle snap onto an entity)",
	BH = "BunnyHop check",
	MV = "MoveCheck(potential attempt at speedhacking? most likely just a poor guy with ping though)",
	AS = "Statistical Aimbot; this shouldn't actually be enabled but whatever.",
}


plogs.AddHook('Simplac.PlayerViolation', function(pl, sid, data)
	local cheat_code = data:sub(1, 2)

	plogs.PlayerLog(pl, 'SimplAC', pl:Name().." violated anticheat protocol: " .. (codes[cheat_code] or "UNEXPLAINED CHEATCODE? PASTE THIS TO GACHI ".. cheat_code) , {
		['Name'] 	= pl:Name(),
		['SteamID64']	= sid ,
		['SteamID'] = pl:SteamID(),
		['Additional Info'] = data,
	})
end)