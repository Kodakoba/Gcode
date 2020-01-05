local zone = {}
local ip = IsPlayer




local inhotel = {}	--holds players and amt of hotel zones they're touching

local bwents = {
	--Player: {
		--Entity,
		--...
	--},

	--...
}

local chatcd = {}

local function owner(ent)
	local ow = ent.CPPIGetOwner and ent:CPPIGetOwner()
	return ip(ow) and ow
end

zone[1] = Vector(-5450.03125, -4352.2109375, 64.359680175781)
zone[2] = Vector(-3657.7392578125, -5111.96875, 450.96875)



zone.OnSpawn = function(self)
	local p1, p2 = self.P1, self.P2

	for k,v in pairs(ents.FindInBox(p1,p2)) do 

		if IsValid(v) and v.GetClass and v:GetClass()=="ambient_generic" then 
			v:Remove() 
		end

	end


end

zone.StartTouchFunc = function(self, ent)	--Started touch

	if not ip(ent) then 
		print(ent, "not player")
		local ow = owner(ent)
		if not ow then return end
		print(ent, "has owner")

		local t = bwents[ow] or ValidSeqIterable()

		if not BWEnts[ent] then print("not a bw ent") return end 

		t:clean()

		print(#t, "ents in hotel")

		if #t == 0 then 	--0 because we haven't added the entity yet; not >= because we don't want to disable multiple times
			ow:ChatPrint("Disabling music in area... ")
			net.Start("Partizone")
				net.WriteBool(false)
				net.WriteUInt(1, 8)
			net.Send(ow)
		end

		t:add(ent)

		bwents[ow] = t
		return
	end 
	print(ent, "player")
	--entity entered is a player


	local ply = ent 

	local info = inhotel[ply] or 0 
	info = info + 1

	inhotel[ply] = info

	if bwents[ply] then 
		print(#bwents[ply], "uh oh?")
		-- check validity of entities
		-- if any of them are still here, bail

		bwents[ply]:clean()
		if #bwents[ply] > 0 then return end
		
	end

	net.Start("Partizone")
		net.WriteBool(true)
		net.WriteUInt(1, 8)
	net.Send(ply)
end


zone.EndTouchFunc = function(self, ent)

	if not ip(ent) then 

		local ow = owner(ent)
		if not ow then return end

		local t = bwents[ow] or ValidSeqIterable()

		local found = false

		for k,v in ipairs(t) do
			if v==ent then found = k end 
		end

		if not found then return end 	--wasn't in owners?

		if #t <= 1 then 	--1, aka the entity that we're about to remove

			if not chatcd[ow] or CurTime() - chatcd[ow] > 1 then
				ow:ChatPrint("Reenabling music in area... ")
				chatcd[ow] = CurTime() 
			end

			net.Start("Partizone")
				net.WriteBool(true)
				net.WriteUInt(1, 8)
			net.Send(ow)
	
		end

		t[found] = nil 
		t:sequential()

		return
	end 

	local info = inhotel[ent] or 1 
	info = info - 1
	
	inhotel[ent] = info

	timer.Simple(0.05, function() 

		if IsValid(ent) and inhotel[ent] <= 0 then 

			net.Start("Partizone")
				net.WriteBool(false)
				net.WriteUInt(1, 8)
			net.Send(ent)

		end

	end)
end

PartizonePoints.Hotel = zone 

