util.AddNetworkString("BWBases")

local bw = BaseWars.Bases
local nw = bw.NW

local zNW = bw.NW.Zones
local bNW = bw.NW.Bases
local adNW = bw.NW.Admin

local bIDSZ = 12
local zIDSZ = 12

zNW:On("CustomWriteChanges", "EncodeZones", function(self, changes, ...)
	local write = {}

	net.WriteUInt(table.Count(changes), 16)
	for zID, zone in pairs(changes) do
		net.WriteUInt(zID, 12)
		net.WriteVector(zone.Mins)
		net.WriteVector(zone.Maxs)
		net.WriteCompressedString(zone:GetName(), bw.MaxZoneNameLength)
	end

	return true
end)

bNW:On("CustomWriteChanges", "EncodeZones", function(self, changes, ...)
	local write = {}

	net.WriteUInt(table.Count(changes), 16)
	for bNW, base in pairs(changes) do
		net.WriteUInt(base:GetID(), 12)
		net.WriteCompressedString(base:GetName(), bw.MaxBaseNameLength + 1)
		net.WriteUInt(#base:GetZones(), 8)
		for k,v in ipairs(base:GetZones()) do
			net.WriteUInt(v:GetID(), 12)
		end
	end

	return true
end)

adNW.Filter = function(self, ply)
	return bw.CanModify(ply)
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

	local name = net.ReadString()
	local baseID = net.ReadUInt(nw.SZ.zone)
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

	if true then
		ns:WriteCompressedString("not implemented (yet)")
		pr:ReplySend("BWBases", false, ns)
		return
	end

	--[[local a, err = bw.SQL.CreateBase(name)
	
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
	end)]]
end

net.Receive("BWBases", function(l, ply)
	local mode = net.ReadUInt(4)

	if mode == bw.NW.BASE_NEW then
		createNewBase(ply)
	elseif mode == bw.NW.ZONE_EDIT then
		editZone(ply)
	else
		print("Unhandled BWBases action:", mode, ply)
	end

end)