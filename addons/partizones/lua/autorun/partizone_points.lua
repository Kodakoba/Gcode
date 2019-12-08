


local ip = function(ent) return IsValid(ent) and ent:IsPlayer() end
if SERVER then
	util.AddNetworkString("Partizone")
	util.AddNetworkString("NoBasingDumbass")
end

local path = "partizones/"

local _CL = 1 
local _SH = 2
local _SV = 3

local function IncludeLuaFolder(name, realm, nofold)

	local file, folder = file.Find(path .. name, "LUA" )

	local tbl = string.Explode("/", name)
	tbl[#tbl] = ""

	local fname = table.concat(tbl,"/")

	for k,v in pairs(file) do
		local name = path .. fname

		if realm==_CL then 

			if SERVER then 
				AddCSLuaFile(name..v)
			end

			if CLIENT then 
				include(name..v)
			end

		elseif realm == _SH then 

			include(name..v)
			AddCSLuaFile(name..v)

		elseif realm == _SV and SERVER then 
			
			include(name..v)
		else
			ErrorNoHalt("Could not include file " .. name .. "; fucked up realm?")
			continue
		end

	end

	if not nofold then
		for k,v in pairs(folder) do
			IncludeFolder(name..v, realm)
		end
	end
	
end



PartizoneMusic = {
	[1] = {
		url = {"https://b.vaati.net/a1f7.mp3", "http://vaati.net/Gachi/shared/DropItLikeItsGachi.mp3"}, 
		name = {"Mystery", "DropItLikeItsSuction"}, 
		pos = Vector(-4543.2329101563, -4843.0903320313, 250.4676361084), 
		maxvol = 0.6, 
		fademin = 512, 
		fademax = 1024
	},

	[2] = {
		url = {"http://vaati.net/Gachi/shared/PrettyNiceDayLoope.mp3"}, 
		name = {"NiceDay"}, 
		pos = Vector(-7187.9111328125, -9354.96875, 192.23675537109),
		think = function()

			if not IsValid(elev) then 

				for k,v in pairs(ents.FindInBox(PartizonePoints.Elevator[1], PartizonePoints.Elevator[2])) do 

					if IsValid(v) and v:GetClass():find("func_tracktrain") then 
						elev = v 
						break
					end

				end

			end
			if not IsValid(elev) then return end 

			return elev:GetPos() + Vector(-0.1640625, -45.96875, 124.2001953125)
		end, 
		maxvol = 1
	}
}

local function ParentZone(name, vec1, vec2)
	local tbl = istable(PartizonePoints[name]) and table.Copy(PartizonePoints[name])
	if not tbl then error('cant parent to ' .. name) return end 
	tbl[1] = vec1 
	tbl[2] = vec2
	return tbl
end


PartizonePoints = PartizonePoints or {}

IncludeLuaFolder("*.lua", _SH)
IncludeLuaFolder("server/*.lua", _SV)
IncludeLuaFolder("client/*.lua", _CL)

for k,v in pairs(PartizonePoints) do 
	OrderVectors(v[1], v[2])
end


if SERVER then

	hook.Add("InitPostEntity", "Parti", function()
		ReloadPartizones()
	end)
	if CurTime() > 20 then 
		ReloadPartizones()
	end
end
