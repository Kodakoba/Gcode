--rename to ranks

CUM.Ranks = CUM.Ranks or {}
local ranks = CUM.Ranks 

require("mysqloo")

local schema_name = "ranks"
local table_name = "CUM_Ranks"

Equipment = Equipment or {}

rsDB = mysqloo.connect("127.0.0.1", "root", "31415", schema_name)

EQmod = {name = "CUM-Ranks", col = Color(60, 175, 255)}

local mod = EQmod

local log = function(...)
	local s = {...}
	local str = ""

	for k,v in pairs(s) do 
		str = str .. (tostring(v) or "Nani? " .. type(v))
	end

	Modules.Log(mod, str)
end

rsDB.onConnected = function()
	log("Connected to MySQL [col=80, 220, 80]successfully[col=255,255,255]!")
	log("Creating ranks...")

	local q = "SELECT * FROM cum_ranks"

	local q = rsDB:query(q)

	q.onError = function(self, err)
		log("failed: ", err)
	end

	q.onSuccess = function(self, data)
		log("cool:")
		PrintTable(data)
	end

	q:start()
end 

rsDB.onConnectionFailed = function(d, err) 
	log("Connection to MySQL [col=240, 50, 50]FAILED! Expect errors!")
end

rsDB:connect()

function CUM.PortRanks()
	local ranks = ULib and ULib.ucl and ULib.ucl.groups
	if not ranks then log("[col=240, 50, 50]Failed to get ULib ranks!") return end

	local q = rsDB:query("SELECT * FROM `cum_ranks`")

	q.onError = function(self, err)
		print("you fucked up:", err)
	end

	q.onSuccess = function(self, data)
		local missingDB = table.Copy(ranks)

		for k,v in pairs(data) do 
			missingDB[v.rank] = nil 
			CUM.Ranks[v.rank] = {perms = util.JSONToTable(v.permissions), players = {}}
			log("[col=80, 220, 80] Restored rank [col=255,255,255]", v.rank, "!")
		end

		for k,v in pairs(missingDB) do 
			log(" [col=240, 240, 100]Missing rank: ", k, "![col=255, 255, 255]")

			local q = rsDB:query("INSERT INTO `cum_ranks`(`rank`, `permissions`) VALUES('" .. rsDB:escape(k) .. "', '[]');")

			q.onError = function(self, err)
				log("youre a retard #2 ", err)
			end
			q.onSuccess = function(self, data)
				log("nice #2")
				CUM.Ranks[k] = {perms = {}, players = {}}
			end

			q:start()

		end

	end

	q:start()

end