BaseWars = BaseWars or {}

include("include.lua")

local AuthTbl = {}

function GM:NetworkIDValidated(name, steamid)

	AuthTbl[steamid] = name

end

function GM:PlayerInitialSpawn(ply)

	self.BaseClass:PlayerInitialSpawn(ply)

	BaseWars.UTIL.RefundFromCrash(ply)

	local f = function()

		if not AuthTbl[ply:SteamID()] then

			ply:ChatPrint(Language("FailedToAuth"))

			ply.UnAuthed = true

		else

			AuthTbl[ply:SteamID()] = nil

		end

	end

	timer.Simple(0, f)

	for k, v in next, ents.GetAll() do

		local Owner = (IsValid(v) and v.CPPIGetOwner and IsValid(v:CPPIGetOwner())) and v:CPPIGetOwner()
		local Class = v:GetClass()
		if Owner ~= ply or not Class:find("bw_") then continue end

		ply:GetTable()["limit_" .. Class] = (ply:GetTable()["limit_" .. Class] or 0) + 1

	end

	timer.Simple( 0, function() ply:SetTeam(1) end )

end

function GM:GetGameDescription()
	return self.Name
end

function GM:ShutDown()

	BaseWars.UTIL.SafeShutDown()

	self.BaseClass:ShutDown()

end

function GM:OnEntityCreated(ent)

	local f = function()

		self.BaseClass:OnEntityCreated(ent)

		local Class = IsValid(ent) and ent:GetClass()
		if Class == "prop_physics" and ent:Health() == 0 then

			local HP = (IsValid(ent:GetPhysicsObject()) and ent:GetPhysicsObject():GetMass() or 50) * BaseWars.Config.UniversalPropConstant
			HP = math.Clamp(HP, 0, 1000)

			ent:SetHealth(HP)

			ent.MaxHealth = math.Round(HP)
			ent.DestructableProp = true

			ent:SetNW2Int("MaxHealth", ent.MaxHealth)

			ent:SetMaxHealth(ent.MaxHealth)
				timer.Create("prop"..ent:EntIndex(),1,0,function() if !(ent:IsValid()) then return end ent:SetNW2Int("MaxHealth",ent.MaxHealth) end)

				function ent:OnRemove()
					timer.Remove("prop"..self:EntIndex())
				end

		end

	end

	timer.Simple(0, f)

end

function GM:SetupPlayerVisibility(ply)

	self.BaseClass:SetupPlayerVisibility(ply)

	for _, v in next, ents.FindByClass("bw_bomb_*") do

		if v.IsExplosive and v:GetNWBool("IsArmed") then

			AddOriginToPVS(v:GetPos())

		end

	end

end

function GM:PreCleanupMap()

	BaseWars.UTIL.RefundAll()

end

function GM:PostCleanupMap()

end

function GM:GetFallDamage(ply, speed)

	local Velocity = speed - 526.5

	return Velocity * 0.225

end

function GM:SetupMove(ply, move)

	local State = self.BaseClass:SetupMove(ply, move)

	if not ply:Alive() then

		return State

	end

	return State

end

local Jump = Sound("npc/zombie/claw_miss1.wav")
function GM:KeyPress(ply, code)

	self.BaseClass:KeyPress(ply, code)

	if code == IN_JUMP and (ply.Stuck and ply:Stuck()) and ply:GetMoveType() == MOVETYPE_WALK then

		ply:UnStuck()

	end

end

