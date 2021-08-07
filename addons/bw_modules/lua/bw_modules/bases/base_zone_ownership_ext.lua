local bw = BaseWars.Bases
local base, zone = bw.Base, bw.Zone


function base:IsEntityOwned(ent)
	-- returns if the entity is owned by the base owner
	local own = ent:BW_GetOwner()
	if not IsValid(own) then return end

	return self:IsOwner(own)
end