-- BaseWars Menu for things and shit
-- by Ghosty

local me = LocalPlayer()
BWFrame = nil
FacErrorReceiver = nil

local newPnl
local maxFac = 4 
MoarPanelsMats["stripes"] = Material("data/hdl/stripes.png", "noclamp")

local stripes = MoarPanelsMats["stripes"]

if MoarPanelsMats["stripes"]:IsError() then
	hdl.DownloadFile("https://i.imgur.com/PJqjQyC.png", "stripes.png", function(fn) MoarPanelsMats["stripes"] = Material(fn, "noclamp") stripes = MoarPanelsMats["stripes"] end)
end

local expanded = nil
local rexpanded = nil 


local justJoined = false 

local function PaintFactionButton(self, w, h, v, glowa, neww, newcol, sU, sV, num, exp)
	if v.id == LocalPlayer():Team() then 
		self.NoDraw = true
		if h>80 then
			draw.RoundedBoxEx(8, 0, 76, w, 126, Color(30, 30, 30), false, false, true, true)
		end

		draw.RoundedBox(8, 0, 0, w, 80, Color(80, 150, 80, glowa))
		draw.RoundedBox(8, 4, 4, w-10, 72, self.drawColor)

	else 
		self.NoDraw = false
		draw.RoundedBoxEx(8, 0, 80, w, 122, Color(30, 30, 30), false, false, true, true)

	end

		local full = neww >= 592
		if v.id == LocalPlayer():Team() then 
			draw.RoundedBoxEx(8, 4, 4, neww-8, 72, newcol, true, full, true, full)
		else 
			draw.RoundedBoxEx(8, 0, 0, neww, 80, newcol, true, full, true, full)
		end

	surface.SetDrawColor(0, 0, 0, 1)

	render.SetStencilEnable(true)
		render.ClearStencil()
		render.SetStencilWriteMask( 3 )
		render.SetStencilTestMask( 3 )
		
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilFailOperation(STENCIL_REPLACE)
		render.SetStencilZFailOperation(STENCIL_REPLACE)

		render.SetStencilReferenceValue( 1 )

		--draw.RoundedPolyBoxEx(8, 4, 4, neww-8, 72, Color(0, 0, 0, 1), not full, not full)

		if v.id == LocalPlayer():Team() then 
			draw.RoundedPolyBoxEx(8, 4, 4, neww-8, 72, newcol, not full, not full)
		else 
			draw.RoundedPolyBoxEx(8, 0, 0, neww, 80, newcol, not full, not full or exp, exp)
		end


		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilFailOperation(STENCIL_REPLACE)
		render.SetStencilZFailOperation(STENCIL_REPLACE)

		surface.SetMaterial(stripes)

		surface.SetDrawColor(255, 255, 255, 100)
		local membw = w/maxFac
		local teamw = membw * num
		local uvm = num

		local uvs = {0 - sU, 0 - sV, 0.25 - sU, 0.25 - sV}

		--[[
			modify 1 to increase horizontal speed
			modify 2 to increase vertical speed 
			modify 3 to increase horizontal scale
			modify 4 to increase vertical scale

			speeds must be always same distance or stripes will start changing angle
		]]

		uvs[3] = uvs[1] + 0.25*num

		surface.DrawTexturedRectUV(0, -80, neww, 160, unpack(uvs))

	render.SetStencilEnable(false)

	draw.SimpleText(v.name .. " ", "R24", 16, 72/2 - 12, color_white, 0, 1)
	draw.SimpleText("Leader: " .. (IsValid(v.own) and v.own:Nick()) or "???", "TW24", 16, 72/2 + 12, Color(200, 200, 200), 0, 1)
end

