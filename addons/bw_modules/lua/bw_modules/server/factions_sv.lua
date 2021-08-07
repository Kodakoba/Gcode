Factions = Factions or {}
MODULE.Name = "FactionsSV"

util.AddNetworkString("Factions")

local facs = Factions

local PLAYER = debug.getregistry().Player

facs.Players = facs.Players or {}
facs.Factions = facs.Factions or {}
facs.FactionIDs = facs.FactionIDs or {}

local facmeta = Factions.meta

facmeta.IsFaction = true

function IsFaction(t)
	local meta = getmetatable(t)

	return meta and meta.IsFaction
end

function facmeta:InRaid()
	return self.Raided or self.Raider
end

function facmeta:GetMembers()
	return self.memvals
end

function facmeta:GetMembersInfo()
	return self.meminfovals
end

function facmeta:IsMember(what)
	local pinfo = GetPlayerInfoGuarantee(what)
	return self.meminfo[pinfo] and pinfo
end

function facmeta:GetName()
	return self.name
end

function facmeta:GetColor()
	return self.col
end

function facmeta:GetPassword()
	return self.pw or false
end

function facmeta:GetID()
	return self.id
end

function facmeta:GetLeader()
	return self.own
end

facmeta.GetOwner = facmeta.GetLeader

function facmeta:GetLeaderInfo()
	return self.ownInfo
end

facmeta.GetOwnerInfo = facmeta.GetLeaderInfo

function facmeta:RaidedCooldown()
	local cd = self.RaidCooldown

	if cd and CurTime() - cd < Raids.FactionCooldown then
		return true, Raids.FactionCooldown - (CurTime() - cd)
	end

	return false
end

function facmeta:Update(now)
	self.PublicNW:Set("Members", self.memvals)
	self.PublicNW:Set("Leader", self.own)
	self.PublicNW:Set("PlayerInfo", self.meminfovals)

	if now then self.PublicNW:Network(true) end
	self:Emit("Update")
end

