util.AddNetworkString("sigma_male")

local sigmas = {}
local anim = Animatable("sigma")
anim.remove = {}

hook.Add("Think", "sigma", function()
	for i=#sigmas, 1, -1 do
		local ply = sigmas[i]

		if not IsValid(ply) then
			table.remove(sigmas, i)
			continue
		end

		local slowFr = anim[ply]
		ply:SetLaggedMovementValue(1 - 0.5 * slowFr)

		if slowFr == 0 and anim.remove[ply] then
			table.remove(sigmas, i)
		end
	end
end)

hook.Add("EntityRemoved", "sigma", function(ent)
	if not IsWeapon(ent) then return end
	if ent:GetClass() ~= "arccw_p228" then return end
	if not table.HasValue(sigmas, ent._sigmaOw) then return end

	local ply = ent._sigmaOw
	anim:To(ply, 0, 0.5, 0, 0.4)
	anim.remove[ply] = true
end)

hook.Add("ArcCW_GunHolstered", "sigma", function(wep, ply)
	if wep:GetClass() ~= "arccw_p228" then return end
	if not table.HasValue(sigmas, ply) then return end

	anim:To(ply, 0, 0.5, 0, 0.4)
	anim.remove[ply] = true
end)

hook.Add("ArcCW_GunDeployed", "sigma", function(wep, ply)
	if wep:GetClass() == "arccw_p228" then
		if not wep._sigmaPlayed then
			net.Start("sigma_male")
			net.WriteEntity(ply)
			net.Broadcast()
			wep._sigmaPlayed = true
		end

		anim[ply] = anim[ply] or 0
		anim:To(ply, 1, 0.8, 0, 0.4)
		sigmas[#sigmas + 1] = ply
		anim.remove[ply] = false

		wep._sigmaOw = ply
	end
end)