function GM:EntityTakeDamage(ent, dmginfo)

	local Player = ((IsValid(ent) and ent:IsPlayer()) and ent) or false
	if dmginfo:IsDamageType(DMG_BURN) and not Player then return true end

	local Owner = IsValid(ent) and ent.CPPIGetOwner and ent:CPPIGetOwner()
	Owner = (IsPlayer(Owner) and Owner) or false

	self.BaseClass:EntityTakeDamage(ent, dmginfo)

	local Inflictor = dmginfo:GetInflictor()
	local Attacker 	= dmginfo:GetAttacker()
	local Damage 	= dmginfo:GetDamage()

	local PropDamageScale = 0.5

	local IsProp = ent:GetClass() == "prop_physics"

	local raidRet = BaseWars.Raid.CanDealDamage(Attacker, ent, Inflictor, Damage)

	if raidRet ~= nil then
		return not raidRet
	end

	--[[
	if Owner then
		if not IsPlayer(Attacker) then return false end

		local IsOwner = Attacker == Owner

		local Enemy = IsOwner or Owner:IsEnemy(Attacker)

		local Cant1 = IsOwner and (Owner:InRaid() or IsProp)
		local Cant2 = not Enemy

		if not ent.AlwaysRaidable and (Cant1 or Cant2) then

			dmginfo:ScaleDamage(0)
			dmginfo:SetDamage(0)

		return false end

	end

	if not Owner and not Player and IsPlayer(Attacker) then --no owner; attacked isn't a player and attacker is a player
		local sid64 = ent.FPPSteamID64

		if sid64 then

			if BaseWars.Raid.WasInRaid(sid64) then --ononono you aint escaping the shame
				local sids = BaseWars.Raid.WasInRaid(sid64).SteamIDs

				local atk = Attacker
				local atkside = 0

				local ow = Owner
				local owside = 0

				for k,v in pairs(sids) do

					if k == sid64 then
						owside = v
					end

					if k == Attacker:SteamID64() then
						atkside = v
					end

				end

				if not (owside==2 and atkside==1) then --only (owner: raided, attacker: raider) gets a pass
					dmginfo:ScaleDamage(0)
					dmginfo:SetDamage(0)
					return false
				end

				if ent.DestructableProp then
					local hp = ent:Health()
					local ActualDmg = Damage * PropDamageScale
					hp = hp - ActualDmg

					if hp < 0 then
						ent:Remove()
						return
					end

					ent:SetHealth(hp)

					local M 		= hp / ent.MaxHealth
					local OldCol 	= ent:GetColor()
					local Color 	= Color(255 * M, 255 * M, 255 * M, OldCol.a)

					ent:SetColor(Color)

					return
				end

			else

				dmginfo:ScaleDamage(0)
				dmginfo:SetDamage(0)

				return false
			end

		end
	end
	

	if ent.DestructableProp then

		if not Owner then return end

		local IsOwner = Attacker == Owner

		local Enemy = IsOwner or Owner:IsEnemy(Attacker)

		local Cant1 = IsOwner and Owner:InRaid()
		local Cant2 = not Enemy

		if Cant1 or Cant2 then return false end

		local hp = ent:Health()
		local ActualDmg = Damage * PropDamageScale
		hp = hp - ActualDmg

		if hp < 0 then
			ent:Remove()
			return
		end

		ent:SetHealth(hp)

		local M 		= hp / ent.MaxHealth
		local OldCol 	= ent:GetColor()
		local Color 	= Color(255 * M, 255 * M, 255 * M, OldCol.a)

		ent:SetColor(Color)

	return end
	]]

	if ent:IsPlayer() then

		if not Attacker:IsPlayer() and dmginfo:IsDamageType(DMG_CRUSH) and (Attacker:IsWorld() or (IsValid(Attacker) and not Attacker:CreatedByMap())) then

			dmginfo:SetDamage(0)

			return

		end

		local FriendlyFire = BaseWars.Config.AllowFriendlyFire
		local Team = ent:GetFactionName()

		if not (ent == Attacker) and not FriendlyFire and ent:InFaction() and Attacker:IsPlayer() and Attacker:InFaction(Team) then
			dmginfo:SetDamage(0)
			return

		end

	end

end

