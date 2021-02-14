LibItUp.SetIncluded()
if not CheckArg then include("lua.lua") end -- lol

local modules = {}

function LogModule(name, col)
	name = name or "[Unnamed]"

	if modules[name] then 
		modules[name].col = col or modules[name].col
		return modules[name]
	end

	modules[name] = {name = name, col = col or Colors.Sky}
	return modules[name]
end


-- you may use '[col = 255, 0, 0]' (ambigous spaces) to color up the logs
function Log(mod, str, ...)
	mod = mod or {name = "No module! " .. debug.traceback(), col = Color(255, 255, 255)}
	local n = mod.name or "???"
	local col = mod.col or Color(255, 0, 0)

	str = isstring(str) and str:format(...) or table.concat({...}, "	")

	local tbl = {
		col,
		("[%s] "):format(n),
		Color(255, 255, 255)
	}

	local str2 = str

	local tags = str:match("%b[]")

	if tags then
		local lastsub = 0

		for s in str:gmatch("%[(.-)%]") do --match color tags
			local r, g, b = s:match("col[%s]*=[%s]*(%d+),[%s]*(%d+),[%s]*(%d+)")

			if r or g or b then

				local where, ends = string.find(str2, s, 1, true)
				str2 = str2:gsub(s, "")

				tbl[#tbl + 1] = string.sub(str2, lastsub+1, where-2)

				tbl[#tbl + 1] = Color(r, g or 0, b or 0)
				lastsub = where
			end
		end

		tbl[#tbl + 1] = string.sub(str2, lastsub+1, #str2)
	else
		tbl[#tbl + 1] = str
	end

	tbl[#tbl + 1] = color_white:Copy()
	tbl[#tbl + 1] = "\n"


	MsgC(unpack(tbl))

end

-- create a logger function with your log module
function Logger(name, col)
	local mod = LogModule(name, col)

	return function(...)
		return Log(mod, ...)
	end
end

function Realm(lower, side)
	local s = (CLIENT and "Client" or "Server") .. (side and "side" or "")
	if lower then return s:lower() end
	return s
end

function Rlm(lower)
	if lower then
		return CLIENT and "cl" or "sv"
	else
		return CLIENT and "CL" or "SV"
	end
end

function clPrint(...)
	if CLIENT then print(...) end
end
clprint = clPrint
function svPrint(...)
	if SERVER then print(...) end
end
svprint = svPrint


LibItUp.LogIDs = LibItUp.LogIDs or {}
function CreateLogID(id, str, types)
	CheckArg(1, id, "string")
	CheckArg(2, str, "string")
	CheckArg(3, types, {})

	local m = LogModule(id, Colors.Warning)
	m.FormatStr = str
	m.Types = types

	LibItUp.LogIDs[id] = m
end

CreateLogID("log-idless", "Attempted to log a string with non-existent ID: %s", {""})

if CLIENT then
	-- todo: this will send the stuff to the server
	function clLog(id, ...)
		if not LibItUp.LogIDs[id] then
			clLog("log-idless", id)
			return
		end

		-- todo: typecheck ... here

		Log(LibItUp.LogIDs[id], LibItUp.LogIDs[id].FormatStr, ...)
	end
end