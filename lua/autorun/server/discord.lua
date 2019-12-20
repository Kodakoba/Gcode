require("bromsock");

discord = discord or {}

dissocket = dissocket or BromSock()


local log
local logtbl = {name = "Discord Relay", col = Color(40, 135, 255)}

if Modules and Modules.Log then 
	log = function(str, ...)
		Modules.Log(logtbl, str:format(...))
	end

	discord.Log = log 
end

hook.Add("PostGamemodeLoaded", "inventory_log", function()

	log = function(str, ...)
		Modules.Log(logtbl, str:format(...))
	end

	discord.Log = log 

end)

local socket = dissocket

local port = 27020
local pingport = 27025

local silence = false 

local function writeline(line)
	local packet = BromPacket()
	packet:WriteLine(line)
	socket:Send(packet, true)

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

    discord.Send("chat", ply:Nick(), msg)

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
ChainAccessor(EmbedMeta, "title", "Name")

function EmbedMeta:SetText(txt, ...)
	self.description = txt:format(...)
	return self
end

EmbedMeta.SetDescription = EmbedMeta.SetText

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



local db = mysqloo and mysqloo.GetDB()

hook.Add("OnMySQLReady", "Discord", function()
	db = mysqloo.GetDB() 
end)



function discord.GetChannels(mode, cb)
	local q = "SELECT whook_url FROM `botto`.`relays` WHERE json_search(`modes`, 'one', '%s') IS NOT NULL"
	q = q:format(db:escape(mode))

	local q = db:query(q)

	q.onSuccess = function(self, dat)
		local urls = {}

		if not dat[1] then return end --no relays listening for this mode 

		for k,v in pairs(dat) do 
			urls[#urls + 1] = v.whook_url
		end

		cb(urls)
	end

	q.onError = function(self, err, sql)
		log("Error on attempting to get channels.\nError: %s\nSQL: %s", err, sql)
	end

	q:start()
end
function discord.Send(mode, name, txt)
	
	local function callback(urls)

		http.Post("https://vaati.net/Gachi/shit.php", { 
			name = name or "GachiRP",
			api = "disrelay",
			p = txt,
			json = "y",
			chan = util.TableToJSON(urls),
		})

	end

	discord.GetChannels(mode, callback)

end 

BlankFunc = function(...) end 

function discord.SendEmbed(mode, name, t, cb, fail)
	local em

	if t.IsEmbed then
		em = {t} 
	else 
		em = t 
	end

	local function callback(urls)
		http.Post("https://vaati.net/Gachi/shit.php", { 
			name = name or "GachiRP",
			api = "disrelay",
			json = "y",
			chan = util.TableToJSON(urls),
			embeds = util.TableToJSON(em),
		}, cb or BlankFunc, fail or BlankFunc)
	end

	discord.GetChannels(mode, callback)
end


discord.Notified = discord.Notified or false 

hook.Add("Tick", "ServerNotify", function()

	if discord.Notified then return end 
	print("LULW NO")
	RunConsoleCommand("sv_hibernate_think", 1)

	local quip 
	
	while quip == nil do 
		quip = eval(quips[math.random(#quips)])
	end

	discord.Notified = true

	timer.Simple(1, function()
		local em = Embed()

		em:SetTitle("Server is now online!")
		:SetDescription(quip .. "\n\nJoin @ steam://connect/" .. game.GetIPAddress() .. " !")
		:SetColor(Color(100, 230, 100))

		discord.SendEmbed("status", nil, em, function(...)
			RunConsoleCommand("sv_hibernate_think", 0)
		end, function(...)
			RunConsoleCommand("sv_hibernate_think", 0)
		end)
		
	end)

end)

hook.Add("ShutDown", "ServerNotify", function()

	local quip 

	while quip == nil do 
		quip = eval(offquips[math.random(#offquips)])
	end

	local em = Embed()
	em:SetTitle("Server is now offline."):SetDescription(quip):SetColor(Color(230, 70, 70))

	discord.SendEmbed("status", nil, em)
end)


--https://discordapp.com/api/webhooks/625254274342977546/6BQv2nJ5wz8g0bHWQIkVTmC64t9uBBqFIbHVFGBbdtL6fJ0T7BtbD4rt9j_tao6Sc2xs

function discord.SendTo(chan, name, text, embeds)


end