-- ?
AIBases.BRICK_PROP = 0
AIBases.BRICK_BOX = 1
AIBases.BRICK_ENEMY = 2
AIBases.BRICK_DOOR = 3
AIBases.BRICK_SIGNAL = 4
AIBases.BRICK_LOOT = 5

AIBases.WeaponPools = {
	shotgun = {
		{"cw_shorty"},
		{"cw_saiga12k_official", "cw_m3super90", "arccw_go_mag7"},
		{"cw_xm1014_official", "arccw_go_m1014"}
	},
	ar = {
		{"cw_g36c", "cw_ak74"},
		{"cw_acr", "cw_scarh", "cw_l85a2", "cw_tr09_qbz97"},
		{"cw_famasg2_official", "cw_ar15", "cw_tr09_auga3",}
	},

	smg = {
		{"cw_mp5", "cw_mac11", "cw_ump45", "arccw_go_bizon"},
		{"cw_mp7_official", "cw_mp9_official",},
		{"arccw_fml_fas_mp5", "arccw_go_p90"}
	},
	pistol = {
		{"cw_makarov", "cw_p99", "arccw_go_p250"},
		{"cw_fiveseven", "arccw_fml_fas_g20",},
		{"cw_deagle", "arccw_deagle50", "arccw_mifl_fas2_ragingbull"}
	},
	sniper = {
		{},
		{"cw_svd_official", "cw_m14",},
		{"cw_l115",}
	},
}

function AIBases.RollWeapon(type, tier)
	local pool = AIBases.WeaponPools[type]
	local valid = not type or type == "random" or (pool and pool[tier] and #pool[tier] > 0)

	if not valid then
		printf("invalid combo: %s T%s", type, tier)
	end

	if not type or type == "random" or not valid then
		for k,v in RandomPairs(AIBases.WeaponPools) do
			if k == type then continue end
			if v[tier] and #v[tier] > 0 then pool, type = v, k break end
		end
	end

	pool = pool[tier]

	return table.SeqRandom(pool)
end

FInc.Recursive("aibases/classes/*.lua", FInc.SHARED, FInc.RealmResolver()
	:SetDefaultRealm(Carry(false, true))
)

FInc.Recursive("aibases/tools/*", FInc.SHARED, FInc.RealmResolver()
	:SetDefault(true)
)