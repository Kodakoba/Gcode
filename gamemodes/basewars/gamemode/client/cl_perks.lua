Perks = Perks or {}

local fe = Material("models/props_c17/fisheyelens")
fe:SetFloat("$bluramount", 0.3)
fe:SetFloat("$refractamount", -0.05)

fe:SetFloat("$vertexalpha", 1)
fe:SetInt("$alphatest", 1)

fe:SetInt("$alpha", 1)

fe:Recompute()

local DrawFX = false
local drawOutline = false 
local olA = 200

local gu = Material("vgui/gradient-u")
local gd = Material("vgui/gradient-d")
local gr = Material("vgui/gradient-r")
local gl = Material("vgui/gradient-l")
local dontrender = false 

function Perks.CreatePrestigeFrame(par)
	local f = vgui.Create("InvisPanel", par)
	par:AlignPanel(f)

	f:SetAlpha(0)
	f:AlphaTo(255, 0.1)

	local fw, fh = f:GetSize()
	local me = LocalPlayer()

	local t = CurTime()
	local ft = CurTime()

	local a = {0,0,0,0,0}
	local ts = {0.3, 1.5, 3, 4.6, 6}
	local txs = {

		{txt = "hi", x = fw/2, y = 36},
		{txt = "youre about to prestige", x = fw/2, y = 72},
		{txt = "you know that by now, probably", x = fw/2, y = 108},
		{txt = function()
			if me:GetLevel()~=5000 then 
				return "but you see, mr. " .. string.lower(me:Nick()) .. ","
			else 
				return "and guess what, mr. " .. string.lower(me:Nick()) .. ","
			end
		end, x = fw/2, y = fh/2},
		{txt = function()
			if me:GetLevel()~=5000 then 
				return "you cant do that cuz youre a pleb"
			else 
				return "you can do that"
			end
		end, x = fw/2, y = fh/2 + 72},

	}

	local L = L
	local showtime = 6
	local mult = 1 

	local wp = vgui.GetWorldPanel()
	local sw, sh = ScrW(), ScrH()

	local eee --EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEENTER THE GUUUUNGEEOOOOOOOOOOOOON
	local shake = 0

	local haslvl = me:GetLevel() >= 5000

	if haslvl then 

		sound.PlayFile("data/hdl/eee_loop.dat", "noblock noplay", function(sc, one, two)
			if not sc then error('what the hell man ' .. one ..' ' .. two) return end
			sc:SetVolume(0)
			sc:EnableLooping(true)
			eee = sc
		end )

	end

	local peakmus = 1

	function f:Paint(w,h)
		draw.RoundedBoxEx(8, 0, 0, w, h, Color(50, 50, 50), nil, nil, true, true)
		if input.IsMouseDown(MOUSE_LEFT) then mult = 5 else mult = 1 end
		ft = ft + FrameTime() * mult

		for k,v in pairs(a) do 
			if not ts[k] then continue end 

			if ft - t > ts[k] then 
				a[k] = L(v, 255, 10, true)
			end 

			local t = txs[k]
			local txt = t.txt

			if not txt then return end 

			if isfunction(txt) then txt = txt() end

			draw.SimpleText(txt, "TW36", t.x, t.y, Color(255,255,255,a[k]), 1, 1)
		end


		if ft - t > showtime and not self.Button and haslvl then 
			self.Button = vgui.Create("FButton", f)
			local b = self.Button 
			b.Label = "DO IT"
			b:SetSize(200, 70)

			b:Center()
			b:CenterVertical(0.8)
			local washeld = false 
			local lastheld
			local gg = false

			eee:Play()

			function b:PrePaint(w2,h2)
				if not IsValid(f) then self:Remove() return end 

				if self:IsDown() then

					shake = L(shake, 10, 2)

					local sx, sy = f:ScreenToLocal(ScrW()/2 - 100 + math.random(0, shake), ScrH()/2 - 35 + math.random(0, shake))
					local nx, ny = L(self.X, sx, 10, true), L(self.Y, sy, 10, true)
					

					self:SetPos(nx, ny)

					if eee then

						eee:SetVolume(L(eee:GetVolume(), peakmus, 1))

					end

					par:SetAlpha(L(par:GetAlpha(), 10, 10, true))
					if not DrawFX then 
						lastheld = CurTime()
					end

					if lastheld and CurTime() - lastheld > 3.5 and not gg then 
						gg = true
						sound.PlayFile("data/hdl/noturningback.dat", "", function() end)
						peakmus = 0.8
						timer.Simple(0.9, function() peakmus = 1 end)
						drawOutline = 1
					end

					DrawFX = true
					washeld = true
				else 
					if gg then 
						par:Remove()
						sound.PlayFile("data/hdl/gg.dat", "", function() end)
						eee:Stop()
						succ = CurTime()
						return
					end

					shake = L(shake, 0, 8)
					local fx, fy = self:GetCenter(0.5, 0.8)
					fx, fy = math.Round(fx), math.Round(fy)
					local nx, ny = L(self.X, fx + math.random(0, shake), 12, true), L(self.Y, fy + math.random(0, shake), 12, true)
					self:SetPos(nx, ny)
					par:SetAlpha(L(par:GetAlpha(), 255, 10, true))
					if IsValid(eee) then

						eee:SetVolume(L(eee:GetVolume(), (washeld and 0.13) or 0.07, 3))
						
					end

					lastheld = nil

					DrawFX = false 

				end
				surface.SetAlphaMultiplier(255)
			end
			function b:PostPaint()
				surface.SetAlphaMultiplier(1)
			end
		end

	end

	function f:OnRemove()
		if IsValid(eee) then eee:Stop() end
		
		--hook.Remove("HUDPaint", "Perks.PrestigeFX")
		DrawFX = false
	end

	local w, h = ScrW(), ScrH()

	local rad = ScrW() * 1.5
	local ref = 0

	local render = render 
	local drewoutline = false 

	hook.Add("HUDPaint", "Perks.PrestigeFX", function() 

		local min = w*0.2
		local max = w*1.5
		
		if DrawFX then
			rad = math.max(L(rad, min, 5), rad - min*FrameTime()*6)
			ref = (min/rad) * -0.04
		else 
			rad = math.min(L(rad, max, 10), rad + max*FrameTime()*18)
			ref = (min/rad) * -0.04
		end


		surface.SetDrawColor(10, 10, 10)
		surface.SetMaterial(gl)
		surface.DrawTexturedRect(0, 0, (max - rad)*0.3, h)

		surface.SetMaterial(gr)
		surface.DrawTexturedRect(w - (max - rad)*0.3, 0, (max - rad)*0.3, h)

		if rad > w and ref>-0.01 then return end 

		local shx, shy = math.random(0, shake), math.random(0, shake)

		
		if not dontrender then
			render.UpdateScreenEffectTexture()
		end

		fe:SetFloat("$refractamount", ref*2.5)
		fe:Recompute()
		surface.SetMaterial(fe)
		local shmult = (drewoutline and 1) or 3
		draw.Circle(w/2 + shx*shmult, h/2 + shy*shmult, ScrW(), 16)

		fe:SetFloat("$refractamount", ref)
		fe:SetFloat("$bluramount", math.Round((min-rad)/max, 3))

		fe:Recompute()

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(fe)


		render.SetStencilEnable(true)
			render.ClearStencil()
			render.SetStencilWriteMask( 3 )
			render.SetStencilTestMask( 3 )
			
			render.SetStencilCompareFunction( STENCIL_NEVER )
			render.SetStencilPassOperation( STENCIL_KEEP )
			render.SetStencilFailOperation( STENCIL_REPLACE )
			render.SetStencilZFailOperation( STENCIL_REPLACE )
			render.SetStencilReferenceValue( 1 )

			surface.DrawTexturedRect(0, 0, w, h)
			
			render.SetStencilReferenceValue( 0 )

				draw.Circle(w/2 + shx, h/2 + shy, rad - 10, 64)

			render.SetStencilCompareFunction( STENCIL_EQUAL )
			render.SetStencilPassOperation( STENCIL_REPLACE )
			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )


			draw.Circle(w/2 + shx, h/2 + shy, rad, 64)	--actual draw op

			if drawOutline then 
				drewoutline = true
				render.ClearStencil()
				render.SetStencilWriteMask( 3 )
				render.SetStencilTestMask( 3 )
				
				render.SetStencilCompareFunction( STENCIL_NEVER )
				render.SetStencilPassOperation( STENCIL_KEEP )
				render.SetStencilFailOperation( STENCIL_REPLACE )
				render.SetStencilZFailOperation( STENCIL_REPLACE )

				render.SetStencilReferenceValue( 1 )

				surface.DrawTexturedRect(0, 0, w, h)

				render.SetStencilReferenceValue( 0 ) 

					draw.Circle(w/2 + shx, h/2 + shy, rad+drawOutline-(drawOutline*0.4), 64)

				render.SetStencilReferenceValue( 1 ) 

				render.SetStencilCompareFunction( STENCIL_EQUAL )
				render.SetStencilPassOperation( STENCIL_REPLACE )
				render.SetStencilFailOperation( STENCIL_KEEP )
				render.SetStencilZFailOperation( STENCIL_KEEP )


				draw.NoTexture()
				surface.SetDrawColor(250, 250, 250, olA)
				draw.Circle(w/2 + shx, h/2 + shy, rad+drawOutline, 512)
					
				drawOutline = L(drawOutline, 50, 5)
				olA = 200 - (drawOutline*4.2)
				if olA < 0 then drawOutline = false end 

				

			end

		render.SetStencilEnable(false)


		


	end)


	return f
