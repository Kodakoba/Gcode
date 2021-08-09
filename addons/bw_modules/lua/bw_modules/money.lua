local PLAYER = debug.getregistry().Player

local PInfo = LibItUp.PlayerInfo
BaseWars.Money = BaseWars.Money or {}
BaseWars.Money.NWKey = "$"

function PLAYER:GetMoney()
	return GetPlayerInfoGuarantee(self):GetMoney()
end

function PInfo:GetMoney()
	if SERVER then
		return self._money
	else
		return self:GetPublicNW():Get(BaseWars.Money.NWKey, -1)
	end
end

if CLIENT then
	local function hookPly(ply)
		local pin = ply:GetPInfo()
		local nw = pin:GetPublicNW()

		nw:On("NetworkedVarChanged", "MoneyCallback", function(_, key, old, new)
			if key ~= "$" then return end

			if ply:IsValid() then
				ply:Emit("MoneyChanged", old, new)
			end

			if pin:IsValid() then
				pin:Emit("MoneyChanged", old, new)
				hook.Run("MoneyChanged", pin, old, new)
			end
		end)
	end

	hook.Add("PlayerJoined", "SetupMoneyCallback", hookPly)
	for k,v in ipairs(player.GetAll()) do
		hookPly(v)
	end
end