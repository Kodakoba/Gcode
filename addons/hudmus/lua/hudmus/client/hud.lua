local white = Color(255,255,255)
local main = Color(50, 50, 50)
local dmain = Color(40, 40, 40)


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
local contextMenuOpen = hudmus.ContextMenuOpen

BSHADOWS = BSHADOWS or {}
	 
	--The original drawing layer
	BSHADOWS.RenderTarget = GetRenderTarget("bshadows_original", ScrW(), ScrH())
	 
	--The shadow layer
	BSHADOWS.RenderTarget2 = GetRenderTarget("bshadows_shadow",  ScrW(), ScrH())
	 
	--The matarial to draw the render targets on
	BSHADOWS.ShadowMaterial = CreateMaterial("bshadows","UnlitGeneric",{
	    ["$translucent"] = 1,
	    ["$vertexalpha"] = 1,
	    ["alpha"] = 1
	})
	 
	--When we copy the rendertarget it retains color, using this allows up to force any drawing to be black
	--Then we can blur it to create the shadow effect
	BSHADOWS.ShadowMaterialGrayscale = CreateMaterial("bshadows_grayscale","UnlitGeneric",{
	    ["$translucent"] = 1,
	    ["$vertexalpha"] = 1,
	    ["$alpha"] = 1,
	    ["$color"] = "0 0 0",
	    ["$color2"] = "0 0 0"
	})
	 
	--Call this to begin drawing a shadow
	BSHADOWS.BeginShadow = function()
	 
	    --Set the render target so all draw calls draw onto the render target instead of the screen
	    render.PushRenderTarget(BSHADOWS.RenderTarget)
	 
	    --Clear is so that theres no color or alpha
	    render.OverrideAlphaWriteEnable(true, true)
	    render.Clear(0,0,0,0)
	    render.OverrideAlphaWriteEnable(false, false)
	 
	    --Start Cam2D as where drawing on a flat surface
	    cam.Start2D()
	 
	    --Now leave the rest to the user to draw onto the surface
	end
	 
	--This will draw the shadow, and mirror any other draw calls the happened during drawing the shadow
	BSHADOWS.EndShadow = function(intensity, spread, blur, opacity, direction, distance, _shadowOnly)
	   
	    --Set default opcaity
	    opacity = opacity or 255
	    direction = direction or 0
	    distance = distance or 0
	    _shadowOnly = _shadowOnly or false
	 
	    --Copy this render target to the other
	    render.CopyRenderTargetToTexture(BSHADOWS.RenderTarget2)
	 
	    --Blur the second render target
	    if blur > 0 then
	        render.OverrideAlphaWriteEnable(true, true)
	        render.BlurRenderTarget(BSHADOWS.RenderTarget2, spread, spread, blur)
	        render.OverrideAlphaWriteEnable(false, false)
	    end
	 
	    --First remove the render target that the user drew
	    render.PopRenderTarget()
	 
	    --Now update the material to what was drawn
	    BSHADOWS.ShadowMaterial:SetTexture('$basetexture', BSHADOWS.RenderTarget)
	 
	    --Now update the material to the shadow render target
	    BSHADOWS.ShadowMaterialGrayscale:SetTexture('$basetexture', BSHADOWS.RenderTarget2)
	 
	    --Work out shadow offsets
	    local xOffset = math.sin(math.rad(direction)) * distance
	    local yOffset = math.cos(math.rad(direction)) * distance
	 
	    --Now draw the shadow
	    BSHADOWS.ShadowMaterialGrayscale:SetFloat("$alpha", opacity/255) --set the alpha of the shadow
	    render.SetMaterial(BSHADOWS.ShadowMaterialGrayscale)
	    for i = 1 , math.ceil(intensity) do
	        render.DrawScreenQuadEx(xOffset, yOffset, ScrW(), ScrH())
	    end
	 
	    if not _shadowOnly then
	        --Now draw the original
	        BSHADOWS.ShadowMaterial:SetTexture('$basetexture', BSHADOWS.RenderTarget)
	        render.SetMaterial(BSHADOWS.ShadowMaterial)
	        render.DrawScreenQuad()
	    end
	 
	    cam.End2D()
	end

MusPanel = MusPanel or nil 
--if IsValid(MusPanel) then MusPanel:Remove() end 
--hudmus:StopURL(LocalPlayer())

local playlists = hudmus:GetPlaylists() 

local grad = Material("gui/gradient")

local cog = Material("data/hdl/settings.png", "smooth")
local playMat = Material("data/hdl/play.png", "smooth")
local editMat = Material("data/hdl/edit.png", "smooth")
local ffw = Material("data/hdl/ffw.png", "smooth")
local plMat = Material("data/hdl/playlist.png")

