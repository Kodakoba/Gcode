function file.Here(lv)
	lv = lv or 2
	local source = debug.getinfo(lv).source

	return source:match(".+/lua/(.+/).+%.lua")
end

function file.Me(lv)
	lv = lv or 2
	local source = debug.getinfo(lv).source

	return source:match(".+/lua/.+/(.+%.lua)")
end



function file.GetFile(path)
	return path:match("[^/]+$")
end

-- matches / at the end too
function file.GetPath(path)
	return path:match("(.+/).+") or ""
end

function file.ForEveryFile(path, where, func, recurse)

	local wildcard = path:match("[^/]+$")
	local path = file.GetPath(path)

	if isfunction(where) then
		recurse = func
		func = where
		where = "LUA"
	end

	local files, folders = file.Find(path .. wildcard, where)

	for k,v in ipairs(files) do
		local full_path = path .. v
		func(full_path)
	end

	if recurse ~= false then
		for k,v in ipairs(folders) do
			file.ForEveryFile(path .. v .. "/" .. wildcard, where, func, true)
		end
	end
end

function file.ForEveryFolder(path, func)

end

function file.ForEvery(path, func)

end