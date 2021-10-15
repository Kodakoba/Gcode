hook.Add("ChatText", "___Nope", function(ind, name, txt, type)
	if type == "joinleave" then return true end
end)

gameevent.Listen( "player_disconnect" )

hook.Add( "player_disconnect", "Cya", function( data )
	local name = data.name
	local reason = data.reason and data.reason:gsub("[\r\n]*$", "")

	local txt = "Player " .. name .. " has left the server. (" .. reason .. ")"

	chat.AddText(Color(250, 30, 30), "[Disconnect] ", Color(200, 200, 200), txt .. ".")
	MsgC(Color(250, 30, 30), "[Disconnect] ", Color(200, 200, 200), txt .. ".	", Color(100, 220, 100), data.networkid .. "\n")
	surface.PlaySound("npc/roller/mine/combine_mine_deploy1.wav")
end)

net.Receive("NewPlayerBroadcast", function()
	local finished = net.ReadBool()
	local joined
	if finished then joined = net.ReadBool() end

	local plyname = net.ReadString()
	local sid = net.ReadString()

	local dat = {
		finished and Colors.Sky or Colors.Yellowish, "[Connect] ",
		Color(200, 200, 200), "Player ",
		Color(100, 220, 100), plyname, " ",
		Color(160, 160, 160), "[STEAMID]",
	}

	local append

	if finished then
		if not joined then
			dat[1] = Colors.Red
			surface.PlaySound("npc/turret_floor/retract.wav")
		else
			surface.PlaySound("garrysmod/content_downloaded.wav")
		end

		append = {
			Color(200, 200, 200),
			joined and "finished loading after " or "gave up on joining after ",
			Color(220, 200, 35), ("%d"):format(net.ReadUInt(16)),
			Color(200, 200, 200), "s.",
		}
	else
		append = {
			Color(200, 200, 200), "has started connecting to the server.",
		}

		surface.PlaySound("npc/scanner/scanner_nearmiss1.wav")
		--surface.PlaySound("npc/roller/mine/rmine_blip1.wav")
	end

	for k,v in ipairs(append) do
		table.insert(dat, v)
	end

	local key = table.ReplaceValue(dat, "[STEAMID]", "", true)

	chat.AddText(unpack(dat))

	dat[key] = ("(%s) "):format(sid)

	MsgC(unpack(dat))
	MsgC("\n")
end)