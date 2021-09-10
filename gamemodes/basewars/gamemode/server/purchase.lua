if not muldim then include("lib_it_up/classes/multidim.lua") end

BaseWars.SpawnList = BaseWars.SpawnList or {}

local function decrLimit(ent)
	if not ent._incrLimit then return end

	local class = ent:GetClass()
	local pin = ent._incrLimit
	pin.BW_EntLimits[class] = pin.BW_EntLimits[class] - 1
end

local function incrLimit(ent, pin)
	if ent._incrLimit == pin then return end

	if ent._incrLimit then
		decrLimit(ent)
	end

	local class = ent:GetClass()
	ent._incrLimit = pin

	pin.BW_EntLimits = pin.BW_EntLimits or {}
	pin.BW_EntLimits[class] = (pin.BW_EntLimits[class] or 0) + 1
end



hook.NHAdd("EntityOwnershipChanged", "BW_Limits", function(ply, ent, oldID)
	if not ent.Bought then return end

	local old = oldID and GetPlayerInfo(oldID)
	local new = ent:BW_GetOwner()
	local class = ent:GetClass()
	local entry = BaseWars.Catalogue[class]

	if not entry then
		errorf("ownership changed on a bought non-catalogue entity!?\n" ..
			"class: %q; owners: %s -> %s", class, old, new)
	end

	if new then
		incrLimit(ent, new)

		if entry.Limit and entry.Limit < new.BW_EntLimits[class] then
			errorf("ownership changed so new owner is over the limit!?\n" ..
				"class: %q; owners: %s -> %s; limits: %d/%d",
				class, old, new, new.BW_EntLimits[class], entry.Limit)
		end
	end
end)

BaseWars.Generators = BaseWars.Generators or muldim:new()
local gens = BaseWars.Generators

local function LimitDeduct(ent, class, ply)
	local pinfo = GetPlayerInfo(ply)

	ent:CallOnRemove("LimitDeduct", function(ent, sid)
		decrLimit(ent)
	end, sid)

	incrLimit(ent, pinfo)

	ent.BWOwner = ply
	ent.Bought = true
end

local function postSpawn(ply, class, ent, info)
	if info.Limit then
		LimitDeduct(ent, class, ply)
	end

	if info.Price and info.Price > 0 then
		ply:SetMoney(ply:GetMoney() - info.Price)
	end
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
	local model, price, class = i.Model, i.Price, i.ClassName
	local lim, vip, trust = i.Limit, i.vip, i.trust

	local gun = i.Gun

	if vip and not IsGroup(ply, "vip") then ply:EmitSound("buttons/button10.wav") return end
	if trust and not IsGroup(ply, "trusted") then ply:EmitSound("buttons/button10.wav") return end

	local level = i.Level
	if gun and (not level or level < BaseWars.Config.LevelSettings.BuyWeapons) then level = BaseWars.Config.LevelSettings.BuyWeapons end

	--[[if level and not ply:HasLevel(level) then
		ply:EmitSound("buttons/button10.wav")
		return
	end]]

	local tr

	if class then

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

	-- check against limits

	if lim then
		local pin = GetPlayerInfoGuarantee(ply)
		local plyLimit = pin.BW_EntLimits or {}
		local amt = plyLimit[class]

		printf("buying %d/%d of `%s`", (amt or 0) + 1, lim, class)

		if amt and lim <= amt then
			ply:Notify(string.format(Language.EntLimitReached, item, amt), BASEWARS_NOTIFICATION_ERROR)
			return
		end

	end

	local Res, Msg

	if gun then
		Res, Msg = hook.Run("BaseWars_PlayerCanBuyGun", ply, class) -- Player, Gun class
	elseif class then
		Res, Msg = hook.Run("BaseWars_PlayerCanBuyEntity", ply, class) -- Player, Entity class
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

		ply:EmitSound("mvm/mvm_money_pickup.wav")
		ply:Notify(string.format(Language.SpawnMenuBuy, item, BaseWars.NumberFormat(price)), BASEWARS_NOTIFICATION_MONEY)
	else
		local scrapSounds = lazy.Get("ScrapSounds") or {
			"buttons/lever1.wav",
			"buttons/lever3.wav",
			"buttons/lever5.wav",
			"buttons/lever8.wav",
			"buttons/button4.wav",
		}

		lazy.Set("ScrapSounds", scrapSounds)
		local snd = scrapSounds[math.random(#scrapSounds)]

		if math.random() < 0.05 and BaseWars.IsRetarded(ply) then
			snd = "vo/breencast/br_overwatch07.wav"
		end

		ply:EmitSound(snd)
	end

	if gun then

		local newEnt = ents.Create("bw_weapon")
			newEnt.WeaponClass = class
			newEnt.Model = model
			newEnt:SetPos(SpawnPos)
			newEnt:SetAngles(SpawnAng)
			newEnt:Spawn()
			newEnt:Activate()

		postSpawn(ply, class, newEnt, i)
		hook.Run("BaseWars_PlayerBuyGun", ply, newEnt) -- Player, Gun entity
		return
	end

	local newEnt = ents.Create(class)
	if not newEnt then
		return
	end

	if newEnt.BW_SpawnFunction then
		newEnt = newEnt:BW_SpawnFunction(ply, tr, class) or newEnt
	end

	newEnt.Bought = true
	newEnt.BWOwner = ply
	newEnt.DoNotDuplicate = true

	BaseWars.Worth.Set(newEnt, price)
	if newEnt.SetUpgradeCost then newEnt:SetUpgradeCost(price) end

	newEnt:CPPISetOwner(ply)

	newEnt:SetPos(SpawnPos)
	newEnt:SetAngles(SpawnAng)
	newEnt:DropToFloor()

	newEnt:Spawn()
	newEnt:Activate()

	if newEnt.BW_PostBuy then
		newEnt:BW_PostBuy(ply, tr, class)
	end

	local phys = newEnt:GetPhysicsObject()

	if i.ShouldFreeze and IsValid(phys) then
		phys:EnableMotion(false)
	end

	postSpawn(ply, class, newEnt, i)

	hook.Run("BaseWars_PlayerBuyEntity", ply, newEnt) -- Player, Entity
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

local banned = {
	["arccw_nade_incendiary"] = true,
}

local function NoGunsFuckYou(ply, class, what)

	local mon = ply:GetMoney()
	local price = 5e6
	if BaseWars.Catalogue[class] then
		price = BaseWars.Catalogue[class].Price
	end

	if mon < price and not BaseWars.IsRetarded(ply) then
		ply:Notify(Language.UseSpawnMenu, BASEWARS_NOTIFICATION_ERROR)
		return false
	end

	if BaseWars.IsRetarded(ply) then return end

	ply:TakeMoney(price)
end

local name = "BaseWars.Disallow_Spawning"

if BaseWars.Config.RestrictProps then
	hook.Add("PlayerSpawnObject", name, Disallow_Spawning)
end

hook.Add("PlayerSpawnSENT", 	name, Disallow_Spawning)
hook.Add("PlayerGiveSWEP", 		name, NoGunsFuckYou)
hook.Add("PlayerSpawnSWEP", 	name, NoGunsFuckYou)
hook.Add("PlayerSpawnNPC", 		name, function() return false end)
hook.Add("PlayerSpawnVehicle", 	name, Disallow_Spawning)