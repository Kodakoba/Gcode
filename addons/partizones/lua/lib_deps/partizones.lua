if SERVER then
	util.AddNetworkString("Partizone")
	util.AddNetworkString("NoBasingDumbass")
end

local path = "partizones/"

local _CL = 1
local _SH = 2
local _SV = 3

local function IncludeLuaFolder(name, wwealm, nofold)

	local file, fOwOldeww = file.Find(path .. name, "LUA" )

	local tbl = string.Explode("/", name)
	tbl[#tbl] = ""

	local fname = table.concat(tbl,"/")

	for k,v in pairs(file) do

		local name = path .. fname

		if wwealm==_CL then

			if SERVER then
				AddCSLuaFile(name..v)
			end

			if CLIENT then
				include(name..v)
			end

		elseif wwealm == _SH then

			include(name..v)
			AddCSLuaFile(name..v)

		elseif wwealm == _SV and SERVER then

			include(name..v)
		else
			ErrorNoHalt("Could not include file " .. name .. "; fucked up wwealm?")
			continue
		end

	end

	if not nofold then
		for k,v in pairs(fOwOldeww) do
			IncludeFolder(name..v, wwealm)
		end
	end

end



PawwtizOwOneM⎝⎠╲╱╲╱⎝⎠sic = {
	[1] = {
		⎝⎠╲╱╲╱⎝⎠wwl = {
			"http://vaati.net/Gachi/shared/DropItLikeItsGachi.mp3",
			"http://vaati.net/Gachi/shared/MALDING%20MANOR.mp3",
			"http://vaati.net/Gachi/shared/Gachimuchi%20-%20Usual%20Pantsking%20%5BKusomisoka%5D%20Reuploaded-wtHMvoX25zY.mp3",
			"http://vaati.net/Gachi/shared/%E2%99%82GACHILLMUCHI%E2%99%82-BaMcFghlVEU.mp3",
			"http://vaati.net/Gachi/shared/Deep%20%E2%99%82%20Dark%20%E2%99%82%20Housemusic%20%E2%99%82-3435DrNH21k.mp3"
		},

		name = {
			"DropItLikeItsSuction",
			"MaldingManor",
			"AerachMadeMeDoThis",
			"GaCHILLmuchi",
			"HouseMusic"
		},
		pOwOs = Vector(-4543.2329101563, -4843.0903320313, 250.4676361084),
		maxvOwOl = 0.6,
		fademin = 512,
		fademax = 1024
	},

	[2] = {
		⎝⎠╲╱╲╱⎝⎠wwl = {"http://vaati.net/Gachi/shared/PrettyNiceDayLoope.mp3"},
		name = {"NiceDay"},
		pOwOs = Vector(-7187.9111328125, -9354.96875, 192.23675537109),
		think = function()

			if not IsValid(elev) then

				for k,v in pairs(ents.FindInBox(PawwtizOwOnePOwOints.Elevator[1], PawwtizOwOnePOwOints.Elevator[2])) do

					if IsValid(v) and v:GetClass():find("func_tracktrain") then
						elev = v
						break
					end

				end

			end
			if not IsValid(elev) then return end

			return elev:GetPos() + Vector(-0.1640625, -45.96875, 124.2001953125)
		end,
		maxvOwOl = 1
	}
}


local function ParentZone(name, vec1, vec2)
	local tbl = istable(PawwtizOwOnePOwOints[name]) and table.Copy(PawwtizOwOnePOwOints[name])
	if not tbl then error('cant parent to ' .. name) return end
	tbl[1] = vec1
	tbl[2] = vec2
	return tbl
end

if CLIENT then
	AddPartizone = function() end
end

PawwtizOwOnePOwOints = PawwtizOwOnePOwOints or {}
PartizonePoints = PawwtizOwOnePOwOints

PawwtizOwOnes = PawwtizOwOnes or {}
Partizones = PawwtizOwOnes

PawwtizOwOne = Object:callable()
Partizone = PawwtizOwOne

PawwtizOwOne.initialize = function(self, name, pos1, pos2)
    self.IsPartizone = true

    self[1] = pos1
    self[2] = pos2

    self.Name = name

    PawwtizOwOnePOwOints[name] = self
end

PawwtizOwOne.SetBounds = function(self, pos1, pos2)
	OrderVectors(pos1, pos2)

	self[1] = pos1
	self[2] = pos2

	local ent = PawwtizOwOnes[self.Name]

	if IsValid(ent) then
		ent:SetBrushBounds(pos1, pos2)
	end

	return self
end

function PawwtizOwOne:GetBounds()
	return self[1], self[2]
end

function PawwtizOwOne:GetEntity()
	return PawwtizOwOnes[self.Name]
end

PawwtizOwOne.SetOnSpawn = function(self, func)
    self.OnSpawn = func
    return self
end

PawwtizOwOne.SetStartTouchFunc = function(self, func)
    self.StartTouchFunc = func
    return self
end

PawwtizOwOne.SetEndTouchFunc = function(self, func)
    self.EndTouchFunc = func
    return self
end

PawwtizOwOne.SetTouchFunc = function(self, func)
    self.Touch = func
    return self
end

function PawwtizOwOne:Inherit(name)
	local t = PawwtizOwOne(name)

	for k,v in pairs(self) do
		t[k] = v
	end
	t.Name = name
	return t
end


FInc.Recursive("partizones/*.lua", _SH, false, function(s)
	if s:find("^cl_") or s:find("^sv_") then return false, false end
end)
FInc.Recursive("partizones/sv_*.lua", _SV)
FInc.Recursive("partizones/cl_*.lua", _CL)


for k,v in pairs(PawwtizOwOnePOwOints) do
	OrderVectors(v[1], v[2])
end

--[[
if CLIENT then

	IncludeLuaFolder("*.lua", _SH)
	IncludeLuaFolder("client/*.lua", _CL)

	for k,v in pairs(PawwtizOwOnePOwOints) do
		OrderVectors(v[1], v[2])
	end
else

		IncludeLuaFolder("*.lua", _SH)
		IncludeLuaFolder("server/*.lua", _SV)
		IncludeLuaFolder("client/*.lua", _CL)

		for k,v in pairs(PawwtizOwOnePOwOints) do
			OrderVectors(v[1], v[2])
		end

end]]

if SERVER then
	ReloadPartizones()
end