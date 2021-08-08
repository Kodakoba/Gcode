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

ChainAccessor(bw.Base, "Data", "Data")
ChainAccessor(bw.Zone, "Data", "Data")

function bw.Zone:__tostring()
	return ("BWZone [%d][%s]"):format(self:GetID(), self:GetName())
end

function bw.Base:__tostring()
	return ("BWBase [%d][%s]"):format(self:GetID(), self:GetName())
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

function LibItUp.PlayerInfo:GetBase(no_owner_check)
	local fac = self:GetFaction()
	if fac then
		return fac:GetBase()
	end

	local base = self._Base
	if not base or not base:IsValid() then return false end

	if not no_owner_check and not base:IsOwner(self) then
		errorf("Something went wrong: %s has base set as %s, but player doesn't own it.", self, base)
		return false
	end

	return base
end

-- this only gets the base if the player is the sole owner of it
function LibItUp.PlayerInfo:GetPlayerBase(no_owner_check)
	local base = self._Base
	if not base or not base:IsValid() then return false end

	if not no_owner_check and not base:IsOwner(self) then
		errorf("Something went wrong: %s has base set as %s, but player doesn't own it.", self, base)
		return false
	end

	return base
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

function bw.Zone:SpawnBrush()
	self:_CheckValidity()

	self.Brush = ents.Create("bw_zone_brush")

	if not self.Brush:IsValid() then
		ErrorNoHalt("Failed to create a zone brush entity.\n")
		return
	end

	self.Brush:SetZone(self)
	self.Brush:Activate()
	self.Brush:Spawn()
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

	self.Data = {}
	self._ShouldPaint = false
	self._Name = ""
	self._Alpha = 0
	self:SetColor( self.DefaultColor:Copy() )

	self:Validate(CLIENT)

	self.Players = {}
	self.Entities = {}

	if SERVER and valid then
		self:SpawnBrush()
	end
end

function bw.Zone:Remove(baseless)
	if not self:IsValid() then return end

	-- call remove first, then invalidate
	self:Emit("Remove")
	bw:Emit("DeleteZone", self)

	if SERVER and self.Brush:IsValid() then
		self.Brush:Remove()
	end

	if not baseless and self:GetBase() then
		self:GetBase():RemoveZone(self)
	end

	BaseWars.Bases.Zones[self:GetID()] = nil
	bw.ZonePaints[self:GetID()] = nil

	self._Valid = false
end

ChainAccessor(bw.Zone, "_Name", "Name")
ChainAccessor(bw.Zone, "_Color", "Color")
ChainAccessor(bw.Zone, "_Alpha", "Alpha")

function bw.Zone:IsValid()
	return self._Valid and bw.Zones[self:GetID()] == self
end

function bw.Zone:GetBase()
	if not self.BaseID then return false end
	return BaseWars.Bases.Bases[self.BaseID]
end

function bw.Zone:EntityEnter(ent)
	self:_CheckValidity()

	self.Entities[ent] = ent:EntIndex()

	if IsPlayer(ent) then
		self.Players[ent] = ent:EntIndex()
	end
end

function bw.Zone:EntityExit(ent)
	self:_CheckValidity()

	self.Entities[ent] = nil

	if IsPlayer(ent) then
		self.Players[ent] = nil
	end
end

--[[-------------------------------------------------------------------------
	Base object
---------------------------------------------------------------------------]]

ChainAccessor(bw.Base, "BaseCore", "BaseCore")
ChainAccessor(bw.Base, "PowerGrid", "PowerGrid")
ChainAccessor(bw.Base, "Networkable", "NW")
ChainAccessor(bw.Base, "_Claimed", "Claimed")

function bw.Base:Initialize(id, json)
	CheckArg(1, id, isnumber, "base ID")

	self.ID = id

	self.Zones = {}			-- sequential table of zones
	self.ZonesByID = {}		-- [zone_id] = zone_obj

	self.Players = {}

	self.Entities = {}

	self.Data = {}

	self.PublicNW = Networkable("BasePub" .. id)

	local pubNW = self.PublicNW
		pubNW:Alias("Claimed", 0)
		pubNW:Alias("ClaimedBy", 1)
		pubNW:Alias("ClaimedFaction", 2)
		pubNW.Base = self

	self.OwnerNW = Networkable("BasePriv" .. id)
		self.OwnerNW.Base = self
		self.OwnerNW.Filter = self.OwnerNWFilter

	self.EntsNW = Networkable("BaseEnts" .. id)
		self.EntsNW.Base = self
		self.EntsNW.Filter = self.OwnerNWFilter

	self.PowerGrid = bw.PowerGrid:new(self)

	if BaseWars.Bases.Bases[id] then
		local old = BaseWars.Bases.Bases[id]
		BaseWars.Bases.Bases[id]:Remove(true)

		self.Owner = old.Owner
		self.Networkable = old.Networkable
	else
		self.Owner = {
			Faction = nil,
			Player = nil
		}
	end

	if json and isstring(json) and SERVER then
		local t = json:FromJSON()
		if t then
			self.Data = t
			self:SpawnCore()
		end
	end

	self.Name = "-unnamed base-"
	self._Valid = true

	BaseWars.Bases.Bases[id] = self

	if self._PostInit then
		self:_PostInit()
	end

