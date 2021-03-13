local bw = BaseWars.Bases

bw.PowerGrid = bw.PowerGrid or Emitter:extend()
local pg = bw.PowerGrid

function pg:Initialize(base)
	CheckArg(1, base, bw.IsBase)

	local id = base:GetID()

	self:SetNW( LibItUp.Networkable:new("PG:" .. id) )

	self:SetBase(base)

	self:SetPower(0)

	local nw = self:GetNW()
		nw.Filter = base.OwnerNWFilter
		nw.Base = base
		nw:Alias("Power", 0)
		nw:Alias("PowerIn", 1)
		nw:Alias("PowerOut", 2)
end

function pg:Update()
	self:GetNW():Set("Power", self:GetPower())
end

function pg:SetPower(pw)
	self._Power = pw
	self:Update()
end

function pg:GetPower()
	return self._Power
end

function pg:AddPower(pw)
	self:SetPower(self:GetPower() + pw)
end

function pg:TakePower(pw)
	self:SetPower(math.max( self:GetPower() - pw, 0 ) )
end

function pg:HasPower(pw)
	return self:GetPower() > pw
end

function pg:Remove()
	self:GetNW():Invalidate()
	self:SetValid(false)
end

function pg:Think()
	local base = self:GetBase()
	if not base or not self:GetValid() then return end

	local ents = base:GetEntities()
end

ChainAccessor(pg, "_Networkable", "NW")
ChainAccessor(pg, "_Base", "Base")
ChainAccessor(pg, "_PowerIn", "PowerIn")
ChainAccessor(pg, "_PowerOut", "PowerOut")
ChainAccessor(pg, "_Valid", "Valid")

include("powergrid_ext_" .. Rlm(true) .. ".lua")
AddCSLuaFile("powergrid_ext_cl.lua")