hdl.DownloadFile("https://secure.webtoolhub.com/static/resources/icons/set7/c11f62618499.png", "settings.png", function(path) cog = Material(path, "smooth") end, function() end)
hdl.DownloadFile("https://www.filotax.es/wp-content/uploads/2017/09/play-icon_blanc2.png", "play.png", function(path) play = Material(path, "smooth") end, function() end)
hdl.DownloadFile("http://vaati.net/Gachi/shared/pencil-edit-button.png", "edit.png", function(path) edit = Material(path, "smooth") end, function() end)
hdl.DownloadFile("http://vaati.net/Gachi/shared/fast-forward-64.png", "ffw.png", function(path) ffw = Material(path, "smooth") end, function() end)
hdl.DownloadFile("http://vaati.net/Gachi/shared/588a64e0d06f6719692a2d10.png", "playlist.png", function(path) plMat = Material(path, "smooth") end, function() end)

local function CreateSettings(par)
	local f = vgui.Create("FFrame")
	f:SetAlpha(0)
	local px, py = par:GetPos()
	f:SetPos(px, py+par:GetTall())
	f:MoveTo(px, py+par:GetTall() + 10,0.1)
	f:AlphaTo(255,0.1)
	f:SetSize(par:GetWide(), 400)
	f.Label = "Music Settings"
	f:MakePopup()

	local sets = {
		["FFTEnabled"] = {label = "Enable visualizer?", desc = "Disabling may improve performance.", spec = "-", sound = {[true] = "vgui/mcore_check.ogg", [false] = "vgui/mcore_uncheck.ogg"}}
	}

	local i = 0
	local changedsettings = false 
	for k,v in pairs(sets) do
		i = i + 1
		local ffte = vgui.Create("FCheckBox", f)
		if hudmus.Settings[k] then ffte:SetValue(hudmus.Settings[k]) end
		ffte:SetSize(28, 28)
		ffte:SetPos(12, f.HeaderSize + -16 + 36*i)
		ffte.Label = v.label
		ffte.Description = v.desc
		ffte.Sound = v.sound
		function ffte:Changed(var)
			hudmus.Settings[k] = var
			changedsettings = true
		end
	end

	function f:OnRemove()
		if changedsettings then 
			hudmus.SaveSettings()
		end
	end
	return f
end
local plPanel 



function PaintTrack(self, w, h, name)

	draw.RoundedBox(8, 0, 0, w, h, Color(50, 150, 255))

	draw.RoundedBox(8, 2, 2, w-4, h-4, Color(60, 60, 60, self:GetAlpha()*2))

	draw.SimpleText(name, "HL24", 24, h*0.15, color_white, 0, 0)

end

function EditPlaylist(name, f)

	if IsValid(plPanel) then 
		plPanel:MoveTo(950, 0, 0.1, 0.4, 1)

		plPanel:AlphaTo(0, 0.1, 0, function(_,self) self:Remove() end)
	end

	local ip = vgui.Create("FScrollPanel", f)
	ip:SetSize(950-300, 600)
	ip:SetPos(749, f.HeaderSize)
	ip:MoveTo(300,f.HeaderSize,0.5,0,0.3)
	local emptyPlaylist = false 
	local vbar = ip:GetVBar()

	function ip:Paint(w, h)
		surface.SetDrawColor(45,45,45,255)
		surface.DrawRect(0,0,w,h)

		if vbar:GetScroll() > 20 then 
			txA = L(txA, 0, 20)
		else 
			txA = L(txA, 255, 20)
		end

		local white = ColorAlpha(color_white, txA)

		draw.SimpleText(name, "R36", w/2, 48, white, 1, 1)

		if emptyPlaylist then 
			draw.SimpleText("Empty!", "R24", w/2, 120, color_white, 1, 1)
		end

	end
	plPanel = ip

	local i = 0
	if not playlists[name] then emptyPlaylist = true return end 

	for k,v in pairs(playlists[name]) do 
		i = i + 1
		local p = vgui.Create("InvisPanel", ip)
		p:SetPos(75, 82*i)
		p:SetSize(500, 80)
		function p:Paint(w,h)
			PaintTrack(self, w, h, k)
		end

		local pp = vgui.Create("DButton", p)
		pp:SetPos(500 - 32 - 8, (80-32)/2 - 20)
		pp:SetSize(32, 32)
		pp:SetText("")
		local ppA = 0
		function pp:Paint(w,h)
			surface.SetMaterial(playMat)
			surface.SetDrawColor(120, 120, 120)
			surface.DrawTexturedRect(0,0,w,h)
			if self:IsHovered() then ppA=L(ppA, 255, 25) else ppA=L(ppA, 0, 15) end 
			surface.DisableClipping(true)
				

				surface.SetFont("HL18")

				local str = "Start playlist from this song"
				local tW = (surface.GetTextSize(str))
				

				draw.RoundedBox(2, -tW - 4, h/2 - 9, tW + 4, h/2 + 9, Color(40, 40, 40, ppA))

				draw.SimpleText(str, "HL18", -tW, h/2, ColorAlpha(color_white, ppA), 0, 1)

			surface.DisableClipping(false)
		end

		local ps = vgui.Create("DButton", p)
		ps:SetPos(500 - 32 - 8, (80-32)/2 + 20)
		ps:SetSize(32,32)
		ps:SetText("")
		local psA = 0
		ps.str = "Add this song to queue"
		function ps:Paint(w,h)
			surface.SetMaterial(playMat)
			surface.SetDrawColor(120, 120, 120)
			surface.DrawTexturedRect(0,0,w,h)

			if self:IsHovered() then psA=L(psA, 255, 25) else psA=L(psA, 0, 15) end 

			surface.DisableClipping(true)

				local str = self.str
				local tW = (surface.GetTextSize(str))
				
				draw.RoundedBox(2, -tW - 4, h/2 - 9, tW + 4, h/2 + 9, Color(40, 40, 40, psA))

				draw.SimpleText(str, "HL18", -tW, h/2, ColorAlpha(color_white, psA), 0, 1)

			surface.DisableClipping(false)

		end
		ps.Clickable = true
		ps.DoClick = function(self) 
			if not self.Clickable then return end
			self.str = "Added!"
			self.Clickable = false
			timer.Simple(2, function() if not IsValid(self) then return end self.Clickable = true self.str = "Add this song to queue(again)" end)
			hudmus:Enqueue(k)
		end
	end
	
