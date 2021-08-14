local ENTITY = FindMetaTable("Entity")
local PLAYER = FindMetaTable("Player")

BaseWars.Ents = BaseWars.Ents or {}

-- returns PlayerInfo, worldspawn or false
function ENTITY:BW_GetOwner()
	local o1, o2 = self:CPPIGetOwner()
	if o1 == nil and o2 == nil then
		return game.GetWorld(), true
	end

	if SERVER then
		if self.CPPI_OwnerSID then
			return (GetPlayerInfo(self.CPPI_OwnerSID)), false
		end

		return false
	else
		local id = BaseWars.Ents.EntityToSteamID(self)

		if isstring(id) then
			return (GetPlayerInfo(id)), false
		end

		return false
	end
end

