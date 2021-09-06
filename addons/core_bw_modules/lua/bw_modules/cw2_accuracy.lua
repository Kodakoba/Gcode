hook.Add("CW2_ConeModifiers", "AccuracyBoost", function(wep, mods)
	mods[1] = mods[1] * 0
	mods[3] = mods[3] * 0.35
end)

hook.Add("CW2_SpreadModifier", "AccuracyBoost", function(wep, spread)
	spread[1] = spread[1] * 0.5
	spread[2] = spread[2] * 0.4
end)