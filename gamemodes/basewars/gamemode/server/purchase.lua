if not muldim then include("lib_it_up/classes/multidim.lua") end

BaseWars.SpawnList = BaseWars.SpawnList or {}

BaseWars.Limits = BaseWars.Limits or muldim:new()

--[[
{
	[sid64] = {
		[ent_class] = number,
		...
	}
}
]]

BaseWars.Purchased = BaseWars.Purchased or muldim:new()
--[[
{
	[sid64] = {
		[ent_class] = {
			[1] = Entity,
			[2] = Entity, ...
		}
	}
}
]]

hook.Add("EntityOwnershipChanged", "BW_Limits", function(ply, ent, id)
	if IsPlayer(ent.BWOwner) and ent.BWOwner ~= ply then
		-- switched owner, probably
		local lim = BaseWars.Limits[ent.BWOwner:SteamID64()]
		lim[ent:GetClass()] = lim[ent:GetClass()] - 1
	end
end)

BaseWars.Generators = BaseWars.Generators or muldim:new()
local gens = BaseWars.Generators

local function LimitDeduct(ent, class, ply)

	local sid = ""

	if IsValid(ply) then
		sid = ply:SteamID64()
	end

	local plyLimit = BaseWars.Limits:GetOrSet(sid)

	ent:CallOnRemove("LimitDeduct" .. sid, function(ent, sid)
		plyLimit[class] = plyLimit[class] - 1
	end, sid )

	plyLimit[class] = (plyLimit[class] or 0) + 1
	--purchased:GetOrSet(class)[class] = (purchased:GetOrSet(class)[class] or 0) + 1


	ent.BWOwner = ply
	ent.Bought = true
end

