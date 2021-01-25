require("mysqloo")

__MYSQL_INFO = {"127.0.0.1", "root", "31415", ""}

mysql = mysqloo
mysqloo.Info = __MYSQL_INFO

if mysqloo.GlobalDatabase and mysqloo.GlobalDatabase:status() == 0 then
	mysqloo.GlobalDatabase:disconnect() --bye bye monkey
end


local err = Logger("MySQL ERROR", Color(230, 120, 120))

local rsDB

local function connect(ply)
	if ply and IsPlayer(ply) and not ply:IsSuperAdmin() then return false end
	if rsDB and rsDB:status() == 0 then rsDB:disconnect() end

	rsDB = mysqloo.connect(unpack(__MYSQL_INFO))

	rsDB.onConnected = function(self)
		local q = self:query("CREATE SCHEMA IF NOT EXISTS master; USE master")

		q.onSuccess = function()
			hook.Run("OnMySQLReady", self)
		end

		q.onError = function(self, ...)
			err("Master MySQL database creation failed.")
			err("Do `mysql_reconnect` if you want to try again.")
			err(...)
		end

		q:start()
	end

	rsDB.onConnectionFailed = function(self, ...)
		err("Master MySQL database connection failed.")
		err("Do `mysql_reconnect` if you want to try again.")
		err(...)
	end

	rsDB:connect()
	mysqloo.GlobalDatabase = rsDB
end

concommand.Add("mysql_reconnect", connectFunc)
connect()

function mysqloo.GetDB()
	return rsDB
end

-- use as q.onError = mysqloo.QueryError
function mysqloo.QueryError(q, errstr)
	err("Query error! Error: %s\n\n	Trace: %s", errstr, debug.traceback())
end

mysqloo.HookName = "OnMySQLReady"

mysqloo.GetDatabase = mysqloo.GetDB
mysqloo.GetDataBase = mysqloo.GetDB


function mysqloo.CreateTable(db, name, ...)

	if isstring(db) then 	--database is optional; it'll just use default
		name = db
		db = rsDB
	end

	local q = "CREATE TABLE IF NOT EXISTS `%s` (%s)"
	local args = {...}

	local qargs = ""

	if args[1] then
		if not IsArgList(args[1]) then
			for k, v in ipairs(args) do
				qargs = qargs .. v
				if next(args, k) then qargs = qargs .. "," end
			end
		else
			qargs = tostring(args[1])
		end
	end

	q = q:format(name, qargs)

	local query = db:query(q)

	query.onError = function(self, err)
		print("Error while creating table!", err)
	end

	query:start()
end



concommand.Add("reconnect_mysql", function(p)
	if IsValid(ply) and not ply:IsSuperAdmin() then return end

	rsDB = mysqloo.connect(unpack(__MYSQL_INFO))

	rsDB.onConnected = function(self)
		hook.Run("OnMySQLReady", self)
	end

	rsDB:connect()

end)


function mysql.quote(db, str)
	return "'" .. db:escape(str) .. "'"
end