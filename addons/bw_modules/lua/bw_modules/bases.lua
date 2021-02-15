
if BaseWars.Bases then
	local b = BaseWars.Bases.NW
	b.Bases:Invalidate()
	b.Zones:Invalidate()
	b.Admin:Invalidate()

	b.Bases = Networkable("bw_bases_bases")
	b.Zones = Networkable("bw_bases_zones")
	b.Admin = Networkable("bw_bases_admin")
end

local function init(force)
	BaseWars.Bases = (not force and BaseWars.Bases) or Emitter.Make({
		-- data populated from base_sql_sv
		Zones = {},	
		Bases = {},

		-- objects from base_zone 
		Zone = nil,
		Base = nil,

		MarkTool = nil, -- gets filled in areamark/ folder

		Log = Logger("BW-Bases" .. Rlm(), CLIENT and Color(55, 205, 135) or Color(200, 50, 120)),	-- bw18 throwback

		NW = {
			Bases = Networkable("bw_bases_bases"),
			Zones = Networkable("bw_bases_zones"),
			Admin = Networkable("bw_bases_admin"),

			BASE_NEW = 0,
			BASE_DELETE = 1,

			ZONE_NEW = 2,
			ZONE_EDIT = 3,

			SZ = {
				base = 12,
				zone = 12
			}
		},

		SQL = {}
	})


	FInc.FromHere("bases/*.lua", _SH, true, FInc.RealmResolver():SetDefault(true))
end

init()
BaseWars.Bases.Reset = Curry(init, true)