function BWSpawn(ply, cat, catID)
	catID = tonumber(catID)

	if not ply:Alive() then ply:Notify(Language.DeadBuy, BASEWARS_NOTIFICATION_ERROR) return end

	local l = BaseWars.SpawnList
	if not l then print("no spawnlist") return end

	if not cat or not catID then print("no cat or num") return end

	-- category -> subcategory -> item number

	local i = l[cat]
	if not i then print("no cat:", cat) return end

	i = i.Items[catID]
	if not i then print("no item with catid:", catID, cat) return end

	local item = i.Name
	local model, price, ent, sf, lim, vip, trust = i.Model, i.Price, i.ClassName, i.UseSpawnFunc, i.Limit, i.vip, i.trust
	local gun = i.Gun

	if vip and not IsGroup(ply, "vip") then ply:EmitSound("buttons/button10.wav") return end
	if trust and not IsGroup(ply, "trusted") then ply:EmitSound("buttons/button10.wav") return end
	local sid64 = ply:SteamID64()

	local level = i.Level
	if gun and (not level or level < BaseWars.Config.LevelSettings.BuyWeapons) then level = BaseWars.Config.LevelSettings.BuyWeapons end

	if level and not ply:HasLevel(level) then

		ply:EmitSound("buttons/button10.wav")

	return end

	local tr

	if ent then

		tr = {}

		tr.start = ply:EyePos()
		tr.endpos = tr.start + ply:GetAimVector() * 85
		tr.filter = ply

		tr = util.TraceLine(tr)

	else

		tr = ply:GetEyeTraceNoCursor()

		if not tr.Hit then return end

	end

	local SpawnPos = tr.HitPos + BaseWars.Config.SpawnOffset
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180
	SpawnAng.y = math.Round(SpawnAng.y / 45) * 45

	-- raid: can't purchase non-guns in a raid
	if not gun and not i.Raid and ply:InRaid() then
		ply:Notify(Language.CannotPurchaseRaid, BASEWARS_NOTIFICATION_ERROR)
		return
	end

	local sid = ply:SteamID64()

	-- check against limits

	if lim then
		local plyLimit = BaseWars.Limits:GetOrSet(sid)
		local amt = plyLimit[ent]

		printf("buying %d/%d of `%s`", (amt or 0) + 1, lim, ent)

		if lim and amt and lim <= amt then
			ply:Notify(string.format(Language.EntLimitReached, item, amt), BASEWARS_NOTIFICATION_ERROR)
			return
		end

	end

	local Res, Msg

	if gun then
		Res, Msg = hook.Run("BaseWars_PlayerCanBuyGun", ply, ent) -- Player, Gun class
	elseif ent then
		Res, Msg = hook.Run("BaseWars_PlayerCanBuyEntity", ply, ent) -- Player, Entity class
	end

	if Res == false then
		if Msg then
			ply:Notify(Msg, BASEWARS_NOTIFICATION_ERROR)
		end
		return
	end

	if price > 0 then

		local plyMoney = ply:GetMoney()

		if plyMoney < price then
			ply:Notify(Language.SpawnMenuMoney, BASEWARS_NOTIFICATION_ERROR)
			return
		end

		ply:SetMoney(plyMoney - price)
		ply:EmitSound("mvm/mvm_money_pickup.wav")

		ply:Notify(string.format(Language.SpawnMenuBuy, item, BaseWars.NumberFormat(price)), BASEWARS_NOTIFICATION_MONEY)

	end

	if gun then

		local Ent = ents.Create("bw_weapon")
			Ent.WeaponClass = ent
			Ent.Model = model
			Ent:SetPos(SpawnPos)
			Ent:SetAngles(SpawnAng)
			Ent:Spawn()
			Ent:Activate()

		if lim then
			LimitDeduct(Ent, ent, ply)
		end

		hook.Run("BaseWars_PlayerBuyGun", ply, Ent) -- Player, Gun entity

	return end


	local prop
	local noundo

	if ent then

		local newEnt = ents.Create(ent)
		if not newEnt then return end


		if newEnt.SpawnFunction and sf then

			newEnt = newEnt:SpawnFunction(ply, tr, ent)

			if newEnt.CPPISetOwner then
				newEnt:CPPISetOwner(ply)
			end

			if lim then
				LimitDeduct(newEnt, ent, ply)
			end

			newEnt.CurrentValue = price
			if newEnt.SetUpgradeCost then newEnt:SetUpgradeCost(price) end

			newEnt.DoNotDuplicate = true

			hook.Run("BaseWars_PlayerBuyEntity", ply, newEnt) -- Player, Entity

			return
		end

		newEnt.Bought = true
		newEnt.BWOwner = ply

		if lim then
			LimitDeduct(newEnt, ent, ply)
		end

		if newEnt.IsGenerator then
			gens[sid64] = (gens[sid64] or 0) + 1
		end

		newEnt.CurrentValue = price
		if newEnt.SetUpgradeCost then newEnt:SetUpgradeCost(price) end

		newEnt.DoNotDuplicate = true

		prop = newEnt
		noundo = true

	end

	if not prop then prop = ents.Create(ent or "prop_physics") end
	if not noundo then undo.Create("prop") end

	if not prop or not IsValid(prop) then return end

	prop:SetPos(SpawnPos)
	prop:SetAngles(SpawnAng)
	prop:Spawn()
	prop:Activate()

	prop:DropToFloor()

	local phys = prop:GetPhysicsObject()

	if IsValid(phys) then

		if i.ShouldFreeze then

			phys:EnableMotion(false)

		end

	end

	undo.AddEntity(prop)
	undo.SetPlayer(ply)
	undo.Finish()

	if prop.CPPISetOwner then
		prop:CPPISetOwner(ply)
	end

	hook.Run("BaseWars_PlayerBuyEntity", ply, prop) -- Player, Entity

end


concommand.Add("basewars_spawn",function(ply,_,args)
	if not IsValid(ply) then return end
			    -- cat   | itemID (catID)
	BWSpawn(ply, args[1], args[2])
end)


local function Disallow_Spawning(ply, ...)
	if not ply:IsAdmin()  then
		ply:Notify(Language.UseSpawnMenu, BASEWARS_NOTIFICATION_ERROR)
		return false
	end
end

local name = "BaseWars.Disallow_Spawning"

if BaseWars.Config.RestrictProps then
	hook.Add("PlayerSpawnObject", name, Disallow_Spawning)
end

hook.Add("PlayerSpawnSENT", 	name, Disallow_Spawning)
hook.Add("PlayerGiveSWEP", 		name, Disallow_Spawning)
hook.Add("PlayerSpawnSWEP", 	name, Disallow_Spawning)
hook.Add("PlayerSpawnVehicle", 	name, Disallow_Spawning)