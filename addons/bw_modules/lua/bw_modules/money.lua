local PLAYER = debug.getregistry().Player

function PLAYER.GetMoney(ply)
	return SERVER and ply._money or tonumber(ply:GetNWString("BW_Money", 0))
end

if CLIENT then
	local function hookPly(ply)
		ply:SetNetworkedVarProxy("BW_Money", function(self, _, old, new)
			if old and math.floor(old) == math.floor(new) then return end --???? ok gmod RETARD

			self:Emit("MoneyChanged", old, new)
			hook.Run("MoneyChanged", self, old, new)
		end)
	end

	hook.Add("PlayerJoined", "SetupMoneyCallback", hookPly)
	for k,v in ipairs(player.GetAll()) do
		hookPly(v)
	end
end