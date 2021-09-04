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

	atk = GetPlayerInfo(atk)
	local own = ent:BW_GetOwner()
	local val = price * (not full and not ret and BaseWars.Config.DestroyReturn or 1)
	local Name = ent.PrintName or ent:GetClass()

	print(own, val)

	wth.Set(ent, nil, true)

	if ent.GetLevel then
		Name = Language("Level", ent:GetLevel()) .. " " .. Name
	end

	if not IsValid(atk) or atk == own then
		print("paying out without attacker", own, val)
		if own then
			Pay(own, val, Name, true)
		end

		hook.Run("EntityPaidWorth", ent, own, val)
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

	local Members = atk:GetFaction() and atk:GetFaction():GetMembers()
	local TeamAmt = #Members

	-- add +1 for owner
	local Involved = own and TeamAmt + 1 or TeamAmt

	local Fraction = math.floor(val / Involved)

	if TeamAmt > 1 then
		for k, v in ipairs(Members) do
			Pay(v, Fraction, Name)
			hook.Run("EntityPaidWorth", ent, v, Fraction)
		end
	else
		Pay(atk, Fraction, Name)
		hook.Run("EntityPaidWorth", ent, atk, Fraction)
	end

	if own then
		Pay(own, Fraction, Name, true)
		hook.Run("EntityPaidWorth", ent, own, Fraction)
	end
end

BaseWars.UTIL.PayOut = wth.PayOut

function wth.RefundAll(ply)
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

		wth.PayOut(ent, owPin, true)
		ent:Remove()
	end
end

BaseWars.UTIL.RefundAll = wth.RefundAll