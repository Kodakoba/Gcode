--hi

hook.Add("PlayerSay", "FuckOff", function(ply, txt)

end)

hook.Add("CheckPassword", "FuckOffIdiots", function(sid64, ip, pw1, pw2, name)
	if name == "#VAC_ConnectionRefusedDetail" and sid64 ~= "76561198101997214" then --eclipse steamid
		return false, "if i ever see you with that name you're getting permabanned"
	end
end)

todo = {}

sql.Check("CREATE TABLE IF NOT EXISTS todo(id INTEGER PRIMARY KEY AUTOINCREMENT, str TEXT NOT NULL DEFAULT '??', done INT DEFAULT 0)" )

function todo.Add(str)
	sql.Check("INSERT INTO todo(str) VALUES("..SQLStr(str)..");")
end

function todo.Get()
	local res = sql.Check("SELECT * FROM todo", true)
	return res 
end

function todo.Solve(id)
	sql.Check("UPDATE todo SET done = 1 WHERE id == " .. id .. ";")
end

function todo.Remove(id)
	sql.Check("DELETE FROM todo WHERE id == " .. id)
end

function todo.Print()
	local res = todo.Get()

	local todos = {}
	local done = {}

	for k,v in pairs(res) do 
		if v.done == "1" then 
			done[#done+1] = {txt = v.str, id = v.id}
			continue
		end
		todos[#todos+1] = {txt = v.str, id = v.id}
	end 

	table.sort(todos, function(a,b) 

		local id = (a.id > b.id)

		return id
	end)

	table.sort(done, function(a,b) 

		local id = (a.id > b.id)

		return id
	end)

	local str = "=====To-do list:=====\n"
	for k,v in pairs(todos) do 
		str = str .. v.txt .. " | ID: " .. v.id .. "\n"
	end 

	str = str .. "\n=====Finished=====\n"

	for k,v in pairs(done) do 
		str = str .. v.txt .. " | ID: " .. v.id .. "\n"
	end 

	print(str)
end

function todo.Addendum(id, s2)
	local res = sql.Check("SELECT str FROM todo WHERE id ==" .. id, true)
	if not res then return end

	local str = res[1].str 
	str = str .. "\nAddendum: " .. s2 .. "\n"
	sql.Check("UPDATE todo SET str =" .. SQLStr(str) .. " WHERE id ==" .. id)
end
