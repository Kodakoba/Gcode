local bw = BaseWars

bw.Base = bw.Base or Emitter:callable()
bw.Zone = bw.Zone or Emitter:callable()

ChainAccessor(bw.Base, "ID", "ID")
ChainAccessor(bw.Zone, "ID", "ID")

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

	self.Brush = ents.Create("bw_zone_brush")

	if not self.Brush:IsValid() then
		ErrorNoHalt("Failed to create a zone brush entity.\n")
		return
	end

	self.Brush:SetZone(self)
end

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
	return bw.Bases[self.BaseID]
end

function bw.Base:Initialize(id)
	CheckArg(1, id, isnumber, "base ID")

	self.ID = id

	self.Zones = {}			-- sequential table of zones
	self.ZonesByID = {}		-- [zone_id] = zone_obj

	self.Players = {}

	bw.Bases.Bases[id] = self
end


function bw.Base:RemoveZone(zone)
	table.RemoveByValue(self.Zones, zone)
	self.ZonesByID[zone.ID] = nil
end

function bw.Base:AddZone(zone)
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

function bw.IsBase(what)
	return getmetatable(what) == bw.Bases.Base
end

if CLIENT then
	-- server includes it in base_sql_sv.lua
	include("areamark/_init.lua")
end