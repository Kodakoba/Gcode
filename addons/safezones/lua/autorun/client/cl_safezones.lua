--
print('obama')
local st = 0

local mata = 0
local txta = 0


local mat = Material("data/hdl/stripes.png", "noclamp smooth")

local gu = Material("vgui/gradient-u")
local gd = Material("vgui/gradient-d")
local gr = Material("vgui/gradient-r")
local gl = Material("vgui/gradient-l")

local icona = 0
local warncol = Color(230, 200, 30)
local lasttxt = ""

hook.Add("HUDPaint", "SafeZone", function()
	local safe = LocalPlayer():GetNWFloat("Safezone", 0)
	if safe > 0 then 
		mata = L(mata, 250, 20, true)
	else 
		mata = L(mata, 0, 10, true)
	end 

	
	if mata <= 1 then return end 

	local fr = (CurTime()*0.05)%0.5

	surface.SetDrawColor(50, 50, 50, mata)
	surface.DrawRect(ScrW()/2 - 300, 75, 600, 100)

	surface.SetDrawColor(0, 0, 0, mata)
	surface.SetMaterial(gl)
	surface.DrawTexturedRect(ScrW()/2 - 300, 75, 16, 100)

	surface.SetMaterial(gr)
	surface.DrawTexturedRect(ScrW()/2 + 300 - 16, 75, 16, 100)

	local x, y = ScrW()/2 - 300, 75
	local w, h = 600, 100
	local txt = "??? forsenE"
	local issafe = false 
	local txx = 0

	if CurTime() - safe < 5 and CurTime() - safe > 0 then
		icona = 200 + math.sin(CurTime()*25)*100 
		warncol = LC(warncol, Color(230, 200, 30, mata), 15)
		txt = ("You will be safe in %s seconds."):format(5 - math.Round(CurTime() - safe))
	elseif CurTime() - safe > 5 and safe ~= 0 then
		icona = L(icona, 0, 25, true)
		warncol = LC(warncol, Color(70, 230, 70, mata), 15)
		txt = "You are under protection."
		issafe = true
	else 
		icona = L(icona, 0, 25, true)
		warncol = LC(warncol, ColorAlpha(warncol, icona), 15)
		txt = lasttxt
	end

	lasttxt = txt
	surface.SetDrawColor(255, 255, 255, icona)
	surface.DrawMaterial("https://i.imgur.com/Xq0xmuF.png", "unsafe.png", x + 64, y + 18, 64, 64)

	render.SetScissorRect(ScrW()/2 - 300, 18, ScrW()/2 + 300, 200, true)
		
		surface.SetDrawColor(warncol)
		surface.DrawRect(x, y - 18, w, 18)
		surface.DrawRect(x, y + h, w, 18)

		surface.SetDrawColor(0, 0, 0, mata)
		surface.SetMaterial(gl)
		surface.DrawTexturedRect(x, y - 18, 16, 18)
		surface.DrawTexturedRect(x, y + h, 16, 18)

		surface.SetMaterial(gr)
		surface.DrawTexturedRect(x + w - 16, y - 18, 16, 18)
		surface.DrawTexturedRect(x + w - 16, y + h, 16, 18)

		surface.SetMaterial(mat)
		surface.SetDrawColor(255, 255, 255, mata)
		surface.DrawUVMaterial("https://i.imgur.com/GBGbyCn.png", "stripes.png", x, y - 18, w, 18, 0 - fr, 0, 1 - fr, 0.05)
		surface.DrawUVMaterial("https://i.imgur.com/GBGbyCn.png", "stripes.png", x, y + h, w, 18, fr, 0, 1 + fr, 0.05)

	render.SetScissorRect(0,0,0,0,false)

	draw.SimpleText(txt, "OS28", ScrW()/2 + txx, y + h/2, Color(255, 255, 255, mata), 1, 1)
end)