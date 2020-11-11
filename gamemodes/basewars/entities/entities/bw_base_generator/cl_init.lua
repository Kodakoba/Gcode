ENT.Base = "bw_base"
ENT.Type = "anim"
ENT.PrintName = "Base Generator"

AddCSLuaFile("shared.lua") --???
include("shared.lua")

local upd = false

local using = false

local looking = {}

local usingtime = 0


local halos = {}

GeneratorPanel = GeneratorPanel
local SplineStrength = 10

if IsValid(GeneratorPanel) then GeneratorPanel:Remove() end

local TimeToOpenPanel = 0.4

DrawCable = DrawCable or false	-- Entity: from

local dcFirstFrame = false -- is this the first frame when DrawCable was defined? used for DeltaText at the very bottom

DrawCableDist = DrawCableDist or nil
DrawCableEntity = DrawCableEntity or nil 	-- Entity: to

function ENT:OpenShit(qm, self, pnl)
	print("initial open on gen")
	print('qm:', qm)
	if not IsValid(pnl) then error("WTF " .. tostring(pnl)) return end

	GeneratorPanel = pnl

	local tim = 0

	local size = 64
	local pad = 6

	local active = false

	local ent = self

	if ent.GenerateOptions then

		if qm.Panels then

			local valid = #qm.Panels > 0

			for k, p in ipairs(qm.Panels) do
				if not IsValid(p) then print(p, "is invalid; recreating all") valid = false break end
			end
			print("all valid?", valid)
			if valid then print("skipping") goto skipOptions end 	-- every option is valid; don't recreate and bail
												-- had ta use a goto here
		end

		local pnls = {ent:GenerateOptions(qm, pnl)}

		qm.Panels = pnls
	end

	::skipOptions::

	if not IsValid(qm.ConnectBtn) then
		print("connectbtn was not valid")
		local con = vgui.Create("FButton", pnl)
		qm.ConnectBtn = con
		con:SetSize(128, 48)

		con.X = pnl.CircleX + pnl.MaxCircleSize
		con.Y = pnl.CircleY - 24

		con:SetMouseInputEnabled(true)
		con.AlwaysDrawShadow = true
		con:SetLabel("Connect to...")

		qm:AddPopIn(con, con.X, con.Y, 64, 0)

		function con:DoClick()
			DrawCable = ent
			dcFirstFrame = true
		end
	else
		print("connectbtn was valid")
	end

	if not IsValid(qm.DisconnectBtn) then

		if IsValid(self:GetHotwired()) or IsValid(self:GetLine()) then

			local disc = vgui.Create("FButton", pnl)
			qm.DisconnectBtn = disc
			disc:SetSize(128, 48)

			disc.X = pnl.CircleX - pnl.MaxCircleSize - 64 - 64
			disc.Y = pnl.CircleY - 24

			disc:PopIn()
			disc.AlwaysDrawShadow = true
			disc:SetLabel("Disconnect")

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

				qm.DisconnectBtn = nil
				ent.ExpectedDisconnect = true

			end

			qm:AddPopIn(disc, disc.X, disc.Y, -64, 0)
		end
	end

	-- todo: make QM panel emit OnRemove
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
			offX = math.sin(f * math.pi * 4) * 10
			hilite = 1 - f
		end
	end

	function pnl:ConnectPaint(w, h)
		self:SetMouseInputEnabled(false)
	end


	function qm:Paint(ent)
		if not IsValid(pnl) then self:SetKeepAlive(false) return end

		local w, h = pnl:GetSize()

		if DrawCable then
			pnl:ConnectPaint(w, h)
			self:SetKeepAlive(true)

			self.FadedDueToCable = true
			if qm.ConnectBtn then
				qm.ConnectBtn:AlphaTo(50, 0.2, 0, nil, 0.3)
			end

			if qm.DisconnectBtn then
				qm.DisconnectBtn:AlphaTo(50, 0.2, 0, nil, 0.3)
			end

			if self.Panels then
				for k,v in ValidIPairs(self.Panels) do
					v:AlphaTo(50, 0.2, 0, nil, 0.3)
				end
			end

		else

			if self.FadedDueToCable then
				if qm.ConnectBtn then
					qm.ConnectBtn:AlphaTo(255, 0.2, 0, nil, 0.3)
				end

				if qm.DisconnectBtn then
					qm.DisconnectBtn:AlphaTo(255, 0.2, 0, nil, 0.3)
				end

				if self.Panels then
					for k,v in ValidIPairs(self.Panels) do
						v:AlphaTo(255, 0.2, 0, nil, 0.3)
					end
				end

				self.FadedDueToCable = false
			end

			self:SetKeepAlive(false)
		end

	end

end

