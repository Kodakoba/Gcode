local bz = BaseWars.Bases
bz.NW.Residence = bz.NW.Residence or Networkable("bw_base_residence")

local resid = bz.NW.Residence

resid:On("WriteChangeValue", "WriteEnt", function(self, eid, dat)
	local resides = dat and dat[1]
	local protected = dat and dat[2]

	net.WriteBool(resides)
	if resides then
		net.WriteBool(not not protected)
	end

	return false
end)

local function exitBase(ent, base)
	if ent:CreatedByMap() or ent:IsPlayer()
		or not ent:BW_GetOwner() then return end

	local eid = isnumber(ent) and ent or ent:EntIndex()

	if resid:Get(eid) then
		resid:Set(eid, nil)
	end
end

local function enterBase(ent, base)
	local eid = isnumber(ent) and ent or ent:EntIndex()
	ent = Entity(eid)
	if not IsValid(ent) then return end -- !>>?!>

	if ent:CreatedByMap() or ent:IsPlayer()
		or not ent:BW_GetOwner() then return end

	resid:Set(eid, {true, base:IsEntityOwned(Entity(eid))})
end

-- trackers
hook.Add("EntityEnteredBase", "EntResidence", function(base, ent)
	enterBase(ent, base)
end)

hook.Add("EntityExitedBase", "EntResidence", function(base, ent)
	if ent:BW_GetBase() then return end -- entered a new base; forget it
	exitBase(ent, base)
end)

hook.Add("BaseUnclaimed", "EntResidence", function(base, ent)
	for ent, eid in pairs(base:GetEntities()) do
		enterBase(eid, base)
	end
end)

hook.Add("BaseClaimed", "EntResidence", function(base, ent)
	for ent, eid in pairs(base:GetEntities()) do
		enterBase(eid, base)
	end
end)

hook.Add("EntityOwnershipChanged", "PGTrackOwned", function(ply, ent)
	if ent:BW_GetBase() then
		enterBase(ent, ent:BW_GetBase())
	end
end)

local function getDamageMult(ent)
	local cfg = BaseWars.Config.BulletProp

	local time = CurTime() - (ent._lastShot or ent:GetCreationTime())
	local fr = math.min(ent._lastFr or 1, math.TimeFraction(cfg.Time, 0, time))
	local recent_frac = Lerp(fr, cfg.Min, cfg.Max)


	return fr, recent_frac
end

local function trackDamage(ent, fr)
	local cfg = BaseWars.Config.BulletProp
	local time = CurTime() - (ent._lastShot or ent:GetCreationTime())
	ent._lastShot = CurTime() - time + cfg.PauseOnShot
	ent._lastFr = fr
end

-- damage logic
hook.Add("BW_ScaleBlowtorchRaidless", "Residence", function(ply, ent, wep, dmg)
	local fr, recent_frac = getDamageMult(ent)

	dmg:ScaleDamage(recent_frac * 5)
	trackDamage(ent, fr)
end)

hook.Add("BW_CanBlowtorchRaidless", "ResidenceCheck", function(ply, ent, wep, dmg)
	-- stuff on the street can be blowtorched

	if not ent:BW_GetBase() then
		return true
	end

	-- stuff in bases not claimed by the ent owner can be blowtorched
	if not ent:BW_GetBase():IsEntityOwned(ent) then
		return true
	end
end)

hook.Add("BW_CanDealEntityDamage", "ResidenceCheck", function(atk, ent, imfl, dmg)
	-- stuff on the street can be shot down but only with a fraction of the damage

	local fr, recent_frac = getDamageMult(ent)

	if not ent:BW_GetBase() then
		dmg:ScaleDamage(recent_frac)
		trackDamage(ent, fr)
		return true
	end

	local base = ent:BW_GetBase()

	-- stuff in bases not claimed by the ent owner can be shot down
	if not base:IsEntityOwned(ent) then

		-- base owner deals 150x bullet damage to others' props in his base
		if IsPlayer(atk) and base:IsOwner(atk) then
			dmg:ScaleDamage(150 * math.max(1, recent_frac))
			return true
		end

		dmg:ScaleDamage(recent_frac / 4)
		return true
	end
end)
