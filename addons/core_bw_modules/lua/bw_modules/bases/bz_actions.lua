local bw = BaseWars.Bases

bw.Actions = table.Merge(bw.Actions or {}, {
	Claim = 0,
	Unclaim = 1,
	-- ?
	SZ = 8,
})