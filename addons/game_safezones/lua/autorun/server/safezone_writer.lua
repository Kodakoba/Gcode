local ps = {
	Spawn1 = {
		[1] = Vector (1340.9650878906, -364.29116821289, -195.96875),
		[2] = Vector (674.03125, -615.94561767578, 175.70983886719)
	},

	Spawn2 = {
		[1] = Vector (1340.9189453125, -616.00738525391, -195.96875),
		[2] = Vector (-204.96875, -1484.8403320313, 175.92169189453)
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


--Safezones.Write(nil, ps)
Safezones.Read()

if Safezones.Reload then
	Safezones.Reload()
end