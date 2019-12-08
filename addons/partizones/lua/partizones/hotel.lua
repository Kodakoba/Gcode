local zone = {}
local ip = IsPlayer

local inhotel = {}

zone[1] = Vector(-5450.03125, -4352.2109375, 64.359680175781)
zone[2] = Vector(-3657.7392578125, -5111.96875, 450.96875)

hents = hents or {}

zone.OnSpawn = function(self)
	local p1, p2 = self.P1, self.P2

	for k,v in pairs(ents.FindInBox(p1,p2)) do 

		if IsValid(v) and v.GetClass and v:GetClass()=="ambient_generic" then 
			v:Remove() 
		end

	end


end

zone.TouchFunc = function(self, ent)
	inhotel[ent] = true
end

zone.StartTouchFunc = function(self, ent)	--Started touch
	print("STARTED TOUCH", self, ent)
	if not ip(ent) then 
		
		if not ent.CPPIGetOwner or not ip(ent:CPPIGetOwner()) then return end
		local ow = ent:CPPIGetOwner()

		local t = hents[ow]
		if not BWEnts[ent] then return end 
		
		if not t or table.Count(t) == 0 then 
			ow:ChatPrint("Disabling music in area... ")
			net.Start("Partizone")
				net.WriteBool(false)
				net.WriteUInt(1, 8)
			net.Send(ow)
		end

		hents[ow] = t or {}
		hents[ow][ent] = self.ZoneName
		return
	end 

	inhotel[ent] = self.ZoneName 

	local ignore = false 

	if hents[ent] then 

		for k,v in pairs(hents[ent]) do 
			if not IsValid(k) then hents[ent][k] = nil end 
			if BWEnts[k] then 
				ignore = true
			end
		end
		
	end

	if ignore then return end 

	net.Start("Partizone")
		net.WriteBool(true)
		net.WriteUInt(1, 8)
	net.Send(ent)
end


zone.EndTouchFunc = function(self, ent)
	if not ip(ent) then 

		if not ent.CPPIGetOwner or not ip(ent:CPPIGetOwner()) then return end

		local own = ent:CPPIGetOwner()

		hents[own] = hents[own] or {}
		local me = hents[own][ent]

		if not me then return end 

		local t = hents[own]

		inhotel[ent] = false

		
		if IsValid(own) and me and me==self.ZoneName and table.Count(hents[own]) <= 1 then 

			if not chatcd[own] or CurTime() - chatcd[own] > 5 then
				own:ChatPrint("Reenabling music in area... ")
				chatcd[own] = CurTime() 
			end

			net.Start("Partizone")
				net.WriteBool(true)
				net.WriteUInt(1, 8)
			net.Send(own)
			hents[own][ent] = nil

		end

		return
	end 

	inhotel[ent] = false 

	timer.Simple(0.05, function() 

		if IsValid(ent) and not inhotel[ent] then 

			net.Start("Partizone")
				net.WriteBool(false)
				net.WriteUInt(1, 8)
			net.Send(ent)

		end

	end)
end

PartizonePoints.Hotel = zone 

