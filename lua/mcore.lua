if SERVER then print('my god what the fuck did you just do ~MCore') return end 
--[[
LocalPlayer():ConCommand("gmod_mcore_test 1")

LocalPlayer():ConCommand("mat_queue_mode -1")

LocalPlayer():ConCommand("cl_threaded_bone_setup 1")

LocalPlayer():ConCommand("cl_threaded_client_leaf_system 1")

LocalPlayer():ConCommand("r_threaded_particles 1")

LocalPlayer():ConCommand("r_threaded_renderables 1")

LocalPlayer():ConCommand("r_queued_ropes 1")

LocalPlayer():ConCommand("studio_queue_mode 1")
]]
local function ApplyMCoreCommands()

	LocalPlayer():ConCommand("gmod_mcore_test 1")

	LocalPlayer():ConCommand("mat_queue_mode -1")

	LocalPlayer():ConCommand("cl_threaded_bone_setup 1")

	LocalPlayer():ConCommand("cl_threaded_client_leaf_system 1")

	LocalPlayer():ConCommand("r_threaded_particles 1")

	LocalPlayer():ConCommand("r_threaded_renderables 1")

	LocalPlayer():ConCommand("r_queued_ropes 1")

	LocalPlayer():ConCommand("studio_queue_mode 1")

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

local bg = Color(59, 67, 87)
local hd = Color(36, 121, 222)

local btnW, btnY = 150, 40

local btnCol1 = {
	[0] = Color(90,170,90,240),
	[1] = Color(180,90, 90,240),
}

local btnCol2 = {
	[0] = Color(120, 210,120,240),
	[1] = Color(200, 120, 120,240),
}

surface.CreateFont( "MCore_Remember", {
    font = "Roboto",
    size = 18,
    weight = 50,
} )
surface.CreateFont( "MCore_Remember2", {
    font = "Roboto",
    size = 20,
    weight = 50,
} )

if tonumber(LocalPlayer():GetPData("MCore_Remember")) == 0 then return end

local mconvar = GetConVar("gmod_mcore_test"):GetBool()
print(LocalPlayer():GetPData("MCore_Remember"), mconvar)
if tonumber(LocalPlayer():GetPData("MCore_Remember")) == 1 and not mconvar then 
	ApplyMCoreCommands()
	local text
	local f = vgui.Create("DFrame")
	f:SetSize(600, 300)
	f:Center()
	f:MakePopup()
	f:SetTitle("")
	f.TA = 0
	f.sX, f.sY = 600, 300
	function f:Paint(w,h)

		draw.RoundedBoxEx(4, 0, 0, w, 24, hd, true, true)
		surface.SetDrawColor(bg)
		surface.DrawRect(0, 24, w, h)
		
		if self.Expand then 
			self.TA = L(self.TA, 0, 10)
			self.sX, self.sY = L(self.sX, 700), L(self.sY, 550)
			if not IsValid(text) then 
				text = vgui.Create("DTextEntry", f)
				text:SetSize(600, 600)
				text:SetPos(20, 30)
				text:SetMultiline(true)
				text:SetFont("MCore_Remember")

				text:SetText([[ 
					 1. Navigate to your Garry's Mod config folder
					 (usually: /Steam/steamapps/common/GarrysMod/garrysmod/cfg)
					 2. Find or create a file named "autoexec.cfg".
					 3. Paste this text in that file:
					 gmod_mcore_test 1
					 cl_threaded_bone_setup 1
					 cl_threaded_bone_setup 1
					 cl_threaded_client_leaf_system 1

					 r_threaded_client_shadow_manager 1
					 r_threaded_particles 1
					 r_threaded_renderables 1
					 r_queued_ropes 1
					
					 4. Save.]])
				function text:Paint(w,h)
					draw.RoundedBox(2, 0, 0, w,h, Color(49, 57, 77))
					self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
					self:SetSize(f.sX-40, f.sY-60)
				end

			end
			self:SetSize(self.sX, self.sY)
			self:Center()
			return
		end
		draw.DrawText("Your multicore settings have not been applied yet; you'll need to reenter the server.\nYou can avoid this by putting those settings in your autoexec config.", "MCore_Remember", w/2, h/2, Color(255,255,255), 1, 1)
	end
	local learn = vgui.Create("DButton", f)
	local accept = vgui.Create("DButton", f)
	local l = learn 
	local a = accept 

	l:SetPos(40, 300-80)
	l:SetSize(200, 60)
	l:SetText("")
	l.Col = btnCol1[0]
	function l:Paint(w,h)
		draw.RoundedBox(4, 0, 0, w, h, self.Col)

		local desCol = (self:IsHovered() and btnCol2[0]) or btnCol1[0]
		if self:IsDown() then local c = btnCol2[0] desCol = Color(c.r*0.7, c.g*0.7, c.b*0.8) end
		draw.SimpleText("Learn more", "MCore_Remember", w/2, h*0.5, Color(255,255,255), 1, 1)
		self.Col = LC(self.Col, desCol, 20)

	end	
	l.DoClick = function(self)
		self:Remove()
		a:Remove()
		f.Expand = true
	end


	a:SetPos(600-40-200, 300-80)
	a:SetSize(200, 60)
	a:SetText("")
	a.Col = btnCol1[1]
	function a:Paint(w,h)
		draw.RoundedBox(4, 0, 0, w, h, self.Col)

		local desCol = (self:IsHovered() and btnCol2[1]) or btnCol1[1]
		if self:IsDown() then local c = btnCol2[1] desCol = Color(c.r*0.7, c.g*0.7, c.b*0.8) end
		draw.SimpleText("Reconnect", "MCore_Remember", w/2, h*0.5, Color(255,255,255), 1, 1)
		self.Col = LC(self.Col, desCol, 20)

	end	
	a.DoClick = function(self)
		self:Remove()
		a:Remove()
		LocalPlayer():ConCommand('retry')
	end

