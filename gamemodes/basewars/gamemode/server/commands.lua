BaseWars.Commands = {
	cmds = {},
}

if ulx or ulib then
	BaseWars.Commands.Pattern = "[/|%.]"
else
	BaseWars.Commands.Pattern = "[!|/|%.]"
end

function BaseWars.Commands.ParseArgs(str)

	local ret 		= {}
	local InString 	= false
	local strchar 	= ""
	local chr 		= ""
	local escaped 	= false

	for i=1, #str do

		local char = str[i]

		if escaped then

			chr = chr..char
			escaped = false

		continue end

		if char:find("[\"|']") and not InString and not escaped then

			InString 	= true
			strchar 	= char

		elseif char:find("[\\]") then

			escaped 	= true

			continue

		elseif InString and char == strchar then

			ret[#ret+1] = chr:Trim()
			chr 		= ""
			InString 	= false

		elseif char:find("[ ]") and not InString and chr ~= "" then

			ret[#ret+1] = chr
			chr 		= ""

		else
			chr = chr .. char

		end

	end

	if chr:Trim():len() ~= 0 then

		ret[#ret+1] = chr

	end

	return ret

end

function BaseWars.Commands.CallCommand(ply, cmd, line, args)

	MsgC(Color(240, 50, 50), "[BW] Command ", Color(255, 255, 255), ply, " -> ", Color(220, 220, 220), cmd .. (line or "") , "\n")

	local ok, msg = pcall(function()

		local allowed, reason = hook.Run("BaseWarsCommand", cmd, ply, line, unpack(args))

		cmd = BaseWars.Commands.cmds[cmd]

		if allowed ~= false then

			if easylua then easylua.Start(ply) end

				allowed, reason = cmd.CallBack(ply, line, unpack(args))

			if easylua then easylua.End() end

		end

		if ply.IsValid() then

			if allowed == false then

				ply:EmitSound("buttons/button8.wav")

				if reason then

					ply:SendLua(string.format([[local s = "%s" notification.AddLegacy(s, 1, 4)]], reason))

				end

			end

		end
	end)

	if not ok then

		ErrorNoHalt(msg)

		return msg

	end

end

function BaseWars.Commands.ConCommand(ply, cmd, args, line)

	local Cmd = args[1]
	if not Cmd then return end

	local TblCmd = BaseWars.Commands.cmds[Cmd]
	if not TblCmd then return end

	if not IsValid(ply) or (TblCmd.IsAdmin and not ply:IsAdmin()) then return end

	if ply.IsBanned and ply:IsBanned() and not ply:IsAdmin() then return end

	table.remove(args, 1)

	BaseWars.Commands.CallCommand(ply, Cmd, table.concat(args, " "), args)

end

function BaseWars.Commands.SayCommand(ply, txt, team)

	if not txt:sub(1, 1):find(BaseWars.Commands.Pattern) then return end

	local cmd 	= txt:match(BaseWars.Commands.Pattern .. "(.-) ") or txt:match(BaseWars.Commands.Pattern .. "(.+)") or ""
	local line 	= txt:match(BaseWars.Commands.Pattern .. ".- (.+)")

	cmd = cmd:lower()

	if not cmd then return end

	local TblCmd = BaseWars.Commands.cmds[cmd]
	if not TblCmd then return end

	if not IsValid(ply) or (TblCmd.IsAdmin and not ply:IsAdmin()) then return end

	BaseWars.Commands.CallCommand(ply, cmd, line, line and BaseWars.Commands.ParseArgs(line) or {})

	return ""

end

function BaseWars.Commands.AddCommand(cmd, callback, admin)

	if istable(cmd) then

		for k, v in next, cmd do

			BaseWars.Commands.AddCommand(v, callback, admin)

		end

		return

	end

	BaseWars.Commands.cmds[cmd] 	= {CallBack = callback, IsAdmin = admin, Cmd = cmd}

end

concommand.Add("basewars", BaseWars.Commands.ConCommand)
hook.Add("PlayerSay", "BaseWars.Commands", BaseWars.Commands.SayCommand)

local dist = 128^2
local function Upgradable(ply, ent)

	local Eyes = ply:EyePos()
	local Class = ent:GetClass()

	return IsValid(ent) and Eyes:DistToSqr(ent:GetPos()) < dist and ent.Upgrade

end

local function Upgrade(ply, amt, ent)

	local trace = ply:GetEyeTrace()

	local Ent = ent or trace.Entity
	if not Upgradable(ply, Ent) then return false end

    local amnt=tonumber(amount) or 1
    amnt = math.min(amnt, Ent.MaxLevel or 1)
   
    for i=1, amnt do 
		local ok = Ent:Upgrade(ply)
		if ok==false then break end
	end

end

BaseWars.Commands.AddCommand({"upg", "upgrade", "upgr"}, function(ply, amount)
	Upgrade(ply, amount)
end, false)
util.AddNetworkString("BW.Upgrade")
net.Receive("BW.Upgrade", function(len, ply)

	local ent = net.ReadEntity()
	if not Upgradable(ply, ent) then return end 
	Upgrade(ply, 1, ent) --no support for multiple amounts
end)
BaseWars.Commands.AddCommand({"max"}, function(ply)

	local trace = ply:GetEyeTrace()

	local Ent = trace.Entity
	if not Upgradable(ply, Ent) then return false end
    
    for i=1, Ent.MaxLevel - Ent.Level do

		local res = Ent:Upgrade(ply)
		if res==false then break end

	end


end, false)

BaseWars.Commands.AddCommand({"tell", "msg"}, function(ply, line, who)

	if not who then return false, BaseWars.LANG.InvalidPlayer end

	local Targ = easylua.FindEntity(who, true)

	if not BaseWars.Ents:ValidPlayer(Targ) then return false, BaseWars.LANG.InvalidPlayer end

	local Msg = line:sub(#who + 1):Trim()

	Targ:ChatPrint(ply:Nick() .. " -> " .. Msg)

end, false)

BaseWars.Commands.AddCommand("psa", function(ply, line, text)

	if text then

		BroadcastLua([[BaseWars.PSAText = "]] .. line .. [["]])

	else

		BroadcastLua([[BaseWars.PSAText = nil]])

	end

end, true)

BaseWars.Commands.AddCommand({"sell", "destroy", "remove"}, function(ply)

	local trace = ply:GetEyeTrace()

	local ent = trace.Entity
	if not ent.CurrentValue then return false end

	local own = IsValid(ent) and ent.CPPIGetOwner and ent:CPPIGetOwner()
	if own ~= ply then return false end

	if ply:InRaid() then return false end

	BaseWars.UTIL.PayOut(ent, ply)
	ent:Remove()

end, false)

BaseWars.Commands.AddCommand({"sellall"}, function(ply, line, who, amount)

	timer.Simple(15, function()
		
		if not IsPlayer(ply) then return end
		if not BWOwners[ply] then ply:ChatAddText("Something went... wrong?") return end 
		if ply:InRaid() then ply:ChatAddText(Color(50, 150, 250), "Your /sellall command was cancelled because you were raided.") return end
		 

		for k,v in ValidPairs(BWOwners[ply]) do 
			if not v.CurrentValue then continue end

			BaseWars.UTIL.PayOut(v, ply)
			v:Remove()
		end

	end)

	ChatAddText(Color(230, 80, 80), ply:Nick() .. "'s entities will be sold in 15 seconds!")

end, false)

BaseWars.Commands.AddCommand({"dw", "dropwep"}, function(ply)

	local Wep = ply:GetActiveWeapon()

	if IsValid(Wep) then

		local Model = Wep:GetModel()
		local Class = Wep:GetClass()

		if BaseWars.Config.WeaponDropBlacklist[Class] then return false end
		local bkup = {}

		for k,v in pairs(BackupWeaponKeys) do 
			if Wep[v] then 
				bkup[v] = (istable(Wep[v]) and table.Copy(Wep[v])) or Wep[v]
			end
		end

		local tr = {}

		tr.start = ply:EyePos()
		tr.endpos = tr.start + ply:GetAimVector() * 85
		tr.filter = ply

		tr = util.TraceLine(tr)

		local SpawnPos = tr.HitPos + BaseWars.Config.SpawnOffset
		local SpawnAng = ply:EyeAngles()

		SpawnAng.p = 0
		SpawnAng.y = SpawnAng.y + 180
		SpawnAng.y = math.Round(SpawnAng.y / 45) * 45

		local Ent = ents.Create("bw_weapon")
			Ent.WeaponClass = Class
			Ent.Model = Model
			Ent:SetPos(SpawnPos)
			Ent:SetAngles(SpawnAng)
			Ent.Backup = bkup
		Ent:Spawn()
		Ent:Activate()

		ply:StripWeapon(Class)

	end

end, false)

BaseWars.Commands.AddCommand({"steam", "sg", "group"}, function(ply)

	ply:SendLua([[gui.OpenURL"]] .. BaseWars.Config.SteamGroup .. [["]])

end, false)

BaseWars.Commands.AddCommand({"forums", "forum", "f"}, function(ply)

	ply:SendLua([[gui.OpenURL"]] .. BaseWars.Config.Forums .. [["]])

end, false)

BaseWars.Commands.AddCommand({"bounty", "place", "placebounty"}, function(ply, line, who, amount)

	if not who then return false, BaseWars.LANG.InvalidPlayer end

	if not amount then return false, BaseWars.LANG.InvalidAmount end

	local Targ = easylua.FindEntity(who, true)

	if not IsPlayer(Targ) then return false, BaseWars.LANG.InvalidPlayer end

	amt = amount:lower():Trim()
	if amt:match("nan") then return false, "Can't break the system mate" end
	
	amount = tonumber(amount) or 0
	
	if amount <= 0 then return false, false, "Can't break the system mate" end

	local result, error = Targ:PlaceBounty( ply, amount )

	if not result and error then
		return result, error
	end

end, false)


local npc

BaseWars.Commands.AddCommand({"help"}, function(ply, line, who, amount)

	if not IsValid(npc) then 
		for k,v in pairs(ents.FindByClass("bw_npc")) do
			npc = v
		end
	end

	net.Start("BaseWars.NPCs.Menu")
	net.WriteEntity(npc)
	net.Send(ply)
end, false)