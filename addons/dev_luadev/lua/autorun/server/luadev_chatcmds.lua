hook.Add("Think","luadev_cmdsinit",function()
hook.Remove("Think","luadev_cmdsinit")

local aowl = aowl or requirex("aowl")

local function add(cmd,callback, hide, allowed, ugroup)

	if not hide then hide = false end
	if not ugroup then ugroup = "developers" end
	if aowl and aowl.AddCommand then
		aowl.AddCommand(cmd,function(ply,script,param_a,...)
			
			local a,b
			
			easylua.End() -- nesting not supported
			
			local ret,why = callback(ply,script,param_a,...)
			if not ret then 
				if why==false then
					a,b = false,why or aowl.TargetNotFound(param_a or "notarget") or "H"
				elseif isstring(why) and IsValid(ply) then
					ply:ChatPrint("FAILED: "..tostring(why))
					a,b= false,tostring(why)
				elseif not IsValid(ply) and isstring(why) then 
					print('FAILED: ' .. tostring(why))
				end
			end
		
			local _ = easylua.Start(ply)
			return a,b
			
		end,(allowed and "user") or ugroup, hide)

	else
		print('What the fuck, no aowl???')
	end

end
util.AddNetworkString("PrivateMessage")

local pmcd = {}

function DoPrivateMessage(ply, line, target)
	if not IsPlayer(target) then return end 
	if #line < 2 then return end 

	if pmcd[ply] and CurTime() - pmcd[ply] < 0.5 then return end 
	pmcd[ply] = CurTime() 

	local col = (IsPlayer(ply) and team.GetColor(ply:Team())) or Color(210, 140, 250)

	local sender = (IsPlayer(ply) and ply:Nick()) or "Console"

	local tgname = (ply ~= target and target:Nick()) or (ply==target and "Yourself")
	local sndname = (ply~=target and sender) or (ply==target and "Schizophrenia")

	ply:ChatAddText(col, "You", Color(200, 200, 200), " to ", team.GetColor(target:Team()), tgname .. ": ", Color(255, 255, 255), (line:gsub("%c", "")))
	target:ChatAddText(col, sndname, Color(200, 200, 200), " to ", team.GetColor(target:Team()), "You: ", Color(255, 255, 255), (line:gsub("%c", "")))
end

net.Receive("PrivateMessage", function(_, ply)
	local str = net.ReadString()
	local ply2 = net.ReadEntity()
	str = str:sub(0, 300)

	if not IsPlayer(ply2) then return end 

	DoPrivateMessage(ply, str, ply2)
end)

local function X(ply,i) return luadev.GetPlayerIdentifier(ply,'cmd:'..i) end

add("l", function(ply, line, target)
	if not line or line=="" then return false,"invalid script" end
	if luadev.ValidScript then local valid,err = luadev.ValidScript(line,"l") if not valid then return false,err end end
	return luadev.RunOnServer(line, X(ply,"l"), {ply=ply}) 
end)

add("ls", function(ply, line, target)
	if not line or line=="" then return false,"invalid script" end
	if luadev.ValidScript then local valid,err = luadev.ValidScript(line,"ls") if not valid then return false,err end end
	return luadev.RunOnShared(line, X(ply,"ls"), {ply=ply})
end)

add("lc", function(ply, line, target)
	if not line or line=="" then return end
	if luadev.ValidScript then local valid,err = luadev.ValidScript(line,"lc") if not valid then return false,err end end
	return luadev.RunOnClients(line,  X(ply,"lc"), {ply=ply})
end)

add("lsc", function(ply, line, target)
	local script = string.sub(line, string.find(line, target, 1, true)+#target+1)
	if luadev.ValidScript then local valid,err = luadev.ValidScript(script,'lsc') if not valid then return false,err end end
	
	easylua.Start(ply) -- for _G.we -> #us
	local ent = easylua.FindEntity(target)
	if type(ent) == 'table' then
		ent = ent.get()
	end
	easylua.End()
	
	return luadev.RunOnClient(script,  ent,  X(ply,"lsc"), {ply=ply})
end)

local sv_allowcslua = GetConVar"sv_allowcslua"

add("lm", function(ply, line, target)
	if not line or line=="" then return end
	if luadev.ValidScript then local valid,err = luadev.ValidScript(line,'lm') if not valid then return false,err end end
	
	if not ply:IsAdmin() and not sv_allowcslua:GetBool() then return false,"sv_allowcslua is 0" end
	
	luadev.RunOnClient(line, ply,X(ply,"lm"), {ply=ply})
	
end)

add("lb", function(ply, line, target)
	if not line or line=="" then return end
	if luadev.ValidScript then local valid,err = luadev.ValidScript(line,'lb') if not valid then return false,err end end

	luadev.RunOnClient(line, ply, X(ply,"lb"), {ply=ply})
	return luadev.RunOnServer(line, X(ply,"lb"), {ply=ply}) 
end)

add("p", function(ply, line, target)
	if not line or line=="" then return end
	if luadev.ValidScript then local valid,err = luadev.ValidScript('x('..line..')','p') if not valid then return false,err end end

	return luadev.RunOnServer("print(" .. line .. ")",  X(ply,"p"), {ply=ply})
end)

add({"table", "t"}, function(ply, line, target)
	if not line or line=="" then return end
	if luadev.ValidScript then local valid,err = luadev.ValidScript('x('..line..')','table') if not valid then return false,err end end

	return luadev.RunOnServer("PrintTable(" .. line .. ")",  X(ply,"table"), {ply=ply}) 
end)
add({"autorunreg", "ar"}, function(ply,line)
	if not line or line=="" then return end
	if luadev.ValidScript then local valid,err = luadev.ValidScript(line,'ar') if not valid then return false,err end end

	if line:find("||") then return false,"script cant contain ||s! (sorry)" end

	local ok,err = luadev.RunOnServer(line, X(ply,"ar"), {ply=ply})

	if not ok then return ok,err end
	file.Add("autorun_registered.txt", line .. "||")

end)

add({"tablem", "tm"}, function(ply, line, target)
	if not line or line=="" then return end
	ply.EasyLua_ExpectingElpos = CurTime()
	if luadev.ValidScript then local valid,err = luadev.ValidScript('x('..line..')','tablem') if not valid then return false,err end end

	luadev.RunOnClient("PrintTable(" .. line .. ")",  ply, X(ply,"table"), {ply=ply}) 
end)

add("keys", function(ply, line, table, search)
	if not line or line=="" then return end
	if luadev.ValidScript then local valid,err = luadev.ValidScript('x('..table..')','keys') if not valid then return false,err end end

	search = search and search:lower() or ""
	return luadev.RunOnServer(
		"local t={} for k,v in pairs(" .. table .. ") do t[#t+1]=tostring(k) end table.sort(t) for k,v in pairs(t) do if string.find(v:lower(),\"" .. search .. "\",1,true) then print(v) end end",
		X(ply,"keys"), {ply=ply}
	)
end)

add({"printc", "pc"}, function(ply, line, target)
	if not line or line=="" then return end
	
	ply.EasyLua_ExpectingElpos = CurTime()
	for k,v in pairs(player.GetAll()) do 
		v.EasyLua_ExpectingElpos = CurTime()
	end

	line = "easylua.PrintOnServer(" .. line .. ")"
	if luadev.ValidScript then local valid,err = luadev.ValidScript(line,'printc') if not valid then return false,err end end

	return luadev.RunOnClients(line,  X(ply,"printc"), {ply=ply})
end)

add({"printm", "pm"}, function(ply, line, target)
	if not line or line=="" then return end

	if not ply:IsSuperAdmin() then 
		DoPrivateMessage(ply, (line:gsub(target, "")):sub(2), easylua.FindEntity(target))
		return
	end

	ply.EasyLua_ExpectingElpos = CurTime()

	line = "easylua.PrintOnServer(" .. line .. ")"
	if luadev.ValidScript then local valid,err = luadev.ValidScript(line,'printm') if not valid then return false,err end end
	
	luadev.RunOnClient(line,  ply,  X(ply,"printm"), {ply=ply})
end, true, true)

add("printb", function(ply, line, target)
	if not line or line=="" then return end
	ply.EasyLua_ExpectingElpos = CurTime()
	if luadev.ValidScript then local valid,err = luadev.ValidScript('x('..line..')','printb') if not valid then return false,err end end

	luadev.RunOnClient("easylua.PrintOnServer(" .. line .. ")",  ply, X(ply,"printb"), {ply=ply})
	return luadev.RunOnServer("print(" .. line .. ")",  X(ply,"printb"), {ply=ply})
end)
local f = {
	"gachi",
	"playsound",
}
local urls = {

	["curb"] = {lnk = "https://my.mixtape.moe/vvvjdo.mp3", name = "Curb Your Enthusiasm"},
	["gasgasgas"] = {lnk = "https://my.mixtape.moe/ccvzvm.ogg", name = "Gas Gas Gas"},
	["bruceu"] = {lnk = "https://my.mixtape.moe/niytmj.mp3", name = "UGANDAAA"},
	["blasted"] = {lnk = "https://my.mixtape.moe/jlomyt.mp3", name = "The Blasted Heath"},
	["SLAVEISGONE"] = {lnk = "https://my.mixtape.moe/eoepua.mp3", name = "MANLY RAVE"},
	["BILL"] = {lnk = "http://vaati.net/Gachi/sharedshit/%E2%99%82%20GACHIBANK%20-%20BILL%20AUGHRIGHT%20%E2%99%82.mp3", name="FUCK YOU"},
	["NightOfF"] = {lnk = "http://vaati.net/Gachi/sharedshit/Boy%20Next%20Door%20-%20-%20Night%20of%20F.mp3", name = "Night of F"},
	["expeditions"] = {lnk = "http://vaati.net/Gachi/sharedshit/Hyper%20Potions%20%26%20Nokae%20-%20Expedition%20%5BMonstercat%20Release%5D.mp3", name = "Expeditions"},
	["11+4"] = {lnk = "http://vaati.net/Gachi/sharedshit/Radio%20-%20Kappa.mp3", name = "Radio Kappa 11+4 I dont give a shit about the win i dont even care about the money"},
	["PepeHands"] = {lnk = "http://vaati.net/Gachi/sharedshit/Sleep%20-%20tight.mp3", name = "PepeHands BILLY"},
	["home"] = {lnk = "http://vaati.net/Gachi/shared/HOME%20-%20Resonance.mp3", name = "HOME - Resonance"},
	["lasagna"] = {lnk = "http://vaati.net/Gachi/shared/ThePenguinBrother%20-%20MAYLASAGNA.mp3", name = "MAYLASAGNA"}
}
local urlps = {
	["q2f2laugh"] = "https://b.vaati.net/aruc.mp3"
}

util.AddNetworkString("StartMusicStream")
util.AddNetworkString("StopMusicStream")
util.AddNetworkString("playsound")

add("pmus", function(ply, line)
	if not GachiRP then return end 

	if not line or line == "" then

		for k,v in pairs(urls) do
			ply:ConsoleAddText(Color(100,200,100), "  " .. k.." - " .. v.name .. "\n")
		end
		ply:ChatPrint("Music printed to console.")
	end 
	for k,v in pairs(urls) do

		if string.lower(k)==string.lower(line or "") then 

			if ply.IsPlayingMusic then net.Start("StopMusicStream") net.WriteEntity(ply) net.Broadcast() end

			net.Start("StartMusicStream")
				net.WriteString(v.lnk)
				net.WriteString(v.name)
				net.WriteEntity(ply)
				net.WriteBool(false)
			net.Broadcast()
			ply:ChatPrint("Playing "..v.name.."...")
			ply.IsPlayingMusic = true
		end

	end

end, true, false, "admin")
add("clmus", function(ply, line)
	if not GachiRP then return end
	if not line or line == "" then

		for k,v in pairs(urls) do
			ply:ConsoleAddText(Color(100,200,100), "  " .. k.." - " .. v.name .. "\n")
		end
		ply:ChatPrint("Music printed to console.")
	end 

	for k,v in pairs(urls) do

		if string.lower(k)==string.lower(line or "") then 

			if ply.IsPlayingMusic then net.Start("StopMusicStream") net.WriteEntity(ply) net.Broadcast() end

			net.Start("StartMusicStream")
				net.WriteString(v.lnk)
				net.WriteString(v.name)
				net.WriteEntity(ply)
				net.WriteBool(true)
			net.Send(ply)
			ply:ChatPrint("Playing "..v.name.." for you only...")
			ply.IsPlayingMusic = true
		end

	end

end, true, false, "admin")

add("stopmus", function(ply)
	if not GachiRP then return end
	if ply.IsPlayingMusic then ply:ChatPrint("Stopping...") net.Start("StopMusicStream") net.WriteEntity(ply) net.Broadcast() end

end, true, false, "admin")

end)