end

function ShowQueue(_, f)

	if IsValid(plPanel) then 
		plPanel:MoveTo(950, 0, 0.1, 0.4, 1)

		plPanel:AlphaTo(0, 0.1, 0, function(_,self) self:Remove() end)
	end

	local ip = vgui.Create("FScrollPanel", f)
	ip:SetSize(950-300, 600 - f.HeaderSize)
	ip:SetPos(749, f.HeaderSize)
	ip:MoveTo(300,f.HeaderSize,0.5,0,0.3)
	local emptyPlaylist = false 
	local vbar = ip:GetVBar()
	local txA = 255

	function ip:Paint(w, h)
		surface.SetDrawColor(45,45,45,255)
		surface.DrawRect(0,0,w,h)

		if vbar:GetScroll() > 20 then 
			txA = L(txA, 0, 20)
		else 
			txA = L(txA, 255, 20)
		end

		local white = ColorAlpha(color_white, txA)
		draw.SimpleText("Current queue: ", "R36", w/2, 48, white, 1, 1)
		if emptyPlaylist then 
			draw.SimpleText("No tracks queued!", "R24", w/2, 120, white, 1, 1)
		end
	end

	plPanel = ip

	local i = 0
	local queue = hudmus.Queue
	if not queue then emptyPlaylist = true return end 

	local pnls = {}

	for k,v in ipairs(queue) do 
		i = i + 1
		local p = vgui.Create("InvisPanel", ip)
		p:SetPos(75, 16 + 82*i)
		p:SetSize(500, 80)

		local name = v.name
		local uid = v.UID 
		pnls[uid] = p 
		local uq = hudmus.UQueue
		function p:Paint(w,h)	--maaan this is messyyyyy
			PaintTrack(self, w, h, name)
			if not uq[uid] and not self.OverTheHills then 
				print('wow theres no me in uq!', uq[uid], uid)
				local amt = 1

				for k,v in pairs(pnls) do 
					if not IsValid(v) then continue end
					amt = amt + 1
					local vx, vy = v:GetPos()
					v:MoveTo(vx,vy - 82,0.3,0.2,0.6)

				end

				self:AlphaTo(0,0.3, 0, function(tbl, s) if IsValid(self) then self:Remove() pnls[k] = nil end end)
				self.OverTheHills = true

			end

			


		end

		local pp = vgui.Create("DButton", p)
		pp:SetPos(500 - 32 - 8, (80-32)/2 - 20)
		pp:SetSize(32, 32)
		pp:SetText("")
		local ppA = 0
		function pp:Paint(w,h)
			

			surface.SetMaterial(playMat)
			surface.SetDrawColor(120, 120, 120)
			surface.DrawTexturedRect(0,0,w,h)
			if self:IsHovered() then ppA=L(ppA, 255, 25) else ppA=L(ppA, 0, 15) end 
			surface.DisableClipping(true)
				

				surface.SetFont("HL18")

				local str = "Skip this song"
				local tW = (surface.GetTextSize(str))
				

				draw.RoundedBox(2, -tW - 4, h/2 - 9, tW + 4, h/2 + 9, Color(40, 40, 40, ppA))

				draw.SimpleText(str, "HL18", -tW, h/2, ColorAlpha(color_white, ppA), 0, 1)

			surface.DisableClipping(false)
		end

		local ps = vgui.Create("DButton", p)
		ps:SetPos(500 - 32 - 8, (80-32)/2 + 20)
		ps:SetSize(32,32)
		ps:SetText("")
		local psA = 0
		ps.str = "Add this song to queue"

		function ps:Paint(w,h)
			surface.SetMaterial(playMat)
			surface.SetDrawColor(120, 120, 120)
			surface.DrawTexturedRect(0,0,w,h)

			if self:IsHovered() then psA=L(psA, 255, 25) else psA=L(psA, 0, 15) end 

			surface.DisableClipping(true)

				local str = self.str
				local tW = (surface.GetTextSize(str))
				
				draw.RoundedBox(2, -tW - 4, h/2 - 9, tW + 4, h/2 + 9, Color(40, 40, 40, psA))

				draw.SimpleText(str, "HL18", -tW, h/2, ColorAlpha(color_white, psA), 0, 1)

			surface.DisableClipping(false)

		end
		ps.Clickable = true
		ps.DoClick = function(self) 
			if not self.Clickable then return end
			self.str = "Added!"
			self.Clickable = false
			timer.Simple(2, function() if not IsValid(self) then return end self.Clickable = true self.str = "Add this song to queue(again)" end)
			hudmus:Enqueue(k)
		end
	end
	
