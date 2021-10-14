hook.Add("ChatText", "___Nope", function(ind, name, txt, type)
	if type == "joinleave" then return true end
end)

gameevent.Listen( "player_disconnect" )

hook.Add( "player_disconnect", "Cya", function( data )
	local name = data.name
	local reason = data.reason

	local txt = "Player " .. name .. " has left the server. (" .. reason .. ")"

	chat.AddText(Color(250, 30, 30), "[Disconnect] ", Color(200, 200, 200), txt .. ".")
	MsgC(Color(250, 30, 30), "[Disconnect] ", Color(200, 200, 200), txt .. ".	", Color(100, 220, 100), data.networkid .. "\n")
end)

net.Receive("StartConnect", function()
	local plyname = net.ReadString()
	local sid = net.ReadString()
	local txt = plyname .. " has started connecting to the server."

	chat.AddText(Color(250, 250, 40), "[Connect] ", Color(230, 230, 230), txt)
	MsgC(Color(250, 250, 40), "[Connect] ", Color(230, 230, 230), txt, Color(100, 220, 100), "	" ..sid .. "\n")
	surface.PlaySound("garrysmod/content_downloaded.wav")
end)