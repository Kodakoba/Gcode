local bw = BaseWars.Bases

bw.CanModify = function(ply)
	return ply:IsAdmin()
end

bw.MaxBaseNameLength = 120
bw.MinBaseNameLength = 2

bw.MaxZoneNameLength = 120
-- zones don't have a minimum name requirement; they can be unnamed

ChainAccessor(bw.Base, "ID", "ID")
ChainAccessor(bw.Zone, "ID", "ID")


--[[-------------------------------------------------------------------------
	Zone object
---------------------------------------------------------------------------]]

function bw.Zone:GetBounds()
	return self._Mins, self._Maxs
end

function bw.Zone:GetCenter()
	return self._Center
end

function bw.Zone:SetBounds(mins, maxs)
	CheckArg(1, mins, isvector, "zone mins")
	CheckArg(2, maxs, isvector, "zone maxs")

	local prevMin, prevMax = self._Mins, self._Maxs
	self._Mins, self._Maxs = mins, maxs

	self._Center = (mins + maxs)
	self._Center:Mul(0.5)

	self:Emit("BoundsChanged", prevMin, prevMax)
	return self
end

bw.Zone.DefaultColor = Color(91, 151, 147)
bw.Zone.PreviewColor = Color(243, 255, 78)

ChainAccessor(bw.Zone, "DefaultColor", "DefaultColor")

function bw.Zone:SetDefaultColor(col)
	if self.Color == self.DefaultColor then
		self.Color = col:Copy()
	end

	self.DefaultColor:Set(col)
end

function bw.Zone:Initialize(id, mins, maxs)
	CheckArg(1, id, isnumber, "zone ID")
	CheckArg(2, mins, isvector, "zone mins")
	CheckArg(3, maxs, isvector, "zone maxs")

	self:SetID(id)

	OrderVectors(mins, maxs)
	self:SetBounds(mins, maxs)

	self._ShouldPaint = false
	self._Name = ""
	self._Alpha = 0
	self:SetColor( self.DefaultColor:Copy() )

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

function bw.Zone:Remove(baseless)
	if SERVER then
		self.Brush:Remove()
	end

	if not baseless then
		self:GetBase():RemoveZone(self)
	end

	BaseWars.Bases.Zones[self:GetID()] = nil
	bw.ZonePaints[self:GetID()] = nil
end

ChainAccessor(bw.Zone, "_Name", "Name")
ChainAccessor(bw.Zone, "_Color", "Color")
ChainAccessor(bw.Zone, "_Alpha", "Alpha")

function bw.Zone:GetBase()
	return BaseWars.Bases.Bases[self.BaseID]
end



--[[-------------------------------------------------------------------------
	Base object
---------------------------------------------------------------------------]]

function bw.Base:Initialize(id)
	CheckArg(1, id, isnumber, "base ID")

	self.ID = id

	self.Zones = {}			-- sequential table of zones
	self.ZonesByID = {}		-- [zone_id] = zone_obj

	self.Players = {}
	self.Name = "-unnamed base-"

	BaseWars.Bases.Bases[id] = self
end

function bw.Base:Remove()
	BaseWars.Bases.Bases[self:GetID()] = nil
	bw.NW.Bases:Set(self:GetID(), nil)
end

ChainAccessor(bw.Base, "Zones", "Zones")
ChainAccessor(bw.Base, "Name", "Name")


function bw.Base:RemoveZone(zone)
	table.RemoveByValue(self.Zones, zone)
	self.ZonesByID[zone:GetID()] = nil
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


-- CL only

function bw.Base:ReadNetwork()
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

--[[-------------------------------------------------------------------------
	Utils
---------------------------------------------------------------------------]]

function bw.GetBase(id)
	if isnumber(id) then
		return BaseWars.Bases.Bases[id]
	elseif bw.IsBase(id) then
		return id
	else
		for k,v in pairs(BaseWars.Bases.Bases) do
			if v:GetName() == id then
				return v
			end
		end
	end
end

function bw.GetZone(id)
	return BaseWars.Bases.Zones[id]
end

function bw.IsBase(what)
	return getmetatable(what) == bw.Base
end

function bw.IsZone(what)
	return getmetatable(what) == bw.Zone
end





if CLIENT then
	-- server includes it in base_sql_sv.lua
	include("areamark/_init.lua")
end