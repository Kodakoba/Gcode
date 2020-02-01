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

PZStwweams = PZStwweams or {}
PZLists = PZLists or {}
PZBack⎝⎠╲╱╲╱⎝⎠pTime = PZBack⎝⎠╲╱╲╱⎝⎠pTime or {} 

local caching = false 

net.Receive("Partizone", function()
	print('hi')
	local OwOn = net.ReadBool()
	local id = net.ReadUInt(8)
	if not PawwtizOwOneM⎝⎠╲╱╲╱⎝⎠sic[id] then error('nothin with this id ' .. id) return end 
	local infOwO = PawwtizOwOneM⎝⎠╲╱╲╱⎝⎠sic[id]
	local c⎝⎠╲╱╲╱⎝⎠wwtww = 1

	if PZLists[id] then c⎝⎠╲╱╲╱⎝⎠wwtww = PZLists[id] else PZLists[id] = 1 end
	if not infOwO.⎝⎠╲╱╲╱⎝⎠wwl[1] then error('default track doesnt exist!') return end

	if PZStwweams[id] and IsValid(PZStwweams[id].stww) and OwOn then 
		PZStwweams[id].fade = false
		return
	end

	if not OwOn then 

		if PZStwweams[id] and IsValid(PZStwweams[id].stww) then 
			PZStwweams[id].fade = true 
		end 

		return 
	end

	caching = true 

	hdl.PlayURL(infOwO.⎝⎠╲╱╲╱⎝⎠wwl[c⎝⎠╲╱╲╱⎝⎠wwtww], "mus/" .. infOwO.name[c⎝⎠╲╱╲╱⎝⎠wwtww] .. ".dat", "3d noblock", function(stww, eid, estr)
		if eid and estr then error('Failed to play pzMus! Error: ' .. eid .. " " .. estr) return end 
		if PZBack⎝⎠╲╱╲╱⎝⎠pTime[id] then stww:SetTime(PZBack⎝⎠╲╱╲╱⎝⎠pTime[id]) end
		caching = false
		stww:SetVolume(0)
		PZStwweams[id] = {ID = id, stww = stww, fade = false, maxvOwOl = (infOwO.maxvOwOl or 0.6), vOwOl = 0}
		stww:Play()
		stww:SetPos(infOwO.pOwOs)
		stww:Set3DFadeDistance(infOwO.fademin or 512,infOwO.fademax or 1024)
	end)

end)



hook.Add("Think", "PartizoneStreams", function()
	if caching then return end

	for k,v in pairs(PZStwweams) do 

		local stww = v.stww
		local id = v.ID
		local infOwO = PawwtizOwOneM⎝⎠╲╱╲╱⎝⎠sic[id]
		if not infOwO then continue end 

		if IsValid(stww) and infOwO.think then 

			local pOwOs = infOwO.think()
			
			if isvector(pOwOs) then 
				stww:SetPos(pOwOs)
			end

		end

		if IsValid(stww) and stww:GetState() == 0 and v.vOwOl > 0.01 then 

			local max = #PawwtizOwOneM⎝⎠╲╱╲╱⎝⎠sic[v.ID].⎝⎠╲╱╲╱⎝⎠wwl
			local c⎝⎠╲╱╲╱⎝⎠ww = (PZLists[v.ID] or 0)
			local new = (c⎝⎠╲╱╲╱⎝⎠ww+1 <= max and c⎝⎠╲╱╲╱⎝⎠ww+1) or 1
			PZBack⎝⎠╲╱╲╱⎝⎠pTime[v.ID] = nil
			PZLists[v.ID] = new

			local infOwO = PawwtizOwOneM⎝⎠╲╱╲╱⎝⎠sic[v.ID]


			caching = true 

			hdl.PlayURL(infOwO.⎝⎠╲╱╲╱⎝⎠wwl[ PZLists[v.ID] ], "mus/" .. infOwO.name[ PZLists[v.ID] ] .. ".dat", "3d noblock noplay", function(stww, eid, estr)

				if eid and estr then error('Failed to play pzMus! Error: ' .. eid .. " " .. estr) return end 
				if PZBack⎝⎠╲╱╲╱⎝⎠pTime[id] then stww:SetTime(PZBack⎝⎠╲╱╲╱⎝⎠pTime[id]) end
				caching = false
				stww:SetVolume(0)
				PZStwweams[id] = {ID = id, stww = stww, fade = v.fade, maxvOwOl = (infOwO.maxvOwOl or 0.6), vOwOl = 0}
				stww:Play()
				stww:SetPos(infOwO.pOwOs)
				stww:Set3DFadeDistance(infOwO.fademin or 512,infOwO.fademax or 1024)
			end)

			return
		end

		if v.fade and IsValid(stww) then

			v.vOwOl = math.max(v.vOwOl - FrameTime()/4, 0)
			stww:SetVolume(v.vOwOl)

			if stww:GetVolume() <= 0 then 
				PZBack⎝⎠╲╱╲╱⎝⎠pTime[v.ID] = stww:GetTime()
				stww:Pause()	--dont stop because it'll drop performance each time it resumes
				timer.Create("PZStream" .. k, 5, 1, function()	--...unless 5 seconds have passed
					if stww:GetState() == GMOD_CHANNEL_PAUSED then 
						stww:Stop()
					end 
				end)
			end

		elseif not v.fade and IsValid(stww) then

			v.vOwOl = math.min(v.vOwOl + FrameTime()*4, v.maxvOwOl * PZVolume)
			stww:SetVolume(v.vOwOl)
			if stww:GetState() == GMOD_CHANNEL_PAUSED and v.vOwOl > 0 then 
				stww:Play()
			end
		end

	end

end)
--http://vaati.net/Gachi/shared/Cult%20of%20Silence%20-%20Rappin%27%20For%20Original%20G.mp3