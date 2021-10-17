--

net.Receive("OpenDiscord", function()
	local dh = vgui.Create("DHTML")
	dh:SetSize(1, 1)
	dh:OpenURL(BaseWars.Config.DiscordLink)
end)