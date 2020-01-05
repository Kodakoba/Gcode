-- i need to rewrite this this is trash

local OpenPlayerSuggestions 
local OpenSuggestion 
local OpeningMy
local AwaitingPlayer

local Suggestions = {}	--SuggestionInfo {[plyname] = {name; desc}}

local SuggestionInfo = {}

local SuggestionTexts = {}

local OpenedSuggestion
local OpenedNum = 0
local function L(v1, v2, vel)	--shortcut
	if not vel then vel = 15 end
	return Lerp(FrameTime()*vel, v1, v2)
end

function OpenSuggestions()
	NewInfo = false
	local f = vgui.Create("DFrame")
	f:SetSize(750,500)
	f:Center()
	f:MakePopup()
	f.A = 0
	f.Removing = false
	f:SetTitle("")
	local a = 0
	concommand.Add("span",function() f:Remove() end)
		function OpenPlayerSuggestions(my, ply)

			for k,v in pairs(Suggestions) do
				if IsValid(v) and v:IsValid() then 
					v.Deleet = true
				end
			end
			if IsValid(OpenedSuggestion) and OpenedSuggestion:IsValid() then OpenedSuggestion:Remove() end
			local s 
			local new

			local snames = {}
			if SuggestionInfo[ply] and SuggestionInfo[ply].name then 
				snames = string.Split(SuggestionInfo[ply].name, "|-|") or {}
			end

			for i,v in pairs(snames) do
				s = vgui.Create("DButton", f)
				s:SetSize(500, 50)	--750 - 180
				s:SetPos(220, 20 + (60*i))
				s:SetText("")
				local a = 0
				if #v > 50 then 
					s.Text = string.sub(v,1, 50) .. ".."
				else
					s.Text = v
				end

				function s:Paint(w,h)

					if not self.Deleet and not f.Removing then 
						a = L(a, 260)
					else
						a = L(a, -10)
					end

					if a < 0 then self:Remove() end

					surface.SetDrawColor(30,30,30, a)
					surface.DrawRect(0,0, w, h)

					surface.SetDrawColor(90,90,90,a)
					surface.DrawRect(1,1, w-2, h-2)

					draw.SimpleText(self.Text, "RL18",w/2, h/2, Color(240, 240, 240, a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				Suggestions[i] = s
				s.DoClick = function(self) 
					if self.Deleet then return end
					for k,v in pairs(Suggestions) do
						if IsValid(v) and v:IsValid() then 
							v.Deleet = true
						end
					end
					if my then OpeningMy = true else OpeningMy = false end
					timer.Simple(0.4, function() GetSuggestionBody(ply, i) end)
					Suggestions = {}
				end
			end

			

			if my then 

				local new = vgui.Create("DButton", f)
				new:SetSize(250, 40)
				new:SetPos((750-180)/2 + 62, 450)
				new:SetText("")
				local a = 0
				function new:Paint(w,h)
					if not self.Deleet and not f.Removing then 
						a = L(a, 260)
					else
						a = L(a, -10)
					end
					if a < 0 then self:Remove() end
					surface.SetDrawColor(30,30,30, a)
					surface.DrawRect(0,0, w, h)
					surface.SetDrawColor(90,120,90, a)
					surface.DrawRect(1,1, w-2, h-2)
					draw.SimpleText("Create your own!", "RL18",w/2, h/2, Color(240, 240, 240, a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				new.DoClick = function(self)
					if self.Deleet then return end
					for k,v in pairs(Suggestions) do
						if IsValid(v) and v:IsValid() then 
							v.Deleet = true
						end
					end
					self.Deleet = true
					timer.Simple(0.4, CreateSuggestion)
				end
				Suggestions[#Suggestions + 1] = new
			end

			
				

		end

		function OpenSuggestion(text, id)
			if IsValid(OpenedSuggestion) and OpenedSuggestion:IsValid() then OpenedSuggestion:Remove() end
			local f2 = vgui.Create("DPanel", f)
			f2:SetSize(570, 476)
			f2:SetPos(180, 24)
			f2.A = 0
			function f2:Paint(w,h)
				if self.Removing then 
					self.A = L(self.A, 0)
					if self.A < 1 then self:Remove() return end
				else
					self.A = L(self.A, 200)
				end
				surface.SetDrawColor(65,65,65,self.A)
				surface.DrawRect(0,0, w, h)
			end
				local txt = vgui.Create("DTextEntry", f2)
				txt:SetPos(75, 120)
				txt:SetEditable(false)
				txt:SetValue(text)
				txt:SetSize(420, 232)
				txt:SetMultiline(true)
				txt:SetFont("A24")
				function txt:Paint(w,h)
					draw.RoundedBox(2, 0, 0, w,h, Color(40,40,40))
					self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
				end
				if id then 	--auto assume that this is my suggestion
					local del = vgui.Create("DButton", f2)
					del:SetPos(245, 380)
					del:SetSize(80, 40)
					del:SetText("")
					del.A = 0
					function del:Paint(w,h)
						if not self.Deleet and not f.Removing then 
							self.A = L(self.A, 255)
						else
							self.A = L(self.A, 0)
						end
						local a = self.A
						surface.SetDrawColor(30,30,30, a)
						surface.DrawRect(0,0, w, h)
						surface.SetDrawColor(Color(140, 40, 30, a))
						surface.DrawRect(1,1, w-2, h-2)

						draw.SimpleText("Deleet?", "RL18",w/2, h/2, Color(240, 240, 240, a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					end

					del.DoClick = function(self)

						if self.Removing then return end
						DeleteSuggestion(id)
						self.Removing = true
						f2.Removing = true
						f.Removing = true 
						txt:Remove()
						timer.Simple(0.2, function() 
							PreOpenSuggestions(true)
						end)

					end

				end
			OpenedSuggestion = f2 
		end

		function CreateSuggestion()
			if IsValid(OpenedSuggestion) and OpenedSuggestion:IsValid() then OpenedSuggestion:Remove() end

			local f2 = vgui.Create("DPanel", f)
			f2:SetSize(570, 476)
			f2:SetPos(180, 24)
			f2.A = 0
			function f2:Paint(w,h)
				if not self.Deleet and not f.Removing then 
					self.A = L(self.A, 200)
					if self.A < 1 then self:Remove() return end
				else
					self.A = L(self.A, 0)
				end
				local a = self.A

				surface.SetDrawColor(65,65,65,a)
				surface.DrawRect(0,0, w, h)
			end

				local name = vgui.Create("DTextEntry", f2)
				name:SetPos(75, 40)
				name:SetSize(420, 40)
				name:SetFont("A24")
				name:SetPlaceholderText("Title")

				function name:Paint(w,h)

					draw.RoundedBox(2, 0, 0, w,h, Color(40,40,40))
					self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
					
				end

				local txt = vgui.Create("DTextEntry", f2)
				txt:SetPos(75, 120)
				txt:SetSize(420, 232)
				txt:SetMultiline(true)
				txt:SetFont("A24")

				local drawtext = ""
				local origtext = txt:GetValue()
				local curroffset = 0
				local enned = 0

				function txt:Paint(w,h)

					draw.RoundedBox(2, 0, 0, w,h, Color(40,40,40))
					self:DrawTextEntryText(Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255))

				end

				OpenedSuggestion = f2 

				local submit = vgui.Create("DButton", f2)
				submit:SetSize(100, 50)
				submit:SetPos(245, 370)
				submit:SetText("")
				submit.Active = false
				submit.Col = Color(60,160,30) --show em that it autoactivates
				function submit:Paint(w,h)
					if #txt:GetValue() < 10 or #txt:GetValue() > 500 then self.Active = false else self.Active = true end

					if self.Active then
						self.Col = ValGoTo(self.Col, Color(60, 130, 60))
					else
						self.Col = ValGoTo(self.Col, Color(30, 60, 30))
					end

					surface.SetDrawColor(30,30,30)
					surface.DrawRect(0,0, w, h)
					surface.SetDrawColor(self.Col)
					surface.DrawRect(1,1, w-2, h-2)
					draw.SimpleText("Submit", "RL18",w/2, h/2, Color(240, 240, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				submit.DoClick = function(self)
					if not self.Active then return end
					WriteSuggestion(txt:GetValue(), name:GetValue())
					f2:Remove()
					f:Remove()
					PreOpenSuggestions(true)
				end
		end

	function f:Paint(w,h)

		if self.Removing then 
			self.A = L(self.A, 0)
			if self.A < 1 then self:Remove() return end
		else
			self.A = L(self.A, 260)
		end

		local a = self.A
		draw.RoundedBox(0, 0, 0, w, 24, Color(30, 30, 30, a))
		draw.RoundedBoxEx(4, 0, 24, w, h-24, Color(45,45,45, a-10), false, false, true, true)

	end

	local plys = vgui.Create("DScrollPanel", f)
	local scroll = plys:GetVBar()
	scroll:SetHideButtons(true) --fuck off
	plys:SetSize(180, 400)
	plys:SetPos(0, 90)
		local my = vgui.Create("DButton", f)
		my:SetSize(150, 40)
		my:SetPos(10, 24+10)
		my:SetText("")
		my.Me = true
		my.A = 0
		if #LocalPlayer():Nick() > 12 then 
			my.Text = string.sub(LocalPlayer():Nick(),1,12) .. ".."
		else
			my.Text = LocalPlayer():Nick()
		end
			function my:Paint(w, h)

				if not self.Deleet and not f.Removing then 
					self.A = L(self.A, 255)
					if self.A < 1 then self:Remove() return end
				else
					self.A = L(self.A, 0)
				end
				local a = self.A

				surface.SetDrawColor(30,30,30, a)
				surface.DrawRect(0,0, w, h)
				local col = Color(90,90,90, a)
				if self.Me then 
					local v = 80+10*math.sin(CurTime()*1.5)
					col = Color(v,v,v*2, a)
				end
				surface.SetDrawColor(col)
				surface.DrawRect(1,1, w-2, h-2)
				
				draw.SimpleText(self.Text, "RL18",w/2, h/2, Color(240, 240, 240, a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			my.DoClick = function()
				OpenPlayerSuggestions(true, LocalPlayer():Nick())
			end

		local i = 0

		for k,v in pairs(SuggestionInfo) do
			i = i + 1
			local b = plys:Add("DButton")
			b:SetSize(150, 40)
			b:SetPos(10, -36 + (50*i))
			if #LocalPlayer():Nick() > 12 then 
				b.Text = string.sub(tostring(k),1,12) .. ".."
			else
				b.Text = tostring(k)
			end
			b:SetText("")
			b.Me = v.isMe or false
			b.A = 0
			function b:Paint(w, h)

				if not self.Deleet and not f.Removing then 
					self.A = L(self.A, 255)
					if self.A < 1 then self:Remove() return end
				else
					self.A = L(self.A, 0)
				end
				local a = self.A

				surface.SetDrawColor(30,30,30, a)
				surface.DrawRect(0,0, w, h)
				local col = Color(90,90,90, a)
				if self.Me then 
					local v = 80+10*math.sin(CurTime()*1.5)
					col = Color(v,v,v*2, a)
				end
				surface.SetDrawColor(col)
				surface.DrawRect(1,1, w-2, h-2)
				draw.SimpleText(self.Text, "RL18",w/2, h/2, Color(240, 240, 240, a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				--draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 130))
			end

			b.DoClick = function()
				OpenPlayerSuggestions(v.isMe, k)
			end

		end
		
end

local NewInfo = false
local AutoOpen = false
function PreOpenSuggestions(silent)


	myPerks = {Types = {}, Rarities = {}}
	NewInfo = false
	LoadingPerks = true
	net.Start("GetSuggestions")	--bring me the fucking PERKS
	net.SendToServer()
	if not silent then
		local Loading = vgui.Create("DPanel")
		Loading:SetSize(300,300)
		Loading:SetPos(ScrW()/2-150, ScrH()/2+100)
		Loading.a = 5
		Loading.text = "Loading suggestions..."
		function Loading:Paint(w,h)

			if self.Removing then 

				if self.Failed then self.a = Lerp(FrameTime(), self.a, 0) self.text = "Failed to load!" else self.a = Lerp(FrameTime()*20, self.a, 0) end

			else

				self.a = Lerp(FrameTime()*10, self.a, 255)

			end

			if self.a < 3 then
			 self:Remove() 

			 	if not self.Failed then 
					 OpenSuggestions() 
					 timer.Simple(0.3, function() LoadingPerks = false end) 
				end

			 return 
			end

			draw.SimpleText(self.text, "RL24", 150, math.sin(CurTime()*3)*15+100, Color(250,250,250,self.a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			if NewInfo then self.Removing = true end
		end
		timer.Simple(5, function() if not IsValid(Loading) or not Loading:IsValid() then return end Loading.Removing = true Loading.Failed = true end)
	end

	if silent then AutoOpen = true end

end
function GetSuggestionBody(ply, i)

	AwaitingPlayer = ply
	OpenedNum = i

	net.Start("GetSuggestionBodies")
		net.WriteString(ply)
	net.SendToServer()
end

	function WriteSuggestion(txt, name)

		net.Start("WriteSuggestion")
			net.WriteString(name)
			net.WriteString(txt)
		net.SendToServer()

	end

	function DeleteSuggestion(key)
		net.Start("DeleetSuggestion")
		net.WriteUInt(key, 16)
		net.SendToServer()
	end

net.Receive("GetSuggestionBodies", function()

	local my

	if OpeningMy then my = OpenedNum OpeningMy = false end

	local txt = net.ReadString()
	txt = string.Split(txt, "|-|")

	SuggestionTexts[ply] = txt

	OpenSuggestion(txt[OpenedNum] or "what", my)

end)

net.Receive("GetSuggestions", function()
	SuggestionInfo = {}
	local records = net.ReadUInt(16)
	local myrecord = net.ReadUInt(16)

	for i=1, records do 
		local ply = net.ReadString() --name
		local sugma = net.ReadString() --suggestion name
		if sugma == '' then NewInfo = true continue end
		SuggestionInfo[ply] = {name = sugma, isMe = (i==myrecord)}
	end

	if AutoOpen then OpenSuggestions() OpenPlayerSuggestions(true, LocalPlayer():Nick()) AutoOpen = false end
	NewInfo = true
end)