function ENT:CloseAll(qm, self, pnl)
	if not IsValid(pnl) then print("!!invalid pnl!!") return end

	if qm.Panels then
		for k,v in pairs(qm.Panels) do
			v:PopOut()
			qm.Panels[k] = nil
		end
	end

	qm.ConnectBtn:PopOut()
	if qm.DisconnectBtn then
		qm.DisconnectBtn:PopOut()
	end
end

function ENT:CLInit()
	local qm = self:SetQuickInteractable()
	qm.OnOpen = function(...) self:OpenShit(...) end
	qm.OnFullClose = function(...) self:CloseAll(...) end
	--qm.OnReopen = OpenShit

	self:OnChangeGridID(self:GetGridID())
end

--[[function ENT:OnChangeGridID(new)
	if self.OldGridID == new or new <= 0 then return end

	self.OldGridID = new

	local grid = PowerGrids[new]
	if not grid then
		grid = PowerGrid:new(self:CPPIGetOwner(), new)
		grid:AddGenerator(self)
	else
		grid:AddGenerator(self)
	end

end]]

function ENT:Think()
	-- what the actual fuck is this

end


hook.Add("PreDrawHalos", "Generators", function()
	if not using then return end
	halo.Add(halos, Color(100, 230, 100), 2, 2, 2, true, true)

	halos = {}
end)

local cab = Material("cable/cable2")

local qual = 25


function GenerateCable(from, to, h, qual)

	h = h or 10

	local beams = {}

	if h==0 then
		return {from, to}
	end

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

	return beams
end

local hp = Vector()

