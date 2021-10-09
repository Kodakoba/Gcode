BaseWars.Worth = BaseWars.Worth or {}

local wth = BaseWars.Worth
wth.Ents = wth.Ents or {}

function wth.Set(ent, price, suppress)
	wth.Ents[ent] = price and math.max(price, 0) or price
	if not suppress then
		hook.Run("EntityWorthChanged", ent)
	end
end

function wth.Add(ent, price, suppress)
	wth.Ents[ent] = math.max((wth.Ents[ent] or 0) + price, 0)
	if not suppress then
		hook.Run("EntityWorthChanged", ent)
	end
end

function wth.Sub(ent, price, suppress)
	wth.Ents[ent] = math.max((wth.Ents[ent] or 0) + price, 0)
	if not suppress then
		hook.Run("EntityWorthChanged", ent)
	end
end

function wth.Get(ent)
	return wth.Ents[ent] or 0, not not wth.Ents[ent]
end

local ENTITY = FindMetaTable("Entity")

function ENTITY:GetWorth()
	return wth.Get(self)
end

local function Pay(ply, amt, name, own)
	local pin = IsPlayerInfo(ply) and ply or GetPlayerInfoGuarantee(ply)
	ply = pin:GetPlayer()

	if ply then
		ply:Notify(
			string.format(own and Language.PayOutOwner or Language.PayOut,
				BaseWars.NumberFormat(amt),
				name or "...something?"), BASEWARS_NOTIFICATION_GENRL)
	end

	pin:GiveMoney(amt)
end

function wth.PayOut(ent, atk, full)
	if not IsValid(ent) then
		errorf("attempted to payout for invalid ent %s", ent)
		return
	end

	local price, had = wth.Get(ent)

	if not had then return 0 end

	atk = CanGetPInfo(atk) and GetPlayerInfo(atk) or
		IsValid(atk) and atk:BW_GetOwner()

	local own = ent:BW_GetOwner()
	local val = price * (not full and BaseWars.Config.DestroyReturn or 1)

	local Name = ent.PrintName or ent:GetClass()

	wth.Set(ent, nil, true)

	if ent.GetLevel then
		Name = Language("Level", ent:GetLevel()) .. " " .. Name
	end

	if not IsValid(atk) or atk == own then
		if own then
			Pay(own, val, Name, true)
		end

		hook.NHRun("EntityPaidWorth", ent, own, val)
		return 0
	end

	if not val then
		ErrorNoHalt("ERROR! NO WORTH! CANNOT PAY OUT!\n")
		return 0
	end

	if val ~= val or val == math.huge then
		ErrorNoHalt("NAN OR INF RETURN DETECTED! HALTING!\n")
		ErrorNoHalt("...INFINITE MONEY GLITCH PREVENTED!!!\n")
		return 0
	end

	local inRaid = atk:IsEnemy(own)
	local Members = atk:GetFaction() and atk:GetFaction():GetMembers()
	local Involved = inRaid and (Members and #Members) or 1

	-- raiders get 60% of the cost if there _is_ a raid
	-- +20% if the owner is somehow missing (owner's fraction)

	local raidFrac = (val * 0.8) / Involved

	-- owner gets 20% of the cost back on raid destruction
	-- and 60% on every other possibility
	local ownfrac = inRaid and val * 0.2 or val

	if inRaid then
		if Members then
			for k, v in ipairs(Members) do
				Pay(v, raidFrac, Name)
				hook.NHRun("EntityPaidWorth", ent, v, raidFrac)
			end
		elseif inRaid then
			Pay(atk, raidFrac, Name)
			hook.NHRun("EntityPaidWorth", ent, atk, raidFrac)
		end
	end

	if own then
		Pay(own, ownfrac, Name, true)
		hook.NHRun("EntityPaidWorth", ent, own, ownfrac)
	end
end

BaseWars.UTIL.PayOut = wth.PayOut

function wth.RefundAll(ply, incomplete)
	print("RefundAll", ply)
	if not ply then
		print('//FULL SERVER REFUND IN PROGRESS//')
	end

	local pin = ply and GetPlayerInfoGuarantee(ply)

	for k, ent in ipairs(ents.GetAll()) do
		if not IsValid(ent) then continue end

		local owPin = ent:BW_GetOwner()

		if not owPin or not IsValid(owPin) then continue end
		if ply and owPin ~= pin then continue end
		if not wth.Get(ent) then print("no price", ent) continue end

		wth.PayOut(ent, owPin, not incomplete)
		ent:Remove()
	end
end

BaseWars.UTIL.RefundAll = wth.RefundAll