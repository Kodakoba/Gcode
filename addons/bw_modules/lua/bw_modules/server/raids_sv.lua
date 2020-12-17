RaidCoolDown = 900 --15 min
RaidDuration = 360 --6 min
local PLAYER = debug.getregistry().Player

util.AddNetworkString("Raid")


local CurrentReply	-- only 1 active at a time, so...

BaseWars.Raid = BaseWars.Raid or {}
local raid = BaseWars.Raid

raid.Cooldowns = raid.Cooldowns or {}

raidmeta = Emitter:callable()

raid.OngoingRaids = raid.OngoingRaids or {} --{[RaidID] = RaidMeta}
local cur = raid.OngoingRaids

raid.Participants = raid.Participants or {}		--Participants as {[player] = RaidMeta}

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

-- obj = Player, SteamID64 or Faction

-- returns the Raid object `obj` is participating in (or nil)
function raid.IsParticipant(obj)
	return raid.Participants[obj]
end

-- returns true if `obj` is participating in this Raid
function raidmeta:IsParticipant(obj)
	if self.Faction then
		if IsPlayer(obj) then return self.Raider:IsMember(obj) or self.Raided:IsMember(obj) end
		return obj == self.Raider or obj == self.Raided
	else
		return self.Raider == obj or self.Raided == obj
	end
end

-- returns true if `obj` is on the Raider side in this Raid
function raidmeta:IsRaider(obj)
	if IsPlayer(obj) or isstring(obj) then
		return self.Participants[obj] == 1
	end

	return self.Raider == obj
end

-- returns true if `obj` is on the Raided side in this Raid
function raidmeta:IsRaided(obj)
	if IsPlayer(obj) or isstring(obj) then
		return self.Participants[obj] == 2
	end

	return self.Raided == obj
end

function raidmeta:GetParticipants()
	return self.Participants
end

function raidmeta:GetSide(obj)
	if IsFaction(obj) and self:IsParticipant(obj) then return self:IsRaider(obj) and 1 or 2 end
	return self.Participants[obj]
end

function raidmeta:Initialize(rder, rded, fac)
	if not IsPlayer(rder) and not IsFaction(rder) then
		errorf("bad argument #1 (expected player or faction, got %s instead)", type(rder))
		return
	end

	if not IsPlayer(rded) and not IsFaction(rded) then
		errorf("bad argument #2 (expected player or faction, got %s instead)", type(rded))
		return
	end

	self.Start = CurTime()

	self.Raider = rder
	self.Raided = rded

	self.Faction = fac

	local id = uniq.Seq("raid")

	raid.OngoingRaids[id] = self
	self.ID = id

	self.Participants = {}
	local part = self.Participants

	if fac then

		for _, ply in ipairs(rder:GetMembers()) do
			part[ply] = 1
			part[ply:SteamID64()] = 1

			raid.Participants[ply] = self
			raid.Participants[ply:SteamID64()] = self
		end


		for _, ply in pairs(rded:GetMembers()) do
			part[ply] = 2
			part[ply:SteamID64()] = 2

			raid.Participants[ply] = self
			raid.Participants[ply:SteamID64()] = self
		end

		hook.Run("RaidStart", rder, rded, true)
	else
		part[rder] = 1
		part[rder:SteamID64()] = 1

		raid.Participants[rder] = self
		raid.Participants[rder:SteamID64()] = self

		part[rded] = 2
		part[rded:SteamID64()] = 2

		raid.Participants[rded] = self
		raid.Participants[rded:SteamID64()] = self

		hook.Run("RaidStart", rder, rded, false)
	end

end

function raidmeta:GetID()
	return self.ID
end

function raidmeta:Stop()

	hook.Run("RaidStop", self.Raider, self.Raided, self.Faction)

	-- remove everything that mentions this raid in raid.Participants
	for k,v in pairs(raid.Participants) do
		if v == self then
			raid.Participants[k] = nil
		end
	end

	net.Start("Raid")
		CurrentReply:Accept()
		net.WriteUInt(3, 4)
		net.WriteUInt(self:GetID(), 16)
	net.Broadcast()

end

function PLAYER:RaidedCooldown()
	local oncd = false
	if raid.Cooldowns[self:SteamID64()] and CurTime() - raid.Cooldowns[self:SteamID64()] < RaidCoolDown then oncd = true end

	return oncd
end

function PLAYER:GetRaid()
	return raid.Participants[self]
end

