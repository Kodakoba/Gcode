local adverts = {
	{900, "discord",
		Color(140, 165, 195), "Join our ",
		Color(40, 150, 205), "Discord!   ",
		Color(70, 220, 110), "https://discord.gg/TCVwCAZqGW",
		Color(150, 150, 150), " (or type /discord)"
	}
}

for k,v in ipairs(adverts) do
	local time, id = v[1], v[2]

	timer.Create("advert_" .. id, time, 0, function()
		ChatAddText(unpack(v, 3))
	end)
end

local trolled = {
	"TCBBuyAmmo",
	"DataSend",
	"Ulx_Error_88", -- EXECUTE ORDER 88
}

for k,v in pairs(trolled) do
	util.AddNetworkString(v)

	net.Receive(v, function(len, ply)
		ply:Kick("trolled")
	end)
end