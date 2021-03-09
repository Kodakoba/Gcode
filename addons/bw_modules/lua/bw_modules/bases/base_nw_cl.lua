local bw = BaseWars.Bases

local zNW = bw.NW.Zones
local bNW = bw.NW.Bases

local nw = bw.NW

local bIDSZ = nw.SZ.base
local zIDSZ = nw.SZ.zone

LibItUp.OnInitEntity(function()
	nw.PlayerData = nw.PlayerData or Networkable("bw_bases_player" .. LocalPlayer():UserID())
	nw.PlayerData:Alias("CurrentZone", 1)
	nw.PlayerData:Alias("CurrentBase", 2)
end)

--[[-------------------------------------------------------------------------
	Networkable decoders
---------------------------------------------------------------------------]]

zNW:On("ReadChangeValue", "DecodeZones", function(self, zID)

	local yiss = net.ReadBool()

	if not yiss then
		local z = bw.Zones[zID]
		if z then z:Remove() end
		return nil, true
	end

	self.Networked.Zones = self.Networked.Zones or {}

	local mins, maxs = net.ReadVector(), net.ReadVector()
	local name = net.ReadCompressedString(bw.MaxZoneNameLength)

	local zone = bw.GetZone(zID) or bw.Zone(zID, mins, maxs) -- don't recreate a zone if we knew about it; just update it instead
	self.Networked.Zones[zID] = zone

	zone:SetName(name)
	zone:SetBounds(mins, maxs)

	return zone
end)

zNW:On("NetworkedChanged", "DecodedAll", function(self)
	zNW:Emit("ReadZones", self.Networked.Zones)
	bw:Emit("ReadZones")
end)

bNW.Yote = true
bNW:On("ReadChangeValue", "DecodeBases", function(self, key)
	local yiss = net.ReadBool()

	if not yiss then
		local z = bw.Zones[key]
		if z then z:Remove() end
		return nil, true
	end

	local base = bw.GetBase(key) or bw.Base(key)

	base:ReadNetwork()

	return base
end)

bNW:On("NetworkedChanged", "DecodedAll", function(self)
	bw:Emit("ReadBases")
end)

local PLAYER = FindMetaTable("Player")

function PLAYER:BW_GetBase()
	if self ~= LocalPlayer() then
		errorf("You can only get base of LocalPlayer! (tried to get %s's base)", self)
		return
	end

	local nw = nw.PlayerData
	if not nw then return end --???

	return bw.GetBase(nw:Get("CurrentBase"))
end

function PLAYER:BW_GetZone()
	if self ~= LocalPlayer() then
		errorf("You can only get zone of LocalPlayer! (tried to get %s's zone)", self)
		return
	end

	local nw = nw.PlayerData
	if not nw then return end --???

	return bw.GetZone( nw:Get("CurrentZone" ))
end

--[[-------------------------------------------------------------------------
	Basezone modify requests
---------------------------------------------------------------------------]]

function bw.RequestBaseCoreCreation(baseid)
	net.Start("BWBases")
		net.WriteUInt(nw.BASE_CORENEW, 4)
		local pr = net.StartPromise()
		net.WriteUInt(baseid, nw.SZ.base)
	net.SendToServer()

	return pr
end

function bw.RequestBaseCoreSave(baseid, eid)
	net.Start("BWBases")
		net.WriteUInt(nw.BASE_CORESAVE, 4)
		local pr = net.StartPromise()
		net.WriteUInt(baseid, nw.SZ.base)
		net.WriteUInt(eid, 16)
	net.SendToServer()

	return pr
end

function bw.RequestBaseCreation(name)
	net.Start("BWBases")
		net.WriteUInt(nw.BASE_NEW, 4)
		local pr = net.StartPromise()
		net.WriteString(name)
	net.SendToServer()

	return pr
end

function bw.RequestZoneYeet(zoneID)
	net.Start("BWBases")
		net.WriteUInt(nw.ZONE_YEET, 4)
		local pr = net.StartPromise()
		net.WriteUInt(zoneID, nw.SZ.zone)
	net.SendToServer()

	return pr
end

function bw.RequestBaseYeet(baseID)
	net.Start("BWBases")
		net.WriteUInt(nw.BASE_YEET, 4)
		local pr = net.StartPromise()
		net.WriteUInt(baseID, nw.SZ.base)
	net.SendToServer()

	return pr
end

function bw.RequestZoneCreation(name, baseID, mins, maxs)
	net.Start("BWBases")
		net.WriteUInt(nw.ZONE_NEW, 4)
		local pr = net.StartPromise()
		net.WriteUInt(baseID, nw.SZ.base)
		net.WriteString(name)
		net.WriteVector(mins)
		net.WriteVector(maxs)
	net.SendToServer()

	return pr
end

function bw.RequestZoneEdit(id, name, mins, maxs)
	if not id or not name or not mins or not maxs then
		errorf("missing argument #%d", (not id and 1) or (not name and 2) or (not mins and 3) or (not maxs and 4))
		return
	end

	net.Start("BWBases")
		net.WriteUInt(nw.ZONE_EDIT, 4)
		local pr = net.StartPromise()
		net.WriteUInt(id, nw.SZ.zone)
		net.WriteString(name)
		net.WriteVector(mins)
		net.WriteVector(maxs)
	net.SendToServer()

	return pr
end

function bw.RequestBaseEdit(id, name)
	if not id or not name then
		errorf("missing argument #%d", (not id and 1) or (not name and 2) or (not mins and 3) or (not maxs and 4))
		return
	end

	net.Start("BWBases")
		net.WriteUInt(nw.BASE_EDIT, 4)
		local pr = net.StartPromise()
		net.WriteUInt(id, nw.SZ.base)
		net.WriteString(name)
	net.SendToServer()

	return pr
end

net.Receive("BWBases", function()
	net.ReadPromise()
end)