local function CreateFactionRaidButton(fs, v)
	local b = vgui.Create("FButton", fs)

	b:SetSize(600, 80)
	b:DockMargin(24, 12, 24, 8)
	b:Dock(TOP)
	b.DrawShadow = false 
	b.id = v.id
	b:PopIn()
	local neww = (600-48)/maxFac * team.NumPlayers(v.id)
	local sU = 0
	local sV = 0

	function b:PrePaint(w, h)

		if rexpanded == self and h~=160 then 
			self:SetSize(w, L(h, 160, 10, true))
		elseif rexpanded ~= self and h~= 80 then 
			self:SetSize(w, L(h, 80, 10, true))
		end
		
	end

	if v.id ~= LocalPlayer():Team() then 
		b.Raid = vgui.Create("FButton", b)
		local bj = b.Raid --nuthin to do with blowjobs

		bj:SetPos(600/2 - 125, 80 + (160 - 80 - 50) / 2)
		bj:SetSize(250, 50)
		bj.DrawShadow = false

		bj.Label = "Start Raid"
		bj:SetColor(200, 70, 70)

		function bj:Think()
			if not LocalPlayer():InFaction() then 
				self.Font = "TW18"
				self.TextY = 8

				self.Label = "Can't start a raid against a\nfaction while not in a faction yourself!"

				self:SetWide(L(self:GetWide(), 350, 5, true))
				self:CenterHorizontal()

				self.Color = Color(60, 60, 60)
				self:SetAlpha(120)

				self.Disabled = true
			elseif LocalPlayer():InRaid() then 

				self.Font = "TWB32"
				self.Label = (LocalPlayer():IsRaider() and "Can't start an another raid while in a raid!") or "Can't start a raid while\nin a raid yourself!"

			else
				self.Font = "TWB32"
				self.Label = "Start Raid"

				self:SetWide(L(self:GetWide(), 250, 5, true))
				self:CenterHorizontal()

				local sin = math.sin(CurTime() * 2)
				local nc = Color(200 + sin*20, 70 + sin*10, 70 + sin*10)

				self.Color = LC(self.Color, nc)
				self:SetAlpha(255)

				self.Disabled = false
			end	
		end

		function bj:DoClick()
			if self.Disabled then return end 

			hook.Add("OnRaid", self, function(self, ok, two)

				if ok then 
					if IsValid(BWFrame) then BWFrame:PopOut() return end 
				end

				if not IsValid(BWFrame) then return end 
				local popup = vgui.Create("DLabel", BWFrame)
				popup:SetSize(BWFrame:GetWide(), BWFrame:GetTall() - BWFrame.HeaderSize)
				popup.Y = BWFrame.HeaderSize
				popup:SetText("")
				popup:PopIn()

				popup:SetMouseInputEnabled(true)

				local a = 0
				function popup:Paint(w, h)
					a = L(a, 250, 15)
					surface.SetDrawColor(Color(0, 0, 0, a))
					surface.DrawRect(0, 0, w, h)

					draw.SimpleText("Raid failed!", "OSB48", w/2, h/2 - 24, ColorAlpha(color_white, a), 1, 1)
					draw.DrawText(isstring(two) and two or "No reason provided.", "OS32", w/2, h/2 + 8, ColorAlpha(color_white, a), 1, 1)
				end

				function popup:DoClick()
					self:PopOut()
				end
			end)

			Raids.CallRaid(v.id, true) --faction raid

		end

	end

	local glowa = 0
	local ot = CurTime()
	

	function b:PostPaint(w, h)
		local membs = team.NumPlayers(v.id)
		neww = L(neww, (604)/maxFac * membs, 10, true)

		local eich, s, vee = ColorToHSV(v.col)
		sU = (sU + FrameTime()/32)--%0.2
		sV = (sV + FrameTime()/48)--%0.2
		s = s * 0.7

		vee = math.max(0.08, vee * 0.6)

		local newcol = HSVToColor(eich,s,vee)

		local sx, sy = self:LocalToScreen(0, 0)

		if CurTime() - ot > 0.2 then glowa = L(glowa, 255, 10, true) end
		if fs:GetParent():GetAlpha() ~= 255 then glowa = 0 end

		PaintFactionButton(self, w, h, v, glowa, neww, newcol, sU, sV, membs, rexpanded==self)
	end
	function b:OnClick()
		if b.id == LocalPlayer():Team() then return false end 
	end
	return b
end

