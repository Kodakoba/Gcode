local fn = "_server_settings.txt"
local jsonDat = file.Read(fn, "DATA")
local dat = jsonDat and util.JSONToTable(jsonDat) or {}

if not file.Exists(fn, "DATA") then
	file.Write(fn, util.TableToJSON({}))
end

Settings = Settings or {}
Settings.Table = dat


function Settings.Get(k, v)
	return (dat[k] ~= nil and dat[k]) or v
end

function Settings.Set(k, v)
	dat[k] = v
	if not timer.Exists("SettingsFlush") then
		timer.Create("SettingsFlush", 3, 1, Settings.Flush)
	end
end

function Settings.Flush()
	local json = util.TableToJSON(dat, true)
	file.Write(fn, json)
end