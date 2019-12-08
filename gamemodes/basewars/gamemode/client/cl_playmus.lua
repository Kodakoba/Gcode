if SERVER then return end
local str = GlobalStreams or { names = {}, streams = {}, clstreams = {} }
GlobalStreams = str
local p = GlobalStreamPanels or {}
GlobalStreamPanels = p
local function PlayURL(url, name, ply, client)

	sound.PlayURL(url,"",function(s, errid, errstr) 

		if not IsValid(ply) or not ply:IsPlayer() then 
			error("Invalid player; not playing music stream.")
		end

		if errid and (errid~=0 and errid~="0") then
			error("Music stream failed! Error ID: "..errid.."\nError string: "..errstr)
		end

		local sid = ply:SteamID64()
		if not IsValid(s) then print('janked up stream; not valid') return end
		if not sid then 
			print(ply)
			error("What the fuck this is not supposed to happen; player ^ ^ ^ did not have SteamID64.")
		end

		str.names[sid] = name
		str.clstreams[sid] = client
		str.streams[sid] = s 

		--if client then 
		--	s:SetPos(ply:GetPos())
		--	s:Set3DFadeDistance(512, 1000000000 )
		--end
	end)

end

PlayMusURL = PlayURL

local function StopURL(ply)
	if not IsValid(ply) or not ply:IsPlayer() then 
		error("Invalid player; could not stop music stream.")
	end

	local sid = ply:SteamID64()

		if not sid then 
			print(ply)
			error("What the fuck this is not supposed to happen; player ^ ^ ^ did not have SteamID64 on stop.")
		end

		local s = str.streams[sid]

		if s and s:IsValid() and s:GetState() ~= GMOD_CHANNEL_STOPPED then 
			s:Stop()
			timer.Simple(0.6, function() str.names[sid] = nil str.streams[sid] = nil end)
		end

end
StopMusURL = StopURL
local plys = {}

hook.Add("Think", "MusicPos", function()
	for k,ply in pairs(player.GetAll()) do
		local sid = ply:SteamID64()
		local s = str.streams[sid] or nil

		if s and s:IsValid() and not str.clstreams[sid] and s:GetState() ~= GMOD_CHANNEL_STOPPED then 
			--str.streams[sid]:SetPos(ply:GetPos())
			local dist = LocalPlayer():GetPos():Distance(ply:GetPos())
			local mult = 1 
			if p[sid] and IsValid(p[sid]) and p[sid].Volume then mult = p[sid].Volume:GetValue() end
			local vol = (2048+512 - math.max(dist, 512))/2048 * mult
			s:SetVolume(math.min(vol, 1))

		elseif ispanel(p[sid]) and (not s or not s:IsValid() or s:GetState() == GMOD_CHANNEL_STOPPED) then 

			p[sid]:Remove()
			p[sid] = nil
		end

	end

end)
local StreamCD = 0
local contextMenuOpen = false 

