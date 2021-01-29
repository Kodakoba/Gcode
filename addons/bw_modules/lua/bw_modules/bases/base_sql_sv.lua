--

local bw = BaseWars
local tbl_name = "bw_baseareas"

local function PopulateBases(bases)
	for baseID, zones in pairs(bases) do
		local base = bw.Base:new(baseID)

		for _, zonedata in ipairs(zones) do
			local zoneID, mins, maxs = unpack(zonedata)
			local zone = bw.Zone:new(zoneID, mins, maxs)
			base:AddZone(zone)
		end

		bw.Bases[baseID] = base
	end

	bw.Bases.Log("SQL data pulled!")
end

mysqloo.OnConnect(function()
	local db = mysqloo:GetDatabase()

	local arg = LibItUp.SQLArgList()

	arg:AddArg("zone_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT")
	arg:AddArg("base_id INT NOT NULL")	-- not PK: there can be multiple zones tied to the same base

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


	mysqloo.CreateTable(db, tbl_name, arg):Then(function(em)

		local query = "SELECT * FROM " .. tbl_name .. " ORDER BY base_id ASC"

		em:Do(db:query(query))
			:Then(function(self, q, data)

				local bases = {
					--[base_id] = { {zone_id, mins, maxs}, ... }
				}
				for _, zdata in ipairs(data) do
					local zID = zdata.zone_id
					local bID = zdata.base_id

					local base = bases[bID] or {}
					bases[bID] = base

					local mins, maxs = Vector(), Vector()
					for k,v in pairs(argnames.min) do
						mins[k] = zdata[v]
					end

					for k,v in pairs(argnames.max) do
						maxs[k] = zdata[v]
					end

					base[#base + 1] = {zID, mins, maxs}
				end

				PopulateBases(bases)

				FInc.AddState("BW_SQLAreasFetched")

			end, mysqloo.QueryError)
	end)

	--[[
		zone_id int AI PK 
		base_id int 
		zone_max_x float 
		zone_max_y float 
		zone_max_z float 
		zone_min_x float 
		zone_min_y float 
		zone_min_z float
	]]
end)

include("areamark/_init.lua")