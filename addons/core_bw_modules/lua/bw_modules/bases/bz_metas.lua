local ENTITY = FindMetaTable("Entity")
local PLAYER = FindMetaTable("Player")

local bw = BaseWars.Bases
local nw = bw.NW

function PLAYER:GetBase()
	return self:GetPInfo():GetBase()
end

function LibItUp.PlayerInfo:GetBase(no_owner_check)
	local fac = self:GetFaction()
	if fac then
		return fac:GetBase()
	end

	local base

	if SERVER then
		base = self._Base
	else
		base = bw.Bases[self:GetPublicNW():Get("OwnedBase", -1)]
	end

	if not base or not base:IsValid() then return false end

	if not no_owner_check and not base:IsOwner(self) then
		if SERVER then
			errorf("Something went wrong: %s has base set as %s, but player doesn't own it.", self, base)
		end
		-- clientside data races can happen, so its fine
		return false
	end

	return base
end

function LibItUp.PlayerInfo:SetBase(base)
	assert(not base or BaseWars.Bases.IsBase(base))

	self._Base = base
	self:GetPublicNW():Set("OwnedBase", base and base:GetID() or nil)

	if base then
		base:On("Unclaim", self, function(_)
			if self._Base == base then
				self:SetBase(nil)
			end
		end)
	end
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

include(Realm():lower() .. "/bz_metas_ext.lua")
