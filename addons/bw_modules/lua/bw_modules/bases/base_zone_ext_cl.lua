-- placeholder

local bw = BaseWars.Bases

local waitingEnts = {}

hook.Add("NotifyShouldTransmit", "BWBaseEntityList", function(ent, enter)
	local eid = ent:EntIndex()

	if enter and waitingEnts[eid] and waitingEnts[eid]:IsValid() then
		waitingEnts[eid].Entities[ent] = eid
		waitingEnts[eid] = nil
	end
end)

function bw.Base:_PostInit()
	local pub = self.PublicNW
	local priv = self.OwnerNW
	local entNW = self.EntsNW

	local base = self

	pub:On("NetworkedChanged", "GetPlayerInfo", function(self, changes)
		print("pub network change", self:Get("ClaimedBy"))
		if self:Get("ClaimedBy") then
			base:SetClaimed(true)

			if not IsPlayerInfo(self:Get("ClaimedBy")) and self:Get("ClaimedFaction") == false then
				-- assume ClaimedBy is a steamid64, make it a playerinfo
				self:Set( "ClaimedBy", GetPlayerInfoGuarantee(self:Get("ClaimedBy"), true) )
			elseif not IsFaction(self:Get("ClaimedBy")) and self:Get("ClaimedFaction") == true then
				-- assume ClaimedBy is a faction ID, make it into a faction
				self:Set( "ClaimedBy", Factions.GetFaction(self:Get("ClaimedBy")) )
			end
		else
			print("base now unclaimed; also unclaiming", self:Get("ClaimedBy"))
			base:SetClaimed(false)
		end
	end)

	entNW:On("NetworkedChanged", "GetEntitiesInfo", function(self, changes)

		for entID, change in pairs(changes) do
			local old, new = change[1], change[2]

			local ent = Entity(entID)

			if not ent:IsValid() then
				if new then
					waitingEnts[entID] = base
					continue
				else
					for k,v in pairs(base.Entities) do
						if v == entID then
							base.Entities[k] = nil	-- i can't believe i have to do this
							continue
						end
					end
				end
			end

			if not old and new then
				hook.Run("EntityEnteredBase", base, ent)
				base.Entities[ent] = entID
			elseif old and not new then
				hook.Run("EntityExitedBase", base, ent)
				base.Entities[ent] = nil
			end
		end

	end)

end

function bw.Base:GetOwner()
	-- return #1: faction or nil
	-- return #2: table of playerinfo(s)
	local pub = self.PublicNW
	local claimed = pub:Get("Claimed")
	if not claimed then return false, false end

	local by = pub:Get("ClaimedBy")
	local fac = pub:Get("ClaimedFaction")

	if fac and IsFaction(by) then
		return by, by:GetMembersInfo()
	else
		return false, by
	end
end

function bw.Base:GetOwnerFaction()
	local pub = self.PublicNW
	local fac = pub:Get("ClaimedFaction")
	if fac then
		return pub:Get("ClaimedFaction")
	end

	return false
end

bw.Base.IsFactionOwned = bw.Base.GetOwnerFaction

function bw.Base:IsOwner(what)
	local pub = self.PublicNW

	local by = pub:Get("ClaimedBy")
	local fac = pub:Get("ClaimedFaction")

	if fac then
		return by == what or by:IsMember(what)
	else
		return by == GetPlayerInfo(what)
	end
end