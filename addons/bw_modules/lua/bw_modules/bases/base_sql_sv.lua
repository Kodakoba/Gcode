--

local bw = BaseWars.Bases

table.Empty(bw.Bases) -- yo we'll be grabbing them anew
table.Empty(bw.Zones)

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
			bw.NW.Zones:Set(zoneID, zone)
		end

		bw.NW.Bases:Set(baseID, base)
		bw.NW.Admin:Set(baseID, data.name)
		
	end

	bw.Log("SQL data pulled!")
end

mysqloo.OnConnect(coroutine.wrap(function()
	local db = mysqloo:GetDatabase()

	local arg = LibItUp.SQLArgList()
		arg:AddArg("base_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT")
		arg:AddArg("base_name VARCHAR(500) NOT NULL")
		arg:AddArg("UNIQUE KEY `base_name_UNIQUE` (`base_name`)")

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

	local q = ("SELECT %s FROM master.%s a RIGHT JOIN master.%s b ON a.base_id = b.base_id;")
				:format(selWhat, zones_tbl, bases_tbl)

	em:Do(db:query(q))
		:Then(function(self, q, data)
			local bases = {}	-- [base_ID] = { name = string, zones = {...} }

			for _, zdata in ipairs(data) do
				-- read the base ID/name (guaranteed to be present)

				local bID = zdata.base_id
				local base = bases[bID] or {
					name = zdata.base_name,
					zones = {}	-- [seq_id] = {zone_id, zone_mins, zone_maxs}
				}

				bases[bID] = base

				-- read the zones data (not guaranteed)
				local zID = zdata.zone_id
				if not zID then continue end

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

local prep_q

mysqloo.OnConnect(function()
	prep_q = mysqloo:GetDatabase():prepare("INSERT INTO bw_bases(base_name) VALUES(?)")
end)

function bw.SQL.CreateBase(name)
	local em = MySQLEmitter(prep_q)

	if #name > bw.MaxBaseNameLength then
		return em, ("name is too long (%d, max is %d)"):format(#name, bw.MaxBaseNameLength)
	end

	if #name < bw.MinBaseNameLength then
		return em, ("name is too short (%d, min is %d)"):format(#name, bw.MinBaseNameLength)
	end

	if bw.GetZone(name) then
		return em, ("base `%s` already exists"):format(name)
	end

	prep_q:setString(1, name)

	em:On("Success", function(qobj)
		local id = prep_q:lastInsert()
		local base = bw.Base:new(id)
		base:SetName(name)
		base:AddToNW()
	end)

	return em:Exec()
end

include("areamark/_init.lua")