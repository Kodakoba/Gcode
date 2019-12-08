easylua.StartEntity("title_npc")
include('shared.lua')
 ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Gwa"
ENT.Author			= "Gwa"
ENT.Contact			= "Gwa"
ENT.Purpose			= "Gwa"
ENT.Instructions	= "Gwa"

function ENT:Draw()
  self:DrawModel()
end

local function LC(col, dest, vel)
	local v = 10
	if not IsColor(col) or not IsColor(dest) then return end
	if isnumber(vel) then v = vel end
	local r = Lerp(FrameTime()*v, col.r, dest.r)
	local g = Lerp(FrameTime()*v, col.g, dest.g)
	local b = Lerp(FrameTime()*v, col.b, dest.b)
	return Color(r,g,b)
end

local function L(s,d,v)
	if not v then v = 5 end
	if not s then s = 0 end
	return Lerp(FrameTime()*v, s, d)
end

local tags = {
	[" <emote=forsenCD, 16, 16> Emotes"] = "The alligning in this menu is a little scuffed; the emotes are alligned better on actual titles.\nPromise.",
	["<color=20,255,20>Colored Text(RGB)</color>"] = "Formatted as RGB.(for example, 20 = Red, 255 = Green, 20 = Blue)",
	["<translate=[rand()*10],[rand()*10]>Shaky Text</translate>"] = "You can do lua expressions in squared brackets([2+2], [50+sin(time()*2)*20], etc.)",
	["<hsv=[t()*120]>Rainbow Text</hsv>"] = true,

}