end
local plEditing

function CreatePlaylist(fr, scr, name, y, editfunc, playfunc)

		local p = vgui.Create("InvisPanel", scr)
		p:SetSize(300, 70)
		p:SetPos(0, y or 0)

		local pName = name 
		local sqrW = 3
		function p:Paint(w,h)
			surface.SetDrawColor(65,65,65)
			surface.DrawRect(0,0,w,h)
			if plEditing==k then sqrW = L(sqrW, 10, 15) else sqrW = L(sqrW, 3, 15) end
			surface.SetDrawColor(40, 160, 250)
			surface.DrawRect(w-sqrW,0,sqrW,h)

			draw.SimpleText(pName, "RL18",w/2, 24, color_white, 1, 1)
		end

		local play = vgui.Create("DButton", p)
		play:SetSize(48, 48)
		play:SetPos(300 - 48 - 16, (70-48)/2)
		play:SetText("")

		local edit = vgui.Create("DButton", p)
		edit:SetSize(24, 24)
		edit:SetPos(300 - 24 - 64 - 8, 70 - (70 - 24) / 2 - 8)
		edit:SetText("")

		function play:Paint(w,h)
			surface.SetMaterial(playMat)
			surface.SetDrawColor(120, 120, 120)
			surface.DrawTexturedRect(0,0,w,h)
		end

		function edit:Paint(w,h)
			surface.SetMaterial(editMat)
			surface.SetDrawColor(120, 120, 120)
			surface.DrawTexturedRect(0,0,w,h)
		end
		edit.DoClick = function()

			if editfunc then 
				editfunc(name, fr)
			else
				EditPlaylist(name, fr)
			end

			plEditing = name
		end
end
NewPlaylist = NewPlaylist or nil 



