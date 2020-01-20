AddCSLuaFile()
include('shared.lua')
ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.Model 		= "models/hunter/blocks/cube025x025x025.mdl"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


PZVolume = PZVolume or 1

function ENT:Initialize()
	local name = self:GetZoneName()

	if not PartizonePoints[name] then 	--wait until proper lua scripts are executed
		hook.Add("PartizoneLoad", self, self.Initialize)
		return
	end

	hook.Remove("PartizoneLoad", self)


	self:SetModel(self.Model)
	
	local pos = PartizonePoints[name]

	self:SetRenderBoundsWS(pos[1], pos[2], Vector(2,2,2))

	self.Partizone = PartizonePoints[name]

	self.BoxCol = Color(25,225,25,0)
end

local a = 0
local ba = 0

local drawDist = 2048
function ENT:Draw()		--shhhh sneaky workaround

	local pos = self:GetPos()

	local pz = self.Partizone
	if not pz then return end 

	local min = pz[1]
	local max = pz[2]

	local mepos = EyePos()

	local bmin = min - pos
	local bmax = max - pos
	OrderVectors(bmin, bmax)

	local rbmin, rbmax = self:GetRenderBounds()

	local rbsum = math.abs(rbmin.x + rbmin.y + rbmin.z) --totally not how vectors work but who cares?
	local bsum = math.abs(bmin.x + bmin.y + bmin.z)		--also this is to set renderbounds if they're not what they're supposed to be: Initialize() seems to..not work?
	if rbsum - bsum < 6 then
		self:SetRenderBoundsWS(min, max,Vector(2,2,2))
	end

	render.SetColorMaterial()

	render.DrawBox(pos, Angle(0,0,0), bmin, bmax, self.BoxCol)	--render outwards
	render.DrawBox(pos, Angle(0,0,0), bmax, bmin, self.BoxCol)	--render inwards
	local desCol = Color(5, 5, 5, ba*2)

	if (mepos - Vector(0,0,64)):WithinAABox(min, max) then ba = math.min(L(ba, 30, 15), 30) desCol = Color(25,225,25, ba) self.BoxCol = LC(self.BoxCol, desCol) return end 

	self.BoxCol = LC(self.BoxCol, desCol)

	local vec, dir, frac = 	util.IntersectRayWithOBB(mepos, LocalPlayer():EyeAngles():Forward()*drawDist, pos, Angle(0,0,0), bmin, bmax )
		
	if vec then 

		ba = L(ba, 60, 15)

	 else 

	 	ba = L(ba, 0, 2)

	 end

end

PZStreams = PZStreams or {}
PZLists = PZLists or {}
PZBackupTime = PZBackupTime or {} 
local caching = false 

net.Receive("Partizone", function()
	local on = net.ReadBool()
	local id = net.ReadUInt(8)
	if not PartizoneMusic[id] then return end 
	local info = PartizoneMusic[id]
	local curtr = 1

	if PZLists[id] then curtr = PZLists[id] else PZLists[id] = 1 end
	if not info.url[1] then error('default track doesnt exist!') return end

	if PZStreams[id] and IsValid(PZStreams[id].str) and on then 
		PZStreams[id].fade = false
		return
	end

	if not on then 

		if PZStreams[id] and IsValid(PZStreams[id].str) then 
			PZStreams[id].fade = true 
		end 

		return 
	end

	caching = true 

	hdl.PlayURL(info.url[curtr], "mus/" .. info.name[curtr] .. ".dat", "3d noblock", function(str, eid, estr)
		if eid and estr then error('Failed to play pzMus! Error: ' .. eid .. " " .. estr) return end 
		if PZBackupTime[id] then str:SetTime(PZBackupTime[id]) end
		caching = false
		str:SetVolume(0)
		PZStreams[id] = {ID = id, str = str, fade = false, maxvol = (info.maxvol or 0.6), vol = 0}
		str:Play()
		str:SetPos(info.pos)
		str:Set3DFadeDistance(info.fademin or 512,info.fademax or 1024)
	end)

end)



hook.Add("Think", "PartizoneStreams", function()
	if caching then return end

	for k,v in pairs(PZStreams) do 
		local str = v.str
		local id = v.ID
		local info = PartizoneMusic[id]
		if not info then continue end 

		if IsValid(str) and info.think then 

			local pos = info.think()
			
			if isvector(pos) then 
				str:SetPos(pos)
			end

		end
		if IsValid(str) and str:GetState() == 0 and v.vol > 0.01 then 

			local max = #PartizoneMusic[v.ID].url
			local cur = (PZLists[v.ID] or 0)
			local new = (cur+1 <= max and cur+1) or 1
			PZBackupTime[v.ID] = nil
			PZLists[v.ID] = new

			local info = PartizoneMusic[v.ID]


			caching = true 

			hdl.PlayURL(info.url[ PZLists[v.ID] ], "mus/" .. info.name[ PZLists[v.ID] ] .. ".dat", "3d noblock noplay", function(str, eid, estr)

				if eid and estr then error('Failed to play pzMus! Error: ' .. eid .. " " .. estr) return end 
				if PZBackupTime[id] then str:SetTime(PZBackupTime[id]) end
				caching = false
				str:SetVolume(0)
				PZStreams[id] = {ID = id, str = str, fade = v.fade, maxvol = (info.maxvol or 0.6), vol = 0}
				str:Play()
				str:SetPos(info.pos)
				str:Set3DFadeDistance(info.fademin or 512,info.fademax or 1024)
			end)

			return
		end

		if v.fade and IsValid(str) then

			v.vol = math.max(v.vol - FrameTime()/4, 0)
			str:SetVolume(v.vol)

			if str:GetVolume() <= 0 then 
				PZBackupTime[v.ID] = str:GetTime()
				str:Pause()	--dont stop because it'll drop performance each time it resumes
				timer.Create("PZStream" .. k, 5, 1, function()	--...unless 5 seconds have passed
					if str:GetState() == GMOD_CHANNEL_PAUSED then 
						str:Stop()
					end 
				end)
			end

		elseif not v.fade and IsValid(str) then
			
			v.vol = math.min(v.vol + FrameTime()*4, v.maxvol * PZVolume)
			str:SetVolume(v.vol)
			if str:GetState() == GMOD_CHANNEL_PAUSED and v.vol > 0 then 
				str:Play()
			end
		end

	end

end)
--http://vaati.net/Gachi/shared/Cult%20of%20Silence%20-%20Rappin%27%20For%20Original%20G.mp3