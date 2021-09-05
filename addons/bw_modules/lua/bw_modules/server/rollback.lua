
BaseWars.Rollback = BaseWars.Rollback or {}
local rb = BaseWars.Rollback

rb.PlayerWorth = rb.PlayerWorth or {}
rb.SavedWorth = rb.SavedWorth or {}

local db

local function onDB()

	db = mysqloo.GetDB()

	local q = db:query([[
	CREATE TABLE IF NOT EXISTS `bw_rollback` (
	  `puid` BIGINT UNSIGNED NOT NULL,
	  `money` BIGINT UNSIGNED,
	  `ents` JSON,
	  PRIMARY KEY (`puid`),
	  UNIQUE INDEX `puid_UNIQUE` (`puid` ASC));
	]])

	q.onError = mysqloo.QueryError
	q:start()
end

mysqloo.OnConnect(onDB)

hook.Add("EntityOwnershipChanged", "RollbackTracker", function(ply, ent, old)
	if old then
		local opi = GetPlayerInfo(old)
		local prevOwWorth = rb.PlayerWorth[opi] or 0
		rb.PlayerWorth[opi] = prevOwWorth - BaseWars.Worth.Get(ent)
	end

	local ow = GetPlayerInfo(ply)

	local prevOwWorth = rb.PlayerWorth[ow] or 0
	rb.PlayerWorth[ow] = prevOwWorth + BaseWars.Worth.Get(ent)
	rb.SavedWorth[ent] = BaseWars.Worth.Get(ent)

	ow:SetBWData("Worth", rb.PlayerWorth[ow])
end)

hook.Add("EntityWorthChanged", "RollbackTracker", function(ent)
	local pin = ent:BW_GetOwner()
	if not pin then return end

	local prevOwWorth = rb.PlayerWorth[pin] or 0
	local prevWorth = rb.SavedWorth[ent] or 0

	rb.SavedWorth[ent] = BaseWars.Worth.Get(ent)
	rb.PlayerWorth[pin] = prevOwWorth - prevWorth + rb.SavedWorth[ent]
	pin:SetBWData("Worth", rb.PlayerWorth[pin])
end)

hook.Add("EntityActuallyRemoved", "RollbackTracker", function(ent)
	local wth = rb.SavedWorth[ent]
	if not wth or wth == 0 then return end

	local pin = ent:BW_GetOwner()

	if pin then
		rb.PlayerWorth[pin] = rb.PlayerWorth[pin] - (rb.SavedWorth[ent] or 0)
		pin:SetBWData("Worth", rb.PlayerWorth[pin])
	end

	rb.SavedWorth[ent] = nil
end)


hook.Add("BW_DataSyncWorth", "RollbackSync", function(pin, wth)
	local fmt = "REPLACE INTO `bw_rollback`(puid, `money`) VALUES (%s, %s)"
	fmt = fmt:format(pin:SteamID64(), wth)

	local q = db:query(fmt)
	q.onError = mysqloo.QueryError
	q:start()
end)

hook.Add("BW_LoadPlayerData", "RollbackLoad", function(ply, ...)
	local pin = GetPlayerInfoGuarantee(ply)

	local fmt = "SELECT `money` FROM `bw_rollback` WHERE puid = %s"
	fmt = fmt:format(pin:SteamID64())

	local q = db:query(fmt)
	q.onError = mysqloo.QueryError
	q.onSuccess = function(_, data)
		if not data[1] then return end

		local mon = data[1].money
		local wth = rb.PlayerWorth[pin] or 0
		-- getting rollback from SQL when there's worth in memory
		-- should, like, never happen; good to handle it nonetheless i think
		local to_add = mon - wth

		if to_add > 0 then
			pin:AddMoney(to_add)
			pin:SetBWData("Worth", wth)
		end
	end
	q:start()
end)