function PLAYER:IsRaided()
	local raidObj = self:GetRaid()
	if not raidObj then return false end

	return raidObj:IsRaided(self)
end

function PLAYER:IsRaider()
	local raidObj = self:GetRaid()
	if not raidObj then return false end

	return raidObj:IsRaider(self)
end

function PLAYER:GetSide()
	local rd = self:GetRaid()
	if not rd then return false end

	return rd:GetSide(self)
end


function PLAYER:IsEnemy(ply2)

	local part = self:GetRaid()
	if not part then return false end

	local part2 = ply2:GetRaid()
	if not part2 then return false end

	if part ~= part2 then return false end --not in the same raid

	return self:GetSide() ~= ply2:GetSide()
end


function raid.Stop(obj) -- obj = player, sid64 or faction

	local raidObj = raid.IsParticipant(obj)
	if not raidObj then return end

	raidObj:Stop()
end

local cdf = "Target is on cooldown!\n(%ds. remaining)"
function raid.Start(rder, rded, fac)
	local oncd, rem = rded:RaidedCooldown()
	if oncd then print('on cd') return false, cdf:format(rem) end

	if raid.IsParticipant(rder) then return false, "You are in a raid already!" end--print("Stopped on start: rder") raid.Stop(part[rder]) end
	if raid.IsParticipant(rded) then return false, "Target is in a raid already!" end--print("Stopped on start: rded") raid.Stop(part[rded]) end

	if not rder:IsRaidable() then return false, "You are not raidable!" end
	if not rded:IsRaidable() then return false, "Target is not raidable!" end

	if fac then
		local rtbl = raidmeta:new(rder, rded, fac)

		net.Start("Raid")
			CurrentReply:Accept()
			net.WriteUInt(2, 4)
			net.WriteUInt(rder.id, 24)
			net.WriteUInt(rded.id, 24)
			net.WriteFloat(rtbl.Start)
			net.WriteUInt(rtbl:GetID(), 16)
		net.Broadcast()

		return rtbl
	end

	local rtbl = raidmeta:new(rder, rded, fac)

	rder:SetNWBool("Raided", true)
	rded:SetNWBool("Raided", true)

	net.Start("Raid")
		CurrentReply:Accept()
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
	local rd = ply:GetRaid()
	if not rd then return end

	local plys = {}

	for obj, side in pairs(rd:GetParticipants()) do
		if IsPlayer(k) then plys[#plys + 1] = obj end
	end

	if #plys == 1 then	-- EVERY participant left; stop the raid
		rd:Stop()
		return
	end

	print(ply, "left during a raid, wat do")
end)

function PLAYER:IsRaidable()
	local sid = self:SteamID64()

	if not BWOwners[self] then return false end -- no entities
	if self:GetLevel() < 75 then return false end

	BWOwners[self]:clean()

	for k,v in ipairs(BWOwners[self]) do

		local class = (isentity(v) and v:GetClass()) or v

		local e = scripted_ents.GetStored(class)
		if not e then print('didnt find', v, "; raids sv") continue end --??

		if e.t.IsValidRaidable then return true end
	end

	return false
end

function raid.WasInRaid(sid)
	if raid.Participants[sid] then return raid.Participants[sid] end
	return false
end

hook.Add("PlayerSpawnObject", "RaidPropsPrevent", function(ply, mdl, skin)
	if ply:InRaid() then return false end
end)

function ReportFail(ply, err)

	net.Start("Raid")
		CurrentReply:Deny()
		net.WriteString(err)
	net.Send(ply)

	CurrentReply = nil
end

net.Receive("Raid", function(_, ply)
	local pr = net.ReplyPromise()
	CurrentReply = pr
	local mode = net.ReadUInt(4)
	--1 = start vs. player
	--2 = start vs. fac
	--3 = concede
	print('Received raid request, mode', mode)

	if mode == 1 then
		local ent = net.ReadEntity()
		if not IsPlayer(ent) then print(ent, "not player") return end
		if ent:RaidedCooldown() then print('on cd') return end
		if ply:InRaid() or ent:InRaid() then print('Ply in raid already') return end
		if ply:InFaction() or ent:InFaction() then print("one of em is in a faction") return end
		print("starting on", ply, ent)
		local ok, err = raid.Start(ply, ent, false)
		print("ok?", ok, err)
		if not ok then
			print("returning no")
			ReportFail(ply, err, pr)
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
		print(ok, "yes")
		if not ok then
			print("returning no")
			ReportFail(ply, err, pr)
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