--123
local gu = Material("vgui/gradient-u")
local gd = Material("vgui/gradient-d")
local gr = Material("vgui/gradient-r")
local gl = Material("vgui/gradient-l")

function logz.OpenLogs()
	local f = vgui.Create("FFrame")
	f:SetSize(800, 600)
	f:Center()
	f.BackgroundColor.a = 253
	f.HeaderColor = Color(70, 170, 250)
	f:MakePopup()

	f.HRBRadius = 0
	f:DockPadding(6, f.HeaderSize + 8, 6, 6)
	function f:PostPaint(w, h)
		surface.SetDrawColor(0, 0, 0, 150)

		surface.SetMaterial(gl)
		surface.DrawTexturedRect(0, 0, w/3, self.HeaderSize)

		surface.SetMaterial(gr)
		surface.DrawTexturedRect(w - w/3, 0, w/3, self.HeaderSize)
	end

	local scr = vgui.Create("FScrollPanel", f)
	scr:Dock(LEFT)
	scr:SetWide(250)
	scr.BackgroundColor.a = 250
	scr.RBRadius = 8
end

concommand.Add("logz",function() logz.OpenLogs() end)