return end

if mconvar then return end 


local p = vgui.Create("DFrame")
p:SetSize(450, 250)
p:Center()
p:MakePopup()
p:SetTitle("")

function p:Paint(w, h)

	draw.RoundedBoxEx(4, 0, 0, w, 24, hd, true, true)

	surface.SetDrawColor(bg)
	surface.DrawRect(0, 24, w, h)

	draw.DrawText("Would you like to enable multicore?\n(Increases performance considerably)", "MCore_Remember2", w/2, h/3, Color(255,255,255), 1, 1)

end


local btns = {}



local btnFuncs = {}
local texts = {"No"}
texts[0] = "Yes"

for i=0, 1 do 
	btns[i] = vgui.Create("DButton", p)
	local b = btns[i]
	b:SetText("")
	b:SetPos(50+200*i, 160)
	b:SetSize(btnW, btnY)
	b.Col = btnCol1[i]
	function b:Paint(w,h)
		draw.RoundedBox(4, 0, 0, w, h, self.Col)

		local desCol = (self:IsHovered() and btnCol2[i]) or btnCol1[i]
		if self:IsDown() then local c = btnCol2[i] desCol = Color(c.r*0.7, c.g*0.7, c.b*0.8) end

		self.Col = LC(self.Col, desCol, 20)
		draw.SimpleText(texts[i], "MCore_Remember", w/2, h/2, Color(255, 255, 255), 1, 1)
	end	
	b.DoClick = function() btnFuncs[i](self, p) end
end



local rem = vgui.Create("DCheckBox", p)
rem:SetPos((450-237-36)/2, 215)
rem:SetSize(18, 18)
rem.Col = Color(40, 50, 80)
rem.ColText = Color(100, 100, 100)
function rem:Paint(w,h)
	draw.RoundedBox(4, 0, 0, w, h, Color(40, 50, 80))
	surface.DisableClipping(true)
		draw.SimpleText("Remember my choice in the future.", (self:GetChecked() and "MCore_Remember2") or "MCore_Remember", 28, 9, self.ColText, 0, 1)
		if self:GetChecked() == true then 
			self.Col = LC(self.Col, Color(70, 190, 70), 30)
			self.ColText = LC(self.ColText, Color(255, 255, 255), 30)
		else
			self.Col = LC(self.Col, Color(40, 50, 80), 30)
			self.ColText = LC(self.ColText, Color(100, 100, 100), 30)
		end
		draw.RoundedBox(4, 2, 2, w-4, h-4, self.Col)
	surface.DisableClipping(false)
end

function rem:OnChange()
	local me = LocalPlayer()
	if rem:GetChecked()==true then 
		EmitSound("vgui/mcore_check.ogg", me:GetPos(), -1, CHAN_AUTO, 0.1, 70, SND_NOFLAGS, 100 )
	else
		EmitSound("vgui/mcore_check.ogg", me:GetPos(), -1, CHAN_AUTO, 0.1, 60, SND_NOFLAGS, 80 )
	end
end