hook.Add("HUDPaint", "MusicDraw", function()
	if CurTime() - StreamCD < 1 then return end

	local me = LocalPlayer()

	


	for k,v in pairs(player.GetAll()) do
		local sid = v:SteamID64()

		local s = str.streams[sid] or nil
		if s and s:IsValid() and s:GetState() ~= GMOD_CHANNEL_STOPPED then 


			if not ispanel(p[sid]) then 

				local f = vgui.Create("DPanel")
				f:SetSize(300,100)
				f:SetPos(ScrW() - 1, ScrH() * 0.8 - 150 - 120)
				f.Time = CurTime()
				f.Compacted = 0
				f.a1 = 200
				function f:Paint(w,h)
					local streams = table.Count(str.streams) + table.Count(str.clstreams)
					if not IsValid(v) then s:Stop() return end

					self.X = Lerp(FrameTime()*20, self.X, ScrW() - 305 - (unimenu and unimenu.ux or 0))

					if not s or not s:IsValid() or ((not isvector(s:GetPos()) or me:GetPos():DistToSqr(v:GetPos()) > 9000000) and not str.clstreams[sid])  then return end

					if not str.clstreams[sid] and me:GetPos():DistToSqr(v:GetPos()) > 2359296 and not contextMenuOpen then

						self.a1 = Lerp(FrameTime()*5, self.a1, 25)
					else
						self.a1 = Lerp(FrameTime()*5, self.a1, 200)
					end

					if CurTime() - self.Time > 5 and not contextMenuOpen then --closing
						local x,y = self:GetSize()
						y = Lerp(FrameTime()*5, y, 70)
						self:SetSize(x, y)
						self.Y = Lerp(FrameTime()*5, self.Y, ScrH() * 0.8 - y*0.5 - 80 * streams)
						self.Compacted = Lerp(FrameTime()*5, self.Compacted, 1)
						self:SetMouseInputEnabled(false)
						self:SetKeyBoardInputEnabled(false)
					else
						local x,y = self:GetSize()
						if not contextMenuOpen then 
							self:SetPos(self.X, ScrH() * 0.8 - y*0.5 - 120 * streams )
							self:SetMouseInputEnabled(false)
							self:SetKeyBoardInputEnabled(false)
						end

						
						if contextMenuOpen then 
							local x,y = self:GetSize()
							y = Lerp(FrameTime()*5, y, 100)
							self:SetSize(x, y)

							self.Y = Lerp(FrameTime()*5, self.Y, ScrH() * 0.8 - y*0.5 - 80 * streams)

							self.Compacted = Lerp(FrameTime()*5, self.Compacted, 0)
							mousex,mousey = gui.MousePos()

						    fx,fy,fw,fh = self:GetBounds()
						    fb1=Vector(fx,fy, 0)
						    fb2=Vector(fx+fw, fy+fh, 0)
						    mouseinframe = Vector(mousex,mousey,0):WithinAABox(fb1,fb2)
    						if mouseinframe then 
    							self:MakePopup()
								self:SetKeyBoardInputEnabled(false) 
							else 
								self:SetMouseInputEnabled(false)
								self:SetKeyBoardInputEnabled(false) 
							end

						end
					end

					draw.RoundedBox(4,0,0,w,h-20, Color(250,250,250,self.a1))

					draw.SimpleText(str.names[sid] or "wat","RL24",w*0.5, (h-20)*0.2 + (h-20)*self.Compacted*0.3,Color(0,0,0, self.a1*1.5),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					draw.SimpleText("by: " ..(IsValid(v) and v:Nick()) or "wat","RL18",w*0.5, h*0.5,Color(0,0,0, (1-self.Compacted) * 255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				end
				local sl = vgui.Create("DNumSlider", f)
				sl:SetPos(0, 0)
				sl:SetSize(500, 30)
				function sl:Think()
					if not IsValid(f) then self:Remove() end
					local fX, fY = f:GetSize()
					self:SetPos(-200, fY-30)
					self:SetSize(500, 30)
					if not s or not s:IsValid() or ((not isvector(s:GetPos()) or me:GetPos():DistToSqr(s:GetPos()) > 9000000) and not str.clstreams[sid]) then return end
					s:SetVolume(self:GetValue())
				end
				f.Volume = sl
				p[sid] = f
				
			end
			
		end

	end
	StreamCD = CurTime()

end)

hook.Add("OnContextMenuOpen", "StreamsOpen", function()
	contextMenuOpen = true 

end)

hook.Add("OnContextMenuClose", "StreamsClose", function()
	contextMenuOpen = false 
end)
--[[
net.Receive("StartMusicStream", function()

 	local url = net.ReadString()
 	local name = net.ReadString()
 	local ply = net.ReadEntity()
 	local cl = net.ReadBool()

 	if not IsValid(ply) or not ply:IsPlayer() then return end

 	PlayURL(url, name, ply, cl)

end)

net.Receive("StopMusicStream", function()
	local ply = net.ReadEntity()

	if not IsValid(ply) or not ply:IsPlayer() then return end

	StopURL(ply)

end)
]]
net.Receive("playsound", function()
	local url = net.ReadString()
	local ply = net.ReadEntity()
	if not url or not ply or not IsValid(ply) then return end
	if LocalPlayer():GetPos():DistToSqr(ply:GetPos()) > 1048576 then return end

	hdl.PlayURL(url, "playsound"..url:sub(#url-6, #url)..".dat", "3d", function(s, errid, errstr) 
		if errid then 
			error("Playsound failed! Error ID: "..tostring(errid)..", error name: "..errstr) 
		end
		if not s or not s:IsValid() then return end 

		s:SetPos(ply:GetPos())
		s:Set3DFadeDistance(512,100000000)

	end)

end)