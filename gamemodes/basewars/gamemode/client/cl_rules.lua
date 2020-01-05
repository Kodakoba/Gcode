


local loaded = false 

function ulx.showMotdMenu( steamid )
	loaded = false

	local window = vgui.Create( "FFrame" )
	window:SetSize(600, 400)
	window:Center()
	window:MakePopup()
	window.Shadow = {}
	
	function window:PostPaint(w, h)
		draw.SimpleText("ATTENTION! ALL EPIC GAMERS", "TWB36", w/2, self.HeaderSize, color_white, 1, 5)

		draw.DrawText("We are currently playtesting. Expect bugs, and, please,\nbreak it as much as possible.", "OS24", 16, self.HeaderSize + 48, color_white, 0, 5)
		draw.SimpleText("Thankssssssssssss", "OS18", 16, self.HeaderSize + 108, color_white, 0, 5)
	end

	local close = vgui.Create("FButton", window)
	close.Label = "okay fine"
	close:SetSize(200, 60)
	close:Center()
	close:CenterVertical(0.8)
	close:SetColor(50, 150, 250)

	close.DoClick = function()
		window:Remove()
	end

end

function ulx.rcvMotd( mode_, data )
	--fuck off ulx
end