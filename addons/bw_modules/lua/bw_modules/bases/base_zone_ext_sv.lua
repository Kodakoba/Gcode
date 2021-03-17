local bw = BaseWars.Bases

function bw.Base:ListenFaction(fac)
	local listenID = "BaseListen" .. self:GetID()

	fac:On("Remove", listenID, function()
		if self.Owner.Faction == fac then
			self:Unclaim()
		end

		fac._Base = nil
	end)

	--[[fac:On("LeaveFaction", listenID, function(_, ply, pinfo)
		print("Player left faction", ply, pinfo, pinfo._Base, pinfo._Base == self)
		if pinfo._Base == self then
			print("equal to self, removing")
			pinfo._Base = nil
		end
	end)]]
end

function bw.Base:Claim(by, force)
	if not self:CanClaim(by) and not force then return false end

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

	elseif IsPlayer(by) then
		local pinfo = by:GetPInfo()
		pinfo._Base = self

		self.Owner.Faction = nil
		self.Owner.Player = pinfo

		by:GetPInfo():On("Destroy", self, function()
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
	hook.NHRun("BaseClaimed", self, by)

	return true
end

hook.Add("FactionCreated", "BWBaseOwnership", function(ply, fac)
	local base = GetPlayerInfo(ply):GetBase(true)
	if base and base:IsValid() then
		base:Claim(fac, true)
	end
end)

function bw.Base:Unclaim(temporarily)
	local prev = self.Owner.Faction or self.Owner.Player
	print("Unclaim called", prev, IsFaction(prev), IsPlayerInfo(prev))

	--[[if IsFaction(prev) then
		prev._Base = nil
	else
		print("Yeeting plyinfo", prev)]]
		prev._Base = nil
	--end

	self.Owner.Faction = nil
	self.Owner.Player = nil

	if not temporarily and self:IsValid() then
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

	if fac then
		for k,v in ipairs(infos) do
			local ply = v:GetPlayer()
			if ply:IsValid() then plys[#plys + 1] = ply end
		end
	else
		plys[1] = infos:GetPlayer()
	end

	Networkable.UpdateFull(plys, nws)
end

-- This filter is used in multiple places
function bw.Base.OwnerNWFilter(nw, ply)
	local self = nw.Base
	return self:IsOwner(ply)
end

function bw.Base:GetOwner()
	-- return #1: faction or nil
	-- return #2: table of playerinfo(s)
	local fac = self:GetOwnerFaction()
	local plys = fac and fac:GetMembersInfo() or self.Owner.Player

	return fac, plys
end

function bw.Base:GetOwnerFaction()
	return self.Owner.Faction
end

bw.Base.IsFactionOwned = bw.Base.GetOwnerFaction

function bw.Base:IsOwner(what)
	if self.Owner.Faction then
		return self.Owner.Faction == what or self.Owner.Faction:IsMember(what)
	else
		return self.Owner.Player == GetPlayerInfo(what)
	end
end

function bw.Base:CanClaim()
	local ow = self.Owner
	if ow.Faction and ow.Faction:IsValid() then return false end
	if ow.Player and ow.Player:IsValid() then return false end

	return true
end