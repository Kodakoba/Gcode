hook.Add("BaseWars_PlayerBuyEntity", "XPRewards", function(ply, ent)

end)

hook.Add("BaseWars_PlayerEmptyPrinter", "XPRewards", function(ply, ent, money)
	if ent:GetClass() == "bw_printer_manual" then
		ply:AwardEXPForMoney(money * 2, true)
	else
		ply:AwardEXPForMoney(money)
	end
end)

util.AddNetworkString("StartConnect")

hook.Add( "CheckPassword", "BroadcastJoin", function( steamID64, ip, pw1, pw2, name )
	local sid = util.SteamIDFrom64( steamID64 )
	if pw1 and pw2 and pw1~=pw2 then
		ChatAddText(Color(250, 40, 40), "[Disconnect] ", Color(200,200,200), name .. "("..sid..") failed password. ("..pw1.." vs. "..pw2..")")
		return
	end
	net.Start("StartConnect")
		net.WriteString(name)
		net.WriteString(sid)
	net.Broadcast()
end )

hook.Add("BaseWars_PlayerCanBuyEntity", "Gennies", function(ply, ent)
	if ent and ent:find("bw_gen_") then

		local gens = BaseWars.Generators[ply:SteamID64()] or 0

		if gens >= 3 then
			ply:Notify("The generator limiting hook was temporarily disabled. Reactivate when going public.", Color(100, 200, 100))
			return true--false, "You can't have more than 3 generators active!"
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

hook.Add("BaseWars_PlayerBuyEntity", "AddToPurchased", function(ply, newEnt) -- Player, Entity

	if not ply.PurchasedItems then
		for k,v in pairs(ents.GetAll()) do
			if IsValid(v) and v.CPPIGetOwner and IsPlayer(v:CPPIGetOwner()) then
				local o = v:CPPIGetOwner()
				o.PurchasedItems = o.PurchasedItems or {}
				o.PurchasedItems[v] = true
			end
		end
	end

	ply.PurchasedItems = ply.PurchasedItems or {}
	ply.PurchasedItems[newEnt] = true

end)
