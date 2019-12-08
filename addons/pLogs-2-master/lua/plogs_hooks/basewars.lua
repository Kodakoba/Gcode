--
plogs.Register('BaseWars', true, Color(0,255,160))
    
plogs.AddHook('PlayerPrestige', function(ply,pts,abs,lvl,money)
    
        local logname = ""
        local nameid = ply:GetName() .. " | " .. ply:SteamID() .. " | " .. ply:SteamID64()
        logname = ply:GetName() .. " prestiged for " .. tostring(pts) .. " prestige points and " .. abs .. " prestige."
        
	plogs.PlayerLog(ply, 'BaseWars', logname, {
		["Player name + SteamID + SteamID64"] 	= namesid1,
		["Player economy info(pre prestige)"] = tostring(lvl) .. "LVL | $".. tostring(money)
	})

end)