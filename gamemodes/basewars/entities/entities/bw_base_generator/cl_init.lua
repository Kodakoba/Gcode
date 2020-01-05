ENT.Base = "bw_base"
ENT.Type = "anim"
ENT.PrintName = "Base Generator"

AddCSLuaFile("shared.lua") --???
include("shared.lua")

local upd = false

local using = false
local usingwho

local looking = {} 

local dist = 0 

local usingtime = 0


local halos = {}

local drawoptions = false 

GeneratorPanel = GeneratorPanel
SplineStrength = 10 

if IsValid(GeneratorPanel) then GeneratorPanel:Remove() end

local TimeToOpenPanel = 0.4

DrawCable = DrawCable or false 

DrawCableDist = DrawCableDist or nil
DrawCableEntity = DrawCableEntity or nil 

local function OpenShit(qm, self, pnl)

	local tim = 0

	local size = 64
	local pad = 6

	local active = false 

	local ent = self

	if ent.GenerateOptions then 

		if pnl.Panels then 

			local valid = true

			for k, pnl in ipairs(pnl.Panels) do 
				if not IsValid(pnl) then valid = false break end
			end

			if valid then return end 

		end

		local pnls = {ent:GenerateOptions(qm, pnl)}

		pnl.Panels = pnls
	end


	local con = vgui.Create("FButton", pnl)
	con:SetSize(128, 48)

	con:Center()
	con:CenterHorizontal(0.7)

	con:SetMouseInputEnabled(true)
	con.AlwaysDrawShadow = true 
	con:SetLabel("Connect to...")

	pnl.HookUp = con

	qm:AddPopIn(con, con.X, con.Y, 64, 0)

	function con:DoClick()
		DrawCable = usingwho 
	end

	if IsValid(self:GetConnectedTo()) then 

		local disc = vgui.Create("FButton", pnl)
		disc:SetSize(128, 48)

		disc:Center()
		disc:CenterHorizontal(0.3)
		disc:PopIn()
		disc.AlwaysDrawShadow = true 
		disc:SetLabel("Disconnect")
		pnl.Disconnect = disc

		function disc:DoClick()
			net.Start("ConnectGenerator")
				net.WriteBool(true)
				net.WriteEntity(ent)
			net.SendToServer()

			sound.PlayFile("data/hdl/sfx/wire_disconnect.dat", "noplay", function(ch)
				if not IsValid(ch) then return end 

				ch:SetPos(ent:GetPos())
				ch:Set3DFadeDistance(500, 1200)
				ch:SetVolume(3)
				ch:Play()
			end)

			self:PopOut()

			PreviewCable = false
			PreviewFinalCablePoint = nil

			pnl.Disconnect = nil
			ent.ExpectedDisconnect = true

		end

		qm:AddPopIn(disc, disc.X, disc.Y, -64, 0)
	end

	function pnl:OnActive()

		if not IsValid(self.Disconnect) and IsValid(ent:GetConnectedTo()) then 
			--[[
				Disconnect button
			]]

			
		end

	end 

	function pnl:OnUnactive()

	end

	local al

	local offX = 0
	local hilite = 0

	function pnl:OnRemove()
		PreviewCable = false
		PreviewFinalCablePoint = nil
		FinalCablePoint = nil
	end

	function pnl:Refuse()
		
		sound.PlayFile("data/hdl/sfx/wire_refuse.dat", "noplay", function(ch)
			if not IsValid(ch) then return end 

			ch:SetVolume(3)
			ch:Play()
		end)
		
		if self.Shake then table.RemoveByValue(self.m_AnimList, self.Shake) end 


		self.Shake = self:NewAnimation(1, 0, 0.6, function() offX = 0 hilite = 0 self.Shake = nil end)
		self.Shake.Think = function(_, self, f)
			local fr = f
			offX = math.sin(fr*math.pi*4)*10
			hilite = 1 - f
		end
	end

	function pnl:GeneratorPaint(w, h)

		tim = usingtime
		if not IsValid(ent) then self:Remove() return end 

		local perc = 100 * (math.min(tim * 1/TimeToOpenPanel, 1))^2

		if perc >= 100 and not DrawCable then 
			size = L(size, 32, 25, true)

			if not active then 
				self:OnActive()
			end
			active = true 

		else 
			size = L(size, 64, 25)
			if active then 
				self:OnUnactive()
			end
			active = false
		end

	end

	local txfrac = 0
	local toofar = 0

	local rndto = 5	--rounding for lerping the text/box sizes in V
	local rndmul = 10^rndto 

	function pnl:ConnectPaint(w, h)
		self:SetMouseInputEnabled(false)
		--[[
		if self.HookUp then 
			al = 255
			self.HookUp:PopOut()
			self.HookUp = nil 
		end

		if self.Disconnect then 
			self.Disconnect:PopOut()
			self.Disconnect = nil 
		end

		if self.Panels then
			for k,v in ValidIPairs(self.Panels) do 
				v:PopOut()
			end
		end
		]]
		self:GeneratorPaint(w, h)

		al = L(al, 0, 15, true)

		local basestr = (DrawCableClass and ("Connect to ")) or "Connect to..."
		local str = (DrawCableClass and basestr .. DrawCableClass) or "Connect to..."
		
		

		if DrawCableClass then 
			txfrac = L(txfrac*rndmul, rndmul, 15, true) / rndmul 	--so to 1
		else 
			txfrac = L(txfrac*rndmul, 0, 25, true) / rndmul
		end

		if DrawCableDist and DrawCableDist > ent.ConnectDistance then 
			toofar = L(toofar*rndmul, rndmul, 15, true) / rndmul
		else 
			toofar = L(toofar*rndmul, 0, 25, true) / rndmul
		end

		surface.SetFont("OSB32")

		local btw, bth = surface.GetTextSize(basestr)
		local ctw, cth = surface.GetTextSize(DrawCableClass or str)

		local rbx = w/2 - btw/2 - ctw*txfrac/2 - 8
		local rbw = btw + ctw*txfrac + 16

		local bgcol = Color(50 + (70*toofar), 50, 50, 220)

		draw.RoundedBox(8, rbx, h/2 + 16, rbw, bth + 4, bgcol)

		local txa = txfrac^3 * 255 

		surface.SetTextColor(color_white)

		local basex = rbx + 8

		surface.SetTextPos(basex, h/2 + bth/2)
		surface.DrawText(basestr)

		surface.SetTextColor(ColorAlpha(Color(50, 150, 250), txa))

		surface.SetTextPos(rbx + btw*(txfrac^0.9) + (surface.GetTextSize(" ")), h/2 + cth/2)
		surface.DrawText(DrawCableClass or "")

		draw.SimpleText("Too far!", "OSB32", offX + w/2 + 1, h/2 + 40 + 12*toofar + 1, Color(0, 0, 0, 205*toofar - hilite*20), 1, 5)
		draw.SimpleText("Too far!", "OSB32", offX + w/2, h/2 + 40 + 12*toofar, Color(210 + hilite*40, 30 + hilite*50, 30 + hilite*50, 255*toofar), 1, 5)
		
	end
	

	function qm:Paint(ent)
		if not IsValid(pnl) then return end 

		local w, h = pnl:GetSize()

		if DrawCable then 
			pnl:ConnectPaint(w, h)
			self:SetKeepAlive(true)

			if pnl.HookUp then 
				pnl.HookUp:AlphaTo(50, 0.2, 0)
			end

			if pnl.Disconnect then 
				pnl.Disconnect:AlphaTo(50, 0.2, 0)
			end

			if self.Panels then
				for k,v in ValidIPairs(self.Panels) do 
					v:AlphaTo(50, 0.2, 0)
				end
			end

		else
			pnl:GeneratorPaint(w, h)
			self:SetKeepAlive(false)
		end

	end

	local ent = self:GetConnectedTo()

	if IsValid(ent) then 
		if ent.DontPreview then return end 
		
		PreviewFinalCablePoint = ent

		if ent.UseSpline~=nil then 
			NoSpline = not ent.UseSpline 
		end

		PreviewCable = self 
	end

