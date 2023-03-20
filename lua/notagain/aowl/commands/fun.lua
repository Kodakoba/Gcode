aowl.AddCommand("fov",function(pl,_,fov,delay)
	fov=tonumber(fov) or 90
	fov=math.Clamp(fov,1,350)
	pl:SetFOV(fov,tonumber(delay) or 0.3)
end, "developers")

aowl.AddCommand({"name","nick","setnick","setname","nickname"}, function(player, line, target, name2)
    --target = (target and name and easylua.FindEntity(target)) or player
    name = ((isstring(target) and isstring(name2)) and name2) or target
    target = (name2==name and easylua.FindEntity(target)) or player
    if not IsValid(target) or not target:IsPlayer() then return false,"no player found" end
	if name then
		if (isstring(name) and #name>40) then
			return false,"my god what are you doing"
		end
	end

	timer.Create("setnick"..target:UserID(),1,1,function()
		if IsValid(target) then
			target:SetNick(name)
		end
	end)
end, "admin", true)

aowl.AddCommand("bot",function(pl,cmd,what,name)
	if not what or what=="" or what=="create" or what==' ' then

		game.ConsoleCommand"bot\n"
		hook.Add("OnEntityCreated","botbring",function(bot)
			if not bot:IsPlayer() or not bot:IsBot() then return end
			hook.Remove("OnEntityCreated","botbring")
			timer.Simple(0,function()
				local x='_'..bot:EntIndex()
				aowl.CallCommand(pl, "bring", x, {x})
				if name and name~="" and bot.SetNick then
					bot:SetNick(name)
				end
			end)
		end)

	elseif what=="kick" then
		for k,v in pairs(player.GetBots()) do
			v:Kick"bot kick"
		end
	elseif what=="zombie" then
		game.ConsoleCommand("bot_zombie 1\n")
	elseif what=="zombie 0" or what=="nozombie" then
		game.ConsoleCommand("bot_zombie 0\n")
	elseif what=="follow" or what=="mimic" then
		game.ConsoleCommand("bot_mimic "..pl:EntIndex().."\n")
	elseif what=="nofollow" or what=="nomimic" or what=="follow 0" or what=="mimic 0" then
		game.ConsoleCommand("bot_mimic 0\n")
	end
end,"developers")

aowl.AddCommand("nextbot",function(pl,cmd,name)
	local bot=player.CreateNextBot(name or "nextbot")

	local x='_'..bot:EntIndex()
	aowl.CallCommand(me, "bring", x, {x})
end,"developers")

--[[aowl.AddCommand({"hp", "health"}, function(ply, line, amnt, target)
	target = target and easylua.FindEntity(target) or nil

	if not IsValid(target) or not target:IsPlayer() then
		target = ply
	end

	target:SetHealth(tonumber(amnt) or target:GetMaxHealth())
end, "mods")]]


aowl.AddCommand({"title", "settitle"}, function(ply, line, target, title, rarted)
	target = target and easylua.FindEntity(target) or nil
	if rarted then ply:ChatPrint('Seclude the title in quotes! ("")') return false, "read chat" end
	if not title then ply:ChatPrint('Usage: .title *player* "title"') return false, "Read chat" end
	if not IsValid(target) or not target:IsPlayer() then
		target = ply
	end
	if #title > 250 then ply:ChatPrint("More than 250 chars!") return end
	target:SetTitle(title)
end, "developers")


aowl.AddCommand({"kill", "slay", "gameend"}, function(ply, line, target)
	target = target and easylua.FindEntity(target) or nil

	if not IsValid(target) or not target:IsPlayer() then return end
	target:Kill()
end, "developers")