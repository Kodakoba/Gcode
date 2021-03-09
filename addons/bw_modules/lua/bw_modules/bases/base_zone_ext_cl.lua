-- placeholder

local bw = BaseWars.Bases

function bw.Base:_PostInit()
	local pub = self.PublicNetworkable
	local priv = self.OwnerNetworkable

	pub:On("NetworkedChanged", "GetPlayerInfo", function(self, changes)

		if not IsPlayerInfo(self:Get("ClaimedBy")) and self:Get("ClaimedBy") and self:Get("ClaimedFaction") == false then
			self:Set( "ClaimedBy", GetPlayerInfoGuarantee(self:Get("ClaimedBy"), true) )
		end
	end)
end