function CreateNewPlaylist(f)
	local _ = IsValid(NewPlaylist) and NewPlaylist:Remove()
	NewPlaylist = vgui.Create("FFrame")
	local np = NewPlaylist 
	local ip 

	local mp
	local PlayList = {}

	local function AddSong(fn, name)

		if PlayList[name] then return "A song with this name already exists in this playlist!" end
		if not fn or not name then return "No filename or no name has been supplied! Probably an error in the code." end
		if not file.Exists("hdl/"..fn, "DATA") then return "A file has not been downloaded, apparently??" .. fn end 

		PlayList[name] = {fn = fn}
		ip:UpdatePlaylist()
	end

	np.Shadow = {}
	np:SetSize(650, 700)
	np:SetAlpha(0)

	np:SetPos(ScrW()/2 - 325, ScrH()/2 - 700/2 - 100)

	np:MoveTo(ScrW()/2 - 325, ScrH()/2 - 700/2 - 50, 0.6, 0, 0.3)

	np:AlphaTo(255, 0.2, 0)

	np:MakePopup()
	np:SetPopupStayAtBack(true)
	np.OnClose = function() if IsValid(mp) then return false end end

	local songPnls = {}


	ip = vgui.Create("FScrollPanel", np)
	ip:SetSize(950-300, 700 - np.HeaderSize - 64)
	ip:SetPos(0, np.HeaderSize + 64)

	local vbar = ip:GetVBar()
	local txA = 255

	local ipW, ipH = ip:GetSize() 

	function ip:UpdatePlaylist()

		local toAdd = table.Copy(PlayList)
		PrintTable(PlayList)

		local i = 0

		for k,v in pairs(songPnls) do
			if not IsValid(v) then songPnls[k] = nil continue end 
			if not v.SongName or not PlayList[v.SongName] then print(v.SongName, "o o p s") v:Remove() songPnls[k] = nil continue end 
			toAdd[v.SongName] = nil
			i = i + 1
		end
		
		for k,v in pairs(toAdd) do 
			i = i + 1
			local tr = vgui.Create("InvisPanel", self)
			songPnls[k] = tr 
			tr.SongName = k 
			tr:SetSize(500, 80)
			tr:SetPos(75, -70 + 82*i)
			function tr:Paint(w,h)
				PaintTrack(self, w, h, k)
			end 
		end

	end

	function ip:Paint(w, h)
		surface.SetDrawColor(65,45,45,255)
		surface.DrawRect(0,0,w,h)
	end

	local name = vgui.Create("FTextEntry", np)
	name:SetPos(650/2 - 192, np.HeaderSize + 16)
	name:SetSize(192*2, 28)
	name:SetPlaceholderText("Playlist name...")
	name:SetMultiline(false)
	name:SetMaxChars(32)

	local done = vgui.Create("FButton", np)
	done:SetSize(72, 32)
	done:SetPos(650 - 72 - 16, np.HeaderSize + 8 + 48 + 8)
	done:SetLabel("Create")
	done:SetColor(60, 60, 60)
	done.Enabled = false 

	function done:Paint(w, h)
		self:Draw(w, h)

		if self.Enabled then 
			self.Color = Color(100, 200, 100)
		else 
			self.Color = Color(60, 60, 60)
		end
		self.Enabled = #name:GetValue() > 0 and table.Count(PlayList) > 0
	end

	done.DoClick = function(self)
		if not self.Enabled then return end 
		local pl = {}
		pl[name:GetValue()] = PlayList

	end

	local new = vgui.Create("DButton", np)
	new:SetSize(48, 48)
	new:SetPos(650 - 56, np.HeaderSize + 8)
	new:SetText("")
	new.Color = Color(35, 35 ,35)

	function new:Paint(w,h)
		draw.RoundedBox(4, 0, 0, w, h, self.Color)
		draw.SimpleText("+", "TWB48", w/2, h/2 - 4, color_white, 1, 1)
	end
	new.DoClick = function()
		mp = vgui.Create("FFrame")
		mp.Shadow = {}
		mp:SetSize(600, 250)
		mp:Center()
		mp:MakePopup()
		mp:SetAlpha(0)
		mp:AlphaTo(255, 0.1, 0)
		local fetching = false
		local fa = 0

		local addbtn
		local name 

		function mp:Paint(w,h)
			self:DrawHeaderPanel(w, h)
			draw.SimpleText("Enter a YouTube link or a direct URL to the music file.", "TW32", w/2, 60, color_white, 1, 1)
			self:MoveToAfter(np)
			if fetching then 
				fa = L(fa, 255, 5)
				draw.SimpleText("Fetching name (this could take a little while...) ", "TW24", w/2, h/2 - 32, ColorAlpha(color_white, fa), 1, 1)
			end
			if isstring(self.Status) then 
				fa = L(fa, 255, 5)
				draw.SimpleText("Error: " .. self.Status, "TW24", w/2, h/2 - 24, ColorAlpha(Color(200, 100, 100), fa), 1, 1)
			end
		end

		local url = vgui.Create("FTextEntry", mp)
		url:SetPlaceholderText("Enter URL...")
		url:SetWide(500)
		url:Center()
		url:CenterVertical(0.6)

		local FetchURL = ""

		local subm = vgui.Create("FButton", mp)
		subm:SetSize(100, 50)
		subm:Center()
		subm:CenterVertical(0.85)
		subm:SetLabel("Submit")
		subm:SetColor(Color(100, 200, 100))

		subm.DoClick = function(me)
			if hudmus.ConvertingURL then return end

			addbtn = vgui.Create("FButton", mp)
			addbtn:SetAlpha(0)

			mp.Status, mp.ErrCode = hudmus.ParseMusicURL(url:GetValue())
			FetchURL = url:GetValue()

			local function RevealAddButton()
				if not IsValid(name) then 
					name = vgui.Create("FTextEntry", mp)
					name:SetPlaceholderText('Enter song name...')
					name:SetSize(512, 28)
					name:SetAlpha(0)
					name:Center()
					name:SetUpdateOnType(true)
					name:ColorTo(Color(100, 60, 60),0.2, 0)

					name.OnValueChange = function(self, str)

						if #str > 3 and #str < 48 then 
							addbtn.Enabled = true
							name:ColorTo(Color(40, 40, 40), 0.2, 0)
						elseif #str <= 3 or #str > 47 then  
							addbtn.Enabled = false
							name:ColorTo(Color(100, 60, 60),0.2, 0)
						end

					end

					subm:MoveTo(100, subm.Y, 0.6, 0, 0.2, function() 
						if not IsValid(mp) then return end

						local add = addbtn

						add:SetSize(100, 50)
						add:SetPos(400, subm.Y)

						add:SetLabel("Add")
						add:SetColor(Color(30, 30, 30))
						add:SetAlpha(0)
						add:AlphaTo(255, 0.2, 0)
						function add:Paint(w,h)
							self:Draw(w,h)

							if self.Enabled and self.Enabled2 and not self.Colored then 
								self:ColorTo(Color(50, 150, 255),0.2, 0)
								self.Colored = true 
								mp:SetCloseable(true)

							elseif not (self.Enabled and self.Enabled2) and self.Colored then 
								self:ColorTo(Color(30, 30, 30),0.2, 0)
								self.Colored = false
								mp:SetCloseable(true)
							end
							
						end

						add.DoClick = function(self)
							if not (self.Enabled and self.Enabled2) then return end
							local err = AddSong(mp.FileName, name:GetValue() )
							if err then 
								mp.Status = err 
							end

						end 

					end)

					mp:SizeTo(600, 300, 0.4, 0, 0.3, function() if IsValid(name) then name:CenterVertical(0.9) name:AlphaTo(255, 0.4, 0) end end)
				else 
					name:SetValue("")
				end

				return name

			end

			if mp.ErrCode == 1 then 
				addbtn.Enabled = true 
				addbtn.Enabled2 = true
			end

			if isnumber(mp.Status) then

				--mp:SetCloseable(false)

				fetching = true

				local nameentry = RevealAddButton()

				addbtn.Enabled = true

				if mp.Status==1 then 
					
					hook.Add("HUDMusOnFetchYTName", "yoimwaitin", function(name) 
						hook.Remove("HUDMusOnFetchYTName", "yoimwaitin") 
						if not IsValid(mp) then return end 
						addbtn.Enabled2 = true 
						nameentry:SetValue(name)
						fetching = false 
					end)

					hook.Add("HUDMusOnDLYT", "yoimwaitin", function(fn) 
						hook.Remove("HUDMusOnDLYT", "yoimwaitin") 
						mp.FileName = fn 
					end)

				end

				if mp.Status==2 then 

					hook.Add("HUDMusOnDLFinish", "yoimwaitin", function(fn) 
						hook.Remove("HUDMusOnDLFinish", "yoimwaitin")
						if not IsValid(mp) then return end 
						mp.FinishedDL = true
						addbtn.Enabled2 = true
						--nameentry:SetValue(name)
						fetching = false
						mp.FileName = fn
					end)
					
				end

			end

		end
	end
	plPanel = ip

