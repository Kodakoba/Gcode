BaseWars.Factions = BaseWars.Factions or {}

util.AddNetworkString("Factions")

local facs = BaseWars.Factions

local PLAYER = debug.getregistry().Player

facs.Players = facs.Players or {}
facs.Factions = facs.Factions or {}
facs.FactionIDs = facs.FactionIDs or {}

facmeta = Networkable:extend()

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
	print("returning", RaidCoolDown - (CurTime() - (self.RaidCooldown or 0)))
	return oncd, RaidCoolDown - (CurTime() - (self.RaidCooldown or 0))
end

function facmeta:Update()
	self:Set("Members", self.memvals)
	self:Set("Leader", self.own)
end

function facmeta:Join(ply, pw, force)

	if table.Count(self.memvals) >= 4 then return false end 

	if ply:InFaction() then return false end 
	if ply:InRaid() then return false end 

	if self.pw and self.pw ~= pw and not force then
		net.Start("Factions")
			net.WriteUInt(10, 4) --hey buddy i think you got the wrong password
		net.Send(ply)

	return false end 

	self.members[ply] = true 
	self.memvals[table.LowestSequential(self.memvals) + 1] = ply

	facs.Players[ply] = self:GetName()

	ply:SetTeam(self:GetID())

	self:Update()
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

function ValidFactions()

	for k,v in pairs(facs.Factions) do 

		--Members checking

		local hasmems = false 

		for ply, num in pairs(v.members) do 

			if IsPlayer(ply) then hasmems = true end 

			if not IsValid(ply) then 
				print("aiai not valid ply", num)
				v.members[num] = nil
			end


		end

		for k2,v2 in pairs(v.memvals) do 
			if not IsValid(v2) then v.memvals[k2] = nil continue end
		end

		if not hasmems then 
			net.Start("Factions")
				net.WriteUInt(3, 4)	--delete
				net.WriteUInt(v.id, 24)
			net.Broadcast()

			v:Invalidate()

			facs.FactionIDs[v.id] = nil
			facs.Factions[k] = nil 

			continue
		end 

		--Owner checking

		if not IsValid(v.own) then 
			facs.RandomizeOwner(v.name)
		end

		v:Update()

	end

end

function facs.InFaction(ply, ply2) --mostly unused, really...
	if IsValid(ply2) then 
		return facs.Players[ply] == facs.Players[ply2]
	end
	return facs.Players[ply] or false
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
	local fac = facs.Factions[name]
	local ppl = {}
	for k,v in pairs(fac.members) do 
		if IsValid(k) then 
			ppl[#ppl+1] = k 
		end
	end
	local own = table.Random(ppl)

	if not own then 

		for k,v in pairs(fac.members) do  --???
			if IsValid(v) then 
				facs.LeaveFac(v)
			end
		end

		v:Invalidate()

		facs.FactionIDs[facs.Factions[name].id] = nil
		facs.Factions[name] = nil

		net.Start("Factions")
			net.WriteUInt(3, 4)	--delete
			net.WriteUInt(fac.id, 24)
		net.Broadcast()

		return 
	end

	facs.Factions[name].own = own
	print('updating owner')
	net.Start("Factions")
		net.WriteUInt(4, 4)	--update leader
		net.WriteUInt(facs.Factions[name].id, 24)
		net.WriteUInt(own:UserID(), 24)
	net.Broadcast()

end
local cooldowns = {}
function facs.CreateFac(ply, name, pw, col)
	if cooldowns[ply] and CurTime() - cooldowns[ply] < 1 then return end 

	ValidFactions()

	local pw = string.sub(pw, 0, 16)
	local name = string.sub(name, 0, 64)

	if not name or name == "" then error('uh') return end 
	if pw == "" then pw = nil end

	local id = 101

	for k,v in pairs(facs.Factions) do 
		if v.id+1 > id then id = v.id+1 end
	end

	if not col then col = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255)) end
	
	local fac = facmeta:new(ply, id, name, pw, col)

	cooldowns[ply] = CurTime()

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

	fac:Update()
end

PLAYER.CreateFaction = facs.CreateFac 

function facs.LeaveFac(ply)

	local name = facs.Players[ply]
	if not name then return end 

	local fac = facs.Factions[name]
	if not fac then return end 


	fac.members[ply] = nil 

	for k,v in pairs(fac.memvals) do
		if v==ply then 
			fac.memvals[k] = nil
			break
		end
	end

	if fac.own == ply then 
		facs.RandomizeOwner(name)
	end 

	facs.Players[ply] = nil
	ply:SetTeam(1)

	fac:Update()

	ValidFactions()
end

PLAYER.LeaveFaction = facs.LeaveFac

function facs.JoinFac(ply, name, pw, force)

	local fac = facs.Factions[name]
	if not fac then return false, "No such factions exist!" end
	
	if ply:InRaid() then return false end 

	fac:Join(ply, pw, force)

	ValidFactions()
end
PLAYER.JoinFaction = facs.JoinFac


hook.Add("PlayerDisconnected", "FactionDisband", function(ply)
	local fac = ply:GetFaction()
	if not fac then return end  

	fac.members[ply] = nil
	facs.Factions[ply] = nil
	for k,v in pairs(fac.memvals) do
		if v==ply then
			fac.memvals[k] = nil
			break
		end
	end

	if fac.owner == ply then 
		facs.RandomizeOwner(fac.name)
	end

	fac:Update()
	ValidFactions()
end)

net.Receive("Factions", function(_, ply)

	local mode = net.ReadUInt(4)
	if mode == 1 then 
		local name = net.ReadString()
		local pw = net.ReadString()
		local col = net.ReadColor()

		facs.CreateFac(ply, name, pw, col)
	elseif mode == 2 then 
		facs.LeaveFac(ply)
	elseif mode == 3 then 
		local ok = facs.JoinFac(ply, net.ReadString(), net.ReadString())

		if ok == false then 
			net.Start("Factions")
			net.WriteUInt(10, 4)
			net.Send(ply)
		end

	end

end)

hook.Add("PlayerInitialSpawn", "FactionNetwork", function(ply)
	ValidFactions()

	net.Start("Factions")
		net.WriteUInt(1, 4)
		net.WriteUInt(table.Count(facs.Factions), 16)
		for k,v in pairs(facs.Factions) do 
			net.WriteUInt(v.id, 24)
			net.WriteString(v.name)
			net.WriteColor(v.col)
			--net.WriteUInt(v.own:UserID(), 24)
			local haspw = false
			if v.pw then haspw = true end
			net.WriteBool(haspw)
		end
	net.Send(ply)

end)

ValidFactions()

net.Start("Factions")
	net.WriteUInt(1, 4)
	net.WriteUInt(table.Count(facs.Factions), 16)
	for k,v in pairs(facs.Factions) do 
		net.WriteUInt(v.id, 24)
		net.WriteString(v.name)
		net.WriteColor(v.col)
		--net.WriteUInt(v.own:UserID(), 24)

		local haspw = false
		if v.pw then haspw = true end
		net.WriteBool(haspw)
	end
net.Broadcast()

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

Factions = BaseWars.Factions 

for k,v in pairs(facs.Factions) do --update
	setmetatable(v, facmeta)
end