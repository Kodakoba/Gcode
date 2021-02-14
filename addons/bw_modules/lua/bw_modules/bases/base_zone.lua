local bw = BaseWars.Bases

bw.CanModify = function(ply)
	return ply:IsAdmin()
end

bw.MaxBaseNameLength = 120
bw.MinBaseNameLength = 2

bw.MaxZoneNameLength = 120
-- zones don't have a minimum name requirement; they can be unnamed

bw.Base = bw.Base or Emitter:callable()
bw.Zone = bw.Zone or Emitter:callable()

ChainAccessor(bw.Base, "ID", "ID")
ChainAccessor(bw.Zone, "ID", "ID")

function bw.GetZone(id)
	if isnumber(id) then
		return BaseWars.Bases.Bases[id]
	else
		for k,v in pairs(BaseWars.Bases.Bases) do
			if v:GetName() == id then
				return v
			end
		end
	end
end

function bw.Zone:GetBounds()
	return self.Mins, self.Maxs
end

function bw.Zone:Initialize(id, mins, maxs)
	CheckArg(1, id, isnumber, "zone ID")
	CheckArg(2, mins, isvector, "zone mins")
	CheckArg(3, maxs, isvector, "zone maxs")

	self.ID = id
	OrderVectors(mins, maxs)
	self.Mins, self.Maxs = mins, maxs
	self.Name = "-unnamed zone-"

	if BaseWars.Bases.Zones[id] then
		local oldZone = BaseWars.Bases.Zones[id]
		local base = oldZone:GetBase()
		if base then
			base:AddZone(self)
		end
	end
	
	BaseWars.Bases.Zones[id] = self

	if SERVER then
		self.Brush = ents.Create("bw_zone_brush")

		if not self.Brush:IsValid() then
			ErrorNoHalt("Failed to create a zone brush entity.\n")
			return
		end

		self.Brush:SetZone(self)
	end
end

ChainAccessor(bw.Zone, "Name", "Name")

function bw.IsZone(what)
	return getmetatable(what) == bw.Zone
end

function bw.Zone:Remove(baseless)
	if SERVER then
		self.Brush:Remove()
	end

	if not baseless then
		self:GetBase():RemoveZone(self)
	end
end

function bw.Zone:GetBase()
	return BaseWars.Bases.Bases[self.BaseID]
end

function bw.Base:Initialize(id)
	CheckArg(1, id, isnumber, "base ID")

	self.ID = id

	self.Zones = {}			-- sequential table of zones
	self.ZonesByID = {}		-- [zone_id] = zone_obj

	self.Players = {}
	self.Name = "-unnamed base-"

	BaseWars.Bases.Bases[id] = self
	print("yes adding", id)
end

ChainAccessor(bw.Base, "Zones", "Zones")
ChainAccessor(bw.Base, "Name", "Name")

-- SV
function bw.Base:AddToNW()
	bw.NW.Bases:Set(self:GetID(), self)
end

function bw.Base:RemoveZone(zone)
	table.RemoveByValue(self.Zones, zone)
	self.ZonesByID[zone.ID] = nil
end

function bw.Base:AddZone(zone)
	if isnumber(zone) then zone = bw.Zones[zone] end
	CheckArg(1, zone, bw.IsZone, "bwzone")

	zone.BaseID = self.ID

	local old = self.ZonesByID[zone.ID]
	if old and old ~= zone then
		old:Remove(true)
		table.ReplaceValue(self.Zones, old, zone, true)
	elseif not old then
		self.Zones[#self.Zones + 1] = zone
	end

	self.ZonesByID[zone.ID] = zone
end

-- CL
function bw.Base:ReadNetwork()
	self.ZoneQueue = self.ZoneQueue or {}
	local zq = self.ZoneQueue

	local name = net.ReadCompressedString(bw.MaxBaseNameLength)
	self:SetName(name)
	
	local zones = net.ReadUInt(8)

	for z=1, zones do
		local zID = net.ReadUInt(12)

		if not bw.Zones[zID] then

			local eid = ("wait:%d:%d"):format(self:GetID(), zID)
			bw.NW.Zones:On("ReadZones", eid, function(nw, zones)
				if zones[zID] then
					self:AddZone(zones[zID])
					bw.NW.Zones:RemoveListener("ReadZones", eid)
				end
			end)

		else
			self:AddZone(zID)
		end
	end
end

function bw.IsBase(what)
	return getmetatable(what) == bw.Base
end

if CLIENT then
	-- server includes it in base_sql_sv.lua
	include("areamark/_init.lua")
end