local function CreateFactionButton(fs, v)

	local b = vgui.Create("FButton", fs)

	b:SetSize(600, 80)
	b:DockMargin(24, 12, 24, 8)
	b:Dock(TOP)
	b.DrawShadow = false 
	b.id = v.id
	b:PopIn()
	local neww = (600-48)/maxFac * team.NumPlayers(v.id)
	local sU = 0
	local sV = 0

	function b:PrePaint(w, h)

		if expanded == self and h~=160 then 
			self:SetSize(w, L(h, 160, 10, true))
		elseif expanded ~= self and h~= 80 then 
			self:SetSize(w, L(h, 80, 10, true))
		end
		if LocalPlayer():InFaction() and justJoined then 
			justJoined = false
			BWFrame:PopOut()
			BWFrame = nil
		end
	end

	timer.Simple(0.2, function()	--factions may come in earlier than the player's team updates for some reason

		if not b or not IsValid(b) then return end 

		if v.id ~= LocalPlayer():Team() then 
			b.Join = vgui.Create("FButton", b)
			local bj = b.Join --nuthin to do with blowjobs
			bj:SetPos(600/2 - 125, 95)
			bj:SetSize(250, 50)
			bj.DrawShadow = false
			function bj:Think()
				if team.NumPlayers(v.id) >= 4 then 
					self:SetColor(40, 40, 40)
					self.Label = "Maximum members reached!"
					self.Disabled = true
				elseif LocalPlayer():InRaid() then 
					self:SetColor(40, 40, 40)
					self.Label = "Can't join a faction in a raid!"
					self.Disabled = true
				elseif not LocalPlayer():InFaction() then
					self:SetColor(100, 200, 100)
					self.Label = "Join Faction"
					self.Disabled = false
				elseif LocalPlayer():InFaction() then
					self:SetColor(50, 50, 50)
					self.Label = "Leave your faction first!"
					self.Disabled = true
				end
			end

			function bj:DoClick()
				local pw = v.pw 
				if LocalPlayer():InFaction() or self.Disabled then return end 

				if pw and not self.te then 
					self:MoveTo(24, self.Y, 0.8, 0, 0.1)

					self.te = vgui.Create("FTextEntry", b)
					self.te:SetPlaceholderText("Enter password...")
					self.te:PopIn()
					self.te:SetSize(275, 36)
					self.te:SetPos(24 + 250 + 36, bj.Y + 40 - 18)
					local tx, ty = 24 + 250 + 36, bj.Y + 40 - 18
					self.te.BGColor = Color(60, 60, 60)
					local bad = 0

					function self.te:Think()

						if self.bad then 
							bad = bad + FrameTime()*10
							if bad > 1.2 then 
								self.bad = false 
							end
						else 
							bad = math.max(bad - FrameTime()*4, 0)
						end

						local shake = math.sin(CurTime() * 30) * math.min(bad, 1)
						self:SetPos(tx + shake*18, ty)
					end

					self.Label = "Submit"
					return
				end

				if not pw then 
					net.Start("Factions")
						net.WriteUInt(3, 4)
						net.WriteString(v.name)
					net.SendToServer()
				elseif pw and self.te then
					net.Start("Factions")
						net.WriteUInt(3, 4)
						net.WriteString(v.name)
						net.WriteString(self.te:GetValue())
					net.SendToServer()
				end

				FacErrorReceiver = function()
					if IsValid(self) then 
						local te = self.te 
						te.bad = true
					end
				end
				justJoined = true 

			end

		else 
			b.Leave = vgui.Create("FButton", b)
			local b = b.Leave 
			b:SetPos(600/2 - 125, 80 + (160 - 80 - 50)/2)
			b:SetSize(250, 50)
			b:SetColor(200, 70, 70)
			b.Label = "Leave Faction"
			b.DrawShadow = false
			function b:Think()
				if LocalPlayer():InRaid() then 
					self.Disabled = true 
					self.Label = "Can't leave faction in a raid!"
					self:SetColor(60, 60, 60)
				else 
					self.Disabled = true 
					self.Label = "Leave Faction"
					self:SetColor(200, 70, 70)
				end
			end
			function b:DoClick()
				net.Start("Factions")
				net.WriteUInt(2, 4)
				net.SendToServer()
				BWFrame:PopOut()
				BWFrame = nil
			end
		end
	end)

	local glowa = 0
	local ot = CurTime()

	function b:PostPaint(w, h)
		local membs = team.NumPlayers(v.id)
		neww = L(neww, (604)/maxFac * membs, 10, true)

		local eich, s, vee = ColorToHSV(v.col)
		sU = (sU + FrameTime()/32)--%0.2
		sV = (sV + FrameTime()/48)--%0.2
		s = s * 0.7

		vee = math.max(0.08, vee * 0.6)

		local newcol = HSVToColor(eich,s,vee)

		local sx, sy = self:LocalToScreen(0, 0)

		if CurTime() - ot > 0.2 then glowa = L(glowa, 255, 10, true) end
		if fs:GetParent():GetAlpha() ~= 255 then glowa = 0 end

		PaintFactionButton(self, w, h, v, glowa, neww, newcol, sU, sV, membs, expanded == self)

	end
	function b:DoClick()
		if expanded == self then expanded = nil return end
		expanded = self
	end
	return b
