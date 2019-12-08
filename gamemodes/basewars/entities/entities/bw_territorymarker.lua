
AddCSLuaFile()
ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.Model 		= "models/props_trainstation/clock01.mdl"
ENT.Skin 		= 0
ENT.RenderGroup = RENDERGROUP_BOTH	--fuck Z
ENT.EXPMult = 0.1
ENT.TerritoryMarker = true 

ENT.CaptureTime = 45 --In seconds, time it takes to (un)capture
ENT.MinPlayers = 1 --Minimum amount of players for these to kick in
				   --This doesn't factor in factions so make sure it's at least above 4, otherwise everyone will be in the same fac and it's a win/win for everyone

local caps = {}

	function ENT:SetupDataTables()

		self:NetworkVar("String", 1, "ControllingFac")
		self:NetworkVar("Bool", 1, "Taken")
		self:NetworkVar("Bool", 2, "Capping")
		self:NetworkVar("Bool", 3, "REEEE")
		self:NetworkVar("Float", 1, "Timer")
		self:NetworkVar("Vector", 1, "FacColor")	--did we really have to?
	end
	
if SERVER then 
	local factbl = BaseWars.Factions.FactionTable
	util.AddNetworkString("Territories_CapStart")

	function ENT:Initialize()

		self:SetModel(self.Model)
		self:SetSkin(self.Skin)

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)

		self:PhysWake()
		self:Activate()

		self:SetUseType(SIMPLE_USE)

		self:SetControllingFac("No faction!")
	end

	function ENT:StartCapture(ply, fac)
		if ply:InRaid() then return end
		self:SetTimer(CurTime())
		self:SetCapping(true)
		self.Capturer = ply 
		net.Start("Territories_CapStart")
			net.WriteEntity(self)
		net.Broadcast()

	end
	function ENT:ResetCapture()
		if self:GetTaken() then 
			local fac = factbl[self:GetControllingFac()]
			PrintTable(fac)

			if fac then 
				fac.XPMult = (fac.XPMult or 0) - 0.1
			end

		end
		self:SetControllingFac("No faction!")
		self:SetCapping(false)
		self:SetTaken(false)
		self:SetTimer(0)
		self.Capturer = nil
	end
	function ENT:Capture(ply, fac)
		print('Capturing')
		if self:GetTaken() then 
			self:ResetCapture()
			return
		end

		if self:GetControllingFac() ~= "No faction!" then 
			local fac = factbl[self:GetControllingFac()]
			if fac then 
				fac.XPMult = fac.XPMult - 0.1
			end
		end

		self:SetControllingFac(fac)
		self:SetCapping(false)
		self:SetTaken(true)
		self:SetTimer(0)
		self.Capturer = nil
		local col = string.FromColor(BaseWars.Factions.FactionTable[self:GetControllingFac()].color)
		local veccol = Vector(col)
		self:SetFacColor(veccol)

			local fac = factbl[self:GetControllingFac()]
			if fac then 
				fac.XPMult = (fac.XPMult or 0) + 0.1
			end

	end

	function ENT:Use(act, call, usetype, value)
		print('AUTISM')
		if not (act:IsPlayer() and call:IsPlayer() and act==call) then return end
		if not act:InFaction() then act:ChatPrint("You have to be in a faction to capture territories!") return end
		if self:GetControllingFac() == act:GetFaction() then return end
		if self:GetCapping() then return end
		if player.GetCount() < self.MinPlayers then act:ChatPrint("Too little players on the server! (Required at least " .. tostring(self.MinPlayers) .. ")") return end

		local fac = act:GetFaction()
		self:StartCapture(act, fac)
		--self:SetControllingFac(fac)
	end

	function ENT:Thonk()	--this one is ran every 0.2s

		if IsValid(self.Capturer) and self.Capturer:IsPlayer() then 

			if self.Capturer:GetPos():DistToSqr(self:GetPos() - Vector(0,0,16)) > 147456 then 
				self:SetREEEE(true)
				self.TimesStriked = (self.TimesStriked or 0) + 1
				if self.TimesStriked > 10 then 
					self.Capturer = nil
					self:SetREEEE(false)
					self:SetCapping(false)
					return
				end
			else
				self:SetREEEE(false)
				self.TimesStriked = math.max((self.TimesStriked or 0) - 1, 0)
			end

			if not self.Capturer:Alive() then 
				self:SetCapping(false)
				self:SetTimer(0)
			end

			if self:GetCapping() and CurTime() - self:GetTimer() > self.CaptureTime then 
				self:Capture(self.Capturer, self.Capturer:GetFaction())
			end

		end
		if player.GetCount() < self.MinPlayers and self:GetTaken() then self:ResetCapture() return end 

		if BaseWars.Factions.FactionTable[self:GetControllingFac()] then 
			local col = string.FromColor(BaseWars.Factions.FactionTable[self:GetControllingFac()].color)
			local veccol = Vector(col)
			self:SetFacColor(veccol)
		else
			self:SetTaken(false)
			self:SetControllingFac("No faction!")
			self:SetFacColor(Vector(100/255, 100/255, 100/255))
		end

	end


	local lastThonk = CurTime()

	function ENT:Think()
		if CurTime() - lastThonk < 0.2 then return end
		self:Thonk()
		lastThonk = CurTime()
	end

