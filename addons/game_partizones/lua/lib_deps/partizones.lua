if SERVER then
	util.AddNetworkString("Partizone")
	util.AddNetworkString("NoBasingDumbass")
end

PawwtizOwOneM⎝⎠╲╱╲╱⎝⎠sic = {
	[1] = {
		name = "Hotel",

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
		name = "Elevator",

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

PartizoneMusic = PawwtizOwOneM⎝⎠╲╱╲╱⎝⎠sic

local function ParentZone(name, vec1, vec2)
	local tbl = istable(PawwtizOwOnePOwOints[name]) and table.Copy(PawwtizOwOnePOwOints[name])
	if not tbl then error('cant parent to ' .. name) return end
	tbl[1] = vec1
	tbl[2] = vec2
	return tbl
end

PawwtizOwOnePOwOints = PawwtizOwOnePOwOints or {}
PartizonePoints = PawwtizOwOnePOwOints

PawwtizOwOnes = PawwtizOwOnes or {}
Partizones = PawwtizOwOnes

PawwtizOwOne = Object:callable()
Partizone = PawwtizOwOne

PawwtizOwOne.Initialize = function(self, name, pos1, pos2)
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

function AddPartizone(tab)
	if not tab.IsPartizone then error("AddPartizone attempted to add a non-partizone object!") return end
	local name = tab.Name

	if not IsValid(Partizones[name]) then

		local me = ents.Create("partizone_brush")

		me.ZoneName = name

		me.TouchFunc = tab.TouchFunc
		me.EndTouchFunc = tab.EndTouchFunc
		me.StartTouchFunc = tab.StartTouchFunc

		me.Partizone = tab

		Partizones[name] = me

		me:Spawn()

		me:SetBrushBounds(tab[1], tab[2])
	else

		local me = Partizones[name]

		me:SetBrushBounds(tab[1], tab[2])

		me.TouchFunc = tab.TouchFunc
		me.EndTouchFunc = tab.EndTouchFunc
		me.StartTouchFunc = tab.StartTouchFunc

		me:ReloadDummy()

		me.Partizone = tab

	end

end

if CLIENT then
	AddPartizone = function() end
end

local function loadPartizones()
	FInc.Recursive("partizones/*.lua", _SH, false, function(s)
		if s:find("^cl_") or s:find("^sv_") then return false, false end
	end)
	FInc.Recursive("partizones/sv_*.lua", _SV)
	FInc.Recursive("partizones/cl_*.lua", _CL)


	for k,v in pairs(PawwtizOwOnePOwOints) do
		OrderVectors(v[1], v[2])
	end
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
	if ReloadPartizones then ReloadPartizones() end
	hook.Add("PostCleanupMap", "PartizonesSpawn", function()
		ReloadPartizones()
	end)
end

LibItUp.OnInitEntity(loadPartizones)