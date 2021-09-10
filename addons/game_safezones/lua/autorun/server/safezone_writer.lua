local ps = {
	Spawn = {
		[1] = Vector (-207, -1488.9, 59),
		[2] = Vector (1341, -365, -195)
	}
}

Safezones = Safezones or {}
Safezones.Brushes = Safezones.Brushes or {}
Safezones.Points = Safezones.Points or {}

file.CreateDir("safezones")

function Safezones.Write(map, tbl)
	map = map or game.GetMap()
	file.Write("safezones/" .. map .. ".dat", util.TableToJSON(tbl or Safezones.Points))
end

function Safezones.Read(map)
	map = map or game.GetMap()
	local json = file.Read("safezones/" .. map .. ".dat", "DATA")

	if not json then
		ErrorNoHalt("No safezones found for map: " .. map .. "\n")
		return
	end

	local dat = util.JSONToTable(json)

	for name, vecs in pairs(dat) do
		OrderVectors(vecs[1], vecs[2])
	end

	table.Empty(Safezones.Points)

	for k,v in pairs(dat) do
		Safezones.Points[k] = v
	end
end


--WriteSafezones(nil, ps)
Safezones.Read()

if Safezones.Reload then
	Safezones.Reload()
end