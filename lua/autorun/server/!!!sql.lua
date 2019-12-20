
require("mysqloo")

__MYSQL_INFO = {"127.0.0.1", "root", "31415", "master"}

mysql = mysqloo


rsDB = mysqloo.connect(unpack(__MYSQL_INFO))
rsDB:connect()

function mysqloo.GetDB()
	return rsDB
end

mysqloo.HookName = "OnMySQLReady"

mysqloo.GetDatabase = mysqloo.GetDB 
mysqloo.GetDataBase = mysqloo.GetDB

function mysqloo.CreateTable(name, ...)
	local q = "CREATE TABLE IF NOT EXISTS `%s` (%s)"
	local args = {...}

	local qargs = ""

	for k, v in ipairs(args) do
		qargs = qargs .. v
		if next(args, k) then qargs = qargs .. "," end
	end

	q = q:format(name, qargs)	--i just hope i'll escape it properly...

	local query = rsDB:query(q)

	query.onError = function(self, err)
		print("Error while creating table!", err)
	end

	query:start()
end



concommand.Add("reconnect_mysql", function(p) 

	if IsValid(ply) and not ply:IsSuperAdmin() then return end
	rsDB = mysqloo.connect(unpack(__MYSQL_INFO))
	rsDB:connect()
	print("Reconnecting to MySQL...")

end)
hook.Run("OnMySQLReady")