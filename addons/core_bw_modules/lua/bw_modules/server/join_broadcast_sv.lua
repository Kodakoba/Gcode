util.AddNetworkString("NewPlayerBroadcast")

_IPs = _IPs or {} -- ew
local IPs = _IPs

_joinTimes = _joinTimes or {}
local joinTimes = _joinTimes

hook.Add( "CheckPassword", "BroadcastJoin", function( steamID64, ip, pw1, pw2, name )
	local sid = util.SteamIDFrom64( steamID64 )
	if pw1 and pw2 and #pw1 > 0 and pw1 ~= pw2 then
		local id_tx = "%s (%s) failed password."
		local dat = {
			Colors.Red, "[Disconnect] ",
			Color(200, 200, 200), id_tx:format(name, sid, pw1, pw2), " (",
			Color(70, 210, 70), pw1,
			Color(200, 200, 200), " vs. ",
			Color(160, 70, 70), pw2,
			Color(200, 200, 200), ").\n"}

		ChatAddText(unpack(dat))
		MsgC(unpack(dat))
		return
	end

	net.Start("NewPlayerBroadcast")
		net.WriteBool(false)
		net.WriteString(name)
		net.WriteString(sid)
	net.Broadcast()

	local txt = name .. (" has started connecting to the server. (%s @ %s)")
		:format(steamID64, ip)

	MsgC(
		Colors.Yellowish, "[Connect] ",
		Color(230, 230, 230), txt,
		"\n"
	)

	joinTimes[steamID64] = SysTime()
	IPs[steamID64] = ip
end )

local function getJoinTime(sid)
	if joinTimes[sid] then return SysTime() - joinTimes[sid] end
	return 0
end

gameevent.Listen( "player_disconnect" )
hook.NHAdd("player_disconnect", "TrackLeave", function( data )
	local name = data.name
	local reason = data.reason and data.reason:gsub("[\r\n]*$", "")
	local sid = util.SteamIDTo64(data.networkid)

	local passed = getJoinTime(sid)
	joinTimes[sid] = nil

	local dat = {
		Colors.Red, "[Disconnect] ",
		Color(200, 200, 200), "TX1",
		Color(100, 220, 100), "NAME",
		Color(160, 160, 160), "DETAILS",
		Color(200, 200, 200), "TX2",
		Color(160, 160, 160), "WHY",
		"\n"
	}

	local remap = {
		TX1 = "Player ",
		NAME = name .. " ",
		DETAILS = ("(%s @ %s) "):format(sid, IPs[sid] or "??? untracked IP?"),
		TX2 = "has left the server. ",
		WHY = ("(%s)"):format(reason)
	}

	if passed ~= 0 then
		remap.TX2 = ("has given up on connecting after %ds. "):format(passed)
	end

	table.RemapValues(dat, remap, true)

	MsgC(unpack(dat))

	net.Start("NewPlayerBroadcast")
		net.WriteBool(true)
		net.WriteBool(false)
		net.WriteString(name)
		net.WriteString(sid)
		net.WriteUInt(math.floor(passed), 16)
	net.Broadcast()
end)

hook.Add("PlayerFullyLoaded", "BroadcastJoin", function(ply)
	local passed = getJoinTime(ply:SteamID64())
	joinTimes[ply:SteamID64()] = nil

	local dat = {
		Colors.Sky, "[Connect] ",
		Color(200, 200, 200), "Player ",
		Color(100, 220, 100), ply:Nick(), " ",
		Color(160, 160, 160), ("(%s @ %s) "):format(ply:SteamID64(), ply:IPAddress()),
		Color(200, 200, 200), "finished connecting after ",
		Color(220, 200, 35), ("%d"):format(passed),
		Color(200, 200, 200), "s.",
		"\n"
	}

	net.Start("NewPlayerBroadcast")
		net.WriteBool(true)
		net.WriteBool(true)
		net.WriteString(ply:Nick())
		net.WriteString(ply:SteamID())
		net.WriteUInt(math.floor(passed), 16)
	net.Broadcast()

	MsgC(unpack(dat))
end)