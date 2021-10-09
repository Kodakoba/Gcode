local spawnTeles = {
	2460, -- teleporter, spawn -> out
	2459, -- destination, out of spawn

	2462, -- teleporter, out -> spawn
	2463  -- destination to spawn
}

local telePositions = {
	[2459] = {
		{
			Vector(-4029.8295898438, -5229.6474609375, 262.03125),
			Angle(1.7818146944046, -146.23651123047, 0),
		},
		{
			Vector(-7461.2104492188, -4836.1040039063, 136.03125),
			Angle(5.048816204071, -38.722328186035, 0),
		},
		{
			Vector(-9130.7197265625, -8089.9692382813, 184.52212524414),
			Angle(2.2570128440857, -17.100738525391, 0),
		},
		{
			Vector(-7488.3022460938, -9828.5810546875, 136.03125),
			Angle(1.7224137783051, 169.62937927246, 0),
		},
		{
			Vector(-7104.953125, -9894.08203125, 136.03125),
			Angle(1.5442117452621, 29.29062461853, 0),
		},
		{
			Vector(-4025.2705078125, -5234.5913085938, 262.03125),
			Angle(7.5436129570007, -137.89656066895, 0),
		},
	},
}

local cidToEnt = {}
local teleEnts = {}
local destEnts = {}
local teleToDest = {}
local destToTele = {}

local function regenerate()
	for i=1, #spawnTeles, 2 do
		local tele, dest = spawnTeles[i], spawnTeles[i + 1]

		cidToEnt[tele] = ents.GetMapCreatedEntity(tele)
		cidToEnt[dest] = ents.GetMapCreatedEntity(dest)

		teleEnts[tele] = cidToEnt[tele]
		destEnts[dest] = cidToEnt[dest]

		teleToDest[tele] = dest
		destToTele[dest] = tele
	end
end

local function changePos(ent)
	local poses = telePositions[ent:MapCreationID()]
	if not poses then print("no poses", ent, ent:MapCreationID()) return end

	local pos = poses[math.random(#poses)]

	while ent:GetPos():IsEqualTol(pos[1], 2) do
		pos = poses[math.random(#poses)]
	end

	ent:SetPos(pos[1])
	ent:SetAngles(pos[2])
end


local function SetupMapLua()
	regenerate()

	if IsValid(TTele_HackyLua) then TTele_HackyLua:Remove() end
	TTele_HackyLua = ents.Create( "lua_run" )
	TTele_HackyLua:SetName( "teletrig_hooker" )
	TTele_HackyLua:Spawn()

	for k, v in pairs( ents.FindByClass( "trigger_teleport" ) ) do
		v:Fire( "AddOutput", "OnStartTouch teletrig_hooker:RunPassedCode:hook.Run( 'OnTeleport' ):0:-1" )
	end

	for k,ent in pairs(destEnts) do
		changePos(ent)
	end
end

LibItUp.OnInitEntity(SetupMapLua)
hook.Add("PostCleanupMap", "SetupMapLua", SetupMapLua)

local acs = {}

hook.Add("OnTeleport", "TestTeleportHook", function()
	local ply = ACTIVATOR
	if acs[ply] == engine.TickCount() then return end
	acs[ply] = engine.TickCount()
	local teleID = CALLER:MapCreationID()
	local dest = teleToDest[teleID]
	if not dest then
		regenerate()
		dest = teleToDest[teleID]
	end

	local destEnt = dest and destEnts[dest]

	if not dest then
		ErrorNoHalt("failed to find destination ID for teleport " .. tonumber(teleID))
		return
	end

	if not destEnt then
		ErrorNoHalt("failed to find destination ent for destination ID " .. tonumber(dest))
		return
	end

	changePos(destEnt)
end)