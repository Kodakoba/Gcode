require("bromsock");

discord = {}

dissocket = dissocket or BromSock()

local socket = dissocket

local port = 27020
local pingport = 27025

local silence = false 

local function writeline(line)
	local packet = BromPacket()
	packet:WriteLine(line)
	socket:Send(packet, true)
	
	print("IRC WROTE: " .. line)
end

local function socketConnect(sock, connected, ip, port)

	if (not connected) then
		msg = "Unable to connect to Discord relay @ %s:%s.\n"
		msg = msg:format(ip, port)

		if not silence then MsgC(Color(250, 100, 100), msg) end

		return
	end

	msg = "Connected to Discord relay @ %s:%s!\n"
	msg = msg:format(ip, port)

	if not silence then MsgC(Color(100, 250, 100), msg) end

	socket:ReceiveUntil("\r\n");
end
socket:SetCallbackConnect(socketConnect);

local function sockDisconnect(sock)
	MsgC(Color(250, 100, 100), "Disconnected from IRC server.\nType discord_reconnect or DiscordReconnect() to attempt reconnection.\nRight now, listening for messages.")
	sock:Listen("127.0.0.1", pingport)
	sock:SetCallbackConnect(socketConnect)
end
socket:SetCallbackDisconnect(sockDisconnect);

local function socketReceive(sock, packet)

	local full = packet:ReadLine():Trim()
	local r, g, b = full:match("(%d+),(%d+),(%d+)|")
	r, g, b = tonumber(r), tonumber(g), tonumber(b)

	full = full:gsub("%d+,%d+,%d+|", "")

	local col = Color(r, g, b)

	local name = full:match("(.+[^\\|])|")

	full = full:gsub("(.+[^\\|])|", "")

	ChatAddText(Color(70, 110, 220), "[Discord] ", col, name, Color(230, 230, 230), ": " .. full)
	MsgC(Color(70, 110, 220), "[Discord] ", col, name, Color(230, 230, 230), ": " .. full .. "\n")

	socket:ReceiveUntil("\r\n")
end

socket:SetCallbackReceive(socketReceive);



function DiscordReconnect()

	socket:Close()

	socket:Connect("127.0.0.1", port)

end

concommand.Add("discord_reconnect", function(ply) 
	if IsValid(ply) and not ply:IsSuperAdmin() then return end 
	DiscordReconnect()
end)

hook.Add("PlayerSay", "Discord", function(ply, msg) 

    if msg[1]=="." then 
        local cmd = msg:match("%.(.-)[%s]") 
        if aowl.cmds[cmd] then return end 
    end 

    discord.Send(ply:Nick(), msg)

end)

local quips = {
	"ah shit here we go again",
	"did i forget to do something there?",
	"welp time to break another dozen features which were working perfectly fine...",
	"probably just gonna stand afk for 20 minutes before deciding i don't wanna hop on after all",
	"time to spend 3 days coding in some useless shit"
}

local offquips = {
	"\"yup, i'm done\"",
	"at least it wasn't a crash",

	function()
		local t = os.date("*t")

		if t.hour > 21 or t.hour < 6 then 
			return ("it's getting pretty late (%s:%s)"):format(t.hour, t.min)
		end 

	end, 

	"another mechanic successfully ruined",
	"now 20% more errors than the last time!"
}

Embed = {}

EmbedMeta = {}
EmbedMeta.IsEmbed = true

EmbedMeta.__index = EmbedMeta 

ChainAccessor(EmbedMeta, "title", "Title")

ChainAccessor(EmbedMeta, "description", "Description")
ChainAccessor(EmbedMeta, "description", "Text")

function EmbedMeta:SetColor(col, g2, b2)
	local r, g, b 

	if IsColor(col) then 
		r, g, b = col.r, col.g, col.b
	else
		r, g, b = col, g2, b2 
	end

	self.color = bit.lshift(r, 16) + bit.lshift(g, 8) + b

	return self
end

function EmbedMeta:GetColor()
	return Color(bit.rshift(self.color, 16), bit.rshift(self.color % 2^16, 8), self.color % 2^8)
end
function Embed:new()
	local t = {}
	setmetatable(t, EmbedMeta)

	return t
end


Embed.__call = Embed.new

setmetatable(Embed, Embed)

function discord.Send(name, txt)
	
	http.Post("https://vaati.net/Gachi/shit.php", { 
		name = name or "GachiRP",
		api = "disrelay",
		p = txt,
	})

end 

function discord.SendEmbed(name, t)
	local em

	if t.IsEmbed then
		em = {t} 
	else 
		em = t 
	end

	print("send eet")

	http.Post("https://vaati.net/Gachi/shit.php", { 
		name = name or "GachiRP",
		api = "disrelay",
		embeds = util.TableToJSON(em)
	})

end

discord.Notified = false 

hook.Add("OnGamemodeLoaded", "ServerNotify", function()

	if discord.Notified then return end 

	local quip 
	
	while quip == nil do 
		quip = eval(quips[math.random(#quips)])
	end
	discord.Notified = true

	timer.Simple(15, function()
		local em = Embed()

		em:SetTitle("Server is now online!")
		:SetDescription(quip .. "\n\nJoin @ steam://connect/" .. game.GetIPAddress() .. " !")
		:SetColor(Color(100, 230, 100))

		discord.SendEmbed(nil, em)
	end)

end)

hook.Add("ShutDown", "ServerNotify", function()

	local quip 

	while quip == nil do 
		quip = eval(offquips[math.random(#offquips)])
	end

	local em = Embed()
	em:SetTitle("Server is now offline."):SetDescription(quip):SetColor(Color(230, 70, 70))

	discord.SendEmbed(nil, em)
end)


--https://discordapp.com/api/webhooks/625254274342977546/6BQv2nJ5wz8g0bHWQIkVTmC64t9uBBqFIbHVFGBbdtL6fJ0T7BtbD4rt9j_tao6Sc2xs

function discord.SendTo(chan, name, text, embeds)


end