hook.Add("BaseWars_PlayerEmptyPrinter", "XPRewards", function(ply, ent, money)
	if ent:GetClass() == "bw_printer_manual" then
		ply:AwardEXPForMoney(money * 2, true)
	else
		ply:AwardEXPForMoney(money)
	end
end)

util.AddNetworkString("NewPlayerBroadcast")

local joinTimes = {}
local IPs = {} -- ew

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
	local reason = data.reason
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

Basewars.GenEntsOwners = Basewars.GenEntsOwners or {}

hook.NHAdd("EntityOwnershipChanged", "BW_GenLimit", function(ply, ent, oldID)
	if not ent.Bought or not ent.IsGenerator then return end

	local old = oldID and GetPlayerInfo(oldID)
	local new = ent:BW_GetOwner()

	if old then
		old._Gens = (old._Gens or 1) - 1
	end

	if new then
		new._Gens = (new._Gens or 0) + 1
	end

	ent._genHooked = new
end)

hook.NHAdd("EntityRemoved", "BW_GenLimit", function(ent)
	if not ent._genHooked then return end
	local pin = ent._genHooked
	pin._Gens = pin._Gens - 1
end)

hook.Add("BaseWars_PlayerCanBuyEntity", "Gennies", function(ply, ent)

	if scripted_ents.IsBasedOn(ent, "bw_base_generator") then
		local gens = GetPlayerInfo(ply)._Gens
		if gens and gens >= 3 then
			--ply:Notify("The generator limiting hook was temporarily disabled. Reactivate when going public.", Color(100, 200, 100))
			return false, "You can't have more than 3 generators active!"
		end
	end
end)

hook.Add("CPPIAssignOwnership", "UpdateSID64", function(ply, ent)
	if IsPlayer(ply) then
		ent.FPPSteamID64 = ply:SteamID64()
	end
end)

hook.Add("BaseWars_PlayerBuyEntity", "Gennies", function(ply, ent)
	local sid64 = ply:SteamID64()

	if ent.IsGenerator then

		ent:CallOnRemove("dec_gen_limit", function()
			BaseWars.Generators[sid64] = (BaseWars.Generators[sid64] or 1) - 1
		end)

	end

end)