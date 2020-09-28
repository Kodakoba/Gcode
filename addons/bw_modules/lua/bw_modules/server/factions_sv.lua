Factions = Factions or {}

util.AddNetworkString("Factions")

local facs = Factions

local PLAYER = debug.getregistry().Player

facs.Players = facs.Players or {}
facs.Factions = facs.Factions or {}
facs.FactionIDs = facs.FactionIDs or {}

Factions.meta = Factions.meta or Networkable:extend()
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

function facmeta:RaidedCooldown()
	local oncd = false
	if self.RaidCooldown and CurTime() - self.RaidCooldown < RaidCoolDown then oncd = true end

	return oncd, RaidCoolDown - (CurTime() - (self.RaidCooldown or 0))
end

function facmeta:Update(now)
	self:Set("Members", self.memvals)
	self:Set("Leader", self.own)

	if now then self:Network(true) end
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

	self.members[ply] = true
	self.memvals[#self.memvals + 1] = ply

	facs.Players[ply] = self:GetName()

	ply:SetTeam(self:GetID())

	self:Update(true)
end

function facmeta:Initialize(ply, id, name, pw, col)

	if not id or not name then error('what??? ' .. tostring(id) .. " " .. tostring(name)) return false end --for real?

	if facs.Factions[name] then return false end

	team.SetUp(id, name, col, false)

	self.id = id
	self.name = name
	self.col = col
	self.pw = pw
	self.own = ply
	self.members = {[ply] = true}
	self.memvals = {ply}

	facs.Factions[name] = self
	facs.Players[ply] = name
	facs.FactionIDs[id] = self

	ply:SetTeam(id)

	self:SetNetworkableID("Faction:" .. id)
end

function facmeta:IsRaidable()
	local kk = false
	for k,v in pairs(self.members) do
		if k.PurchasedItems then
			for ent, _ in pairs(k.PurchasedItems) do
				if ent.IsValidRaidable then kk = true break end
			end
		end
	end
	return kk
end

function facmeta:ChangeOwnership(to)
	to = to or table.SeqRandom(self.memvals)
	if not to then
		self:Remove()
		error("Noone to change ownership to; killing faction")
		return
	end

	self.own = to
	self:Update(true)
end

function facmeta:RemovePlayer(ply)
	self.members[ply] = nil
	facs.Players[ply] = nil

	table.RemoveByValue(self.memvals, ply)

	ply:SetTeam(1)

	if #self.memvals == 0 then
		self:Remove()
		return
	end

	if self.own == ply and #self.memvals > 0 then
		self:ChangeOwnership()
	end
	self:Update(true)
end

function facmeta:Remove()
	facs.Factions[self.name] = nil
	facs.FactionIDs[self.id] = nil

	for k,v in ipairs(self.memvals) do
		v:SetTeam(1)
		facs.Players[v] = nil
	end

	net.Start("Factions")
		net.WriteUInt(3, 4)	--delete
		net.WriteUInt(self.id, 24)
	net.Broadcast()

	self:Invalidate()
end

function ValidFactions()

	for k,v in pairs(facs.Factions) do

		table.Filter(v.members, function(v)
			return v:IsValid()
		end)

		if table.Count(v.members) == 0 then
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

function facs.GetPlayerFaction(ply, ply2)
	if IsPlayer(ply2) then
		return facs.Players[ply] == facs.Players[ply2]
	elseif isstring(ply2) then
		return facs.Players[ply] == ply2
	else
		return facs.Factions[facs.Players[ply]] or false
	end
end

PLAYER.GetFaction = facs.GetPlayerFaction
PLAYER.InFaction = facs.GetPlayerFaction


function facs.RandomizeOwner(name)
	local fac = IsFaction(name) and name or facs.Factions[name]
	fac:ChangeOwnership()
end


local cooldowns = {}

function facs.CreateFac(ply, name, pw, col)
	if cooldowns[ply] and CurTime() - cooldowns[ply] < 1 then return end

	pw = pw and utf8.sub(pw, 0, 32)
	name = utf8.sub(name, 0, 32)

	if not Factions.CanCreate(name, pw, col, ply) then print("err can't create fac:", Factions.CanCreate(name, pw, col, ply)) return end

	ValidFactions()

	if not name or name == "" then error('uh no name?') return end
	if pw == "" then pw = nil end

	local id = 101

	for k,v in pairs(facs.Factions) do
		if v.id+1 > id then id = v.id+1 end
	end

	if not col then col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255)) end

	local fac = facmeta:new(ply, id, name, pw, col)

	cooldowns[ply] = CurTime()

	fac:Update(true)

	net.Start("Factions")
		net.WriteUInt(2, 4)	--update
		net.WriteUInt(id, 24)
		net.WriteString(name)
		net.WriteColor(col)
		--net.WriteUInt(ply:UserID(), 24)

		local haspw = false
		if pw then haspw = true end
		net.WriteBool(haspw)

	net.Broadcast()

end

PLAYER.CreateFaction = facs.CreateFac

function facs.LeaveFac(ply)
	local fac = ply:GetFaction()
	if not fac then return end

	fac:RemovePlayer(ply)
end

PLAYER.LeaveFaction = facs.LeaveFac

function facs.JoinFac(ply, id, pw, force)

	local fac = facs.FactionIDs[id] or (IsFaction(id) and id)
	if not fac then return false, Factions.Errors.NoFac end

	if ply:InRaid() then return false, Factions.Errors.JoinInRaid end
	if ply:InFaction() then return false, Factions.Errors.JoinInFac end

	if fac.pw and fac.pw ~= pw then
		return false, Factions.Errors.BadPassword
	end

	fac:Join(ply, pw, force)

	ValidFactions()
	return true
end

PLAYER.JoinFaction = facs.JoinFac

function facs.KickOut(ply)
	local fac = ply:GetFaction()
	if not fac then return end

	fac:RemovePlayer(ply)

	-- more logic if needed here; different from just leaving fac
end

PLAYER.KickFromFaction = facs.KickOut

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

		facs.CreateFac(ply, name, pw, col)
		throwSuccess(ply, reqID)
	elseif mode == Factions.LEAVE then
		-- Leaving a faction

		facs.LeaveFac(ply)

	elseif mode == Factions.JOIN then
		-- Joining a faction
		reqID = net.ReadUInt(8)

		local id = net.ReadUInt(24)
		local has_pw = net.ReadBool()
		local pw

		if has_pw then pw = net.ReadString() end

		local ok, why = facs.JoinFac(ply, id, pw)

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
	facs.FullUpdate()
end)

function facs.FullUpdate()
	ValidFactions()

	net.Start("Factions")
		net.WriteUInt(1, 4)
		net.WriteUInt(table.Count(facs.Factions), 16)
		for k,v in pairs(facs.Factions) do
			net.WriteUInt(v.id, 24)
			net.WriteString(v.name)
			net.WriteColor(v.col)

			local haspw = false
			if v.pw then haspw = true end
			net.WriteBool(haspw)
		end
	net.Broadcast()
end


facs.FullUpdate()


function facs.GetFaction(id)
	ValidFactions()
	if isnumber(id) then return facs.FactionIDs[id] or false end
	return facs.Faction[id] or false
end

function PLAYER:IsFacmate(ply2)
	return facs.Players[self] == facs.Players[ply2]
end

function PLAYER:FactionMembers()
	return (not self:GetFaction() and {self}) or (self:GetFaction() and self:GetFaction().memvals)
end