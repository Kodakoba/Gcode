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
	self.Mins, self.Maxs = OrderVectors(mins, maxs)

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

function bw.Zone:Remove()
	self.Brush:Remove()
end

function bw.Zone:GetBase()
	return bw.Bases[self.BaseID]
end

function bw.Base:Initialize(id)
	CheckArg(1, id, isnumber, "base ID")

	self.ID = id

	self.Zones = {}
	self.ZonesByID = {}

	self.Players = {}

	bw.Bases.Bases[id] = self
end



function bw.Base:AddZone(zone)
	CheckArg(1, zone, bw.IsZone, "bwzone")

	zone.BaseID = self.ID

	local old = self.ZonesByID[zone.ID]
	if old and old ~= zone then
		old:Remove()
		table.ReplaceValue(self.Zones, old, zone, true)
	end

	self.Zones[zone.ID] = zone
end

function bw.IsBase(what)
	return getmetatable(what) == bw.Bases.Base
end