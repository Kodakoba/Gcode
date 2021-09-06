
function BaseWars.NoPK(ent, info)

	local how = info:GetInflictor()
	if info:GetDamageType() == 1 and not IsPlayer(how) then return true end
	--[[if how:IsPlayer()
	print(info:GetAttacker(), )]]
end

hook.Add("EntityTakeDamage", "StopItFaggots", BaseWars.NoPK)
