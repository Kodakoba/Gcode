--

local bw = BaseWars

local zones_tbl = "bw_baseareas"
local bases_tbl = "bw_bases"

local function PopulateBases(bases)
	for baseID, data in pairs(bases) do
		local base = bw.Base:new(baseID)
		base:SetName(data.name)

		for _, zonedata in ipairs(data.zones) do
			local zoneID, mins, maxs, name = unpack(zonedata)
			local zone = bw.Zone:new(zoneID, mins, maxs)
			base:AddZone(zone)
			bw.Bases.NWZones:Set(zoneID, zone)
		end

		bw.Bases.NWBases:Set(baseID, base)
		bw.Bases.NWAdmin:Set(baseID, data.name)
		
	end

	bw.Bases.Log("SQL data pulled!")
	bw.Bases.NWAdmin:Network()
end

mysqloo.OnConnect(coroutine.wrap(function()
	local db = mysqloo:GetDatabase()

	local arg = LibItUp.SQLArgList()
		arg:AddArg("base_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT")
		arg:AddArg("base_name VARCHAR(500) NOT NULL")

	-- creating bases table (contains ID and name)
	mysqloo.CreateTable(db, bases_tbl, arg):Then(coroutine.Resumer())
	

	local arg = LibItUp.SQLArgList()

	arg:AddArg("zone_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT")
	arg:AddArg("base_id INT NOT NULL")	-- not PK: there can be multiple zones tied to the same base
	arg:AddArg("base_name VARCHAR(255) NOT NULL") -- you really don't need the name to be any longer than this
  	
	local sides = {"max", "min"}
	local dims = {"x", "y", "z"}

	local argnames = {min = {}, max = {}}

	for k,v in ipairs(sides) do
		for _, v2 in ipairs(dims) do
			local argname = "zone_" .. v .. "_" .. v2
			argnames[v][v2] = argname
			arg:AddArg(argname .. " FLOAT NOT NULL")
		end
	end

	local em = mysqloo.CreateTable(db, zones_tbl, arg):Then(coroutine.Resumer())

	coroutine.yield(); coroutine.yield()	-- 2 queries, 2 yields

	local selWhat = "a.zone_id, b.base_id, b.base_name"

	for k,v in pairs(argnames) do
		for _, v2 in pairs(v) do
			selWhat = "a." .. v2 .. ", " .. selWhat
		end
	end

	local q = ("SELECT %s FROM master.%s a INNER JOIN master.%s b ON a.base_id = b.base_id;")
				:format(selWhat, zones_tbl, bases_tbl)

	em:Do(db:query(q))
		:Then(function(self, q, data)
			local bases = {}	-- [base_ID] = { name = string, zones = {...} }

			for _, zdata in ipairs(data) do
				local zID = zdata.zone_id
				local bID = zdata.base_id

				local base = bases[bID] or {
					name = zdata.base_name,
					zones = {}	-- [seq_id] = {zone_id, zone_mins, zone_maxs}
				}

				bases[bID] = base

				local mins, maxs = Vector(), Vector()
				for k,v in pairs(argnames.min) do
					mins[k] = zdata[v]
				end

				for k,v in pairs(argnames.max) do
					maxs[k] = zdata[v]
				end

				base.zones[#base.zones + 1] = {zID, mins, maxs}
			end

			PopulateBases(bases)

			FInc.AddState("BW_SQLAreasFetched")

		end, mysqloo.QueryError)

end))

include("areamark/_init.lua")