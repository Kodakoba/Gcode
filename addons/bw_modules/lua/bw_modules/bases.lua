
BaseWars.Bases = BaseWars.Bases or {

	-- data populated from base_sql_sv
	Zones = {},	
	Bases = {},

	-- objects from base_zone 
	Zone = nil,
	Base = nil,

	MarkTool = nil, -- gets filled in areamark/ folder
}

FInc.FromHere("bases/*", _SH, false, FInc.RealmResolver():SetDefault(true))