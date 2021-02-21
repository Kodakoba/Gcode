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

function bw.Zone:__tostring()
	return ("BWZone [%d][%s]"):format(self:GetID(), self:GetName())
end

function bw.Base:__tostring()
	return ("BWBase [%d][%s]"):format(self:GetID(), self:GetName())
end

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

	OrderVectors(mins, maxs)

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

function bw.Zone:_Validate()
	local id = self:GetID()
	if id < 0 then return false, "ID" end

	local mins, maxs = self:GetBounds()
	if not mins or not maxs then return false, "Bounds" end

	if BaseWars.Bases.Zones[id] then
		local oldZone = BaseWars.Bases.Zones[id]
		local base = oldZone:GetBase()

		if base then
			base:AddZone(self)
		end

		oldZone:Remove()
	end

	BaseWars.Bases.Zones[id] = self
	self._Valid = true
	
	return true
end

function bw.Zone:Validate(optional)
	local ok, why = self:_Validate()

	self._Valid = ok
	if not ok and not optional then
		errorf("bw.Zone:Validate() : %s were incorrect.", why)
		return
	end

end

function bw.Zone:Initialize(id, mins, maxs)
	CheckArg(1, id, isnumber, "zone ID")

	local valid = id >= 0
	-- use an id < 0 to create a fake zone
	if valid then
		CheckArg(2, mins, isvector, "zone mins")
		CheckArg(3, maxs, isvector, "zone maxs")
	end

	self:SetID(id)

	if valid then
		OrderVectors(mins, maxs)
		self:SetBounds(mins, maxs)
	end

	self._ShouldPaint = false
	self._Name = ""
	self._Alpha = 0
	self:SetColor( self.DefaultColor:Copy() )

	self:Validate(CLIENT)

	self.Players = {}
	self.Entities = {}
	
	if SERVER and valid then
		self.Brush = ents.Create("bw_zone_brush")

		if not self.Brush:IsValid() then
			ErrorNoHalt("Failed to create a zone brush entity.\n")
			return
		end

		self.Brush:SetZone(self)
		self.Brush:Activate()
		self.Brush:Spawn()

	end
end

function bw.Zone:Remove(baseless)
	if not self._Valid then return end

	if SERVER and self.Brush:IsValid() then
		self.Brush:Remove()
	end

	if not baseless then
		self:GetBase():RemoveZone(self)
	end

	BaseWars.Bases.Zones[self:GetID()] = nil
	bw.ZonePaints[self:GetID()] = nil

	self._Valid = false
	self:Emit("Remove")
	bw:Emit("DeleteZone", self)
end

ChainAccessor(bw.Zone, "_Name", "Name")
ChainAccessor(bw.Zone, "_Color", "Color")
ChainAccessor(bw.Zone, "_Alpha", "Alpha")

function bw.Zone:IsValid()
	return self._Valid
end

function bw.Zone:GetBase()
	if not self.BaseID then return false end
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
	self.Entities = {}

	self.Name = "-unnamed base-"
	self._Valid = true

	if BaseWars.Bases.Bases[id] then
		BaseWars.Bases.Bases[id]:Remove(true)
	end

	BaseWars.Bases.Bases[id] = self
end

function bw.Base:Remove(replaced)
	self._Valid = false

	if not replaced then
		for k,v in ipairs(self.Zones) do
			v:Remove(true)
		end
	end

	BaseWars.Bases.Bases[self:GetID()] = nil
	bw.NW.Bases:Set(self:GetID(), nil)

	self:Emit("Remove")
	bw:Emit("DeleteBase", self)
end

ChainAccessor(bw.Base, "Zones", "Zones")
ChainAccessor(bw.Base, "Name", "Name")

function bw.Zone:IsValid()
	return self._Valid
end

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