end

function CreatePlaylistMenu(par)
	local f = vgui.Create("FFrame")
	f:SetAlpha(0)
	local px, py = par:GetPos()
	local pw, ph = par:GetSize()
	local offx = (950 - par:GetWide())/2

	f:SetPos(px-offx, py+ph)
	f:MoveTo(px-offx, py+ph + 10,0.1)
	f:AlphaTo(255,0.1)

	
	f:SetSize(950, 600)
	f.Label = "Playlists"
	f:MakePopup()

	local scr = vgui.Create("FScrollPanel", f)
	scr:SetSize(300, 500)
	scr:SetPos(0, f.HeaderSize)
	function scr:Paint(w,h)
		surface.SetDrawColor(60, 60, 60)
		surface.DrawRect(0, 0, w, h)

		--surface.SetMaterial(grad)
		--surface.SetDrawColor(0, 0, 0)
		--surface.DrawTexturedRectRotated(0,h-200,1500, 1500, 75)


			surface.SetDrawColor(20, 20, 20, 120)
			surface.DrawLine(w-1, 0, w-1, h)

	end
	CreatePlaylist(f, f, "Current queue", 500, ShowQueue)
	local new = vgui.Create("DButton", f)
	new:SetSize(24, 24)
	new:SetPos(300 - 24, 600 - 24 - 2)
	new:SetText("")
	new.Color = Color(35, 35 ,35)

	function new:Paint(w,h)
		draw.RoundedBox(4, 0, 0, w, h, self.Color)
		draw.SimpleText("+", "TWB48", w/2, h/2 - 4, color_white, 1, 1)
	end

	new.DoClick = function() CreateNewPlaylist(f) end

	local i = 0

	

	for k,v in pairs(playlists) do 

		i = i + 1
		CreatePlaylist(f, scr, k, -70 + 75*i)
	end

	return f
end


local fft = {}
local curName = "No stream!"

function VolumeSliderPaint(self, w, h)

	draw.RoundedBox(2, 0, h/2 - 4, w, 8, Color(70, 70, 70))

end

local sl 

