--
util.AddNetworkString("bhdn_spawn")

local hgs = {}
timer.Create("hdn_cleanup_janny_gc", 10, 0, function()
	hgs = {}
end)

function BHDN_Notify(victim, dmg)
	local recv = dmg:GetAttacker()
	if not IsPlayer(recv) then return end

	local vPly = IsPlayer(victim) and victim

	local pos

	if dmg:IsBulletDamage() then
		pos = victim:WorldToLocal(dmg:GetDamagePosition())
	else
		pos = victim:OBBCenter()
	end

	local dmgAmt = dmg:GetDamage()
	local hg = hgs[victim] or HITGROUP_GENERIC
	hgs[victim] = nil

	local crit = vPly and
		(dmgAmt > vPly:GetMaxHealth() or
			hg == HITGROUP_HEAD
		)

	net.Start("bhdn_spawn", true)
		net.WriteEntity(victim)
		net.WriteUInt(math.min(65535, dmgAmt), 16)
		net.WriteBool(crit)
		net.WriteVector(pos)
	net.Send(recv)
end

hook.Add( "PostEntityTakeDamage", "BHDN", function(ply, dmg, took)
	if not took then return end
	BHDN_Notify(ply, dmg)
end )

hook.Add("ScalePlayerDamage", "BHDN", function(ply, hg, dmg)
	hgs[ply] = hg -- LastHitGroup? never heard of em
end)