function facmeta:_AddToMembers(what)
	local pinfo, ply = GetPlayerInfoGuarantee(what)

	local new = not self.meminfo[pinfo]

	self.memvals[#self.memvals + 1] = ply
	self.meminfovals[#self.meminfovals + 1] = pinfo
	pinfo._Faction = self
	self.members[ply] = true
	self.meminfo[pinfo] = true

	pinfo:On("Destroy", self, function()
		self:RemoveFromMembers(pinfo)
	end)

	if new then
		self:Emit("JoinFaction", ply, pinfo)
		hook.NHRun("PlayerJoinedFaction", self, ply, pinfo)
	end
end

function facmeta:_RemoveFromMembers(what)
	local pinfo, ply = GetPlayerInfoGuarantee(what)

	if Factions.Players[ply] == self:GetName() then Factions.Players[ply] = nil end

	local had = self.meminfo[pinfo]

	table.RemoveByValue(self.memvals, ply)
	table.RemoveByValue(self.meminfovals, pinfo)
	self.members[ply] = nil
	self.meminfo[pinfo] = nil
	pinfo._Faction = nil

	if had then
		self:Emit("LeaveFaction", ply, pinfo)
		hook.NHRun("PlayerLeftFaction", self, ply, pinfo)
	end
end

function facmeta:Join(ply, pw, force)

	if #self.memvals >= 4 then return false, "Too many members!" end

	if ply:InFaction() then return false, "Player is already in a faction!" end
	if ply:InRaid() then return false, "Player is in a raid!" end

	if self.pw and self.pw ~= pw and not force then
		net.Start("Factions")
			net.WriteUInt(10, 4) --hey buddy i think you got the wrong password
			Factions.Errors[1]:Write()
		net.Send(ply)

		return false, "wrong password boy"
	end

	self:_AddToMembers(ply)

	Factions.Players[ply] = self:GetName()

	ply:SetTeam(self:GetID())

	self:Update(true)
end

function facmeta:OnRaided()
	self.RaidCooldown = CurTime()
	self.PublicNW:Set("RaidCooldown", self.RaidCooldown)
end

function facmeta:Initialize(ply, id, name, pw, col)

	if not id or not name then error('what??? ' .. tostring(id) .. " " .. tostring(name)) return false end --for real?

	if Factions.Factions[name] then return false end

	team.SetUp(id, name, col, false)

	self.id = id
	self.name = name
	self.col = col
	self.pw = pw




	self.members = {}		-- [ply] = true
	self.memvals = {}		-- [seq_id] = ply
	self.meminfo = {}		-- [plyInfo] = true
	self.meminfovals = {}	-- [seq_id] = plyInfo

	if IsPlayer(ply) then
		Factions.Players[ply] = name
		ply:SetTeam(id)
		self:_AddToMembers(ply)
	elseif ply ~= false then
		error("Attempted to create a faction with no player; use `false` as the first arg if this is intentional.")
	end

	Factions.Factions[name] = self
	Factions.FactionIDs[id] = self

	if id > 0 then
		self.own = ply
		self.ownInfo = GetPlayerInfo(ply)

		self.PublicNW = Networkable:new("Faction:" .. id)
		self.PublicNW:On("WriteChangeValue", "WritePlayerInfo", self._SerializePlayerInfo)

		self.PublicNW:Alias("Members", 1)
		self.PublicNW:Alias("Leader", 2)
		self.PublicNW:Alias("PlayerInfo", 3)
	end

	self:On("Raided", "CooldownTracker", self.OnRaided)
end

function facmeta:_SerializePlayerInfo(key, val)
	if key == "PlayerInfo" then
		net.WriteUInt(#val, 4)
		for k,v in ipairs(val) do
			net.WriteString(v:GetSteamID64())
		end
		return false
	end
end

function facmeta:IsRaidable(caller)
	-- caller can be nil if it's checked as "generally raidable"
	local can, err = hook.Run("IsFactionRaidable", self)
	if can == false then return can, err end

	if caller then
		can, err = BaseWars.Raid.CanGenerallyRaid(caller, false)
		if can == false then
			return can, err
		end
	end

	can, err = BaseWars.Raid.CanRaidFaction(caller, self)
	if can == false then
		return can, err
	end

	return true
end

function facmeta:ChangeOwnership(to)
	to = to or table.SeqRandom(self.memvals)
	if not to then
		self:Remove()
		error("Noone to change ownership to; killing faction") -- this shouldn't happen
		return
	end

	self.own = to
	self:Update(true)
end

function facmeta:RemovePlayer(ply)
	self:_RemoveFromMembers(ply)

	if ply:IsValid() then
		ply:SetTeam(1)
	end

	if #self.memvals == 0 then -- todo: launch a destruction timer in 300s instead of instantly removing
		self:Remove()
		return
	end

	if self.own == ply and #self.memvals > 0 then
		self:ChangeOwnership()
	end
	self:Update(true)
end

function facmeta:Remove()
	if self == Factions.NoFaction then return end

	self._Valid = false

	Factions.Factions[self.name] = nil
	Factions.FactionIDs[self.id] = nil

	for k,v in ipairs(self.memvals) do
		v:SetTeam(1)
		Factions.Players[v] = nil
	end

	for k, pinfo in ipairs(self.meminfovals) do
		pinfo._Faction = nil
	end

	hook.NHRun("FactionDisbanded", self)

	net.Start("Factions")
		net.WriteUInt(3, 4)	--delete
		print("Deleting faction", self.id)
		net.WriteUInt(self.id, 24)
	net.Broadcast()

	if self.id > 0 then
		self.PublicNW:Invalidate()
	end
	self:Emit("Remove")
end

function facmeta:IsValid()
	return self._Valid ~= false
end

function Factions.Validate()

	for k,v in pairs(Factions.Factions) do
		if v == Factions.NoFaction then continue end

		table.Filter(v.members, function(v)
			return v:IsValid()
		end)

		if table.Count(v.members) == 0 then
			-- todo: check the timer before removing
			v:Remove()
			continue
		end

		--Owner checking

		if not IsValid(v.own) then
			v:ChangeOwnership()
		end

		v:Update()

	end

end

function Factions.GetPlayerFaction(ply, ply2)
	if IsPlayer(ply2) then
		return Factions.Players[ply] == Factions.Players[ply2]
	elseif isstring(ply2) then
		return Factions.Players[ply] == ply2
	else
		return Factions.Factions[Factions.Players[ply]] or false
	end
end

PLAYER.GetFaction = Factions.GetPlayerFaction
PLAYER.InFaction = Factions.GetPlayerFaction


function Factions.RandomizeOwner(name)
	local fac = IsFaction(name) and name or Factions.Factions[name]
	fac:ChangeOwnership()
end


local cooldowns = {}

function Factions.CreateFac(ply, name, pw, col)
	if cooldowns[ply] and CurTime() - cooldowns[ply] < 1 then return end

	pw = pw and utf8.sub(pw, 0, 32)
	name = utf8.sub(name, 0, 32)

	if not Factions.CanCreate(name, pw, col, ply) then print("err can't create fac:", Factions.CanCreate(name, pw, col, ply)) return end

	Factions.Validate()

	if not name or name == "" then error('uh no name?') return end
	if pw == "" then pw = nil end

	local id = 101

	for k,v in pairs(Factions.Factions) do
		if v.id+1 > id then id = v.id+1 end
	end

	if not col then col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255)) end

	local fac = facmeta:new(ply, id, name, pw, col)

	cooldowns[ply] = CurTime()

	-- first make them aware of the faction, then network its' details

	net.Start("Factions")
		net.WriteUInt(2, 4)	--update
		net.WriteUInt(id, 24)
		net.WriteString(name)
		net.WriteColor(col)

		local haspw = false
		if pw then haspw = true end
		net.WriteBool(haspw)

	net.Broadcast()

	fac:Update(true)

	-- anyone that tries to network data about the faction will do it afterwards
	-- no data races on my watch
	hook.NHRun("FactionCreated", ply, fac)
end

PLAYER.CreateFaction = Factions.CreateFac

function Factions.LeaveFac(ply)
	local fac = ply:GetFaction()
	if not fac then return end

	fac:RemovePlayer(ply)
end

PLAYER.LeaveFaction = Factions.LeaveFac

function Factions.JoinFac(ply, id, pw, force)

	local fac = Factions.FactionIDs[id] or (IsFaction(id) and id)
	if not fac then return false, Factions.Errors.NoFac end

	if ply:InRaid() then return false, Factions.Errors.JoinInRaid end
	if ply:InFaction() then return false, Factions.Errors.JoinInFac end

	if fac.pw and fac.pw ~= pw then
		return false, Factions.Errors.BadPassword
	end

	fac:Join(ply, pw, force)

	Factions.Validate()
	return true
end

PLAYER.JoinFaction = Factions.JoinFac

function Factions.KickOut(ply)
	local fac = ply:GetFaction()
	if not fac then return end

	fac:RemovePlayer(ply)

	-- more logic if needed here; different from just leaving fac
end

PLAYER.KickFromFaction = Factions.KickOut

hook.Add("PlayerDisconnected", "FactionDisband", function(ply)
	local fac = ply:GetFaction()
	if not fac then return end

	fac:RemovePlayer(ply)
end)

local function throwError(ply, uid, lang)
	lang = lang or Factions.Errors.Generic
	net.Start("Factions")
		net.WriteUInt(10, 4)
		net.WriteUInt(uid, 8)
		net.WriteBool(false)
		lang:Write()
	net.Send(ply)
end

local function throwSuccess(ply, uid)
	net.Start("Factions")
		net.WriteUInt(10, 4)
		net.WriteUInt(uid, 8)
		net.WriteBool(true)
	net.Send(ply)
end

net.Receive("Factions", function(_, ply)

	local mode = net.ReadUInt(4)
	local reqID

	if mode == Factions.CREATE then
		-- Creating a faction
		reqID = net.ReadUInt(8)
		local name = net.ReadString()
		local pw = net.ReadString()
		local col = net.ReadColor()

		name = name:gsub("%c", "")
		pw = pw:gsub("%c", "")
		col.a = 255

		local can, err = facs.CanCreate(name, pw, col, ply)
		if not can then
			throwError(ply, reqID, err)
			--[[if ply.canCreateFacCD and CurTime() - ply.canCreateFacCD < 1 then return end
			ply:ChatAddText(Color(220, 75, 75), "Failed to create faction!\n", err)
			ply.canCreateFacCD = CurTime()]]
			return
		end

		Factions.CreateFac(ply, name, pw, col)
		throwSuccess(ply, reqID)
	elseif mode == Factions.LEAVE then
		-- Leaving a faction

		Factions.LeaveFac(ply)

	elseif mode == Factions.JOIN then
		-- Joining a faction
		reqID = net.ReadUInt(8)

		local id = net.ReadUInt(24)
		local has_pw = net.ReadBool()
		local pw

		if has_pw then pw = net.ReadString() end

		local ok, why = Factions.JoinFac(ply, id, pw)

		if ok == false then
			throwError(ply, reqID, why)
		else
			throwSuccess(ply, reqID)
		end

	elseif mode == Factions.KICK then
		-- Kicking a faction member

		local whomst = net.ReadEntity()
		if not IsPlayer(whomst) then return end

		if ply:GetFaction() ~= whomst:GetFaction() then
			errorf("%s (%s) attempted to kick %s (%s) from a faction they are not in.", ply:Nick(), ply:SteamID64(), whomst:Nick(), whomst:SteamID64())
			return
		end

		if ply:GetFaction():GetOwner() ~= ply then
			errorf("%s (%s) attempted to kick %s (%s) despite not being the leader.", ply:Nick(), ply:SteamID64(), whomst:Nick(), whomst:SteamID64())
			return
		end

		whomst:KickFromFaction()
	end

end)

hook.Add("PlayerInitialSpawn", "FactionNetwork", function(ply)
	Factions.FullUpdate()
end)

function Factions.FullUpdate()
	Factions.Validate()

	net.Start("Factions")
		net.WriteUInt(1, 4)
		net.WriteUInt(table.Count(Factions.Factions), 16)
		for k,v in pairs(Factions.Factions) do
			net.WriteUInt(v.id, 24)
			net.WriteString(v.name)
			net.WriteColor(v.col)

			local haspw = false
			if v.pw then haspw = true end
			net.WriteBool(haspw)
		end
	net.Broadcast()
end


Factions.FullUpdate()

function PLAYER:IsFacmate(ply2)
	return Factions.Players[self] == Factions.Players[ply2]
end

function PLAYER:FactionMembers()
	return (not self:GetFaction() and {self}) or (self:GetFaction() and self:GetFaction().memvals)
end