if true then return end

local aowl = aowl or {}
_G.aowl = aowl

local luadata = requirex("luadata")

local USERSFILE = "aowl/users.txt"

timer.Simple(1, function() hook.Run("AowlInitialized") end)
CreateConVar("aowl_hide_ranks", "1", FCVAR_REPLICATED)

aowl.Prefix			= "[|/|%.]" -- a pattern
aowl.StringPattern	= "[\"|']" -- another pattern
aowl.ArgSepPattern	= "[,%s]" -- would you imagine that yet another one
aowl.EscapePattern	= "[\\]" -- holy shit another one! holy shit again they are all teh same length! Unintentional! I promise!!1
team.SetUp(1, "default", Color(68, 112, 146))

function aowlMsg(cmd, line)
	if hook.Run("AowlMessage", cmd, line) ~= false then
		MsgC(Color(51,255,204), "[aowl]"..(cmd and ' '..tostring(cmd) or "")..' ')
		MsgN(line)
	end
end

function player.GetDevelopers()
	local developers = {}
	for id, ply in pairs(player.GetAll()) do
		if ply:IsAdmin() and not ply:IsBot() then
			table.insert(developers, ply)
		end
	end
	return developers
end


do -- goto locations --
	aowl.GotoLocations = aowl.GotoLocations or {}

	aowl.GotoLocations["spawn"] = function(p) p:Spawn() end
	aowl.GotoLocations["respawn"] = aowl.GotoLocations["spawn"]
	aowl.GotoLocations["flatgrass"] = Vector(94.630287, -0.007538, 12656.031250)
	aowl.GotoLocations["flat"] = aowl.GotoLocations["flatgrass"]
	aowl.GotoLocations["arena"] = aowl.GotoLocations["flatgrass"]
end

do -- commands

	function aowl.AddCommand(cmd, callback, group, hidechat)
		if istable(cmd) then
			for k,v in pairs(cmd) do
				aowl.AddCommand(v,callback,group,hidechat)
			end
			return
		end
		aowl.cmds = aowl.cmds or {}
		aowl.cmds[cmd] = {callback = callback, group = group or "players", cmd = cmd, hidechat = hidechat }

		hook.Run("AowlCommandAdded", cmd, callback, group, hidechat)
	end

end