btnFuncs[0] = function(self, frame)
	if rem:GetChecked() then 
		LocalPlayer():SetPData("MCore_Remember", 1)
	end
	frame:Close()

	LocalPlayer():ConCommand("gmod_mcore_test 1")
	LocalPlayer():ConCommand("mat_queue_mode -1")
	LocalPlayer():ConCommand("cl_threaded_bone_setup 1")
	LocalPlayer():ConCommand("cl_threaded_client_leaf_system 1")
	LocalPlayer():ConCommand("r_threaded_particles 1")
	LocalPlayer():ConCommand("r_threaded_renderables 1")
	LocalPlayer():ConCommand("r_queued_ropes 1")
	LocalPlayer():ConCommand("studio_queue_mode 1")
	local f = vgui.Create("DFrame")
	f:SetSize(500, 300)
	f:Center()
	f:MakePopup()
	f:SetTitle("")
	f.Dim = 0
	f.sX, f.sY = 500, 300
	f.TA = 255

	local text = nil 

	function f:Paint(w,h)

		surface.DisableClipping(true)
			self.Dim = L(self.Dim, (self.Expand and 254) or 250, 5)
			surface.SetDrawColor(0, 0, 0, self.Dim)
			surface.DrawRect(-ScrW(), -ScrH(), ScrW()*2, ScrH()*2)
		surface.DisableClipping(false)

		draw.RoundedBoxEx(4, 0, 0, w, 24, hd, true, true)
		surface.SetDrawColor(bg)
		surface.DrawRect(0, 24, w, h)
		draw.DrawText("The changes will not apply until you reconnect to the server.\nYou can make these commands autorun each time your game\nlaunches, by putting certain commands in your autoexec.cfg\nconfig.", "MCore_Remember2", 10, 32, Color(255,255,255, self.TA))
		draw.SimpleText("If you wish to know more, press the button below.", "MCore_Remember2", w/2, h*0.6, Color(255,255,255, self.TA), 1, 1)
		if self.Expand then 
			self.TA = L(self.TA, 0, 10)
			self.sX, self.sY = L(self.sX, 700), L(self.sY, 550)
			if not IsValid(text) then 
				text = vgui.Create("DTextEntry", f)
				text:SetSize(600, 600)
				text:SetPos(20, 30)
				text:SetMultiline(true)
				text:SetFont("MCore_Remember")

				text:SetText([[ 
					 1. Navigate to your Garry's Mod config folder
					 (usually: /Steam/steamapps/common/GarrysMod/garrysmod/cfg)
					 2. Find or create a file named "autoexec.cfg".
					 3. Paste this text in that file:
					 gmod_mcore_test 1
					 cl_threaded_bone_setup 1
					 cl_threaded_bone_setup 1
					 cl_threaded_client_leaf_system 1

					 r_threaded_client_shadow_manager 1
					 r_threaded_particles 1
					 r_threaded_renderables 1
					 r_queued_ropes 1
					
					 4. Save.]])
				function text:Paint(w,h)
					draw.RoundedBox(2, 0, 0, w,h, Color(49, 57, 77))
					self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
					self:SetSize(f.sX-40, f.sY-60)
				end

			end
			self:SetSize(self.sX, self.sY)
			self:Center()
		end


	end
	local b = vgui.Create("DButton", f)
	b:SetText("")
	b:SetPos(60, 220)
	b:SetSize(120, 50)
	b.Col = btnCol1[0]
	function b:Paint(w,h)
		draw.RoundedBox(4, 0, 0, w, h, self.Col)

		local desCol = (self:IsHovered() and btnCol2[0]) or btnCol1[0]
		if self:IsDown() then local c = btnCol2[0] desCol = Color(c.r*0.7, c.g*0.7, c.b*0.8) end
		draw.SimpleText("Learn more", "MCore_Remember", w/2, h*0.5, Color(255,255,255), 1, 1)
		self.Col = LC(self.Col, desCol, 20)

	end	
	b.DoClick = function(self)
		self:Remove()
		f.Expand = true
	end

	local accept = vgui.Create("DButton", f)
	local a = accept 
	a:SetPos(500-120-60, 300-80)
	a:SetSize(120, 50)
	a:SetText("")
	a.Col = btnCol1[1]
	function a:Paint(w,h)
		draw.RoundedBox(4, 0, 0, w, h, self.Col)

		local desCol = (self:IsHovered() and btnCol2[1]) or btnCol1[1]
		if self:IsDown() then local c = btnCol2[1] desCol = Color(c.r*0.7, c.g*0.7, c.b*0.8) end
		draw.SimpleText("Reconnect", "MCore_Remember", w/2, h*0.5, Color(255,255,255), 1, 1)
		self.Col = LC(self.Col, desCol, 20)

	end	
	a.DoClick = function(self)
		self:Remove()
		a:Remove()
		LocalPlayer():ConCommand('retry')
	end

end

btnFuncs[1] = function(self, frame)
	if rem:GetChecked() then 
		LocalPlayer():SetPData("MCore_Remember", 0)
	end

	frame:Close()
end