else

	local tbl = {}
	local vars = {}
	local math = math 
	local min = math.min

	local function CircMeUpFam(x, y, radius, seg, perc)

		local cir = {}
	    local times = (seg / 100 * (math.min(perc or 100, 100)) )
	    draw.NoTexture()

	    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )

	    for i = 0, times do
	        local a = math.rad( ( i / seg ) * -360 )
	        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = 0.5} )--math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	    end

	    surface.DrawPoly( cir )

	end


	function ENT:Initialize()

		local e = self:EntIndex()
		tbl[e] = {}
		caps[self] = self
		local function RegisterVar(name, defval)			--this is highly experimental and i have no flipping idea if it actually optimizes or not
			if isstring(name) then 

				tbl[e][name] = tbl[e][name] or defval or 0  --however fprofiler stops saying that this entity adressed the entity metatable 10k times each second thus taking 50ms off each second

			elseif istable(name) then 	
															 --so maybe this works? maybe it doesn't? fuck if i know dude, i just know that storing everything in ENT metatable is a bad habit, according to fprofiler
				for k,v in pairs(name) do
					tbl[e][v] = tbl[e][v] or defval or 0
				end

			end
		end

		RegisterVar({"a1", "a2", "a3", "t1", "t2", "t3", "t4"})	--3D2D Info HUD
		RegisterVar({"Rad"})
		RegisterVar("Col", Color(200,200,200))
		self.m_bInitialized = true --what does m_bVARNAME mean? nobody knows
								   --maybe facepunch does
		vars = tbl[e]
	end

	surface.CreateFont("BigInfo", {

			size     = 48,
			font     = "Helvetica",
			weight   = 500,

		})

	surface.CreateFont("TerritoryInfo", {

			size     = 28,
			font     = "Helvetica",
			weight   = 400,

		})

	surface.CreateFont("OtherInfo", {

			size     = 24,
			font     = "Roboto Light",
			weight   = 600,

		})

	ENT.LookedAt, ENT.LastLooked = false, CurTime() - 2
	ENT.LookedFor = 0

	local function L(s, d, vel)
		if not isnumber(vel) then vel = 5 end
		return Lerp(FrameTime()*vel, (s or 0), d)
	end

	function ENT:OnVis(time)
		local vars = tbl[self:EntIndex()] 
		vars.a1 = L(vars.a1, 100, 8)

		if not self:GetCapping() then 
			if time>0.5 then vars.t1 = L(vars.t1, 100, 2) end
			if time>0.8 then vars.t2 = L(vars.t2, 100, 2) end
			if time>1 then vars.t3 = L(vars.t3, 100, 2) end
			if time>1.2 then vars.t4 = L(vars.t4, 100, 2) end
		else
			if time>0.2 then vars.t1 = L(vars.t1, -200, 1) end
			if time>0.4 then vars.t2 = L(vars.t2, -200, 1) end
			if time>0.5 then vars.t3 = L(vars.t3, -200, 1) end
			if time>0.6 then vars.t4 = L(vars.t4, -200, 1) end
		end

	end

	function ENT:OnTurningInvis(time)
		vars.a1 = L(vars.a1, 0, 4)
		time = time * 4 --shh
		if time>0.2 then vars.t1 = L(vars.t1, -200, 1) end
		if time>0.4 then vars.t2 = L(vars.t2, -200, 1) end
		if time>0.5 then vars.t3 = L(vars.t3, -200, 1) end
		if time>0.6 then vars.t4 = L(vars.t4, -200, 1) end

	end

	function ENT:OnInvis()
		vars.t1 = 0
		vars.t2 = 0
		vars.t3 = 0
		vars.t4 = 0
		self.LookedFor = 0
		self.LastLooked = 0
	end

	function ENT:DrawInfo()

		local me = LocalPlayer()
		local vars = tbl[self:EntIndex()] 

		if me:GetEyeTrace().Entity == self or self:GetPos():DistToSqr(LocalPlayer():GetPos()) < 65536 then 
			self.LookedAt = true 
			self.LastLooked = CurTime() 
			self.LookedFor = self.LookedFor + FrameTime()
		end

		if CurTime() - self.LastLooked < min(5, self.LookedFor*2) then 

			self:OnVis(CurTime() - self.LastLooked+self.LookedFor )

		else
			local time = CurTime() - self.LastLooked - min(5, self.LookedFor*2)
			self:OnTurningInvis( time*2 )

		end


		if vars.a1 < 1 then self:OnInvis() end


		surface.SetDrawColor(70,70,155, vars.a1*1.5)
		surface.DrawRect(0,0,400,200)

		surface.SetDrawColor(155,155,155, vars.a1*1.8)
		surface.DrawRect(8,8,386,186)
		
		local facName = ""
		if not self:GetTaken() then 
			facName = "Not captured!"
		else
			surface.SetFont("TerritoryInfo")
			local sX, sY = surface.GetTextSize(self:GetControllingFac())
			if sX > 200 then facName = "Captured by " .. string.sub(self:GetControllingFac(), 1, 12) .. "..."
			else facName = "Captured by " .. self:GetControllingFac() end
			
		end

			draw.SimpleText(facName or "what", "TerritoryInfo", 400/2, 30, Color(255,255,255, min(vars.t1, vars.a1)*2.5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			draw.SimpleText("Bonus EXP multiplier: " .. self.EXPMult .. "x", "OtherInfo", vars.t2/4, 70, Color(255,255,255, min(vars.t2, vars.a1)*2.5), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(tostring(self.CaptureTime) .. "s. to capture", "OtherInfo", vars.t3/4, 100, Color(255,255,255, min(vars.t3, vars.a1)*2.5), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			--draw.SimpleText("Even more damn info", "OtherInfo", vars.t4/4, 130, Color(255,255,255, min(vars.t4, vars.a1)*2.5), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			local capText = (not self:GetTaken() and "Use to start capturing!") or (LocalPlayer():GetFaction()==self:GetControllingFac() and "This already belongs to you!") or (LocalPlayer():InRaid() and "Cannot capture while in raid!") or "Use to neutralize capture!"
			local sindiff = math.sin(CurTime()*3)*40
			local capCol = Color(240+sindiff, 30+sindiff/2, 30+sindiff/2)

			draw.SimpleText(capText, "OtherInfo", 386/2, 160, ColorAlpha(capCol, min(vars.t4*2.5, vars.a1*2.5)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if self:GetCapping() then
			local sindiff = math.sin(CurTime()*2)*40
			local capCol = Color(240+sindiff, 10+sindiff, 10+sindiff, 255)

			draw.SimpleText("Capturing!", "BigInfo", 386/2, 50, capCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			local perc = (CurTime() - self:GetTimer()) / self.CaptureTime * 100 --percent of capture done (1 - 100)
			surface.SetDrawColor(255 - perc*2.55, perc*2.55, 40)
			CircMeUpFam(386/2, -75, 50, 64, (CurTime() - self:GetTimer()) / self.CaptureTime * 100 )
		end

	end

	function ENT:DrawClaimedFaction()
		local fac = self:GetTaken()
		local col = Color(100, 100, 100)

		if fac then 
			col = (self:GetFacColor()/255):ToColor()
		end

		surface.SetDrawColor(col)
		surface.DrawRect(250,0,237,235)
	end

	function ENT:DrawCapturing()
		vars.Rad = L(vars.Rad, 384)
		if self:GetREEEE() then 
			vars.Col = ValGoTo(vars.Col, Color(230, 50, 50))
		else
			vars.Col = ValGoTo(vars.Col, Color(200,200,200))
		end

		surface.SetDrawColor( ColorAlpha(vars.Col, 100) )
		draw.NoTexture()
		CircMeUpFam(0, 0, vars.Rad, 128)
	end

	function ENT:Draw()

		self:DrawModel()
		if not self.m_bInitialized then self:Initialize() return end
		if not tbl[self:EntIndex()] then self:Initialize() return end
		local pos, ang, scale = self:GetPos(), self:GetAngles(), 0.1

		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 90)

		pos = pos + ang:Forward() * 4

		cam.Start3D2D(pos, ang, scale)
			local ok, err = pcall(self.DrawInfo, self)
			if not ok then
				print(err)
			end
		cam.End3D2D()


		pos = self:GetPos() + ang:Up() * 5.7 + ang:Right() * -66 + ang:Forward() * -36.8
		ang = ang + Angle(0,0,0.1)
		cam.Start3D2D(pos, ang, scale)
			local ok, err = pcall(self.DrawClaimedFaction, self)
			if not ok then
				print(err)
			end
		cam.End3D2D()

		pos = self:GetPos() + ang:Up() * -5.8 + ang:Right() * -65.5 + ang:Forward() * -36.8
		ang = ang + Angle(0,0,-0.4)
		cam.Start3D2D(pos, ang, scale)
			local ok, err = pcall(self.DrawClaimedFaction, self)
			if not ok then
				print(err)
			end
		cam.End3D2D()
	end

	--https://forum.facepunch.com/f/gmoddev/njdo/Draw-Circle-On-Ground-With-Given-Radius/1/

	hook.Add("PostDrawOpaqueRenderables", "WAAH", function(what, skybox)
		for k,v in pairs(caps) do 	--I HATE IT GODDAMNIT
			if not IsValid(v) then caps[k] = nil return end
			if v.TerritoryMarker and v.GetCapping and v:GetCapping() then
				local pos, ang, scale = v:GetPos(), v:GetAngles(), 1
				pos = pos + ang:Up()*-64
				cam.Start3D2D(pos, ang, scale)
					local ok, err = pcall(v.DrawCapturing, v)
					if not ok then
						print(err)
					end
				cam.End3D2D()
			end


		end

	end)

end
