local bw = BaseWars.Bases

function bw.Base:ListenFaction(fac)
	local listenID = "BaseListen" .. self:GetID()

	fac:On("Update", listenID, function()
		-- ?
	end)

	fac:On("Remove", listenID, function()
		if self.Owner.Faction == fac then
			self:Unclaim()
		end
	end)
end

function bw.Base:Claim(by)
	if not self:CanClaim(by) then return false end

	if IsFaction(by) then
		self.Owner.Faction = by
		self.Owner.Player = nil
		self:SetClaimed(true)
		self:ListenFaction(by)

	elseif IsPlayer(by) then
		local pinfo = by:GetPInfo()
		self.Owner.Faction = nil
		self.Owner.Player = pinfo
		self:SetClaimed(true)

		by:GetPInfo():On("Destroy", self, function()
			if self.Owner.Player == pinfo then
				self:Unclaim()
			end
		end)
	end

	self:Emit("Claim")
	hook.Run("BaseClaimed", self, by)

	return true
end

function bw.Base:Unclaim()
	local prev = self.Owner.Faction or self.Owner.Player
	self.Owner.Faction = nil
	self.Owner.Player = nil
	self:SetClaimed(false)

	self:Emit("Unclaim")
	hook.Run("BaseUnclaimed", self, prev)
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
		return self.Owner.Player == what
	end
end

function bw.Base:CanClaim()
	local ow = self.Owner
	if ow.Faction and ow.Faction:IsValid() then return false end
	if ow.Player and ow.Player:IsValid() then return false end

	return true
end