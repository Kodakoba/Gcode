local adverts = {
	{900, "discord",
		Color(140, 165, 195), "Join our ",
		Color(40, 150, 205), "Discord!   ",
		Color(70, 220, 110), "https://discord.gg/TCVwCAZqGW"
	}
}

for k,v in ipairs(adverts) do
	local time, id = v[1], v[2]

	timer.Create("advert_" .. id, time, 0, function()
		ChatAddText(unpack(v, 3))
	end)
end