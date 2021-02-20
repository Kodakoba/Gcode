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


local function createNewBase(ply)
	local pr = net.ReplyPromise(ply)
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

local function createNewZone(ply)
	local pr = net.ReplyPromise(ply)
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

local function editZone(ply)
	local pr = net.ReplyPromise(ply)
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

local function editBase(ply)
	local pr = net.ReplyPromise(ply)
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

local function yeetBase(ply)
	local pr = net.ReplyPromise(ply)
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

local function yeetZone(ply)
	local pr = net.ReplyPromise(ply)
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

net.Receive("BWBases", function(l, ply)
	local mode = net.ReadUInt(4)

	if mode == bw.NW.BASE_NEW then
		createNewBase(ply)
	elseif mode == bw.NW.BASE_EDIT then
		editBase(ply)
	elseif mode == bw.NW.ZONE_EDIT then
		editZone(ply)
	elseif mode == bw.NW.ZONE_NEW then
		createNewZone(ply)
	elseif mode == bw.NW.ZONE_YEET then
		yeetZone(ply)
	elseif mode == bw.NW.BASE_YEET then
		yeetBase(ply)
	else
		print("Unhandled BWBases action:", mode, ply)
	end

end)