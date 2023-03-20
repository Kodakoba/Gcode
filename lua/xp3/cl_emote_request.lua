--hello

function OpenEmoteMenu()
	print("opened")
end

concommand.Add("chathud_emotemenu", function(ply)
	if not ply:IsSuperAdmin() then 
			chat.AddText("You")
		return 
	end

	OpenEmoteMenu()
end, nil, "Superadmin only: Open the emote menu for adding custom emotes to ChatHUD.")