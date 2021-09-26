
function ulx.showMotdMenu( steamid )

	local window = vgui.Create( "FFrame" )
	window:SetSize(500, 300)
	window:Center()
	window:MakePopup()
	window.Shadow = {}

	window.Y = window.Y - 48
	window:MoveBy(0, 48, 0.3, 0, 0.3)
	window:PopIn()

	local ruleFont = "OS20"
	local th = draw.GetFontHeight(ruleFont)

	function window:PostPaint(w, h)
		local y = self.HeaderSize
		local _, hth = draw.SimpleText("Rules of the land:", "OSB36", w/2, y, color_white, 1, 5)
		y = y + hth

		draw.DrawText("1. Don't cheat.", ruleFont, 16, y, color_white, 0, 5)
		y = y + th

		draw.DrawText("2. Don't try to crash the server.", ruleFont, 16, y, color_white, 0, 5)
		y = y + th
		--draw.SimpleText("Thankssssssssssss", "OS18", 16, self.HeaderSize + 108, color_white, 0, 5)
	end

	local close = vgui.Create("FButton", window)
	close.Label = "okay fine"
	close:SetSize(180, 40)
	close:Center()
	close.Y = window:GetTall() - close:GetTall() - 16
	close:SetColor(50, 150, 250)

	function window:OnClose()
		self:MoveBy(0, 48, 0.2, 0, 3.2)
		self:PopOut(0.2)
		self:SetInput(false)
		return false
	end

	close.DoClick = function()
		window:OnClose()
	end

end

function ulx.rcvMotd( mode_, data )
	--fuck off ulx
end