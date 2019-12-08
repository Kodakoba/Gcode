--hairy balls

local db

local PLAYER = FindMetaTable("Player")

function PLAYER:FetchResearch()
	local q = "SELECT perkid, level FROM research WHERE puid=%s"
	q = q:format(self:GetPUID())

	local query = db:query(q)

	query.onSuccess = function(self, data)
		print("cool got research data:")
		PrintTable(data)
	end

	query.onError = function(self, err)
		print("research SQL failed:", err, "\nquery:", q)
	end

	query:start()

end

function PLAYER:Research(perkid, lv)
	local q = [[DELETE FROM research WHERE puid=%s AND perkid=%s; REPLACE INTO research(puid, perkid, level) VALUES (%s, %s, %s);]]
	local uid = self:GetUID()

	q = q:format(uid, perkid, uid, perkid, lv)

	local query = db:query(q)

	query.onSuccess = function(self, data)
		print("all a-ok")
	end

	query.onError = function(self, err)
		print("research SQL failed:", err, "\nquery:", q)
	end

	query:start()

end

local function OnMySQL()
	db = mysql.GetDatabase()
	mysqloo.CreateTable("research", "`puid` INT", "`perkid` INT", "`level` INT")
end

hook.Add("OnMySQLReady", "Research", OnMySQL)

if mysqloo.GetDatabase then 
	OnMySQL()
end

hook.Add("PlayerInitialSpawn", "Research", function(ply)
	ply:FetchResearch()
end)