end

local post = {

}

local glitches = {}

local sinmult = 60
local tosin = 0

local lastneed = 0
local stripechance = 60

succ = CurTime()

local stripes = Material("data/hdl/stripes.png")

local blank = CreateMaterial("glitch_mat", "UnlitGeneric", {

})

hook.Remove("HUDPaint", "PostPrestige")

local chance = 5
local stop = false
local numglitches = 0 

local mindflood = 0 
local saws = {
}

local flow = false 
local flowch



local flowx = 0
local flowy = 0 

local distort = false 
local lastdist = CurTime()
distsegs = {}
local distch

hook.Remove("PostRender", "PostPrestige")

if true then return end ---------------------------STOP

function StartDistort()
	distort = CurTime() 

	sound.PlayFile("data/hdl/ui/softsquare.dat", "noplay", function(ch)
		if not IsValid(ch) then return end 
		ch:Pause()
		ch:SetVolume(0.9)
		ch:Play()
		distch = ch
	end)

end

function StartFlow()
	flow = CurTime()

	sound.PlayFile("data/hdl/ui/tinnitus.dat", "noplay", function(ch)
		if not IsValid(ch) then return end 
		ch:Pause()
		ch:SetVolume(0.9)
		ch:Play()
		flowch = ch
	end)


end
timer.Simple(2, function() StartFlow() end)

