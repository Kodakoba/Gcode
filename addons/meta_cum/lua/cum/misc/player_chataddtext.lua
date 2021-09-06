local Tag = "ChatAddText"
local Tag2 = "ConsoleAddText"
if SERVER then
	util.AddNetworkString(Tag)
	util.AddNetworkString(Tag2)
	local PLAYER = FindMetaTable("Player")

	function PLAYER:ChatAddText(...)
		net.Start(Tag)
			net.WriteTable({...})
		net.Send(self)
	end

	function ChatAddText(...)
		net.Start(Tag)
			net.WriteTable({...})
		net.Broadcast()
	end

	function PLAYER:ConsoleAddText(...)
		net.Start(Tag2)
			net.WriteTable({...})
		net.Send(self)
	end

	function ConsoleAddText(...)
		net.Start(Tag2)
			net.WriteTable({...})
		net.Broadcast()
	end
end

if CLIENT then
	local function receive1()
		local data = net.ReadTable()
		if not istable(data) then return end

		chat.AddText(unpack(data))
	end

	local function receive2()
		local data = net.ReadTable()
		if not istable(data) then return end

		MsgC(unpack(data))
	end

	net.Receive(Tag, receive1)
	net.Receive(Tag2, receive2)
end