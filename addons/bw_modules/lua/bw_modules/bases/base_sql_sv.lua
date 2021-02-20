--

local bw = BaseWars.Bases

local zones_tbl = "bw_baseareas"
local bases_tbl = "bw_bases"

local function PopulateBases(bases)
	for baseID, data in pairs(bases) do
		local base = bw.Base:new(baseID)
		base:SetName(data.name)

		for _, zonedata in ipairs(data.zones) do
			local zoneID, zoneName, mins, maxs, name = unpack(zonedata)
			local zone = bw.Zone:new(zoneID, mins, maxs)
			if zoneName then
				zone:SetName(zoneName)
			end
			base:AddZone(zone)
			zone:AddToNW()
		end

		base:AddToNW()
		
	end

	bw.Log("SQL data pulled!")
end

local sides = {"min", "max"}
local dims = {"x", "y", "z"}

local argnames = {min = {}, max = {}}
local allArgNames = {}

for k,v in ipairs(sides) do
	for _, v2 in ipairs(dims) do
		local argname = "zone_" .. v .. "_" .. v2
		argnames[v][v2] = argname
		allArgNames[#allArgNames + 1] = argname
	end
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
	
	for k,v in ipairs(allArgNames) do
		arg:AddArg(v .. " FLOAT NOT NULL")
	end

	local em = mysqloo.CreateTable(db, zones_tbl, arg):Then(coroutine.Resumer())

	coroutine.yield(); coroutine.yield()	-- 2 queries, 2 yields

	local selWhat = "a.zone_id, a.zone_name, b.base_id, b.base_name"

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
					zones = {}	-- [seq_id] = {zone_id, zone_name, zone_mins, zone_maxs}
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

				base.zones[#base.zones + 1] = {zID, zdata.zone_name or false, mins, maxs}
			end

			PopulateBases(bases)

			FInc.AddState("BW_SQLAreasFetched")

		end, mysqloo.QueryError)

end))






--[[
	SQL operations
]]

local base_q

mysqloo.OnConnect(function()
	base_q = mysqloo:GetDatabase():prepare("INSERT INTO bw_bases(base_name) VALUES(?)")
end)

