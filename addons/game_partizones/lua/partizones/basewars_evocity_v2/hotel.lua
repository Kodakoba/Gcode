local zone = Partizone("hotel")

local ip = IsPlayer

local inhotel = {}	--holds players and amt of hotel zones they're touching
zone.InHotel = inhotel

local bwents = {
	--Player: {
		--Entity,
		--...
	--},

	--...
}

zone.BWOwners = bwents

local chatcd = {}

local function owner(ent)
	local ow = ent.CPPIGetOwner and ent:CPPIGetOwner()
	return ip(ow) and ow
end

zone:SetBounds(
	Vector(-5450.03125, -4352.2109375, 64.359680175781),
	Vector(-3657.7392578125, -5111.96875, 450.96875)
)

zone:SetOnSpawn(function(self)

	local p1, p2 = zone:GetBounds()

	for k,v in ipairs(ents.FindInBox(p1, p2)) do

		if v:GetClass() == "ambient_generic" then

			--v:Remove() 	--holy based, this causes random players to become the bearers of earrape
			local snd = v:GetSaveTable().message
			if snd:find("piano") then v:StopSound(snd) end
		end

	end

end)

zone:SetStartTouchFunc(function(self, ent)	--Started touch

	if not ip(ent) then

		local ow = owner(ent)
		if not ow then return end


		local t = bwents[ow] or ValidSeqIterable()

		if not BWEnts[ent] then return end

		t:clean()
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

	--entity entered is a player

	-- stop the piano music, dumbass source
	local p1, p2 = zone:GetBounds()

	for k,v in ipairs(ents.FindInBox(p1, p2)) do

		if v:GetClass() == "ambient_generic" then
			local snd = v:GetSaveTable().message
			if snd:find("piano") then v:StopSound(snd) end
		end

	end

	local ply = ent

	local info = inhotel[ply] or 0
	info = info + 1

	inhotel[ply] = info

	if bwents[ply] then
		-- check validity of entities
		-- if any of them are still here, bail

		bwents[ply]:clean()
		if #bwents[ply] > 0 then return end

	end

	net.Start("Partizone")
		net.WriteBool(true)
		net.WriteUInt(1, 8)
	net.Send(ply)
end)


zone:SetEndTouchFunc(function(self, ent)

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
end)


AddPartizone(zone)