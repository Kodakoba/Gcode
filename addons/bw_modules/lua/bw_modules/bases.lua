

if BaseWars.Bases then
	local b = BaseWars.Bases.NW
	b.Bases:Invalidate()
	b.Zones:Invalidate()

	b.Bases = Networkable("bw_bases_bases")
	b.Zones = Networkable("bw_bases_zones")
end


local function init(force)
	if force and BaseWars.Bases then
		for k,v in pairs(BaseWars.Bases.Bases) do
			v:Remove()
		end

		for k,v in pairs(BaseWars.Bases.Zones) do
			v:Remove()
		end
	end


	BaseWars.Bases = (not force and BaseWars.Bases) or Emitter.Make({
		-- data populated from base_sql_sv
		Zones = {},
		Bases = {},

		-- objects from base_zone
		Zone = Emitter:callable(),
		Base = Emitter:callable(),

		MarkTool = nil, -- gets filled in areamark/ folder

		Log = Logger("BW-Bases" .. Rlm(), CLIENT and Color(55, 205, 135) or Color(200, 50, 120)),	-- bw18 throwback

		NW = {
			Bases = Networkable("bw_bases_bases"),
			Zones = Networkable("bw_bases_zones"),
			PlayerData = SERVER and {} or nil, 	-- defined in base_nw_*
												-- serverside, a table ; clientside, the nw object itself
			BASE_NEW = 0,
			BASE_YEET = 1,

			ZONE_NEW = 2,
			ZONE_EDIT = 3,
			ZONE_YEET = 4,

			BASE_EDIT = 5,

			BASE_CORENEW = 6,
			BASE_CORESAVE = 7,

			SZ = {
				base = 12,
				zone = 12
			}
		},

		Actions = {
			Claim = 0,
			Unclaim = 1,


			SZ = 8,
		},

		SQL = {},			-- SV
		ZonePaints = {},	-- CL
	})

	if force then
		local b = BaseWars.Bases.NW
		b.Bases:Invalidate()
		b.Zones:Invalidate()

		b.Bases = Networkable("bw_bases_bases")
		b.Bases.Yeet = true
		b.Zones = Networkable("bw_bases_zones")
	end

	if force and SERVER then
		for k,v in ipairs(ents.FindByClass("bw_zone_brush")) do
			v:Remove()
		end

		for k,v in ipairs(ents.FindByClass("bw_basecore")) do
			v:Remove()
		end
	end

	FInc.FromHere("bases/*.lua", _SH, true, FInc.RealmResolver():SetDefault(true))
end

init(true)
BaseWars.Bases.Reset = Curry(init, true)
