local tag = "BaseWars.Factions"

Factions = Factions or {}

Factions.Factions = Factions.Factions or {}
Factions.FactionIDs = Factions.FactionIDs or {}

local facs = Factions

Factions.meta = Factions.meta or Networkable:extend()
local facmeta = Factions.meta
facmeta.IsFaction = true

function IsFaction(t)
	local meta = getmetatable(t)

	return meta and meta.IsFaction
end

function facmeta:Initialize(id, name, col, haspw)
	local new = self:SetNetworkableID("Faction:" .. id)
	if new then self = new end

	self.id = id
	self.name = name
	self.col = col
	self.haspw = haspw

	self:On("NetworkedVarChanged", "TrackMembers", function(_, key, old, new)
		print("trackmembers: wtf is", _, _ == self)

		if key == "Members" then
			self:RunPlayerHooks(old, new)
			return
		end

		if key == "Leader" then
			hook.Run("FactionChangedLeader", self, old, new)
			return
		end
	end)

	self:On("NetworkedChanged", function()
		hook.Run("FactionsUpdate", self)
	end)

	return new
end

function facmeta:RunPlayerHooks(old, new)
	-- calculate who left & who joined
	local old_plys = {}

	for k, ply in ipairs(old) do
		old_plys[ply] = true
	end

	for k, ply in ipairs(new) do
		if not old_plys[ply] then hook.Run("FactionJoinedPlayer", self, ply) end
		old_plys[ply] = nil
	end

	for left_ply, _ in pairs(old_plys) do
		hook.Run("FactionLeftPlayer", self, left_ply)
	end
end

function facmeta:InRaid()
	return self:Get("Raided") or self:Get("Raider")
end

function facmeta:GetMembers()
	return self:Get("Members")
end

function facmeta:GetLeader()
	return self:Get("Leader")
end


function facmeta:GetName()
	return self.name
end

function facmeta:GetColor()
	return self.col
end

function facmeta:HasPassword()
	return self.pw or false
end

function facmeta:GetID()
	return self.id
end

local PLAYER = debug.getregistry().Player

net.Receive("Factions", function(len)

	local type = net.ReadUInt(4)

	print(('CL: Factions: Type %s; size: %s bytes'):format(type, len/8))

	if type == 1 then -- full update

		facs.Factions = {}

		local amt = net.ReadUInt(16)

		for i=1, amt do
			local id = net.ReadUInt(24)
			local name = net.ReadString()
			local col = net.ReadColor()

			local haspw = net.ReadBool()

			team.SetUp(id, name, col, false)

			local fac = facmeta:new(id, name, col, haspw)
			facs.Factions[name] = fac
			facs.FactionIDs[id] = fac

			--[[facs.Factions[name] = {id = id, name = name, col = col, own = lead, pw = haspw}
			facs.FactionIDs[id] = {id = id, name = name, col = col, own = lead, pw = haspw}]]
		end

	elseif type==2 then -- update

		local id = net.ReadUInt(24)
		local name = net.ReadString()
		local col = net.ReadColor()

		local haspw = net.ReadBool()

		team.SetUp(id, name, col, false)

		print("created new faction:", id, name)

		local fac = facmeta:new(id, name, col, haspw)
		facs.Factions[name] = fac
		facs.FactionIDs[id] = fac

	elseif type==3 then

		local id = net.ReadUInt(24)
		print("deleting faction #" .. id)
		for k,v in pairs(facs.Factions) do
			if v.id and v.id==id then
				v:Invalidate()
				facs.Factions[k] = nil
				facs.FactionIDs[id] = nil
				break
			end
		end

	end

	if type==10 then
		if FacErrorReceiver then FacErrorReceiver() end
		return
	end
	hook.Run("FactionsUpdate")
end)

function GetFactions()
	return Factions.Factions
end

function PLAYER:InFaction(ply2)
	local fac = Factions.FactionIDs[self:Team()]

	if not ply2 then
		if fac then return fac.name else return false end
	elseif IsPlayer(ply2) then
		local fac2 = Factions.FactionIDs[ply2:Team()]
		if self:Team()~=1 and fac==fac2 then
			return fac.name
		else
			return false
		end
	elseif isnumber(ply2) then
		return self:Team() == ply2
	end
	return false --???
end

function Factions.RequestCreate(name, pw, col)
	if not Factions.CanCreate(name, pw, col, LocalPlayer()) then return false end

	net.Start("Factions")
		net.WriteUInt(1, 4) -- 'create'
		net.WriteString(name)
		net.WriteString(pw)
		net.WriteColor(col)
	net.SendToServer()

end