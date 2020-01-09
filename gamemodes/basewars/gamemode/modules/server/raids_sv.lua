RaidCoolDown = 900 --15 min
RaidDuration = 360 --6 min
local PLAYER = debug.getregistry().Player

util.AddNetworkString("Raid")


BaseWars.Raid = BaseWars.Raid or {}
local raid = BaseWars.Raid

raid.Cooldowns = raid.Cooldowns or {}

raidmeta = {}
raidmeta.__index = raidmeta

raid.OngoingRaids = raid.OngoingRaids or {} --{[RaidID] = RaidMeta}
local cur = raid.OngoingRaids 

raid.Participants = raid.Participants or {}		--Participants as {[player] = RaidMeta}
local part = raid.Participants 

local lowseq = table.LowestSequential

local function Date()
	local ts = os.time()
	local date = os.date( "%H:%M:%S - %d.%m.%Y" , ts )
	return date
end

local function Time()
	local ts = os.time()
	local date = os.date( "%H:%M:%S" , ts )
	return date
end

function raidmeta:new(rder, rded, fac)

	local new = {}
	setmetatable(new, raidmeta)

	new.Events = {}
	new.FactionRaid = fac 

	new.Raiders = {} --just strings for logging
	new.Raided = {}

	new._Raiders = {}	--[Player] = true
	new._Raided = {}

	new.Start = CurTime()

	local id = lowseq(raid.OngoingRaids) + 1

	raid.OngoingRaids[id] = new
	new.ID = id 

	local part = raid.Participants

	local date = Date()

	if fac then 
		local ers = {}
		local sids = {}

		for k,v in pairs(rder.members) do 
			ers[#ers+1] = k:Nick() .. (" (%s)"):format(k:SteamID())
			part[k] = new
			part[k:SteamID64()] = new
			new._Raiders[k] = true
			sids[k:SteamID64()] = 1
		end

		rder.Raiders = true
		rder.Raided = false 

		local ed = {}
		for k,v in pairs(rded.members) do 
			ed[#ed+1] = k:Nick() .. (" (%s)"):format(k:SteamID())
			part[k] = new
			part[k:SteamID64()] = new
			new._Raided[k] = true
			sids[k:SteamID64()] = 2

		end

		rded.Raided = true
		rded.Raiders = false 

		new.Raiders = ers 
		new.Raided = ed
		new:LogEvent(1, {[[raider faction "]] .. rder.name .. [["]], [[raided faction "]] .. rded.name .. [["]], date })
		new:LogList(2, new.Raiders)
		new:LogList(3, new.Raided)
		new.SteamIDs = sids
	else 
		new.Raiders = rder:Nick() .. (" (%s)"):format(rder:SteamID())
		new.Raided = rded:Nick() .. (" (%s)"):format(rded:SteamID())

		new._Raiders = rder
		new._Raided = rded
		local sids = {} 

		sids[rder:SteamID64()] = 1 
		sids[rded:SteamID64()] = 2
		new.SteamIDs = sids

		part[rder] = new 
		part[rder:SteamID64()] = new

		part[rded] = new 
		part[rded:SteamID64()] = new

		new:LogEvent(1, {[[raider player "]] .. new.Raiders .. [["]], [[raided player "]] .. new.Raided .. [["]], date })
	end


	return new
end

function raidmeta:GetSteamID64()
	return self.SteamIDs
end

local lang = BaseWars.LANG.Shorts

function raidmeta:LogList(id, info)

	local str = Time() .. ":\n"

	for k,v in pairs(info) do 
		local add = isstring(v) and v 
		if not add and IsPlayer(v) then 
			add = v:Nick() .. (" (%s)"):format(v:SteamID())
		end

		str = str .. add
	end

	if isnumber(id) then 
		local pre = lang[id]
		

		if not pre then 
			self.Events[#self.Events + 1] = "Missing language for ID " .. id .. "!\nInfo: " .. str
		else 
			self.Events[#self.Events + 1] = pre .. str
		end

	elseif isstring(id) then
		self.Events[#self.Events + 1] = id .. str
	end

end

function raidmeta:LogEvent(id, info)

	if isnumber(id) and istable(info) then 

		local pre = lang[id]
		if not pre then 
			pre = "Missing language for ID " .. id .. "!\nInfo: " .. table.concat(info, "\n")
			self.Events[#self.Events + 1] = Time() .. ": " .. pre 
			return
		end
		local s = string.format(pre, unpack(info))

		self.Events[#self.Events + 1] = Time() .. ": " .. s
	elseif isnumber(id) and isstring(info) then 

		local pre = lang[id]
		if not pre then 
			pre = "Missing language for ID " .. id .. "!\nInfo: " .. table.concat(info, "\n")
			self.Events[#self.Events + 1] = Time() .. ": " .. pre 
			return
		end
		local s = string.format(pre, info)

		self.Events[#self.Events + 1] = Time() .. ": " .. s

	end

end

function raidmeta:IsRaider(ply)
	return self._Raiders[ply]
end

function raidmeta:IsRaided(ply)
	return self._Raided[ply]
end

function raidmeta:GetRaiders()
	return self._Raiders
end

function raidmeta:GetRaided()
	return self._Raided
end

function raidmeta:GetID()
	return self.ID
end

function raidmeta:Stop()
	
	local r = self 

	if not r.FactionRaid then 
		local k1 = IsPlayer(r._Raiders) and r._Raiders:SetNWBool("Raided", false)
		local k2 = IsPlayer(r._Raided) and r._Raided:SetNWBool("Raided", false)

		raid.Participants[r._Raiders] = nil 
		raid.Participants[r._Raided] = nil

		if IsPlayer(r._Raiders) then 
			raid.Participants[r._Raiders:SteamID64()] = nil 
		end 

		if IsPlayer(r._Raided) then
			raid.Participants[r._Raided:SteamID64()] = nil 
		end

		for k,v in pairs(raid.OngoingRaids) do 
			if v==r then 
				raid.OngoingRaids[k] = nil 
			end 
		end

	else 
		local fac1
		for k,v in pairs(r._Raiders) do 
			if IsPlayer(k) then k:SetNWBool("Raided", false) else continue end
			raid.Participants[k] = nil
			raid.Participants[k:SteamID64()] = nil
			if k:GetFaction() then 
				fac1 = k:GetFaction()
			end
		end

		local fac2

		for k,v in pairs(r._Raided) do 
			if IsPlayer(k) then k:SetNWBool("Raided", false) else continue end
			raid.Participants[k] = nil
			raid.Participants[k:SteamID64()] = nil
			if k:GetFaction() then 
				fac2 = k:GetFaction()
			end
		end

		
		if fac2 then 
			fac2.Raided = nil 
			fac2.Raiders = nil 
		end 
		if fac1 then 
			fac1.Raiders = nil 
			fac1.Raided = nil 
		end

		for k,v in pairs(raid.OngoingRaids) do 
			if v==r then 
				raid.OngoingRaids[k] = nil 
			end 
		end
	end

	for k,v in pairs(self:GetSteamID64()) do 
		raid.Participants[k] = nil
	end

	net.Start("Raid")
		net.WriteUInt(3, 4)
		net.WriteUInt(self:GetID(), 16)
	net.Broadcast()

end

function PLAYER:RaidedCooldown()
	local oncd = false 
	if raid.Cooldowns[self:SteamID64()] and CurTime() - raid.Cooldowns[self:SteamID64()] < RaidCoolDown then oncd = true end

	return oncd
end

function PLAYER:IsRaided()
	local part = raid.Participants[self]

	if not part then return false end
	return part._Raided==self or part._Raided[self] or false
end 

function PLAYER:IsRaider()
	local part = raid.Participants[self]

	if not part then return false end
	return part._Raiders==self or part._Raiders[self] or false
end

function PLAYER:GetSide()
	return self:InRaid() and (self:IsRaided() and 2 or 1)
end

function PLAYER:GetRaid()
	return raid.Participants[self]
end

function PLAYER:IsEnemy(ply2)
	local part = raid.Participants[self]
	if not part then print('self not participant') return false end

	local part2 = raid.Participants[ply2]
	if not part2 then print('ply2 not participant') return false end 

	if part ~= part2 then print('not same raid')  return false end --not in the same raid 

	local enemies = (self:IsRaided() and not ply2:IsRaided()) or (ply2:IsRaided() and not self:IsRaided())


	return enemies
end


function raid.Stop(rder) --rder = player OR RaidMeta

	if IsPlayer(rder) then 
		if not raid.Participants[rder] then print('Nope') return end

		local r = raid.Participants[rder]

		r:Stop()

	elseif istable(rder) and rder.Start then --thats a raidmeta
		rder:Stop()
	end

end

local cdf = "Target is on cooldown!\n(%ds. remaining)"
function raid.Start(rder, rded, fac)
	local oncd, rem = rded:RaidedCooldown()
	if oncd then print('on cd') return false, cdf:format(rem) end

	if part[rder] then return false, "You are in a raid already!" end--print("Stopped on start: rder") raid.Stop(part[rder]) end
	if part[rded] then return false, "Target is in a raid already!" end--print("Stopped on start: rded") raid.Stop(part[rded]) end

	if not rder:IsRaidable() then return false, "You are not raidable!" end 
	if not rded:IsRaidable() then return false, "Target is not raidable!" end

	if fac then 
		local rtbl = raidmeta:new(rder, rded, fac)
		local involved = {}

		for k,v in pairs(rder.members) do 
			k:SetNWBool("Raided", true)
			involved[k] = true
		end

		for k,v in pairs(rded.members) do 
			k:SetNWBool("Raided", true)
			involved[k] = true
		end

		rtbl.Involved = involved
		
		net.Start("Raid")
			net.WriteUInt(2, 4)
			net.WriteUInt(rder.id, 24)
			net.WriteUInt(rded.id, 24)
			net.WriteFloat(rtbl.Start)
			net.WriteUInt(rtbl:GetID(), 16)
		net.Broadcast()

		return rtbl 
	end
	print('starting')
	local rtbl = raidmeta:new(rder, rded, fac)

	local inv = {}

	inv[rder] = true 
	inv[rded] = true 

	rder:SetNWBool("Raided", true)
	rded:SetNWBool("Raided", true)

	net.Start("Raid")
		net.WriteUInt(1, 4)
		net.WriteUInt(rder:UserID(), 24)
		net.WriteUInt(rded:UserID(), 24)
		net.WriteFloat(rtbl.Start)
		net.WriteUInt(rtbl:GetID(), 16)
	net.Broadcast()


	return rtbl
end

hook.Add("PlayerInitialSpawn", "RaidNetwork", function(ply)


end)


hook.Add("PlayerDisconnected", "RaidLog", function(ply) --aiaiai
	if part[ply] then 
		local r = part[ply]

		local raider = r._Raiders[ply] or r._Raiders == ply
		local raided = r._Raided[ply] or r._Raided == ply

		local str = "%s ( %s )"
		str = str:format(ply:Nick(), ply:SteamID())
		print("Logging", str)
		if raider then 
			r:LogEvent(10, str)
			if istable(r._Raiders) then 
				local anyoneleft = false

				for k,v in pairs(r._Raiders) do 
					if k~=ply and IsValid(k) then anyoneleft = true return end 
				end

				if not anyoneleft then 
					print("Stopping raid cause all raiders left")
					raid.Stop(r)
				end
			end

			if IsPlayer(r._Raiders) then --he's the only raider...
				print("Stopping raid cause raider ply left")
				raid.Stop(r)
			end
		elseif raided then 
			r:LogEvent(11, str)
		else 
			r:LogEvent(12, str)
		end

	end

end)

function PLAYER:IsRaidable()
	local sid = self:SteamID64()

	if not BWOwners[self] then return end 

	if self:GetLevel() < 75 then return false end 
	
	BWOwners[self]:clean()

	for k,v in ipairs(BWOwners[self]) do 

		local class = (isentity(v) and v:GetClass()) or v
		local e = scripted_ents.Get(class)
		if not e then print('didnt find', v, "; raids sv") continue end --??

		if e.IsValidRaidable then return true end
	end

	return false
end

function raid.WasInRaid(sid)
	if raid.Participants[sid] then return raid.Participants[sid] end 
	return false 
end

hook.Add("PlayerSpawnObject", "RaidPropsPrevent", function(ply, mdl, skin)
	if IsPlayer(ply) and ply:InRaid() then return false end

end)

function ReportFail(ply, err)

	net.Start("Raid")
		net.WriteUInt(4, 4)
		net.WriteString(err)
	net.Send(ply)

end
net.Receive("Raid", function(_, ply)
	local mode = net.ReadUInt(4)
	--1 = start vs. player
	--2 = start vs. fac
	--3 = concede
	print('Received raid request, mode', mode)

	if mode == 1 then 
		local ent = net.ReadEntity()
		if not IsPlayer(ent) then return end
		if ent:RaidedCooldown() then print('on cd') return end 
		if ply:InRaid() or ent:InRaid() then print('Ply in raid already') return end 
		if ply:InFaction() or ent:InFaction() then print("one of em is in a faction") return end 

		local ok, err = raid.Start(ply, ent, false)
		if not ok then 
			print("returning no")
			ReportFail(ply, err)
		end
	elseif mode == 2 then 
		local fac = net.ReadUInt(24)

		if not ply:GetFaction() or not Factions.GetFaction(fac) then print('Not faction 1 or not faction 2:', ply:GetFaction(), Factions.GetFaction(fac), fac) ReportFail(ply, "Something's gone wrong...\nThis faction doesn't exist anymore?") return end 
		
		local oncd, rem = Factions.GetFaction(fac):RaidedCooldown()
		if oncd then print('on cd') ReportFail(ply, cdf:format(rem)) return end 

		local fac1 = ply:GetFaction()
		local fac2 = Factions.GetFaction(fac)

		if fac1:InRaid() or fac2:InRaid() then print('Fac is in raid already') ReportFail(ply, "That faction is in a raid already!") return end
		print("Mode 2; starting raid(?)")
		local ok, err = raid.Start(ply:GetFaction(), Factions.GetFaction(fac), true)

		if not ok then 
			print("returning no")
			ReportFail(ply, err)
		end

	elseif mode==3 then
		if not raid.Participants[ply] then print("Ply is not participating in raid") return false end 
		if ply:IsRaided() then print("Not stopping raid from raided") return false end --do not accept concedes from raided

		if ply:IsRaider() then 
			raid.Stop(ply)
		end
	end

end)

hook.Add("Think", "RaidsThink", function()
	for k,v in pairs(raid.OngoingRaids) do 
		if CurTime() - v.Start > RaidDuration then 
			raid.Stop(v)
		end
	end
end)

hook.Add("PlayerDeath", "RaidsDeath", function(ply, by, atk)
	local side = ply:GetSide()

	if side then 

		local delay = side * 5 + 5	--raided get (2*5) + 5 = 15s
		ply:SetRespawnTime(delay)
		
	end

end)


hook.Remove("PlayerSpawn", "RaidsSpawn")
hook.Remove("PlayerDeathThink", "RaidsDeath")