end

ChainAccessor(bw.Base, "Entities", "Entities")
ChainAccessor(bw.Base, "Players", "Players")

ChainAccessor(bw.Zone, "Entities", "Entities")
ChainAccessor(bw.Zone, "Players", "Players")

function bw.Base:EntityEnter(ent)
	self:_CheckValidity()

	self.Entities[ent] = ent:EntIndex()
	self.EntsNW:Set(ent:EntIndex(), true)

	if IsPlayer(ent) then
		self.Players[ent] = ent:EntIndex()
	end
end

function bw.Base:EntityExit(ent)
	self:_CheckValidity()

	self.Entities[ent] = nil
	self.EntsNW:Set(ent:EntIndex(), nil)

	if IsPlayer(ent) then
		self.Players[ent] = nil
	end
end


function bw.Base:Remove(replaced)
	self._Valid = false

	if not replaced then
		for k,v in ipairs(self.Zones) do
			v:Remove(true)
		end

		self.PublicNW:Invalidate()
		self.OwnerNW:Invalidate()
		self.EntsNW:Invalidate()
		self.PowerGrid:Remove()
	end

	if SERVER and IsValid(self:GetBaseCore()) then
		self:GetBaseCore():Remove()
	end

	BaseWars.Bases.Bases[self:GetID()] = nil
	if bw.NW.Bases:IsValid() then
		bw.NW.Bases:Set(self:GetID(), nil)
	end

	self:Emit("Remove")
	bw:Emit("DeleteBase", self)
end

ChainAccessor(bw.Base, "Zones", "Zones")
ChainAccessor(bw.Base, "Name", "Name")

function bw.Base:IsValid()
	return self._Valid and bw.Bases[self:GetID()] == self
end

function bw.Base:RemoveZone(zone)
	table.RemoveByValue(self.Zones, zone)
	self.ZonesByID[zone:GetID()] = nil
end

function bw.Base:AddZone(zone)
	self:_CheckValidity()

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

function bw.Base:_Ready()
	if self._Ready then return end

	self:Emit("Ready")
	hook.Run("BaseReceived", self)
	self._Ready = true
end

function bw.Base:_OnReady()
	local cores = ents.FindByClass("bw_basecore") 	-- find all cores on the map; any cores that enter PVS
													-- will be handled by NotifyShouldTransmit

	for k,v in ipairs(cores) do
		local base = v:GetBase()
		if base == self then
			self:SetBaseCore(v)

			-- a base is only ready if it has a core assigned to it as well
			self:_Ready()
			break
		end
	end

end

hook.Add("NotifyShouldTransmit", "ReadyBase", function(e, add)
	if not add then return end
	if not bw.IsCore(e) then return end

	local ENT = scripted_ents.GetStored("bw_basecore").t
	local base = ENT.GetBase(e) -- fucking gmod is insane
	if not base then print(e, myBaseID, "didn't find base with that ID when entered PVS?") return end

	base:SetBaseCore(e)
	base:_Ready()
end)

function bw.Base:ReadNetwork()
	local name = net.ReadCompressedString(bw.MaxBaseNameLength)
	self:SetName(name)

	local amtZones = net.ReadUInt(8)

	for z=1, amtZones do
		local zID = net.ReadUInt(12)

		if not bw.Zones[zID] then

			local eid = ("wait:%d:%d"):format(self:GetID(), zID)
			bw.NW.Zones:On("ReadZones", eid, function(nw, zones)
				if zones[zID] then
					self:AddZone(zones[zID])
					bw.NW.Zones:RemoveListener("ReadZones", eid)
					self:_OnReady()
				end
			end)

		else
			self:AddZone(zID)
			self:_OnReady()
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

function bw.IsCore(what)
	return IsEntity(what) and what:IsValid() and what:GetClass() == "bw_basecore"
end

function bw.Zone:_CheckValidity()
	if not self:IsValid() then
		errorf("Zone CheckValidity failed!")
		return
	end
end

function bw.Base:_CheckValidity()
	if not self:IsValid() then
		errorf("Base CheckValidity failed!")
		return
	end
end

hook.Add("PostCleanupMap", "RespawnBaseZone", function()
	if CLIENT then return end

	for k,v in pairs(bw.Zones) do
		v:SpawnBrush()
	end

	for k,v in pairs(bw.Bases) do
		v:SpawnCore()
	end


	for k,v in pairs(bw.Zones) do
		v:GetBrush():ForceScanEnts()
	end
end)

if CLIENT then
	-- server includes it in base_sql_sv.lua
	include("areamark/_init.lua")
end

include("base_zone_ownership_ext.lua")

FInc.FromHere("baseview/_init.lua", _SH, true, FInc.RealmResolver():SetDefault(true))
FInc.FromHere("powergrid/_init.lua", _SH, true, FInc.RealmResolver():SetDefault(true))