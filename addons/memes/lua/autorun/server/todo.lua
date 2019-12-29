--hi

hook.Add("PlayerSay", "FuckOff", function(ply, txt)

end)

hook.Add("CheckPassword", "FuckOffIdiots", function(sid64, ip, pw1, pw2, name)
	if name == "#VAC_ConnectionRefusedDetail" and sid64 ~= "76561198101997214" then --eclipse steamid
		return false, "if i ever see you with that name you're getting permabanned"
	end
end)

todo = {}

sql.Check("CREATE TABLE IF NOT EXISTS todo(id INTEGER PRIMARY KEY AUTOINCREMENT, str TEXT NOT NULL DEFAULT '??', done INT DEFAULT 0, adds INT DEFAULT 0)" )

function todo.Add(str)
	sql.Check("INSERT INTO todo(str) VALUES("..SQLStr(str)..");")

	local em = Embed()
	em:SetText("```\n" .. str .. "```"):SetTitle("Todo added"):SetColor(200, 200, 50)

	discord.SendEmbed("todo", "GachiRP", em)
end

function todo.Get()
	local res = sql.Check("SELECT * FROM todo", true)
	return res 
end

function todo.Solve(id)
	local res, err = sql.Check("UPDATE todo SET done = 1 WHERE id == " .. id .. "; SELECT str FROM todo WHERE id == " .. id, true)
	if not res then return end 

	local em = Embed()
	em:SetText("```\n" .. res[1].str .. "```\nSolved!"):SetTitle("Todo solved!"):SetColor(90, 210, 90)

	discord.SendEmbed("todo", "GachiRP", em)

end

function todo.Remove(id)
	local res = sql.Check("SELECT str, done FROM todo WHERE id == " .. id .. ";DELETE FROM todo WHERE id == " .. id, true)
	if not res then return end 

	local em = Embed()

	local done = tobool(res[1].done)
	local str = res[1].str

	em:SetText("```\n%s```\n%s.", str, (done and "Removed") or "Scrapped" ):SetTitle("Todo %s", (done and "Removed") or "Scrapped"):SetColor(240, 120, 120)

	discord.SendEmbed("todo", "GachiRP", em)
end

function todo.Print()
	local res = todo.Get()

	local todos = {}
	local done = {}

	for k,v in pairs(res) do 
		if v.done == "1" then 
			done[#done+1] = {txt = v.str, id = tonumber(v.id)}
			continue
		end
		todos[#todos+1] = {txt = v.str, id = tonumber(v.id)}
	end 

	table.sort(todos, function(a,b) 

		local id = (a.id < b.id)

		return id
	end)

	table.sort(done, function(a,b) 

		local id = (a.id < b.id)

		return id
	end)

	local str = "=====To-do list:=====\n"
	for k,v in pairs(todos) do 
		str = str .. v.txt .. " | ID: " .. v.id .. "\n\n"
	end 

	str = str .. "\n=====Finished=====\n"

	for k,v in pairs(done) do 
		str = str .. v.txt .. " | ID: " .. v.id .. "\n\n"
	end 

	print(str)
end

function todo.Addendum(id, s2)
	local res = sql.Check("SELECT str, adds FROM todo WHERE id ==" .. id, true)
	if not res then return end

	local str = res[1].str 
	local adds = tonumber(res[1].adds)

	local add = ("%sAddendum #%d: %s"):format( "\n", adds+1, s2 )

	str = str .. add

	sql.Check("UPDATE todo SET str =" .. SQLStr(str) .. ", adds = adds + 1 WHERE id ==" .. id)

	local em = Embed()
	em:SetText("```\n" .. str .. "```"):SetTitle("Todo addendum:"):SetColor(200, 200, 70)

	discord.SendEmbed("todo", "GachiRP", em)

end