local SpawnClasses = {
	["info_player_deathmatch"] = true,
	["info_player_rebel"] = true,
	["gmod_player_start"] = true,
	["info_player_start"] = true,
	["info_player_allies"] = true,
	["info_player_axis"] = true,
	["info_player_counterterrorist"] = true,
	["info_player_terrorist"] = true,
}

local LastThink = CurTime()
local Spawns 	= {}

local function ScanEntities()

	Spawns = {}

	for k, v in next, ents.GetAll() do

		if not v or not IsValid(v) or k < 1 then continue end

		local Class = v:GetClass()

		if SpawnClasses[Class] then

			Spawns[#Spawns+1] =  v

		end

	end

end
--[[
function GM:PlayerShouldTakeDamage(ply, atk)

	if aowl and ply.Unrestricted then

		return false

	end

	if ply == atk then

		return true

	end

	for k, v in next, ents.FindInSphere(ply:GetPos(), 256) do

		local Class = v:GetClass()

		if SpawnClasses[Class] then

			if BaseWars.Ents:ValidPlayer(atk) then

				atk:Notify(BaseWars.LANG.SpawnKill, BASEWARS_NOTIFICATION_ERROR)

			end

			return false

		end

	end

	for k, v in next, ents.FindInSphere(atk:GetPos(), 256) do

		local Class = v:GetClass()

		if SpawnClasses[Class] then

			if BaseWars.Ents:ValidPlayer(atk) then

				atk:Notify(BaseWars.LANG.SpawnCamp, BASEWARS_NOTIFICATION_ERROR)

			end

			return false

		end

	end

	return true

end
]]
function GM:PostPlayerDeath(ply)

end

function GM:PlayerDisconnected(ply)

	BaseWars.UTIL.ClearRollbackFile(ply)

	self.BaseClass:PlayerDisconnected(ply)

end

function GM:Think()

	local State = self.BaseClass:Think()

	if LastThink < CurTime() - 5 then

		BaseWars.UTIL.WriteCrashRollback()

		for k, v in next, ents.GetAll() do

			if v:IsOnFire() then

				v:Extinguish()

			end


		end

		for k, s in next, Spawns do

			if not s or not IsValid(s) then

				ScanEntities()

				return State

			end

			local Ents = ents.FindInSphere(s:GetPos(), 256)

			if #Ents < 2 then

				continue

			end

			for _, v in next, Ents do

				if v.BeingRemoved or v.NoFizz then

					continue

				end

				local Owner = v:CPPIGetOwner()

				if not Owner or not IsValid(Owner) or not Owner:IsPlayer() then

					continue

				end

				if v:GetClass() == "prop_physics" then

					v.BeingRemoved = true
					v:Remove()

					Owner:Notify(BaseWars.LANG.DontBuildSpawn, BASEWARS_NOTIFICATION_ERROR)

				end

			end

		end

		LastThink = CurTime()

	end

	return State

end

function GM:InitPostEntity()

	self.BaseClass:InitPostEntity()

	ScanEntities()

	for k, v in next, ents.FindByClass("*door*") do

		v:Fire("unlock")

	end

	BaseWars.UTIL.WriteCrashRollback(true)

end

function GM:PlayerSpawn(ply)

	self.BaseClass:PlayerSpawn(ply)
	self:SetPlayerSpeed(ply, BaseWars.Config.DefaultWalk, BaseWars.Config.DefaultRun)

	local Spawn = ply.SpawnPoint
	if IsValid(Spawn) and (not Spawn.IsPowered or Spawn:IsPowered()) then

		local Pos = Spawn:GetPos() + BaseWars.Config.Ents.SpawnPoint.Offset

		ply:SetPos(Pos)

	end

	for k, v in next, BaseWars.Config.SpawnWeps do

		ply:Give(v)

	end

	if ply:HasWeapon("hands") then
		ply:SelectWeapon("hands")
	elseif ply:HasWeapon("none") then
		ply:SelectWeapon("none")
	end

end

ScanEntities()
