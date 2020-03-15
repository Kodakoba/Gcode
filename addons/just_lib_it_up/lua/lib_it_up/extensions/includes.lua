FInc = {} --Fast Inclusion

local includes = {
	[_CL] = function(name)
		if SERVER then 
			AddCSLuaFile(name)
		else
			return include(name)
		end
	end,

	[_SH] = function(name)
		AddCSLuaFile(name)
		return include(name)
	end,


	[_SV] = function(name)
		if not SERVER then return end
		return include(name)
	end,

}

local needToInclude = {
	[1] = {[_CL] = true, [_SH] = true, [_SV] = false},
	[2] = {[_CL] = true, [_SH] = true, [_SV] = true} 	--even though server's _CL should be false it's actually true because the server needs to AddCSLua
}

local function Realm()
	return CLIENT and 1 or 2
end

local function NeedToInclude(realm)
	return needToInclude[Realm()][realm]
end

FInc.IncludeRealms = includes 

local BlankFunc = function() end 

function FInc.Recursive(name, realm, nofold, searchpath, callback)	--even though with "nofold" it's not really recursive
	if not NeedToInclude(realm) then return end
	callback = callback or BlankFunc 

	local file, folder = file.Find( searchpath or name, "LUA" )

	local path = name:match("(.+/).+$")
	local wildcard = name:match(".+/(.+)$")

	for k,v in pairs(file) do
		if not v:match(".+%.lua$") then continue end --if file doesn't end with .lua, ignore it

		if loading then files = files + 1 end

		local name = path .. v

		if includes[realm] then 
			callback (path, includes[realm] (name))
		else
			ErrorNoHalt("Could not include file " .. name .. "; fucked up realm?\n")
			continue
		end

	end

	if not nofold then 
		for k,v in pairs(folder) do
			-- path/ .. found_folder  .. /  .. wildcard_used

			-- muhaddon/newfolder/*.lua

			FInc.Recursive(path .. v .. "/" .. wildcard, realm, nil, nil, callback)
		end
	end

end


function FInc.NonRecursive(name, realm)
	return FInc.Recursive(name, realm, true)
end

function FInc.FromHere(name, realm, nofold)
	if not NeedToInclude(realm) then return end

	local where = debug.getinfo(2).source

	where = where:match(".+/lua/(.+)")

	if not where or where:sub(-4) ~= ".lua" then 
		local err = "FInc.FromHere called from invalid path! %s\n"
		err = err:format(where)

		ErrorNoHalt(err)
		return 
	end

	local path = where:match("(.+/).+%.lua$")	--get the path without the caller file

	if not path or #path < 1 then 
		local err = "FInc.FromHere couldn't get source file! %s ; matched to %s\n"
		err = err:format(where, path)

		ErrorNoHalt(err)
		return 
	end

	FInc.Recursive(name, realm, nofold, path .. name)
	
end


setmetatable(FInc, {__call = FInc.Recursive})