hook.Add("PostDrawTranslucentRenderables", "DrawCables", function(d, sb)
	if d or sb then return end
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

function ENT:PlayDisconnect(was)
	sound.PlayFile("data/hdl/sfx/wire_disconnect.dat", "noplay 3d", function(ch)
		if not IsValid(ch) then return end

		ch:SetPos(was:GetPos())
		ch:Set3DFadeDistance(500, 1200)
		ch:SetVolume(3)
		ch:Play()
	end)
end

function ENT:OnDisconnect(was)
	if self.ExpectedDisconnect then self.ExpectedDisconnect = false return end
	if not IsValid(was) then return end --?

	self:PlayDisconnect(was)

	if self==PreviewCable then
		PreviewCable = false
		PreviewFinalCablePoint = nil
		FinalCablePoint = nil
	end

end


net.Receive("ConnectGenerator", function()
	-- really just a listener for disconnects
	local gen = net.ReadEntity()
	local from = net.ReadEntity()

	gen:PlayDisconnect(from)
end)

function ENT:OnConnect(who)

	if self.ExpectedConnect then self.ExpectedConnect = false return end
	if not IsValid(who) then return end

	sound.PlayFile("data/hdl/sfx/wire_connect.dat", "noplay 3d", function(ch)
		if not IsValid(ch) then return end
		if LocalPlayer():GetPos():Distance(who:GetPos()) > 900 then return end

		ch:SetPos(who:GetPos())
		ch:Set3DFadeDistance(300, 1000)
		ch:SetVolume(3)
		ch:Play()
	end)

end

hook.Add("PostDrawTranslucentRenderables", "DrawConnectPrompt", function(d, sb)
	if not DrawCable or not DrawCableTrace then return end
	local tr = DrawCableTrace

	local e = IsValid(tr.Entity) and tr.Entity

	if e and (e.Cableable or (e.IsElectronic or e.Connectable)) and e ~= DrawCable then
		DrawCableClass = e.PrintName or e:GetClass()
		DrawCableEntity = e
		FinalCablePoint = e

		if e.UseSpline ~= nil then
			NoSpline = not e.UseSpline
		end
		if e.SplineStrength then
			SplineStrength = e.SplineStrength
		else
			SplineStrength = 10
		end
		local pos = e.ConnectPoint and e:LocalToWorld(e.ConnectPoint) or e:GetPos()
		local pos2 = DrawCable.ConnectPoint and DrawCable:LocalToWorld(DrawCable.ConnectPoint) or DrawCable:GetPos()

		DrawCableDist = pos:Distance(pos2)
	else
		DrawCableClass = nil
		DrawCableEntity = nil
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

local anim


hook.Add("StartCommand", "StopConnectingCable", function(ply, cmd)
	local wL, wR = wasLMB, wasRMB
	wasLMB, wasRMB = cmd:KeyDown(IN_ATTACK), cmd:KeyDown(IN_ATTACK2)


	if not cmd:KeyDown(IN_ATTACK) and not cmd:KeyDown(IN_ATTACK2) then return end


	if (DrawCable or (preventRMBs and (CurTime() - preventRMBs < dur))) and cmd:KeyDown(IN_ATTACK2) and not wR then
		cmd:RemoveKey(IN_ATTACK2)

		DrawCable = false
		PreviewCable = false
		FinalCablePoint = nil

		preventRMBs = preventRMBs or CurTime()
	elseif preventRMBs and (wR or (CurTime() - preventRMBs > dur)) then
		preventRMBs = nil
	end

	local preventLMB = (DrawCable or (preventLMBs and (CurTime() - preventLMBs < dur))) and cmd:KeyDown(IN_ATTACK)
	if preventLMB then cmd:RemoveKey(IN_ATTACK) end

	if preventLMB and not wL then

		if not IsValid(DrawCableEntity) then
			wasLMB = false
			anim:Emit("Refuse")
			return
		end

		local maxDist = math.min(DrawCable.ConnectDistance, DrawCableEntity.ConnectDistance)

		local pos = DrawCableEntity.ConnectPoint and DrawCableEntity:LocalToWorld(DrawCableEntity.ConnectPoint) or DrawCableEntity:GetPos()
		local pos2 = DrawCable.ConnectPoint and DrawCable:LocalToWorld(DrawCable.ConnectPoint) or DrawCable:GetPos()

		if pos:Distance(pos2) > maxDist then
			if IsValid(GeneratorPanel) then
				GeneratorPanel:Refuse()
			end

			anim:Emit("Refuse")
			return
		end

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

		DrawCable = nil
		PreviewCable = false
		DrawCableEntity = nil
		FinalCablePoint = nil

		preventLMBs = preventLMBs or CurTime()

	elseif preventLMBs and (wL or (CurTime() - preventLMBs < dur)) then
		cmd:RemoveKey(IN_ATTACK)
	else
		preventLMBs = nil
	end



end)


local boxCol = Color(50, 50, 50, 220)

local blkCol = Color(0, 0, 0)
local redCol = Color(210, 30, 30)

local dt

local yOffset = 32

hook.Add("HUDPaint", "DrawPreviewCable", function()
	if not DrawCable then return end
	local sw, sh = ScrW(), ScrH()

	anim = anim or Animatable("Cables")

	if not dt then
		dt = DeltaText()

		local dtext = dt:AddText("")
		dtext.Animation.Length = 0.2
		dtext:SetColor(Colors.DarkWhite:Copy())
		dt.BText = dtext

		local base = dtext:AddFragment("Connect to")
		local what = dtext:AddFragment("...")

		dt.ConnectWhat = what

		dt:SetAlignment(1)
		dt:SetFont("OSB32")
		dtext:SetLiftStrength(-18)
		dt:CycleNext()
	end


	if DrawCableClass then
		anim:To("Frac", 1, 0.4, 0, 0.3)
		local _, frag = dt.BText:ReplaceText(dt.ConnectWhat, " " .. DrawCableClass, nil, dcFirstFrame)
		if frag then frag.Color = Colors.Sky end
	else
		anim:To("Frac", 0, 0.3, 0, 0.3)
		local _, frag = dt.BText:ReplaceText(dt.ConnectWhat, "...", nil, dcFirstFrame)
		if frag then frag.Color = Colors.DarkWhite end
	end

	local maxDist = DrawCable.ConnectDistance

	if IsValid(DrawCableEntity) then
		maxDist = math.min(maxDist, DrawCableEntity.ConnectDistance)
	end

	if DrawCableDist and DrawCableDist > maxDist then
		anim:To("FarFrac", 1, 0.4, 0, 0.3)
	else
		anim:To("FarFrac", 0, 0.3, 0, 0.3)
	end

	local txFrac = anim.Frac or 0
	local farFrac = anim.FarFrac or 0

	surface.SetFont("OSB32")

	local rbx = sw/2 - dt:GetWide() / 2 - 4
	local rbw = dt:GetWide() + 8

	boxCol.r = 50 + (70 * farFrac)

	draw.RoundedBox(8, rbx, sh/2 + yOffset, rbw, 32 + 4, boxCol)

	dt:Paint(sw/2, sh/2 + yOffset + 32 * 0.125 / 2)

	if farFrac > 0 then

		blkCol.a = farFrac * 250
		redCol.a = farFrac * 255

		draw.SimpleText("Too far!", "OSB32",
					rbx + rbw / 2 + 1,
					sh / 2 + yOffset + 36 + farFrac * 16 + 1,
					blkCol, 1, 5)
		draw.SimpleText("Too far!", "OSB32",
					rbx + rbw / 2,
					sh / 2 + yOffset + 36 + farFrac * 16,
					redCol, 1, 5)
	end


	dcFirstFrame = false
end)

--def not stolen from factorio

hdl.DownloadFile("http://vaati.net/Gachi/shared/wire-connect-pole.ogg", "sfx/wire_connect.dat")
hdl.DownloadFile("http://vaati.net/Gachi/shared/wire-pickup.ogg", "sfx/wire_disconnect.dat")
hdl.DownloadFile("http://vaati.net/Gachi/shared/cannot-build.ogg", "sfx/wire_refuse.dat")
