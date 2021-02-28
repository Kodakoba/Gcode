util.AddNetworkString("BWBases")

local bw = BaseWars.Bases
local nw = bw.NW

local zNW = bw.NW.Zones
local bNW = bw.NW.Bases

local bIDSZ = 12
local zIDSZ = 12

zNW:On("WriteChangeValue", "EncodeZones", function(self, key, zone, plys) -- changes, ...)
	--[[local write = {}

	net.WriteUInt(table.Count(changes), 16)
	for zID, zone in pairs(changes) do]]
	if bw.IsZone(zone) then
		net.WriteBool(true)
		--net.WriteUInt(zID, 12)
		local mins, maxs = zone:GetBounds()
		net.WriteVector(mins)
		net.WriteVector(maxs)
		net.WriteCompressedString(zone:GetName(), bw.MaxZoneNameLength)
	else
		net.WriteBool(false)
	end
	--end

	return false
end)

bNW:On("WriteChangeValue", "EncodeZones", function(self, key, base, plys) -- changes, ...)

	if bw.IsBase(base) then
		net.WriteBool(true)

		net.WriteCompressedString(base:GetName(), bw.MaxBaseNameLength + 1)
		net.WriteUInt(#base:GetZones(), 8)

		for k,v in ipairs(base:GetZones()) do
			net.WriteUInt(v:GetID(), 12)
		end
	else
		net.WriteBool(false)
	end

	return false
end)


-- adding to NW will proc a networkable update automatically

function bw.Base:AddToNW()
	bw.NW.Bases:Set(self:GetID(), self)
end

function bw.Zone:AddToNW()
	bw.NW.Zones:Set(self:GetID(), self)
end


local function createNewBase(ply, pr)
	local ns = netstack:new()
	if not bw.CanModify(ply) then
		ns:WriteCompressedString("no permissions")
		pr:ReplySend("BWBases", false, ns)
		return
	end

	local name = net.ReadString()

	local a, err = bw.SQL.CreateBase(name)
	
	if err then
		ns:WriteCompressedString(err)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	a:Then(function(_, q)
		ns:WriteUInt(q:lastInsert(), bIDSZ)
		pr:ReplySend("BWBases", true, ns)
	end, function(_, why)
		ns:WriteCompressedString("query failed:\n" .. why)
		pr:ReplySend("BWBases", false, ns)
	end)
end

local function createNewZone(ply, pr)
	local ns = netstack:new()
	if not bw.CanModify(ply) then
		ns:WriteCompressedString("no permissions")
		pr:ReplySend("BWBases", false, ns)
		return
	end

	local baseID = net.ReadUInt(nw.SZ.base)
	local name = net.ReadString()
	local mins, maxs = net.ReadVector(), net.ReadVector()

	local a, err = bw.SQL.CreateZone(name, baseID, mins, maxs)
	
	if err then
		ns:WriteCompressedString(err)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	a:Then(function(_, q)
		ns:WriteUInt(q:lastInsert(), nw.SZ.zone)
		pr:ReplySend("BWBases", true, ns)
	end, function(_, why)
		ns:WriteCompressedString("query failed:\n" .. why)
		pr:ReplySend("BWBases", false, ns)
	end)
end

local function editZone(ply, pr)
	local ns = netstack:new()

	if not bw.CanModify(ply) then
		ns:WriteCompressedString("no permissions")
		pr:ReplySend("BWBases", false, ns)
		return
	end

	local zoneID = net.ReadUInt(nw.SZ.zone)
	local name = net.ReadString()
	local mins, maxs = net.ReadVector(), net.ReadVector()

	local zone = bw.GetZone(zoneID)
	if not zone then
		ns:WriteCompressedString("didn't find zone with ID " .. zoneID)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	local a, err = bw.SQL.EditZone(zoneID, name, mins, maxs)

	if err then
		ns:WriteCompressedString(err)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	a:Then(function(_, q)
		pr:ReplySend("BWBases", true, ns)
		zone:SetBounds(mins, maxs)
		zone:SetName(name)
	end, function(_, why)
		ns:WriteCompressedString("query failed:\n" .. why)
		pr:ReplySend("BWBases", false, ns)
	end)
end

local function editBase(ply, pr)
	local ns = netstack:new()

	if not bw.CanModify(ply) then
		ns:WriteCompressedString("no permissions")
		pr:ReplySend("BWBases", false, ns)
		return
	end

	local baseID = net.ReadUInt(nw.SZ.base)
	local name = net.ReadString()

	local base = bw.GetBase(baseID)
	if not base then
		ns:WriteCompressedString("didn't find base with ID " .. zoneID)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	local a, err = bw.SQL.EditBase(baseID, name)

	if err then
		ns:WriteCompressedString(err)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	a:Then(function(_, q)
		pr:ReplySend("BWBases", true, ns)
		base:SetName(name)
		base:AddToNW()
	end, function(_, why)
		ns:WriteCompressedString("query failed:\n" .. why)
		pr:ReplySend("BWBases", false, ns)
	end)
end

local function yeetBase(ply, pr)
	local ns = netstack:new()

	if not bw.CanModify(ply) then
		ns:WriteCompressedString("no permissions")
		pr:ReplySend("BWBases", false, ns)
		return
	end

	local ID = net.ReadUInt(nw.SZ.base)
	local base = bw.GetBase(ID)

	if not base then
		ns:WriteCompressedString("didn't find base with ID " .. ID)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	local a, err = bw.SQL.YeetBase(ID)

	if err then
		ns:WriteCompressedString(err)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	a:Then(function(_, q)
		pr:ReplySend("BWBases", true, ns)
	end, function(_, why)
		ns:WriteCompressedString("query failed:\n" .. why)
		pr:ReplySend("BWBases", false, ns)
	end)
