
require("mysqloo")

__MYSQL_INFO = {"127.0.0.1", "root", "31415", ""}

mysql = mysqloo
mysqloo.Info = __MYSQL_INFO
mysqloo.__OnConnectCallbacks = {}
mysqloo.__masterSchemaExists = mysqloo.__masterSchemaExists or false

--[[if mysqloo.GlobalDatabase and mysqloo.GlobalDatabase:status() == 0 then
	mysqloo.GlobalDatabase:disconnect() --bye bye monkey
end]]


local err = Logger("MySQL ERROR", Color(230, 120, 120))

local rsDB


local function connect(ply)
	if ply and IsPlayer(ply) and not ply:IsSuperAdmin() then return false end
	if rsDB and rsDB:status() == 0 then rsDB:disconnect() end

	rsDB = mysqloo.connect(unpack(__MYSQL_INFO))

	rsDB.onConnected = function(self)
		local q = self:query("CREATE DATABASE IF NOT EXISTS master; USE master")

		q.onSuccess = function()
			mysqloo.__masterSchemaExists = true
			hook.Run("OnMySQLReady", self)
			if mysqloo.__OnConnectCallbacks then
				for k,v in ipairs(mysqloo.__OnConnectCallbacks) do
					v[1](unpack(v, 2))
				end
				mysqloo.__OnConnectCallbacks = nil
			end
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

concommand.Add("mysql_reconnect", connect)

if not mysqloo.GlobalDatabase then
	connect()
end

function mysqloo.GetDB()
	return mysqloo.GlobalDatabase
end

-- use as q.onError = mysqloo.QueryError
function mysqloo.QueryError(q, errstr, qstr)
	err("Query error!\n	\"%s\"\n\n	Query: \"%s\"\n	Trace: %s",
						errstr, 			qstr, 			debug.traceback())
end

mysqloo.HookName = "OnMySQLReady"

mysqloo.GetDatabase = mysqloo.GetDB
mysqloo.GetDataBase = mysqloo.GetDB


function mysqloo.CreateTable(db, name, ...)

	if isstring(db) then 	--database is optional; it'll just use default
		name = db
		db = mysqloo.GlobalDatabase
	end

	if db == nil then
		if mysqloo.GlobalDatabase then -- db == nil due to user error
			errorf( "mysqloo.CreateTable: no database supplied (%s, %s; %s)",
				db, name, table.concat({...}, ", ") )
			return
		else	-- db == nil due to global database not being initialized yet
			err("Attempted to create table `%s` before global database init. Attempting to recover...", name)
			mysqloo.OnConnect(mysqloo.CreateTable, name, ...)
			return false
		end
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

	local em = MySQLEmitter(db:query(q), true)
		:Catch(mysqloo.QueryError)

	return em
end

function mysqloo.OnConnect(cb, ...)
	if mysqloo.GlobalDatabase and mysqloo.GlobalDatabase:status() == 0 and mysqloo.__masterSchemaExists then
		cb(...)
	else
		table.insert(mysqloo.__OnConnectCallbacks, {cb, ...})
	end
end

function mysql.quote(db, str)
	return "'" .. db:escape(str) .. "'"
end