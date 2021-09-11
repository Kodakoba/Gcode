--
local bz = BaseWars.Bases
bz.NW.Residence = Networkable("bw_base_residence")

local resid = bz.NW.Residence

resid:On("WriteChangeValue", "WriteEnt", function(self, eid, dat)
	local resides = dat and dat[1]
	local protected = dat and dat[2]

	print("WriteChangeValue", eid, resides, protected)

	net.WriteBool(resides)
	if resides then
		net.WriteBool(not not protected)
	end

	return false
end)

local function exitBase(ent, base)
	local eid = isnumber(ent) and ent or ent:EntIndex()

	if resid:Get(eid) then
		resid:Set(eid, false)
	end
end

local function enterBase(ent, base)
	local eid = isnumber(ent) and ent or ent:EntIndex()

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

-- damage logic
hook.Add("BW_CanBlowtorchRaidless", "ResidenceCheck", function(ply, ent, wep, dmg)
	-- stuff on the street can be blowtorched
	if not ent:BW_GetBase() then
		-- 1x multiplier
		return true
	end

	-- stuff in bases not claimed by the ent owner can be blowtorched
	if not ent:BW_GetBase():IsEntityOwned(ent) then
		dmg:ScaleDamage(5) --5x mult
		return true
	end
end)

hook.Add("BW_CanDealEntityDamage", "ResidenceCheck", function(atk, ent, imfl, dmg)
	-- stuff on the street can be shot down but only with a fraction of the damage
	if not ent:BW_GetBase() then
		dmg:ScaleDamage(0.5)
		return true
	end

	local base = ent:BW_GetBase()

	-- stuff in bases not claimed by the ent owner can be shot down
	if not base:IsEntityOwned(ent) then

		-- base owner deals 3x bullet damage to others' props in his base
		if IsPlayer(atk) and base:IsOwner(atk)
			and not base:IsOwner(ent:BW_GetOwner()) then
			dmg:ScaleDamage(3)
			return true
		end

		dmg:ScaleDamage(0.5)
		return true
	end
end)
