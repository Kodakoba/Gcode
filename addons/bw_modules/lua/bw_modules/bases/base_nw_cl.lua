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
		return
	end

	self.Networked.Zones = self.Networked.Zones or {}

	local mins, maxs = net.ReadVector(), net.ReadVector()
	local name = net.ReadCompressedString(bw.MaxZoneNameLength)

	local zone = bw.GetZone(zID) or bw.Zone(zID, mins, maxs) -- don't recreate a zone if we knew about it; just update it instead
	self.Networked.Zones[zID] = zone

	zone:SetName(name)
	zone:SetBounds(mins, maxs)

	return true
end)

zNW:On("NetworkedChanged", "DecodedAll", function(self)
	zNW:Emit("ReadZones", self.Networked.Zones)
	bw:Emit("ReadZones")
end)

bNW:On("ReadChangeValue", "DecodeBases", function(self, key)
	local yiss = net.ReadBool()
	
	if not yiss then
		local z = bw.Zones[key]
		if z then z:Remove() end
		return
	end

	local base = bw.GetBase(key) or bw.Base(key)
	base:ReadNetwork()

	return true
end)

bNW:On("NetworkedChanged", "DecodedAll", function(self)
	bw:Emit("ReadBases")
end)


--[[-------------------------------------------------------------------------
	Basezone modify requests
---------------------------------------------------------------------------]]

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

local baseCol = color_white:Copy()
local zoneCol = color_white:Copy()

local baseFontH = 32

local bdt = DeltaText():SetFont("MR" .. baseFontH)
local zdt = DeltaText():SetFont("MR24")

local baseToID = {
	-- [id] = elem_num
}

local zToID = {
	-- [id] = elem_num
}

local an = Animatable("bases")
an.BaseFrac = 0
an.ZoneFrac = 0

local function appear(z)
	an:To("BaseFrac", 1, 0.4, 0, 0.3)
	an:To("ZoneFrac", 1, 0.3, 0.3, 0.3)
end

local function disappear()
	an:To("BaseFrac", 0, 0.25, 0.15, 2)
	an:To("ZoneFrac", 0, 0.25, 0, 3)
	bdt:DisappearCurrentElement()
end

local function think()
	baseCol.a = an.BaseFrac
	zoneCol.a = an.ZoneFrac
end

local lastBaseName = ""



hook.Add("HUDPaint", "bas", function()
	think()

	local nw = nw.PlayerData

	if not nw:Get("CurrentBase") then
		disappear()
	else

		local base = bw.GetBase(nw:Get("CurrentBase"))
		if not base then print("Didn't find base with ID", nw:Get("CurrentBase")) disappear() return end

		local frag = baseToID[base:GetID()]

		if not frag then
			local piece, key = bdt:AddText(base:GetName())
			piece.Color = baseCol
			baseToID[base:GetID()] = key
		else
			frag = bdt:ActivateElement(frag)
		end
	end

	bdt:Paint(8, ScrH() * 0.3)
	zdt:Paint(8, ScrH() * 0.3 + baseFontH)
	--appear()
	--draw.SimpleText(base:GetName(), "OS32", 8, ScrH() * 0.3, color_white, 0, 5)
end)