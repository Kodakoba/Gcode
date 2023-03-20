StartTool("OreMark")

_OreData = _OreData or {}

file.CreateDir("inventory")
file.CreateDir("inventory/ores")

MARKER_WRITE = MARKER_WRITE or "ores"

local map = game.GetMap()

local function readOreData(force, where)
	local path = "inventory/ores/" .. map .. ".dat"
	if where then
		path = "mark/" .. where .. ".dat"
		file.CreateDir("inventory/" .. where .. "/")
	end

	if _OreData and (not force and not where) then return _OreData end

	local dat = file.Read(path, "DATA")

	if not dat then
		file.Write(path, "")
		return {}
	end


	_OreData = util.JSONToTable(dat) or {}

	if where == "ores" then
		Inventory.OresPositions = _OreData
	end

	return _OreData
end

readOreData(true)

local function writeOreData(where)
	local path = "inventory/ores/" .. map .. ".dat"

	if where then
		path = "mark/" .. where .. ".dat"
		file.CreateDir("mark/")
	end

	file.Write(path, util.TableToJSON(_OreData))

	if MARKER_WRITE == "ores" then
		Inventory.OresPositions = table.Copy(_OreData)
		OresRespawn()
	end
end

local nw = Networkable("Orepositions")
local bufs = nw.Buffers or muldim:new()
nw.Buffers = bufs

nw.AlreadyNetworkedPlyBuf = {}
nw.AlreadyNetworkedPos = {}

nw.Filter = function(self, ply)
	return ply:IsSuperAdmin()
end

function SetMarkerName(nm)
	table.Empty(bufs)
	-- table.Empty(nw.AlreadyNetworkedPlyBuf)
	-- table.Empty(nw.AlreadyNetworkedPos)

	MARKER_WRITE = nm

	local poses = readOreData(true, nm)
	PrintTable(poses)
	nw:Set("Positions", poses)
	nw:Network(true)

	_OreData = {}
end

nw:On("WriteChangeValue", 1, function(self, k, v, plyList)
	if not IsPlayer(k) and k ~= "Positions" then return end
	local isPos = k == "Positions"

	local alw = isPos and self.AlreadyNetworkedPos or self.AlreadyNetworkedPlyBuf

	self.AwarePlayers = self.AwarePlayers or {}

	local ignoreKnowledge = false

	for k,v in ipairs(plyList) do
		if not self.AwarePlayers[k] then ignoreKnowledge = true end
		self.AwarePlayers[k] = true
	end

	local toNW = {}
	local amt = 0

	for k, pos in pairs(v) do
		if alw[k] == pos and not ignoreKnowledge then continue end
		toNW[k] = pos
		amt = amt + 1
		alw[k] = pos
	end

	for k, _ in pairs(alw) do
		if not v[k] then
			toNW[k] = false
			alw[k] = nil
			amt = amt + 1
		end
	end

	net.WriteUInt(amt, isPos and 16 or 8)
	for k,v in pairs(toNW) do
		net.WriteUInt(k, isPos and 16 or 8)
		net.WriteBool(v and true or false)
		if v then net.WriteVector(v) end
	end

	return false
end)


local poses = readOreData()
nw:Set("Positions", poses)
nw:Network()


local v1 = Vector(4, 4, 4)
local v2 = -v1

local visv1
local visv2

local function closestIntersection(t, ep, fw)
	local hit, hitDist, key = nil, math.huge

	for k, v in pairs(t) do

		local vechit = util.IntersectRayWithOBB(ep, fw, v, angle_zero, v2, v1)
		if vechit then
			local dist = vechit:DistToSqr(v)

			if hitDist > dist then
				hit = v
				key = k
				hitDist = dist
			end
		end
	end

	return hit, key
end

function TOOL:LeftClick(tr)
	local where = tr.HitPos

	local ply = self:GetOwner()
	if not ply:IsSuperAdmin() then error("HOW ARE YOU EVEN ALLOWED") return end

	bufs:Insert(where, ply)

	if SERVER then
		nw:Set(ply, bufs[ply])
		nw:Network()
	end

	return true
end

function TOOL:Allowed()
	return self:GetOwner():IsSuperAdmin()
end

function TOOL:RightClick(tr)
	local ply = self:GetOwner()
	if not ply:IsSuperAdmin() then error("HOW ARE YOU EVEN ALLOWED") return end

	if ply:KeyDown(IN_WALK) and not ply:KeyDown(IN_SPEED) then

		if CurTime() - (ply.LastOreClear or 0) > 0.7 then
			ply.OresCleaned = 0
			return
		end

		ply.LastOreClear = CurTime()
		ply.OresCleaned = (ply.OresCleaned or 0) + 1

		if ply.OresCleaned == 2 then
			bufs[ply] = {}
			nw:Set(ply, bufs[ply])
			nw:Network()

			ply.OresCleaned = 0
		end
		return
	end

	ply.LastOreClear = CurTime()
	ply.OresCleaned = 0

	local ep = ply:EyePos()
	local fw = ply:EyeAngles():Forward() * 512

	local hit, key = closestIntersection(bufs:GetOrSet(ply), ep, fw)

	if hit then
		bufs[ply][key] = nil
		nw:Set(ply, bufs[ply])
		nw:Network()
	else
		local hit, key = closestIntersection(_OreData, ep, fw)
		local sure = ply:KeyDown(IN_WALK) and ply:KeyDown(IN_SPEED)
		if hit then
			if not sure then ply:ChatAddText(color_white, "Hold SHIFT + ALT if you want to", Colors.Red, " remove existing positions", color_white, ".") return end
			table.remove(_OreData, key)
			ply:ChatAddText(Colors.Red, "Removed existing position.")

			nw:Set("Positions", _OreData)
			nw:Network()

			timer.Create("OreSave", 2, 1, function() writeOreData(MARKER_WRITE) end)
		end
	end

	return true
end

function TOOL:Reload()
	local ow = self:GetOwner()
	if not ow:IsSuperAdmin() then error("HOW ARE YOU EVEN ALLOWED") return end

	local newPoses = bufs[ow]
	if not newPoses then return end

	local amt = 0

	for k,v in pairs(newPoses) do
		amt = amt + 1
		_OreData[#_OreData + 1] = v
	end

	writeOreData(MARKER_WRITE)

	printf("Player %s(%s) saved %d new ore positions.", ow:Nick(), ow:SteamID64(), amt)

	bufs[ow] = {}
	nw:Set(ow, bufs[ow])

	nw:Set("Positions", _OreData)
	nw:Network()
end

EndTool()