function bw.SQL.CreateBase(name)
	local em = MySQLEmitter(base_q)

	if #name > bw.MaxBaseNameLength then
		return em, ("name is too long (%d, max is %d)"):format(#name, bw.MaxBaseNameLength)
	end

	if #name < bw.MinBaseNameLength then
		return em, ("name is too short (%d, min is %d)"):format(#name, bw.MinBaseNameLength)
	end

	if bw.GetBase(name) then
		return em, ("base `%s` already exists"):format(name)
	end

	base_q:setString(1, name)

	em:On("Success", function(qobj)
		local id = base_q:lastInsert()
		local base = bw.Base:new(id)
		base:SetName(name)
		base:AddToNW()
	end)

	return em:Exec()
end

local zone_q

mysqloo.OnConnect(function()
	local fuck = "INSERT INTO bw_baseareas(%s, zone_name, base_id) VALUES(%s)"
	fuck = fuck:format(table.concat(allArgNames, ", "), ("?, "):rep(#allArgNames + 2):sub(1, -3))

	zone_q = mysqloo:GetDatabase():prepare(fuck)
end)


function bw.SQL.CreateZone(name, baseid, min, max)
	local em = MySQLEmitter(zone_q)

	if #name > bw.MaxZoneNameLength then
		return em, ("name is too long (%d, max is %d)"):format(#name, bw.MaxZoneNameLength)
	end

	if not bw.GetBase(baseid) then
		return em, ("no base found for %s"):format(baseid)
	end
	local base = bw.GetBase(baseid)
	

	for i=1, 3 do
		zone_q:setNumber(i, min[i])
	end

	for i=4, 6 do
		zone_q:setNumber(i, max[i-3])
	end

	zone_q:setString(7, name)
	zone_q:setNumber(8, baseid)

	em:On("Success", function(qobj)
		local id = zone_q:lastInsert()
		local zone = bw.Zone:new(id, min, max)
		zone:SetName(name)
		zone:AddToNW()
		base:AddZone(zone)
	end)

	return em:Exec()
end

local edit_zone_q
local edit_base_q

mysqloo.OnConnect(function()
	local fuck = "UPDATE master.bw_baseareas SET %s, zone_name = ? WHERE (`zone_id` = ?);"
	fuck = fuck:format(
		-- SET `name` = ?, `name` = ?
		table.concat(allArgNames, " = ?, ") .. " = ?" 
	)
	-- UPDATE master.bw_baseareas SET zone_name = ?, zone_min_x = ?, zone_min_y = ?, zone_min_z = ?, zone_max_x = ?, zone_max_y = ?, zone_max_z = ? WHERE (`zone_id` = ?);
	edit_zone_q = mysqloo:GetDatabase():prepare(fuck)

	local fuck = "UPDATE master.%s SET base_name = ? WHERE (`base_id` = ?);"
	fuck = fuck:format(bases_tbl)

	-- UPDATE master.bw_baseareas SET base_name = ? WHERE (`zone_id` = ?);
	edit_base_q = mysqloo:GetDatabase():prepare(fuck)
end)


function bw.SQL.EditZone(id, name, min, max)
	local em = MySQLEmitter(edit_zone_q)

	if #name > bw.MaxZoneNameLength then
		return em, ("name is too long (%d, max is %d)"):format(#name, bw.MaxZoneNameLength)
	end

	local zone = bw.GetZone(id)
	if not zone then
		return em, ("no zone found with id %s"):format(id)
	end

	for i=1, 3 do
		edit_zone_q:setNumber(i, min[i])
	end

	for i=4, 6 do
		edit_zone_q:setNumber(i, max[i-3])
	end

	edit_zone_q:setString(7, name)
	edit_zone_q:setNumber(8, id)

	em:On("Success", function(qobj)
		zone:SetName(name)
		zone:SetBounds(min, max)
		zone:AddToNW()
	end)

	return em:Exec()
end

function bw.SQL.EditBase(id, name)
	local em = MySQLEmitter(edit_base_q)

	if #name > bw.MaxBaseNameLength then
		return em, ("name is too long (%d, max is %d)"):format(#name, bw.MaxZoneNameLength)
	end

	local base = bw.GetBase(id)
	if not base then
		return em, ("no base found with id %s"):format(id)
	end

	edit_base_q:setString(1, name)
	edit_base_q:setNumber(2, id)

	em:On("Success", function(qobj)
		base:SetName(name)
		base:AddToNW()
	end)

	return em:Exec()
end

local yeet_zone_q
local yeet_base_q

mysqloo.OnConnect(function()
	local yeetzone = "DELETE FROM master.%s WHERE (`zone_id` = ?);"
	yeetzone = yeetzone:format(zones_tbl)

	local yeetbase = "DELETE FROM master.%s WHERE (`base_id` = ?);"
	yeetbase = yeetbase:format(bases_tbl)

	yeet_zone_q = mysqloo:GetDatabase():prepare(yeetzone)
	yeet_base_q = mysqloo:GetDatabase():prepare(yeetbase)
end)

function bw.SQL.YeetZone(id)
	local em = MySQLEmitter(yeet_zone_q)

	local zone = bw.GetZone(id)
	if not zone then
		return em, ("no zone found with id %s"):format(id)
	end

	yeet_zone_q:setNumber(1, id)

	em:On("Success", function(qobj)
		zone:Remove()
	end)

	return em:Exec()
end

function bw.SQL.YeetBase(id)
	local em = MySQLEmitter(yeet_base_q)

	local base = bw.GetBase(id)
	if not base then
		return em, ("no base found with id %s"):format(id)
	end

	yeet_base_q:setNumber(1, id)

	em:On("Success", function(qobj)
		base:Remove()
	end)

	return em:Exec()
end

include("areamark/_init.lua")