end
function CreateBWFrame()
	local f = vgui.Create("TabbedFrame")
	f:SetSize(700, 550)
	f:SetPos(ScrW()/2 - 350, ScrH() - 1)
	f:SpringIn(nil, nil, -1, ScrH()/2 - 275, 0.6)
	f:MakePopup()
	justJoined = false 

	f.Shadow = {}
	f:PopIn()
	f.Label = "BaseWars"

	stripes = MoarPanelsMats["stripes"] --refresh

	expanded = nil 

	BWFrame = f

	local facs

	f:AddTab("Factions", function()
		facs = vgui.Create("InvisPanel", f)

		f:AlignPanel(facs)

		facs:DockPadding(24, 16, 24, 24)
		facs:PopIn()

		local fs = vgui.Create("FScrollPanel", facs)
		fs:Dock(FILL)

		fs.BackgroundColor = Color(40, 40, 40)
		fs.GradBorder = true 

		fs.BorderW = 2 

		local facbtns = {}

		for k,v in pairs(GetFactions()) do 
			if isnumber(v.own) and IsPlayer(Player(v.own)) then Factions.Factions[k].own = Player(v.own) end
			facbtns[v.name] = CreateFactionButton(fs, v)

		end

		local new = vgui.Create("FButton", facs)

		new.Label = "Create Faction"

		new:Dock(BOTTOM)
		new:SetSize(240, 60)
		new:DockMargin(200, 16, 200, 0)
		new:SetColor(40, 130, 230)

		hook.Add("FactionsUpdate", "BWMenu", function()
			if not IsValid(facs) then return end 
			local f = Factions.Factions

			for k,v in pairs(f) do --add factions that didnt exist
				if facbtns[k] then continue end
				facbtns[v.name] = CreateFactionButton(fs, v)

			end

			for k,v in pairs(facbtns) do --remove factions that existed
				if not f[k] then v:PopOut() facbtns[k] = nil end
			end
		end)

		function new:PostPaint(w,h)

			if LocalPlayer():InRaid() then 
				self.Disabled = true 
				self.DrawShadow = false
				self:SetAlpha( L(self:GetAlpha(), 120, 10, true) )
				new:SetColor(60, 60, 60)
				self.Label = "Can't create factions in a raid!"
				self:DockMargin(160, 16, 160, 0)

			elseif LocalPlayer():InFaction() then 
				self.Disabled = true 
				self.DrawShadow = false
				self:SetAlpha( L(self:GetAlpha(), 120, 10, true) )
				new:SetColor(60, 60, 60)
				self.Label = "Already in a faction!"
				self:DockMargin(160, 16, 160, 0)

			else 
				self.Disabled = false 
				self.DrawShadow = true
				self:SetAlpha( L(self:GetAlpha(), 255, 10, true) )
				new:SetColor(40, 130, 230)
				self.Label = "Create Faction"
				self:DockMargin(200, 16, 200, 0)
			end

		end

		new.DoClick = function()
			if new.Disabled then return end 

			if IsValid(newPnl) then newPnl:PopOut() newPnl = nil f.Dim = false return end 

			f.Dim = true

			newPnl = vgui.Create("FFrame")
			newPnl:SetCloseable(false, true)
			newPnl:SetPos(new:LocalToScreen(new:GetWide()/2 - 250, -200 + 16))
			newPnl:MoveBy(-1, -24, 0.1, 0, 0.3)
			newPnl:SetSize(500, 200)

			newPnl:MakePopup()
			newPnl:PopIn()
			newPnl.Shadow = {}

			function newPnl:Think()
				if not IsValid(f) then self:Remove() return end 
				self:MoveToFront()
			end

			local ten = vgui.Create("FTextEntry", newPnl)
			ten:SetPos(12, f.HeaderSize + 8)
			ten:SetSize(256, 28)
			ten:SetPlaceholderText("Name")

			local tepw = vgui.Create("FTextEntry", newPnl)
			tepw:SetPos(12, f.HeaderSize + 40 + 8)
			tepw:SetSize(256, 28)
			tepw:SetPlaceholderText("Password")

			local col = vgui.Create("DColorMixer", newPnl)
			col:SetPos(12 + 256 + 12, f.HeaderSize + 8)
			col:SetSize(500 - (12 + 256 + 12) - 8, 200 - f.HeaderSize - 16)
			col:SetPalette(false)
			col:SetAlphaBar(false)
			col:SetWangs(false)
			col:SetColor(Color(math.random(0, 255), math.random(0, 255), math.random(0, 255)))
			newPnl.HeaderColor = col:GetColor()
			function col:ValueChanged(col)
				newPnl.HeaderColor = col
			end

			local done = vgui.Create("FButton", newPnl)
			done.Label = "Create"
			done.Disabled = true 
			done:SetColor(25, 40, 25)
			done:SetSize(200, 40)
			done:SetPos(12, 200 - 8 - 40)

			function done:Think()
				local n = ten:GetValue()
				local pw = tepw:GetValue()
				if self.Disabled then 
					self:SetColor(25, 40, 25)
					self.LabelColor = Color(200, 200, 200)
				else 
					self:SetColor(80, 170, 80)
					self.LabelColor = Color(255, 255, 255)
				end
				if #n < 5 or #n > 64 then self.Disabled = true return end 
				if #pw > 16 then self.Disabled = true return end

				self.Disabled = false 
			end

			function done:DoClick()
				if self.Disabled then return end
				net.Start("Factions")
					net.WriteUInt(1, 4)
					net.WriteString(ten:GetValue())	--there are checks serverside, dont you worry
					net.WriteString(tepw:GetValue())
					local col = col:GetColor()
					
					net.WriteColor(Color(col.r, col.g, col.b))
				net.SendToServer()
				newPnl:PopOut()
				f.Dim = false 
				new.Disabled = true

				newPnl = nil 

			end
		end

	end, function()
		if facs then
			facs:PopOut()
			facs = nil
		end
	end)

	local rfacs

	f:AddTab("Raids", function()

		rfacs = vgui.Create("InvisPanel", f)
		local facs = rfacs --xd

		f:AlignPanel(facs)

		facs:DockPadding(24, 16, 24, 12)
		facs:PopIn()

		local fs = vgui.Create("FScrollPanel", facs)
		fs:Dock(FILL)
		fs:DockMargin(0, 0, 0, 12)
		fs.BackgroundColor = Color(40, 40, 40)
		fs.GradBorder = true 

		fs.BorderW = 2 

		local c = vgui.Create("FButton", rfacs)

		c:Dock(BOTTOM)
		c:DockMargin(200, 20, 200, 0)
		c:SetSize(20, 60)
		c.Label = "Concede Raid"
		c.Pressed = 0
		c.DrawShadow = false --looks ugly
		function c:Think()
			local canconc = LocalPlayer():InRaid() and LocalPlayer():IsRaider()

			if not canconc then 
				self:SetColor(60, 60, 60)
				self.Disabled = true 
			else 
				self:SetColor(190, 70, 70)
				self.Disabled = false 
			end

		end

		function c:DoClick()
			if self.Disabled then return end 
			if self.Pressed == 0 then 
				self.Pressed = self.Pressed+1
				self.Label = "Are you sure?\nThis will instantly stop the raid!"
				self.Font = "TW18"

				self.TextY = 12
				return
			end 

			net.Start("Raid")
				net.WriteUInt(3, 4) -- = concede 
			net.SendToServer()
			f:PopOut()
			rfacs = nil
		end

		local facbtns = {}
		local plybtns = {}

		for k,v in pairs(GetFactions()) do 
			if isnumber(v.own) and IsPlayer(Player(v.own)) then Factions.Factions[k].own = Player(v.own) end
			facbtns[v.name] = CreateFactionRaidButton(fs, v)

		end

		for k,v in pairs(player.GetAll()) do 
			if v:Team() ~= 1 or v == LocalPlayer() then continue end 

			local b = vgui.Create("EButton", fs)
			plybtns[#plybtns + 1] = b
			b:SetSize(600, 80)
			b:DockMargin(24, 12, 24, 8)
			b:Dock(TOP)
			b.DrawShadow = false 

			local av = vgui.Create("AvatarImage", b)
			av:SetPlayer(v, 64)
			av:SetSize(64, 64)
			av:SetPos(16, 80/2 - 32)
			
			av:SetPaintedManually(true)

			function b:PrePaint(w, h)

				--if rexpanded == self and h~=160 then 
				--	self:SetSize(w, L(h, 160, 10, true))
				--elseif rexpanded ~= self and h ~= 80 then 
				--	self:SetSize(w, L(h, 80, 10, true))
				--end

			end

			function b:PostPaint(w,h)
				if not IsValid(v) then self:PopOut() return end 

				local w, h = av:GetSize()

				render.SetStencilEnable(true)

					render.ClearStencil()
					render.SetStencilWriteMask( 3 )
					render.SetStencilTestMask( 3 )
					
					render.SetStencilCompareFunction( STENCIL_ALWAYS )
					render.SetStencilPassOperation( STENCIL_REPLACE )

					render.SetStencilReferenceValue( 1 ) --include

					draw.Circle(16 + w/2, (80/2 - 32) + h/2, w/2, 32)

					render.SetStencilCompareFunction( STENCIL_EQUAL )
					render.SetStencilFailOperation( STENCIL_KEEP )
					render.SetStencilZFailOperation( STENCIL_KEEP )

					av:PaintManual()

				render.SetStencilEnable(false)

				draw.SimpleText(v:Nick() .. " ", "R24", 80 + 16, 8, color_white, 0, 5)
				local lcol = Color(80, 80, 80)
				if v:GetLevel() < 100 then lcol = Color(210, 100, 100) self.Disabled = true end
				draw.SimpleText("Level: " .. v:GetLevel(), "R18", 80 + 24, 32, lcol, 0, 5) 

			end

			b.Raid = vgui.Create("FButton", b)
			local bj = b.Raid --nuthin to do with blowjobs

			bj:SetPos(600/2 - 125, 80 + 80/2 - 25)
			bj:SetSize(250, 50)
			bj.DrawShadow = false

			bj.Label = "Start Raid"
			bj:SetColor(200, 70, 70)

			

			function bj:Think()
				if LocalPlayer():InFaction() then 
					self.Font = "TW18"
					self.TextY = 8

					self.Label = "Can't start a raid against a\nsingle player while in a faction!"

					self:SetWide(L(self:GetWide(), 350, 5, true))
					self:CenterHorizontal()

					self.Color = Color(60, 60, 60)
					self:SetAlpha(120)

					self.Disabled = true
				elseif LocalPlayer():InRaid() then 

					self.Font = "TWB24"
					self.Label = (LocalPlayer():IsRaider() and "Can't start an another raid while in a raid!") or "Can't start a raid while\nin a raid yourself!"

				else
					self.Font = "TWB32"
					self.Label = "Start Raid"

					self:SetWide(L(self:GetWide(), 250, 5, true))
					self:CenterHorizontal()

					self.Color = Color(200, 70, 70)
					self:SetAlpha(255)

					self.Disabled = false
				end	
			end

			function bj:DoClick()
				if self.Disabled then return end 

				hook.Add("OnRaid", self, function(self, ok, two)	--first arg in the function is the button, somehow????????
					if ok then 
						if IsValid(BWFrame) then print("dicknigga", ok, two) BWFrame:Remove() return end 
					end

					if not IsValid(BWFrame) then return end 
					local popup = vgui.Create("DLabel", BWFrame)
					popup:SetSize(BWFrame:GetWide(), BWFrame:GetTall() - BWFrame.HeaderSize)
					popup.Y = BWFrame.HeaderSize
					popup:SetText("")
					popup:PopIn()

					popup:SetMouseInputEnabled(true)

					local a = 0
					function popup:Paint(w, h)
						a = L(a, 250, 15)
						surface.SetDrawColor(Color(0, 0, 0, a))
						surface.DrawRect(0, 0, w, h)

						draw.SimpleText("Raid failed!", "OSB48", w/2, h/2 - 24, ColorAlpha(color_white, a), 1, 1)
						draw.DrawText(isstring(two) and two or "No reason provided.", "OS32", w/2, h/2 + 8, ColorAlpha(color_white, a), 1, 1)
					end

					function popup:DoClick()
						self:PopOut()
					end

					self.Disabled = false
				end)

				Raids.CallRaid(v, false) --not faction
				self.Disabled = true
			end
			
			function b:OnClick()
				for k,v in ValidPairs(facbtns) do 
					if v ~= self then v.Expand = false end 
				end
				for k,v in ValidPairs(plybtns) do 
					if v ~= self then v.Expand = false end 
				end
			end
		end

		

	end, function()
		if rfacs then 
			rfacs:PopOut()
			rfacs = nil 
		end
	end)

	f:SelectTab("Factions")
end
hook.Add("Think", "BaseWars.Menu.Open", function()

	me = LocalPlayer()

    local wep = me:GetActiveWeapon()
	if wep ~= NULL and wep.CW20Weapon and wep.dt.State == (CW_CUSTOMIZE or 4) then return end

	if input.IsKeyDown(KEY_F3) then
		if IsValid(BWFrame) then return end 
		CreateBWFrame()
	end
	

end)
