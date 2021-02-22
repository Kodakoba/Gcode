--rename to ranks

CUM.Ranks = CUM.Ranks or {}
local ranks = CUM.Ranks 

local schema_name = "ranks"
local table_name = "CUM_Ranks"

Equipment = Equipment or {}

rsDB = mysqloo.GetDB()

mysqloo.CreateTable("cum_ranks", "`rank` MEDIUMTEXT", "`permissions` TEXT", "`rankid` INT PRIMARY KEY")

EQmod = {name = "CUM-Ranks", col = Color(60, 175, 255)}

local mod = EQmod

local log = Logger("CUM-SQL", Color(0, 117, 191))

hook.Add("OnMySQLReady", "CUM", function()
	rsDB = mysqloo.GetDB()
	
	if rsDB then
		log("Connected to MySQL [col=80, 220, 80]successfully[col=255,255,255]!")
	else 
		log("Connection to MySQL [col=240, 50, 50]FAILED! Expect errors!")
	end

end)


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

