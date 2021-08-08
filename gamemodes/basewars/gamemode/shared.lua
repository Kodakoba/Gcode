GM.Name 		= "BaseWars"

GM.Author 		= "Original: Q2F2, Ghosty, Liquid, Tenrys, Trixter, User4992\nModded: gachirmx"

GM.Credits		= [[
Original:

	Thanks to the following people:
		Q2F2			- Main backend dev.
		Ghosty			- Main frontent dev.
		Trixter			- Frontend + Several entities.
		Liquid			- Misc dev, good friend.
		Tenrys			- Misc dev, good friend also.
		Pyro-Fire		- Owner of LagNation, ideas ect.
		Devenger		- Twitch Weaponry 2
		User4992		- Fixes for random stuff.

	This GM has been built from scratch with almost no traces of the original BaseWars existing.
	2017 Re-released MIT version.
]]

GM.License = [[

basewars_free:
	Copyright (c) 2015-2017 Hexahedronic, Q2F2, Ghosty, Liquid, Tenrys, Trixter, User4992.

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Credits:
	]] .. GM.Credits .. [[

See GM.OGLicense for the basewars_free license.
See GM.OGCredits for the basewars_free credits.]]

local license = GM.License

GM.OGLicense = [[
Copyright (c) 2015-2017 Hexahedronic, Q2F2, Ghosty, Liquid, Tenrys, Trixter, User4992
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

GM.OGCredits = [[
Thanks to the following people:
	Q2F2			- Main backend dev.
	Ghosty			- Main frontent dev.
	Trixter			- Frontend + Several entities.
	Liquid			- Misc dev, good friend.
	Tenrys			- Misc dev, good friend also.
	Pyro-Fire		- Owner of LagNation, ideas ect.
	Devenger		- Twitch Weaponry 2
	User4992		- Fixes for random stuff.
This GM has been built from scratch with almost no traces of the original BaseWars existing.
2017 Re-released MIT version.
]]

GachiRP = true

function Deprecated()
	local str = [[!! Attempt to call deprecated function: "%s" !!]] .. "\n"

	local tr = debug.traceback()
	local caller

	local traced = false

	for s in string.gmatch(tr, "(%C+)%c") do

		if not isstring(s) then print(s, "not a string") return end
		for where, what in string.gmatch(s, "(.+) in (.+)") do
			if not caller then
				print(str:format(what))
				caller = what
			else
				if not traced then print("Stack traceback: \n") traced = true end
				local str = [[	From: %s
	What: %s]] .. "\n"
				print(str:format(where, what))
			end
		end

	end

end

--[[
	thank you based volvo

	[10:18 PM] code_gs: some CNetworkVars delay in their sending
	[10:18 PM] code_gs: Idk what the conditions or flags for that are but I noticed it a while ago
]]

local ENTITY = FindMetaTable("Entity")

__SetHealth = __SetHealth or ENTITY.SetHealth

ENTITY.SetHealth = function(self, hp)
	if self:GetClass() == "prop_physics" then
		self:SetDTInt(30, hp)
	else
		return __SetHealth(self, hp)
	end
end

__Health = __Health or ENTITY.Health

ENTITY.Health = function(self)
	if self:GetClass() == "prop_physics" then
		return self:GetDTInt(30)
	else
		return __Health(self)
	end
end


function GM:GetGameDescription()
	return self.Name
end

function ents.FindInCone(cone_origin, cone_direction, cone_radius, cone_angle)

	local entities = ents.FindInSphere(cone_origin, cone_radius)
	local result = {}

	cone_direction:Normalize()

	local cos = math.cos(cone_angle)

	for _, entity in next, entities do

		local pos = entity:GetPos()
		local dir = pos - cone_origin
		dir:Normalize()

		local dot = cone_direction:Dot(dir)

		if dot > cos then

			table.insert(result, entity)

		end

	end

	return result

end

--ents.FindInCone = Deprecated

function BaseWars.IsXmasTime(day)

	local Month = tonumber(os.date("%m"))
	local Day	= tonumber(os.date("%d"))

	return Month == 12 and (not day or (Day == 24 or Day == 25))

end

BaseWars.IsXmasTime = Deprecated

function BaseWars.AddToSpawn(t)

	t.Limit = t.Limit or BaseWars.Config.DefaultLimit

	t.Price = t.Price or 420
	t.Level = t.Level or 0

	t.Model = t.Model or "models/Humans/Group01/Male_Cheaple.mdl"
	t.ShouldFreeze = (t.Gun and false) or (t.ShouldFreeze == nil and true) or t.ShouldFreeze
	t.Name = t.Name or "???"
	if not t.ClassName then error("look i'd put up with your shit like not setting limits or price but NOT CLASS NAME???") return end

	return t

end

BASEWARS_NOTIFICATION_ADMIN = color_white
BASEWARS_NOTIFICATION_ERROR = Color(255, 0, 0, 255)
BASEWARS_NOTIFICATION_MONEY = Color(0, 255, 0, 255)
BASEWARS_NOTIFICATION_RAID 	= Color(255, 255, 0, 255)
BASEWARS_NOTIFICATION_GENRL = Color(255, 0, 255, 255)
BASEWARS_NOTIFICATION_DRUG	= Color(0, 255, 255, 255)

local tag = "BaseWars.UTIL"

BaseWars.UTIL = {}

local colorRed 		= Color(255, 0, 0)
local colorBlue 	= Color(0, 0, 255)
local colorWhite 	= Color(255, 255, 255)

local function Pay(ply, amt, name, own)

	ply:Notify(string.format(own and Language.PayOutOwner or Language.PayOut, BaseWars.NumberFormat(amt), name), BASEWARS_NOTIFICATION_GENRL)

	ply:GiveMoney(amt)

end

function BaseWars.UTIL.PayOut(ent, attacker, full, ret)

	if not IsValid(ent) or not (IsValid(attacker) and attacker:IsPlayer()) then return 0 end

	if not ent.CurrentValue then ErrorNoHalt("ERROR! NO CURRENT VALUE! CANNOT PAY OUT!\n") return 0 end

	local Owner = IsValid(ent) and ent.CPPIGetOwner and IsValid(ent:CPPIGetOwner()) and ent:CPPIGetOwner()
	local Val = ent.CurrentValue * (not full and not ret and BaseWars.Config.DestroyReturn or 1)

	if Val ~= Val or Val == math.huge then

		ErrorNoHalt("NAN OR INF RETURN DETECTED! HALTING!\n")
		ErrorNoHalt("...INFINITE MONEY GLITCH PREVENTED!!!\n")

	return 0 end

	if ret then return Val end

	local Name = ent.PrintName or ent:GetClass()

	if ent.IsPrinter then Name = Language("Level", ent:GetLevel()) .. " " .. Name end

	if attacker == Owner then

		Pay(Owner, Val, Name, true)

	return 0 end

	local Members = attacker:FactionMembers()
	local TeamAmt = table.Count(Members)
	local Involved = Owner and TeamAmt + 1 or TeamAmt

	local Fraction = math.floor(Val / Involved)

	if #Members > 1 then

		for k, v in next, Members do

			Pay(v, Fraction, Name)

		end

	else

		Pay(attacker, Fraction, Name)

	end

	if Owner then

		Pay(Owner, Fraction, Name, true)

	end

	return Val

end

function BaseWars.UTIL.RefundAll(ply, ret)

	if not ply and not ret then print('//FULL SERVER REFUND IN PROGRESS//') end

	local RetTbl = {}

	if ret then

		for k, v in next, player.GetAll() do

			RetTbl[v:SteamID64()] = 0

		end

	end

	for k, v in next, ents.GetAll() do

		if not IsValid(v) then continue end

		local Owner = v:CPPIGetOwner()

		if not Owner or (ply and ply ~= Owner) or not IsValid(Owner) then continue end

		if not v.CurrentValue then continue end

		if not ret then

			BaseWars.UTIL.PayOut(v, Owner, true, ret)
			v:Remove()

		else

			RetTbl[Owner:SteamID64()] = RetTbl[Owner:SteamID64()] + BaseWars.UTIL.PayOut(v, Owner, true, ret)

		end

	end

	return RetTbl

end

function BaseWars.UTIL.WriteCrashRollback(recover)

	--[[	if recover then

			if file.Exists("server_crashed.dat", "DATA") then

				print("Server crash detected, converting data rollbacks into refund files!")

			else

				return

			end

			local Files = file.Find("basewars_crashrollback/*_save.txt", "DATA")

			for k, v in next, Files do

				local FileName = v:gsub("_save.txt", "")
				local FileData = file.Read("basewars_crashrollback/" .. v, "DATA")

				file.Write("basewars_crashrollback/" .. FileName .. "_load.txt", FileData)

			end

		return end

	local RefundTable = BaseWars.UTIL.RefundAll(nil, true)

	for k, v in next, RefundTable do

		if not file.IsDir("basewars_crashrollback", "DATA") then file.CreateDir("basewars_crashrollback") end

		file.Write("basewars_crashrollback/" .. tostring(k) .. "_save.txt", v)

	end

	file.Write("server_crashed.dat", "")
	]]
	
end

function BaseWars.UTIL.RefundFromCrash(ply)

	--[[

	local UID = ply:SteamID64()
	local FileName = "basewars_crashrollback/" .. UID .. "_load.txt"

	if file.Exists(FileName, "DATA") then

		local Money = file.Read(FileName, "DATA")
		Money = tonumber(Money)
		if not Money then file.Delete(FileName) return end
		ply:ChatPrint(Language.WelcomeBackCrash)
		ply:ChatPrint(Language("Refunded", BaseWars.NumberFormat(Money)))

		print("Refunding ", ply, " for server crash previously.")
		ply:GiveMoney(Money)

		file.Delete(FileName)

	end

	]]

end

function BaseWars.UTIL.ClearRollbackFile(ply)

	local UID = ply:UniqueID()
	local FileName = "basewars_crashrollback/" .. UID .. "_save.txt"

	if file.Exists(FileName, "DATA") then file.Delete(FileName) end

end

function BaseWars.UTIL.SafeShutDown()

	BaseWars.UTIL.RefundAll()

	local Files = file.Find("basewars_crashrollback/*_save.txt", "DATA")

	for k, v in next, Files do

		file.Delete("basewars_crashrollback/" .. v)

	end

	file.Delete("server_crashed.dat")

end

function BaseWars.UTIL.FreezeAll()

	for k, v in next, ents.GetAll() do

		if not IsValid(v) then continue end

		local Phys = v:GetPhysicsObject()
		if not IsValid(Phys) then continue end

		Phys:EnableMotion(false)

	end

end

local NumTable = {
	[5] = {10^6 , "Million"},
	[4] = {10^9 , "Billion"},
	[3] = {10^12, "Trillion"},
	[2] = {10^15, "Quadrillion"},
	[1] = {10^18, "Quintillion"},
}

function BaseWars.NumberFormat(num)

	for i = 1, #NumTable do

		local Div = NumTable[i][1]
		local Str = NumTable[i][2]

		if num >= Div or num <= -Div then

			return string.Comma2(math.Round(num / Div, 1)) .. " " .. Str

		end

	end

	return string.Comma2(math.Round(num))

end

local PlayersCol = Color(125, 125, 125, 255)
team.SetUp(1, "No Faction", PlayersCol)

function GM:PlayerNoClip(ply)

	local Admin = ply:IsAdmin() or ply:IsSuperAdmin()

	if SERVER then

		-- Second argument doesn't work??
		local State = ply:GetMoveType() == MOVETYPE_NOCLIP

		if aowl and not Admin and State and not ply.__is_being_physgunned then

			return true

		end

	end

	return Admin and not ply:InRaid()

end

local function BlockInteraction(ply, ent, ret)

	if ent then

		if not IsValid(ent) then return false end

		local Classes = BaseWars.Config.PhysgunBlockClasses
		if Classes[ent:GetClass()] then return false end

		local Owner = ent.CPPIGetOwner and ent:CPPIGetOwner()

		if IsPlayer(ply) and ply:InRaid() then return false end
		if IsPlayer(Owner) and Owner:InRaid() then return false end

	else

		if ply:InRaid() then return false end

	end

	return ret == nil or ret

end

local function IsAdmin(ply, ent, ret)

	if BlockInteraction(ply, ent, ret) == false then return false end

	return ply:IsAdmin()

end

function GM:PhysgunPickup(ply, ent)

	local Ret = self.BaseClass:PhysgunPickup(ply, ent)

	if ent:IsVehicle() then return IsAdmin(ply, ent, Ret) end

	return BlockInteraction(ply, ent, Ret)

end

function GM:CanPlayerUnfreeze(ply, ent, phys)

	local Ret = self.BaseClass:CanPlayerUnfreeze(ply, ent, phys)

	return BlockInteraction(ply, ent, Ret)

end

function GM:CanTool(ply, tr, tool)

	local Ret = self.BaseClass:CanTool(ply, tr, tool)

	if BaseWars.Config.BlockedTools[tool] then return IsAdmin(ply, ent, Ret) end
	if IsValid(tr.Entity) and tr.Entity:GetClass():find("bw_") then return IsAdmin(ply, ent, Ret) end

	return BlockInteraction(ply, ent, Ret)

end

function GM:CanDrive()
	return false
end

function GM:OnPhysgunReload()
	return false
end

function GM:CanProperty(ply, prop, ent, ...)

	local Ret = self.BaseClass:CanProperty(ply, prop, ent, ...)
	local Class = ent:GetClass()

	if prop == "persist" 	then return false end
	if prop == "ignite" 	then return false end
	if prop == "extinguish" then return IsAdmin(ply, ent, Ret) end

	if prop == "remover" and Class:find("bw_") then return IsAdmin(ply, ent, Ret) end

	return BlockInteraction(ply, ent, Ret)

end

function GM:GravGunPunt(ply, ent)

	local Ret = self.BaseClass:GravGunPunt(ply, ent)
	local Class = ent:GetClass()

	if ent:IsVehicle() then return false end

	if Class == "prop_physics" then return false end

	return BlockInteraction(ply, ent, Ret)

end

local NoSounds = {
	"vo/engineer_no01.mp3",
	"vo/engineer_no02.mp3",
	"vo/engineer_no03.mp3",
}
function GM:PlayerSpawnProp(ply, model)

	local Ret = self.BaseClass:PlayerSpawnProp(ply, model)

	local EscapedModel = model:lower():gsub("\\","/"):gsub("//", "/"):Trim()
	if BaseWars.Config.ModelBlacklist[EscapedModel] then

		ply:EmitSound(NoSounds[math.random(1, #NoSounds)], 140)

	return end

	Ret = (Ret == nil or Ret)

	return Ret == nil or Ret

end

local Lerp = Lerp
local FrameTime = FrameTime
local IsColor = IsColor

local Color = Color

function LC(col, dest, vel)
	local v = 10
	if not IsColor(col) or not IsColor(dest) then return end
	if isnumber(vel) then v = vel end
	local r = Lerp(FrameTime()*v, col.r, dest.r)
	local g = Lerp(FrameTime()*v, col.g, dest.g)
	local b = Lerp(FrameTime()*v, col.b, dest.b)
	return Color(r,g,b)
end

function L(s, d, v, pnl)
	if not v then v = 5 end
	if not s then s = 0 end
	local res = Lerp(FrameTime()*v, s, d)
	if pnl then
		local choose = res>s and "ceil" or "floor"
		res = math[choose](res)
	end
	return res
end