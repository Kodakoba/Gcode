function IncludeLuaFolder(name, realm, nofold)

	local file, folder = file.Find( name, "LUA" )

	local tbl = string.Explode("/", name)
	tbl[#tbl] = ""

	local fname = table.concat(tbl,"/")

	for k,v in pairs(file) do
		local name = fname

		if realm==_CL then 

			if SERVER then 
				AddCSLuaFile(name..v)
			end

			if CLIENT then 
				include(name..v)
			end

		elseif realm == _SH then 

			include(name..v)
			AddCSLuaFile(name..v)

		elseif realm == _SV and SERVER then 
			
			include(name..v)
		else
			ErrorNoHalt("Could not include file " .. name .. "; fucked up realm?")
			continue
		end

		modules = modules + 1
	end

	if not nofold then
		for k,v in pairs(folder) do
			IncludeFolder(name..v, realm)
		end
	end
	
end