timer.Simple(6, function() 
	StartDistort()
end)

timer.Simple(18, function() StartDistort() end)

timer.Simple(19, function() StartFlow() end)

hdl.DownloadFile("http://vaati.net/Gachi/shared/saw.mp3", "ui/saw.dat")	--feelsgoodman Clap LOUDER
hdl.DownloadFile("http://vaati.net/Gachi/shared/square.mp3", "ui/square.dat")
hdl.DownloadFile("http://vaati.net/Gachi/shared/softsquare.mp3", "ui/softsquare.dat")
hdl.DownloadFile("http://vaati.net/Gachi/shared/tinnitus.mp3", "ui/tinnitus.dat")

local suction = CurTime()

hook.Add("PostRender", "PostPrestige", function()
	if not succ then return end 

	--succ is time @ which glitch sequence started
	--stop is time @ which S U C C sequence started

	local ct = CurTime()

	if not stop then 

		chance = ((ct - succ)/10)^2
		if math.random(0, 100) < chance * FrameTime() * 100 then 
			print('ey', chance)

			local pos = {}
			pos[1] = math.random(0, ScrW())
			pos[2] = math.random(0, ScrH())

			local size = {}
			local slim = math.min(10-chance, 7)
			size[1] = math.random(0, slim*ScreenScale(1))*10
			size[2] = math.random(size[1]/10, slim*ScreenScale(1))*5

			glitches[#glitches + 1] = {
				t = ct, 
				pos = pos, 
				size = size, 
				col = ColorRand(),
				mult = (math.random(0, 3)==1 and math.random(70, 90)) or 0, 
				rand = math.random(1, 2)
			}
			numglitches = numglitches + 1

		end

	end

	if chance > 45 then 
		stop = CurTime()

	end

	if chance > 30 then 
		mindflood = math.min(mindflood + FrameTime()/10, L(mindflood, 1, 2))
	end

	render.UpdateScreenEffectTexture()
	local tex = render.GetScreenEffectTexture(0)
	blank:SetTexture("$basetexture", tex)
	cam.Start2D()

	local sw, sh = ScrW(), ScrH()

	for k,v in pairs(glitches) do 
			local rem = CurTime() - v.t
		--local k, err = pcall(function()
			local x, y = v.pos[1], v.pos[2]
			local w, h = v.size[1], v.size[2]
			

			surface.SetMaterial(blank)
			surface.SetDrawColor(255,255,255,255)
			local fu = 0
			if v.mult ~= 0 then 
				fu = math.sin(v.t + (CurTime() * v.mult))*0.01
				rem = rem * 1.5 --waving ones stay on for less
			elseif rem > 0.25 then
				fu = (v.rand==1 and 0.03) or -0.03
			else 
				fu = (v.rand==1 and 0.02) or -0.02
			end
			--render.SetScissorRect(x, y, w, h, true)
				
				surface.DrawTexturedRectUV(x, y, w, h, (x/sw)+fu, (y/sh), (x+w)/sw+fu, (y+h)/sh)
			--render.SetScissorRect(x, y, w, h, false)
			surface.SetDrawColor(ColorAlpha(v.col, 19))
			surface.DrawRect(x, y, w, h)

			if rem > 0.4 then table.remove(glitches, k) end
		--end)
		--if not k then print(k, err) end

	end

	if flow then 
		surface.SetMaterial(blank)
		surface.SetDrawColor(255,255,255,255)

		surface.DrawTexturedRectUV(0, 0, sw, sh, 0 + flowx, 0 + flowy, 1 + flowx, 1 + flowy)
		flowy = flowy - FrameTime()/math.Rand(8, 12)
		flowx = flowx + FrameTime()/math.Rand(10, 12)
		if CurTime() - flow >= 0.3 then 
			flow = false 
			if IsValid(flowch) then flowch:Stop() flowch = nil end
		end

	end

	if distort then 
		if ct - lastdist >= 0.25 then 
			distsegs = {}
			local amt = math.random(5, 12)

			for i=1, amt do 
				if math.random(0, 12) == 6 then continue end --1/12 chance of a glitchrect not appearing

				local w = math.random(sw/10, sw/2)
				local x = 0

				if w>=sw then 
					w = sw 
				else 
					x = math.random(0, ScrW() - 50)
				end

				distsegs[i] = {
					x = x,
					y = ScrH()/amt * (i-1),
					w = w,
					h = (ScrH()-80)/amt,
					u = 0,
					v = math.random(0, 30)/100
				}
				lastdist = CurTime()
			end

		end

		surface.SetMaterial(blank)
		surface.SetDrawColor(255,255,255,255)

		for k,v in pairs(distsegs) do 
			local x, y, w, h = v.x, v.y, v.w, v.h 

			local ou, ov = v.u, v.v

			local u1, v1 = x/sw, y/sh
			local u2, v2 = (x+w)/sw, (y+h)/sh 

			u1, v1 = u1 + ou, v1 + ov 
			u2, v2 = u2 + ou, v2 + ov

			render.SetScissorRect(x, y, x+w, y+h, true)
				surface.DrawTexturedRectUV(0, 0, sw, sh, u1, v1, u2, v2)
			render.SetScissorRect(x, y, x+w, y+h, false)
			v.u = math.random(0, 10000)/10000
		end
		if CurTime() - distort > 1 then 
			if IsValid(distch) then distch:Stop() distch = nil end 
			distort = false 
		end
	end

	if mindflood > 0 and not stop then 
		local sclw = (ScrW()/1920)
		local sclh = (ScrH()/1080)

		local sw, sh = sw+2, sh+2

		local gw, gh = mindflood*sclw*96, mindflood*sclh*80
		surface.SetDrawColor(0, 0, 0, mindflood * 255)


		surface.SetMaterial(gu)

		for i=1, 3 do
			surface.DrawTexturedRect(0, 0, sw, gh)
		end

		surface.SetMaterial(gd)

		for i=1, 3 do
			surface.DrawTexturedRect(0, sh - gh, sw, gh)
		end

		surface.SetMaterial(gr)

		for i=1, 3 do
			surface.DrawTexturedRect(sw - gw, 0, gw, sh)
		end

		surface.SetMaterial(gl)

		for i=1, 3 do
			surface.DrawTexturedRect(0, 0, gw, sh)
		end
	end
	if suction then 

	end
	cam.End2D()
	--end
end)
