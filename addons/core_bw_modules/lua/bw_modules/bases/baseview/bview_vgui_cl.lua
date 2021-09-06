local bw = BaseWars.Bases
local bv = bw.BaseView

-- initial GUI open; no panels exist
function bv.OpenGUI(cont)
	local panels = cont:GetVGUI() 	
	local scale = ScrH() / 768
	local dzX, dzY = ScrW() * 0.05, ScrH() * 0.05 --deadzones

	local canv = vgui.Create("InvisPanel")
	cont:SetVGUI(canv)
		canv:Dock(LEFT)
		canv:SetWide(scale * 600 + dzX * 2)
		canv:MakePopup()

	function canv:Exit()
		self:Remove()
		cont:SetVGUI(nil)
	end

	local close = vgui.Create("FButton", canv)
		close:Dock(BOTTOM)
		close:DockMargin(dzX, 0, dzX, dzY)
		close:SetColor(Colors.Reddish)
		close.Label = "Exit"
		close.Font = "OSB32"

	function close:DoClick()
		canv:Exit()
	end

	local f = vgui.Create("NavPanel", canv)
		f:SetWide(scale * 600, scale * 400)
		f:SetPos(-f:GetWide(), ScrH() * 0.05)
		f:To("X", ScrW() * 0.05, 0.4, 0, 0.3)

end