surface.CreateFont( "PanelLabel", {
	--font = "Titillium Web SemiBold",
	font = "Titillium Web SemiBold",
	size = 30,
	weight = 200,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local gradup = Material("vgui/gradient_up")
local graddn = Material("vgui/gradient_down")
surface.CreateFont("A36", {
        font = "Arial",
        size = 36,
        weight = 600
})

surface.CreateFont("A24", {
        font = "Arial",
        size = 24,
        weight = 400
})

function OpenTitleMenu()
	local f = vgui.Create("DFrame")

	--timer.Simple(15, function() f:Remove() end)
	f:SetSize(800, 600)
	f:Center()
	f:SetTitle("")
	--f.RBRadius = 8
	--f.Shadow = {}
	f.Label = "Select your title"
	--f.Icon = {mat=Material("vgui/prestige/health.png"), w=24, h=24}
	--f:InitPanel()
	f:MakePopup()
	f:SetDraggable(false)

	local allowed = true--LocalPlayer():GetNWBool("TitleAccess", false)

	function f:Paint(w,h)
			
		local hc =  Color(40, 170, 245)
		local bg = Color(50, 50, 50)

		local label = "Choose your title"

		local x,y = 0, 0

		local hh = 30

		draw.RoundedBoxEx(8, x, y, w, hh, hc, true, true)
		draw.RoundedBoxEx(8, x, y+hh, w, h-hh, bg, false, false, true, true)

		local xoff = 16

		draw.SimpleText(label, "PanelLabel", x+xoff, y, Color(255,255,255), 0, 2)
		if not allowed then 
			draw.RoundedBox(8, x, y, w, h, Color(10, 10, 10, 230))
			draw.SimpleText("You have no access to titles!","A36",w/2, h/2, Color(255, 255, 255), 1, 1)
			draw.SimpleText("If you believe you should, contact Splen or Gachi.", "A24", w/2, h/2 + 28, Color(255, 255, 255), 1, 1)
		end
	end

	if not allowed then return end 

	local mdl = vgui.Create("DPanel", f)
	mdl:SetSize(800*0.9, 150)
	mdl:SetPos(40, 64)
	mdl.wid = 0
	local me = LocalPlayer()
	
	local te = vgui.Create("DTextEntry", f)
	te:SetSize(600, 48)
	te:SetPos(100, 256)
	te:SetFont("PanelLabel")
	
	te.AllowInput = function( self, stringValue )
		if not allowed then return true end
		return false
	end
	te.Paint = function(self, w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(40, 40, 40))
		self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end
	local ok = vgui.Create("DButton", f)

	function mdl:Paint(w,h)
		surface.DisableClipping(true)
			draw.RoundedBox(8, w/2 - self.wid/2 , 0, self.wid, h, Color(40, 40, 40))

			local wid, err = Titles.DrawNonPlayer(te:GetValue() or "", team.GetColor(me:Team()), LocalPlayer():Nick(),  self, 800*0.45, 100)
			self.wid = math.max(wid+60, w)

			if err then 
				draw.SimpleText("Error: "..err, "PanelLabel", w/2, h+24, Color(250, 50, 50), 1, 1)
			end

			if #te:GetValue() > 2 and #te:GetValue() < 128 and not err then ok.ActuallyOK = true else ok.ActuallyOK = false end
		surface.DisableClipping(false)
	end

	
	ok:SetPos(400 - 75, 500)
	ok:SetSize(150, 50)
	ok:SetText("")
	ok.ActuallyOK = false
	ok.Col = Color(50, 120, 50)
	function ok:Paint(w,h)
		self.Col = LC(self.Col, (self.ActuallyOK and Color(150, 255, 150)) or Color(50, 120, 50))
		draw.RoundedBox(8, 0, 0, w, h, self.Col)
	end
	ok.DoClick = function()
		net.Start("GiveMeMyTitle")
			net.WriteString(te:GetValue())
		net.SendToServer()
	end
	local help = vgui.Create("DButton", f)
	help:SetSize(48,48)
	help:SetPos(800 - 72, 520)
	help:SetText("")

	function help:Paint(w,h)
		draw.RoundedBox(8, 0, 0, w, h, Color(30, 30, 30))
		draw.SimpleText("?", "PanelLabel", w/2, h/2, Color(255,255,255), 1, 1)
	end
	local finmove = false 
	local helpOpen = false 
	local hf 
	local function CreateHelpWindow()

		if not helpOpen then 
			hf = vgui.Create("DPanel")
			hf:SetSize(300, 600)
			hf:SetDragParent(help)
			hf:MoveRightOf(f, 12)
			hf:MoveBelow(f, -f:GetTall())
			hf:SetAlpha(0)
			local x, y = f:GetPos()

			f:MoveTo(x-120, y, 0.3, 0, -1,function() hf:AlphaTo(255, 0.15, 0) end)

			local A = 0

			function hf:Paint(w, h)

				if not IsValid(f) then self:Remove() return end 

				if finmove then 	
					A = L(A, 255, 25)
				else
					A = L(A, 0, 25)
				end

				--self.HeaderColor = Color(40, 170, 245, math.ceil(A))
				--self.BackgroundColor = Color(50, 50, 50, math.ceil(A))

				hf:MoveRightOf(f, 12)
				hf:MoveBelow(f, -f:GetTall())

				local hc =  Color(40, 170, 245)
				local bg = Color(50, 50, 50)

				local x,y = 0, 0

				local hh = 30

				draw.RoundedBoxEx(8, x, y, w, hh, hc, true, true)
				draw.RoundedBoxEx(8, x, y+hh, w, h-hh, bg, false, false, true, true)

			end
			local Y = 36

			for k,v in pairs(tags) do 
				local tagbtn = vgui.Create("DButton", hf)

				tagbtn:SetPos(0, Y)
				Y = Y+56
				tagbtn:SetSize(300, 48)
				tagbtn:SetText("")
				tagbtn:SetAlpha(255)
				tagbtn.A = 255
				tagbtn.A2 = 0

				function tagbtn:Paint(w,h)
					surface.SetMaterial(graddn)
					surface.SetDrawColor(Color(30, 30, 30))
					surface.DrawTexturedRect(0, 0, w, 4)
					surface.DisableClipping(true)
					surface.SetMaterial(gradup)
					surface.DrawTexturedRect(0, h, w, 4)
					surface.DisableClipping(false)
					
					if self:IsHovered() then 
						draw.DrawText(k, "Default", w/2, h/2, Color(200, 200, 200), 1, 1)
					else
						Titles.DrawNonPlayer(k, Color(200, 200, 200), nil,  self, w/2, h/2, "PanelLabel")
					end
					
				end
				tagbtn.DoClick = function() 
					if IsValid(te) then 
						te:SetValue(te:GetValue() .. k)
					end

				end
				tagbtn:SetTooltip((isstring(v) and v) or false)
			end

			helpOpen = true
		else 
			local x, y = f:GetPos()
			finmove=false
			f:MoveTo(x+120, y, 0.3, 0, -1,function() finmove = false hf:Remove() end)
			hf:AlphaTo(0, 0.1, 0)
			helpOpen = false
		end

	end


	help.DoClick = function()
		CreateHelpWindow()
	end

end

net.Receive("OpenTitleMenu", OpenTitleMenu)
easylua.EndEntity()