function hudmus.CreateHUD(str) --{stream = s, name = name, ply = ply, cl = client}
	if not IsValid(MusPanel) then 

		MusPanel = vgui.Create("DPanel")
		MusPanel:SetPos(ScrW()/2 - 200, 36)

	else 
		MusPanel:AlphaTo(255, 0.1, 0, function() dimmed = false dimming = false end)
	end
	str = str or hudmus.CurrentStream or {}
	local s = str.stream 
	local name = str.name or "No stream!"
	curName = name
	local ply = str.ply or LocalPlayer() 
	local cl = str.client or true

	local mp = MusPanel 
	mp:SetSize(400, 100)
	
	mp.A = mp.A or 0
	local x, y
	local bands = {}
	local samebands = {}
	local a2 = 255

	if not IsValid(mp.Settings) then 

		local set = vgui.Create("DButton", mp)
		set:SetAlpha(0)
		set:SetSize(32,32)
		set:SetPos(400 - 32 - 16, 100 - 32 - 8)
		set:SetText("")

		set.DoClick = function() 
			if IsValid(mp.SettingsFrame) then return end 
			local set = CreateSettings(mp) 
			mp.SettingsFrame = set 
		end

		mp.Settings = set

		local rot = 0

		function set:Paint(w,h)
			surface.SetMaterial(cog)
			surface.SetDrawColor(120, 120, 120)
			surface.DrawTexturedRectRotated(w/2,h/2,w,h, rot)
			if IsValid(mp.SettingsFrame) then rot = (rot + FrameTime()*360)%360 else rot = L(rot, 0, 20) end
		end
	end

	if not IsValid(mp.Playlists) then 
		local pl = vgui.Create("DButton", mp)
		pl:SetAlpha(0)
		pl:SetSize(32,32)
		pl:SetPos(400 - 32 - 16, 26)
		pl:SetText("")

		pl.DoClick = function() 
			if IsValid(mp.PlaylistsFrame) then return end 
			local set = CreatePlaylistMenu(mp) 
			mp.PlaylistsFrame = set 
		end

		local plcol = 0
		function pl:Paint(w,h)
			surface.SetMaterial(plMat)
			surface.SetDrawColor(220, 220, 220)
			surface.DrawTexturedRect(0, 0, w, h)
		end

		mp.Playlists = pl
	end

	

	local dimA = 0
	local dimming = false 
	local dimmed = false 

	function mp:Paint(w,h)
		self.A = L(self.A, 255, 10)
		local x, y = self:LocalToScreen(0,0)
		surface.SetDrawColor(main)
		BSHADOWS.BeginShadow()
			draw.RoundedBox(8, x, y, w, h, ColorAlpha(main, self.A))
		BSHADOWS.EndShadow(4, 2, 1, (self.A-205)*5)

		local contextMenuOpen = hudmus.ContextMenuOpen or false

		if not IsValid(s) or s:GetState() == GMOD_CHANNEL_STOPPED then 
			--self:Remove() 
			hudmus:PlayNextInQueue()

			if not contextMenuOpen and not dimming and not dimmed then self:AlphaTo(0, 0.1, 0, function() dimmed = true dimming = false end) end
			if contextMenuOpen and dimmed then self:AlphaTo(255, 0.1, 0, function() dimmed = false dimming = false end) end

			local str = hudmus.CurrentStream or {}
			if not str then return end 
			s = str.stream 
			name = str.name 
			ply = str.ply 
			cl = str.client

			
		else

			if dimmed or dimming then 
				self:AlphaTo(255, 0.1, 0, function() dimmed = false dimming = false end)
			end
			if hudmus.Settings.FFTEnabled == false then 

			else 
				s:FFT(fft, FFT_256)
				draw.RoundedBox(4, 12, h-57, (3*128 - 16), 54, Color(40, 40, 40))
				surface.SetDrawColor(50, 150, 250)

				for k,v in ipairs(fft) do 

					bands[k] = bands[k] or v 

					samebands[k] = samebands[k] or {} 

					local len = #samebands[k]

					samebands[k][len+1] = v
					
					local prevband = bands[k-1] or 0
					local nextband = bands[k+1] or 0

					local nearbysmooth = (bands[k] + prevband + nextband) 

					local pastbands = 0 

					for i=1, 4 do 
						pastbands = pastbands + (samebands[k][len - i] or 0)
					end

					local prevsmooth = pastbands/4

					local band = v + prevsmooth

					local pw = math.log10(band*(20 + 2*k)) * 35
					pw = math.min(pw, 50)
					surface.DrawRect(16+ 3*k, h-5 - pw, 2, pw)
				end
			end

		end

		if contextMenuOpen then 
			self.Y = math.ceil(L(self.Y, 64, 5))
			a2 = L(a2, 0, 15)
			dimA = L(dimA, 250, 15)
		else
			self.Y = math.floor(L(self.Y, 36, 5))
			dimA = L(dimA, 0, 15)
		end

		

		local y = y - ScrH()*0.02
		local h2 = y + h
		
		
		surface.DisableClipping(true)
			draw.SimpleText("[C]", "RL24", w/2, h2+24, ColorAlpha(white, a2), 1, 1)
		surface.DisableClipping(false)

		draw.RoundedBox(8, 0, 0, w, h, Color(20, 20, 20, dimA))

		draw.SimpleText(curName, "RL18", w/2, 24, ColorAlpha(white, self.A), 1, 1)

	end
	--Garry's mod = one big workaround
	--oh yeah this is a workaround as well by the way V V V
	local blankfunc = function() end
	if not IsValid(mp.Volume) then 

		local sl = vgui.Create("DNumSlider", mp)
		sl:SetSize(250, 20)
		sl:Center()
		sl:AlignBottom(2)
		sl:SetText("")
		sl:SetMax(1)
		sl:SetMin(0)
		sl:SetDecimals(2)
		sl:SetValue(hudmus.Settings.Volume or 0.5)
		sl:SetAlpha(0)
		sl.PerformLayout = blankfunc

		sl.TextArea:SetTextColor(Color(50, 150, 255))

		sl.Slider:SetSize(250, 20)
		sl.Slider:Dock(NODOCK)
		sl.Slider:AlignLeft(0)

		
		

		sl.Wang:Dock(NODOCK)
		sl.Wang:SetSize(0, 0)
		sl.Label:Dock(NODOCK)
		sl.Label:SetSize(0, 0)

		sl.TextArea:SetSize(0,0)
		local lastEdit = 0
		local txA = 0
		function sl.Slider:Paint(w, h)
			sl.MoveToAfter(mp)
			surface.SetDrawColor(Color(20, 20, 20))
			surface.DrawRect(2, h * 0.5 - 3, w, 6)

			draw.RoundedBox(4,0,h * 0.5 - 5,w, 10, Color(60, 60, 60))

			surface.SetDrawColor(Color(50, 150, 255))

			local num = sl:GetValue() or 0
			local volw = tonumber(num) * w
			surface.DrawRect(2, h * 0.5 - 3, math.min(volw, w-6), 6)

			if CurTime() - lastEdit < 1.5 then 
				txA = L(txA, 255, 15)
			else 
				txA = L(txA, 0, 5)
			end
			surface.DisableClipping(true)
				draw.SimpleText(string.format("%s%%", math.Round(num*100)), "TWB18", num*w, -12, ColorAlpha(color_white, txA), 1)
			surface.DisableClipping(false)

		end

		function sl:OnValueChanged(num)
			hudmus.Settings.Volume = num
			lastEdit = CurTime()

			mp.ChangedSettings = true
			local stream = hudmus.CurrentStream and hudmus.CurrentStream.stream
			if IsValid(stream) then 
				stream:SetVolume(num)
			end

		end

		function sl.TextArea:Paint(w,h)

		end

		function sl.Slider.Knob:Paint(w,h)
		end
		--/end workaround

		mp.Volume = sl
	end
	local b = vgui.Create("DButton", mp)
	b:SetSize(32, 32)
	b:SetPos(16, 100 - 40)
	b:SetText("")
	b:SetAlpha(0)
	b.DoClick = function(s)
		if s.Clickable then 
			hudmus:StopURL(LocalPlayer())
		end
	end

	mp.Stopbtn = b
	function b:Paint(w,h)
		local a = mp.A
		surface.DisableClipping(true)
		surface.SetMaterial(ffw)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(0,0,w,h)
		surface.DisableClipping(false)
	end

	local p = vgui.Create("DButton", mp)
	p:SetSize(32, 32)
	p:SetPos(16, 24)
	p:SetText("")
	p:SetAlpha(0)
	p.DoClick = function(s)
		if s.Clickable then 
			hudmus:StopURL(LocalPlayer())
		end
	end

	mp.Pausebtn = p
	function p:Paint(w,h)
		local a = mp.A
		--h = h*0.8
		draw.RoundedBox(4,0, 0, 10, h, color_white)
		draw.RoundedBox(4,18, 0, 10, h, color_white)
	end

	hook.Add("OnContextMenuOpen", "StreamsOpen", function()
		hudmus.ContextMenuOpen = true
		--
		timer.Simple(0, function() 
			if IsValid(MusPanel) then 
				MusPanel:MakePopup() 
				MusPanel:SetKeyBoardInputEnabled(false)
				
				MusPanel.Settings:AlphaTo(255, 0.2, 0) 
				MusPanel.Settings.Clickable = true

				MusPanel.Stopbtn:AlphaTo(255, 0.2, 0)
				MusPanel.Stopbtn.Clickable = true

				MusPanel.Playlists:AlphaTo(255, 0.2, 0) 
				MusPanel.Playlists.Clickable = true

				MusPanel.Pausebtn:AlphaTo(255, 0.2, 0)
				MusPanel.Pausebtn.Clickable = true

				MusPanel.Volume:AlphaTo(255, 0.2, 0)
				MusPanel.Volume:MoveToFront()
			else 
				print('Invalid panel - open')
			end
		end)
		
	end)

	hook.Add("OnContextMenuClose", "StreamsClose", function()
		hudmus.ContextMenuOpen = false

		timer.Simple(0, function() 
			if IsValid(MusPanel) then 

				MusPanel:SetMouseInputEnabled(false) 
				MusPanel:SetKeyboardInputEnabled(false) 
				MusPanel.Settings:AlphaTo(0, 0.2, 0, function(t, self) self.Clickable = false end) 
				MusPanel.Playlists:AlphaTo(0, 0.2, 0, function(t, self) self.Clickable = false end) 
				MusPanel.Stopbtn:AlphaTo(0, 0.2, 0, function(t, self) self.Clickable = false end)
				MusPanel.Pausebtn:AlphaTo(0, 0.2, 0, function(t, self) self.Clickable = false end)
				MusPanel.Volume:AlphaTo(0, 0.2, 0)
				if MusPanel.ChangedSettings then 
					hudmus.SaveSettings()
				end
				MusPanel.ChangedSettings = false 
			else 
				print('Invalid panel - closed')
			end
		end)

	end)

	
end
concommand.Add("fftprint",function() PrintTable(fft) end)
function hudmus.RemoveHUD()
	if IsValid(MusPanel) then curName = "No stream!" end--MusPanel:Remove() end 
end

function hudmus.RecreateHUD()
	if IsValid(MusPanel) then MusPanel:Remove() end 
	hudmus.CreateHUD()
end

hook.Add("HUDMus", "OnStart", hudmus.CreateHUD)
hook.Add("HUDMusStop", "OnStop", hudmus.RemoveHUD)
hook.Add("InitPostEntity", "LoadHUDMus", function()
	if not IsValid(MusPanel) then 
		hudmus.CreateHUD()
	end
end)
