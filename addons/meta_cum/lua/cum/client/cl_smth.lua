--123
local sargs = {
	p = "Player",
	n = "number",
	s = "string",
	e = "Entity",
}

local sprops = {
	s = "silent",
	a = "args",
	d = "Description",
}
function CUM.ParseCommands(dat)
	local decomp = util.Decompress(dat)
	if not decomp then decomp = dat end 

	local tbl = util.JSONToTable(decomp)

	for catname, cmds in pairs(tbl) do
		CUM.Cats[catname] = CUM.Cats[catname] or {}
		local cat = CUM.Cats[catname]

		for k,v in pairs(cmds) do
			
			for key, val in pairs(v) do 
				if sprops[key] then 
					v[sprops[key]] = val 
					v[key] = nil 
				end 
			end

			local cmd = {}

			if v.args then
				local args = {}
				for k,v in pairs(v.args) do
					args[k] = {type = (sargs[v.t]) or v.t, desc = v.desc}
				end 
				cmd.args = args
			end

			if v.Description then
				cmd.Description = v.Description
			end

			if v.silent then 
				cmd.silent = v.silent 
			end 

			cat[k] = cmd 

		end
	end
	
	print("Received:")
	print(decomp)
end

net.Receive("CUM", function(len)
	print("CUM commands len:", len/8)

	local type = net.ReadUInt(4)

	if type==1 then 
		local len = net.ReadUInt(32)
		CUM.ParseCommands(net.ReadData(len))
	end 

end)