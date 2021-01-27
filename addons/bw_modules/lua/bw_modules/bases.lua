
BaseWars.Bases = BaseWars.Bases or {

	-- data populated from base_sql_sv
	Zones = {},	
	Bases = {},

	-- objects from base_zone 
	Zone = nil,
	Base = nil,

	MarkTool = nil, -- gets filled in areamark/ folder

	Log = Logger("BW-Bases" .. Rlm(), CLIENT and Color(55, 205, 135) or Color(200, 50, 120))	-- bw18 throwback
}

FInc.FromHere("bases/*.lua", _SH, true, FInc.RealmResolver():SetDefault(true))