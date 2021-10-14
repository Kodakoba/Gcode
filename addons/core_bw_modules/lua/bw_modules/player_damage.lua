if CLIENT then
	hook.Add("HUDShouldDraw", "NoRed", function(h)
		if h == "CHudDamageIndicator" then return false end
	end)
end

hook.Add("PostEntityTakeDamage", "NoViewpunch", function(ent, dmg)
	if not ent:IsPlayer() then return end

	ent:SetViewPunchAngles(angle_zero)
	ent:SetViewPunchVelocity(angle_zero)
end)