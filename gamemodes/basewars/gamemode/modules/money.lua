local PLAYER = debug.getregistry().Player

function PLAYER.GetMoney(ply)
	return tonumber(ply:GetNWString("BasewarsMoney")) or 0
end

if CLIENT then
	local function hookPly(ply)
		ply:SetNetworkedVarProxy("BasewarsMoney", function(self, _, old, new)
			if math.floor(old) == math.floor(new) then return end --???? ok gmod RETARD
			print(old, new)
			self:Emit("MoneyChanged", old, new)
			hook.Run("MoneyChanged", self, old, new)
		end)
	end

	hook.Add("PlayerJoined", "SetupMoneyCallback", hookPly)
	for k,v in ipairs(player.GetAll()) do
		hookPly(v)
	end
end