require("bromsock");

dissocket = dissocket or BromSock()

local socket = dissocket

local port = 27020
local pingport = 27025

local silence = false 

print("Initializing discord...")

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

    http.Post("https://vaati.net/Gachi/shit.php", {
    	p = msg, 
    	name = ply:Nick()
    }) 

end)