end

local function yeetZone(ply, pr)
	local ns = netstack:new()

	if not bw.CanModify(ply) then
		ns:WriteCompressedString("no permissions")
		pr:ReplySend("BWBases", false, ns)
		return
	end

	local ID = net.ReadUInt(nw.SZ.zone)
	local zone = bw.GetZone(ID)

	if not zone then
		ns:WriteCompressedString("didn't find zone with ID " .. ID)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	local a, err = bw.SQL.YeetZone(ID)

	if err then
		ns:WriteCompressedString(err)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	a:Then(function(_, q)
		pr:ReplySend("BWBases", true, ns)
	end, function(_, why)
		ns:WriteCompressedString("query failed:\n" .. why)
		pr:ReplySend("BWBases", false, ns)
	end)
end

local function spawnCore(ply, pr)
	local ns = netstack:new()

	if not bw.CanModify(ply) then
		ns:WriteCompressedString("no permissions")
		pr:ReplySend("BWBases", false, ns)
		return
	end

	local ID = net.ReadUInt(nw.SZ.base)
	local base = bw.GetBase(ID)

	if not base then
		ns:WriteCompressedString("didn't find base with ID " .. ID)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	-- jesus
	local baseCore = scripted_ents.GetStored("bw_basecore")
	if not baseCore or not baseCore.t or not baseCore.t.Model then
		ns:WriteCompressedString("didn't find basecore entity/model somehow...?")
		pr:ReplySend("BWBases", false, ns)
		return
	end

	print( baseCore.Model )
	local ok, ent = pcall(DoPlayerEntitySpawn, ply, "prop_physics", baseCore.t.Model, 0)

	if not ok then
		ns:WriteCompressedString("error while spawning: " .. ent)
		pr:ReplySend("BWBases", false, ns)
		return
	elseif not ent:IsValid() then
		ns:WriteCompressedString("spawned prop wasn't valid, somehow...")
		pr:ReplySend("BWBases", false, ns)
		return
	end

	ns:WriteUInt(ent:EntIndex(), 16)
	pr:ReplySend("BWBases", true, ns)
end

local function saveCore(ply, pr)
	local ns = netstack:new()

	if not bw.CanModify(ply) then
		ns:WriteCompressedString("no permissions")
		pr:ReplySend("BWBases", false, ns)
		return
	end

	local ID = net.ReadUInt(nw.SZ.base)
	local base = bw.GetBase(ID)

	if not base then
		ns:WriteCompressedString("didn't find base with ID " .. ID)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	local eid = net.ReadUInt(16)
	local ent = Entity(eid)
	if not IsValid(ent) then
		ns:WriteCompressedString("didn't find entity with EntIndex " .. eid)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	base:GetData().BaseCore = {
		pos = ent:GetPos(),
		ang = ent:GetAngles(),
		mdl = ent:GetModel()
	}

	local json = util.TableToJSON(base:GetData())
	local a, err = bw.SQL.SaveData(ID, json)

	if err then
		ns:WriteCompressedString(err)
		pr:ReplySend("BWBases", false, ns)
		return
	end

	a:Then(function(_, q)
		pr:ReplySend("BWBases", true, ns)
		ent:Remove()
		base:SpawnCore()
	end, function(_, why)
		ns:WriteCompressedString("query failed:\n" .. why)
		pr:ReplySend("BWBases", false, ns)
	end)
end

local function DetermineAction(mode, ply, pr)

	if mode == bw.NW.BASE_NEW then
		createNewBase(ply, pr)
	elseif mode == bw.NW.BASE_EDIT then
		editBase(ply, pr)
	elseif mode == bw.NW.ZONE_EDIT then
		editZone(ply, pr)
	elseif mode == bw.NW.ZONE_NEW then
		createNewZone(ply, pr)
	elseif mode == bw.NW.ZONE_YEET then
		yeetZone(ply, pr)
	elseif mode == bw.NW.BASE_YEET then
		yeetBase(ply, pr)
	elseif mode == bw.NW.BASE_CORENEW then
		spawnCore(ply, pr)
	elseif mode == bw.NW.BASE_CORESAVE then
		saveCore(ply, pr)
	else
		print("Unhandled BWBases action:", mode, ply)
		local ns = netstack:new()
		ns:WriteCompressedString("Unhandled action.")
		pr:ReplySend("BWBases", false, ns)
	end

end

net.Receive("BWBases", function(l, ply)
	local mode = net.ReadUInt(4)
	local pr = net.ReplyPromise(ply)

	local ok, err = pcall(DetermineAction, mode, ply, pr)
	if not ok then
		ns:WriteCompressedString("Error!")
		pr:ReplySend("BWBases", false, ns)
		return false
	end
end)

local function initNW(ply)
	if bw.NW.PlayerData[ply] then return end

	bw.NW.PlayerData[ply] = Networkable("bw_bases_player" .. ply:UserID())
	local nw = bw.NW.PlayerData[ply]
	nw:Bind(ply)
	nw:Alias("CurrentZone", 1)
	nw:Alias("CurrentBase", 2)

	nw.Filter = function(self, p2)
		return ply == p2
	end
end

nw.InitPlayerNW = initNW

function bw.GetPlayerNW(ply)
	return bw.NW.PlayerData[ply]
end

hook.Add("PlayerInitialSpawn", "InitBaseNWPlayerData", function(ply)
	initNW(ply)
end)

for k,v in ipairs(player.GetAll()) do
	initNW(v)
end