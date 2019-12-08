
sql.Debugging = true 

function sql.isPlayer(ply)
	local ch1 = (ply and isentity(ply) and IsValid(ply))
	local ch2 = false 
	local sid = nil
	if ch1 then ch2=ply:IsPlayer() else return false end
	if ch2 then sid = ply:SteamID64() end

    return (ch1 and ch2 and sid) or false
    
end

function sql.Check(query, expectres)
	local res = sql.Query(query)

	if res==nil and expectres then 
		if sql.Debugging then 
			print('SQL Error(?): expected a result, got nil instead.\nQuery: '..query)
		end
		return false, false
	end

	if res==false then print('SQL Error: \nQuery: ' .. query .. ' \n Error: ' .. sql.LastError()) return false, true end

	if expectres then return res end
end

local musq = "CREATE TABLE IF NOT EXISTS HUDMus(URL TEXT, Name TEXT)" 

sql.Check(musq)

local PLAYER = debug.getregistry().Player 
