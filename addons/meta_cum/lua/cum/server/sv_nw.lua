--123
util.AddNetworkString("CUM")

local args = {
	["p"] = "Player",
	n = "number",
	s = "string",
	e = "Entity",
	d = "Description"
}

local props = {
	s = "silent",
	a = "args",
	d = "Description",
}

local backargs = table.KeysToValues(args)
local backprops = table.KeysToValues(props)

function CUM.NetworkRanks(ply)

end 

function CUM.NetworkCommands(ply)
	local nw = {}

	for catname, cmds in pairs(CUM.Cats) do 
		local cat = {}
		nw[catname] = cat

		for k,_ in pairs(cmds) do 
			local v = CUM.cmds[k]

			if not v then local str = "[CUM-NW] didn't find command \"%s\" located in category \"%s\""  print(str:format(k, catname)) continue end 

			local cmd = {}
			cat[k] = cmd

			local args = {} 
			cmd.args = args 

			for k,v in pairs(v.Args) do 
				local val = backargs[v.type] or v.type
				local tbl = {t = val}
				if v.desc then tbl.desc = v.desc end
				args[k] = tbl
			end

			cmd.silent = v.Silent or false
			cmd.Description = v.Description
			--fill up the table ^

			--shorten the keys V

			for k,v in pairs(cmd) do
				if backprops[k] then
					cmd[backprops[k]] = v 
					cmd[k] = nil 
				end
			end

		end 	

	end

	local js = util.TableToJSON(nw)
	local comp = util.Compress(js)

	if #comp > #js then comp = js end 

	net.Start("CUM")
		net.WriteUInt(1, 4)
		net.WriteUInt(#comp, 32)
		net.WriteData(comp, #comp)
	net.Send(ply)
end 

hook.Add("PlayerFullyLoaded", "CUM.Ranks", function(ply)
	print(ply, "loaded")
	if not ply:IsAdmin() then return end 

	if ply:IsSuperAdmin() then 
		CUM.NetworkRanks(ply)
	end 
	CUM.NetworkCommands(ply)
end)