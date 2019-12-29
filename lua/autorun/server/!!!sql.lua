
require("mysqloo")

__MYSQL_INFO = {"127.0.0.1", "root", "31415", "master"}

local Database = FindMetaTable("MySQLOO table")



mysql = mysqloo
mysqloo.Info = __MYSQL_INFO

rsDB = mysqloo.connect(unpack(__MYSQL_INFO))

rsDB.onConnected = function(self)
	hook.Run("OnMySQLReady", self)
end

rsDB:connect()



function mysqloo.GetDB()
	return rsDB
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

	for k, v in ipairs(args) do
		qargs = qargs .. v
		if next(args, k) then qargs = qargs .. "," end
	end

	q = q:format(name, qargs)	--i just hope i'll escape it properly...

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