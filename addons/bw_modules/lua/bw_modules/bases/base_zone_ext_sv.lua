local bw = BaseWars.Bases

function bw.Base:ListenFaction(fac)
	local listenID = "BaseListen" .. self:GetID()

	fac:On("Remove", listenID, function()
		if self.Owner.Faction == fac then
			self:Unclaim()
		end

		fac._Base = nil

		if IsValid(fac:GetOwner()) then
			self:Claim(fac:GetOwner())
		end
	end)

	--[[fac:On("LeaveFaction", listenID, function(_, ply, pinfo)
		print("Player left faction", ply, pinfo, pinfo._Base, pinfo._Base == self)
		if pinfo._Base == self then
			print("equal to self, removing")
			pinfo._Base = nil
		end
	end)]]
end

function bw.Base:AttemptClaim(by)
	self:_CheckValidity()

	if not self:CanClaim(by) then return false end

	if IsFaction(by) then
		if by:GetBase() then return false end
	else
		local info = by:GetPInfo()
		if info:GetBase() then return false end
	end

	return self:Claim(by)
end

function bw.Base:Claim(by)
	self:_CheckValidity()

	if self:GetClaimed() then
		self:Unclaim(true)
	end

	self.PublicNW:Set("Claimed", true)

	if IsFaction(by) then
		self.Owner.Faction = by
		self.Owner.Player = nil

		by._Base = self

		self:ListenFaction(by)

		self.PublicNW:Set("ClaimedFaction", true)
		self.PublicNW:Set("ClaimedBy", by:GetID())

	elseif IsPlayer(by) or IsPlayerInfo(by) then
		local pinfo = by:GetPInfo()
		pinfo._Base = self

		self.Owner.Faction = nil
		self.Owner.Player = pinfo

		pinfo:On("Destroy", self, function()
			if self.Owner.Player == pinfo then
				self:Unclaim()
			end
		end)

		self.PublicNW:Set("ClaimedFaction", false)
		self.PublicNW:Set("ClaimedBy", pinfo:GetSteamID64())
	end

	self:SetClaimed(true)
	self:Emit("Claim")
	self:UpdateNW()
	hook.NHRun("BaseClaimed", self, IsFaction(by) and by or GetPlayerInfo(by))

	return true
end

hook.Add("FactionCreated", "BWBaseOwnership", function(ply, fac)
	local base = GetPlayerInfo(ply):GetPlayerBase(true)

	if base and base:IsValid() then
		base:Claim(fac)
	end
end)

function bw.Base:Unclaim(temporarily)
	self:_CheckValidity()


	if not self:GetClaimed() then
		errorf("Tried to unclaim an unclaimed base!")
		return
	end

	local fac, members = self:GetOwner()

	if fac then
		fac._Base = nil
	end

	for k,v in ipairs(members) do
		v._Base = nil
	end

	self.Owner.Faction = nil
	self.Owner.Player = nil

	self.PublicNW:Set("Claimed", false)

	if not temporarily then
		self:SetClaimed(false)

		self:Emit("Unclaim")
		hook.NHRun("BaseUnclaimed", self, prev)

		self.PublicNW:Set("ClaimedFaction", false)
		self.PublicNW:Set("ClaimedBy", nil)
	end
end

function bw.Base:SpawnCore()
	local dat = self:GetData()
	if not dat.BaseCore then return end

	local bc = dat.BaseCore
	local pos, ang, mdl = bc.pos, bc.ang, bc.mdl

	if not isvector(pos) or not isangle(ang) or not util.IsValidModel(mdl) then
		errorf("Invalid data for base's basecore spawn.\
	Position: %s (valid: %s)\
	Angle: %s (valid: %s)\
	Model: %s (valid: %s)",
	tostring(pos), isvector(pos),
	tostring(ang), isangle(ang),
	tostring(mdl), util.IsValidModel(mdl))
	end

	local prevCore = IsValid(self:GetBaseCore()) and self:GetBaseCore()
	local core = prevCore or ents.Create("bw_basecore")
	core:SetPos(pos)
	core:SetAngles(ang)

	if not prevCore then
		core:Spawn()
	end

	self:AddToNW()

	core:SetBase(self)
	core:SetModel(mdl)

	self:SetBaseCore(core)
end

function bw.Base:UpdateNW()
	local plys, nws = {}, {self.OwnerNW, self.EntsNW}
	local fac, infos = self:GetOwner()

	for k,v in ipairs(infos) do
		local ply = v:GetPlayer()
		if ply:IsValid() then plys[#plys + 1] = ply end
	end

	Networkable.UpdateFull(plys, nws)
end

-- This filter is used in multiple places
function bw.Base.OwnerNWFilter(nw, ply)
	local self = nw.Base
	return self:IsOwner(ply)
end

function bw.Base:GetOwner()
	self:_CheckValidity()

	-- return #1: faction or nil
	-- return #2: table of playerinfo(s)
	local fac = self:GetOwnerFaction()
	local plys = fac and fac:GetMembersInfo() or {self.Owner.Player}

	return fac, plys
end

function bw.Base:GetOwnerFaction()
	self:_CheckValidity()

	return self.Owner.Faction
end

bw.Base.IsFactionOwned = bw.Base.GetOwnerFaction

function bw.Base:GetOwnerPlayer()
	self:_CheckValidity()
	return self.Owner.Player
end

function bw.Base:IsOwner(what)
	assert(IsPlayer(what) or isstring(what) or IsPlayerInfo(what) or IsFaction(what))

	self:_CheckValidity()

	local fac, infos = self:GetOwner()

	if IsFaction(what) then
		return fac == what
	else
		local pin = GetPlayerInfo(what)
		for k,v in ipairs(infos) do
			if v == pin then return true end
		end

		return false
	end
end

function bw.Base:CanClaim()
	self:_CheckValidity()

	local ow = self.Owner
	if ow.Faction and ow.Faction:IsValid() then return false end
	if ow.Player and ow.Player:IsValid() then return false end

	return true
end


ChainAccessor(bw.Zone, "Brush", "Brush")

hook.Add("BWBasesLoaded", "BrushRescan", function()
	for k,v in pairs(bw.Zones) do
		if v:GetBrush() then
			v:GetBrush():ForceScanEnts()
		end
	end
end)