end

function ENT:CLInit()
	local qm = self:SetQuickInteractable()
	qm.OnOpen = OpenShit
	--qm.OnReopen = OpenShit
end

function ENT:Think()
	local p = LocalPlayer()
	local ent = self
	if not upd then 
		upd = true 
		using = p:KeyDown(IN_USE)
	end 

	if not using then return end
	--^ this is for fun; this kind of caching barely impacts pefromance, probably

	local tr = p:GetEyeTrace()
	if tr.Entity ~= self or tr.Fraction*32768 > 192 then looking[self] = nil return end 

	usingwho = self 

	looking[self] = true
	halos[#halos + 1] = self

	usingtime = math.min(usingtime + FrameTime(), TimeToOpenPanel)
	dist = tr.Fraction*32768

	drawoptions = true

	if not IsValid(GeneratorPanel) then 
		GeneratorPanel = vgui.Create("InvisPanel")

		local pnl = GeneratorPanel
		pnl:SetSize(600, 400)
		pnl:Center()
		
	end

end

hook.Add("Think", "gennies", function()

	if ((not using or table.IsEmpty(looking)) or dist > 192 ) and not DrawCable then 

		usingtime = math.max(usingtime - FrameTime(), 0)
		drawoptions = false
		if usingtime == 0 and IsValid(GeneratorPanel) then 
			--GeneratorPanel:Remove()

			PreviewCable = false
			PreviewFinalCablePoint = nil

		end

	end

	upd = false

end)

hook.Add("PreDrawHalos", "Generators", function()
	if not using then return end 
	halo.Add(halos, Color(100, 230, 100), 2, 2, 2, true, true)

	halos = {}
end)

local cab = Material("cable/cable2")

local qual = 25

local FinalCablePoint
local NoSpline = false 

local cache = muldim()

function GenerateCable(from, to, h, qual)

	local s1, s2 = tostring(from), tostring(to)

	local cached = cache:Get(s1, s2, h, qual)
	if cached then 
		return cached 
	end

	h = h or 10 

	local beams = {}

	if h==0 then 
		return {from, to}
	end

	local dif = from - to 

	local div = 1/qual

	local p1 = from --+ Vector(0, 0, h)

	local p2 = from --- Vector(0, 0, h/2)

	local p3 = to - Vector(0, 0, h*3)

	local p4 = to + Vector(0, 0, h/2)

	local p5 = to 

	local points = { 
		p1, 
		p2, 
		p3,
		p4,
		p5
	}

	beams[#beams + 1] = from

	for i=0, 1, div do 
		beams[#beams + 1] = math.BSplinePoint(i, points, 1)
	end
	cache:Set(beams, s1, s2, h, qual)
	return beams
end

hook.Add("PostDrawTranslucentRenderables", "DrawCables", function(d, sb)

	if not IsValid(DrawCable) and not IsValid(PreviewCable) then DrawCable = nil PreviewCable = nil return end --generator probably doesn't exist anymore, nil it so the new panel doesn't bug out

	local tr = util.TraceLine({
		start = LocalPlayer():EyePos(),
		endpos = LocalPlayer():EyePos() + EyeAngles():Forward() * 48,
		filter = LocalPlayer()
	})

	local longtr = util.TraceLine({
		start = LocalPlayer():EyePos(),
		endpos = LocalPlayer():EyePos() + EyeAngles():Forward() * 192,
		filter = LocalPlayer()
	})	--maybe not necessarily efficient

	DrawCableTrace = longtr

	local hp = Vector()

	local fcpent = FinalCablePoint or PreviewFinalCablePoint
	local fcp = tr.HitPos

	if IsValid(fcpent) then 
		fcp = (fcpent.ConnectPoint and fcpent:LocalToWorld(fcpent.ConnectPoint)) or fcpent:GetPos()
	end
	hp:Set(fcp)	--to where

	local ent = DrawCable or PreviewCable --from who

	local pos = ent:GetPos()

	local rdist = hp:Distance(pos) --real distance
	local dist = math.min(rdist, ent.ConnectDistance)
	local h = math.min(((ent.ConnectDistance - dist)/50)^0.7, SplineStrength)

	local dif = hp - pos


	local difnorm = dif:GetNormalized()

	--local div = 1/qual

	hp:Set(pos + difnorm*dist)


	local beams = {}

	if not NoSpline then

		beams = GenerateCable(pos, hp, h, qual)

		--[[
		local p1 = pos + Vector(0, 0, h)

		local p2 = pos + dif/2 - Vector(0, 0, h*2)

		local p3 = hp - Vector(0, 0, h*2)

		local p4 = hp + Vector(0, 0, h/2)

		local p5 = hp 

		local points = { 
			p1, 
			p2, 
			p3,
			p4,
			p5
		}

		beams[#beams + 1] = pos

		for i=0, 1, div do 
			beams[#beams + 1] = math.BSplinePoint(i, points, 1)
		end
		]]
	else 
		beams[#beams + 1] = pos
		beams[#beams + 1] = hp
	end

	local red

	if rdist > ent.ConnectDistance then 
		beams[#beams + 1] = beams[#beams]
		beams[#beams + 1] = fcp or tr.HitPos
		red = #beams - 1
	end

	DrawCableDist = rdist

	render.SetMaterial( cab )

	render.StartBeam(#beams)

		local col = color_white

		for k, v in ipairs(beams) do
			if red == k then col = Color(255, 20, 20) end
			render.AddBeam( v, 2, 0.5, col)
		end

	render.EndBeam()

end)

function ENT:OnDisconnect(was)
	
	if self.ExpectedDisconnect then self.ExpectedDisconnect = false return end 
	if not IsValid(was) then return end --?

	sound.PlayFile("data/hdl/sfx/wire_disconnect.dat", "noplay 3d", function(ch)
		if not IsValid(ch) then return end 

		ch:SetPos(was:GetPos())
		ch:Set3DFadeDistance(500, 1200)
		ch:SetVolume(3)
		ch:Play()
	end)

	if self==PreviewCable then
		PreviewCable = false
		PreviewFinalCablePoint = nil
		FinalCablePoint = nil
	end

end

function ENT:OnConnect(who)
	
	if self.ExpectedConnect then self.ExpectedConnect = false return end 
	if not IsValid(who) then return end 

	sound.PlayFile("data/hdl/sfx/wire_connect.dat", "noplay 3d", function(ch)
		if not IsValid(ch) then return end 

		ch:SetPos(who:GetPos())
		ch:Set3DFadeDistance(500, 1200)
		ch:SetVolume(3)
		ch:Play()
	end)

end

local rad = 24

hook.Add("PostDrawTranslucentRenderables", "DrawConnectPrompt", function(d, sb)
	if not DrawCable or not DrawCableTrace then return end
	local tr = DrawCableTrace

	local e = IsValid(tr.Entity) and tr.Entity

	if e and (e.IsElectronic or e.Connectable) then 
		DrawCableClass = e.PrintName or e:GetClass()
		DrawCableEntity = e
		FinalCablePoint = e

		if e.UseSpline~=nil then 
			NoSpline = not e.UseSpline 
		end
		if e.SplineStrength then 
			SplineStrength = e.SplineStrength 
		else 
			SplineStrength = 10
		end
		DrawCableDist = e:GetPos():Distance(DrawCable:GetPos())
	else 
		DrawCableClass = nil 
		FinalCablePoint = nil
		NoSpline = false
		--DrawCableDist = nil
	end

end)

local preventRMBs = nil
local preventLMBs = nil

local wasLMB = false 
local wasRMB = false 

local dur = 0.1	--tremor squad

hook.Add("StartCommand", "StopConnectingCable", function(ply, cmd)
	local wL, wR = wasLMB, wasRMB 
	wasLMB, wasRMB = cmd:KeyDown(IN_ATTACK), cmd:KeyDown(IN_ATTACK2)

	local wasLMB, wasRMB = wL, wR

	if not cmd:KeyDown(IN_ATTACK) and not cmd:KeyDown(IN_ATTACK2) then return end 


	if (DrawCable or (preventRMBs and (CurTime() - preventRMBs < dur))) and cmd:KeyDown(IN_ATTACK2) and not wasRMB then 
		cmd:RemoveKey(IN_ATTACK2)
		print('removed dc')
		DrawCable = false
		PreviewCable = false
		FinalCablePoint = nil

		preventRMBs = preventRMBs or CurTime()
	elseif preventRMBs and (wasRMB or (CurTime() - preventRMBs > dur)) then
		preventRMBs = nil 
	end

	if (DrawCable or (preventLMBs and (CurTime() - preventLMBs < dur))) and cmd:KeyDown(IN_ATTACK) and not wasLMB and IsValid(DrawCableEntity) then 
		if DrawCableEntity:GetPos():Distance(DrawCable:GetPos()) > DrawCable.ConnectDistance then
			if IsValid(GeneratorPanel) then 
				GeneratorPanel:Refuse()
			else 

			end 
			return
		end
		cmd:RemoveKey(IN_ATTACK)
		
		net.Start("ConnectGenerator")
			net.WriteBool(false)
			net.WriteEntity(DrawCable)
			net.WriteEntity(DrawCableEntity)
		net.SendToServer()

		DrawCable.ExpectedConnect = true 

		local where = DrawCableEntity:GetPos()

		sound.PlayFile("data/hdl/sfx/wire_connect.dat", "noplay", function(ch)
			if not IsValid(ch) then return end 

			ch:SetPos(where)
			ch:Set3DFadeDistance(500, 1200)
			ch:SetVolume(3) --its real fuckin quiet
			ch:Play()
		end)
		print("removed dc")
		DrawCable = nil 
		PreviewCable = false
		DrawCableEntity = nil 
		FinalCablePoint = nil

		preventLMBs = preventLMBs or CurTime()
		--if IsValid(GeneratorPanel) then 
		--	GeneratorPanel:Remove()
		--end

	elseif preventLMBs and (wasLMB or (CurTime() - preventLMBs < dur)) then
		cmd:RemoveKey(IN_ATTACK) 
	else
		preventLMBs = nil 
	end

	

end)

--def not stolen from factorio

hdl.DownloadFile("http://vaati.net/Gachi/shared/wire-connect-pole.ogg", "sfx/wire_connect.dat")
hdl.DownloadFile("http://vaati.net/Gachi/shared/wire-pickup.ogg", "sfx/wire_disconnect.dat")
hdl.DownloadFile("http://vaati.net/Gachi/shared/cannot-build.ogg", "sfx/wire_refuse.dat")
