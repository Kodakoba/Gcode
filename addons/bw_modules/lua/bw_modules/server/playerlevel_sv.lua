BaseWars.PlayerLevel = BaseWars.PlayerLevel or {}
local MODULE = BaseWars.PlayerLevel

function MODULE.GetLevel(ply, uncache)

end
PLAYER.GetLevel = MODULE.GetLevel

function MODULE.GetXP(ply)

	if SERVER then

		local puid = MODULE.Init(ply)
		local xp = ply.xp

		if not xp then
			local data = sql.Check("SELECT * FROM bw_plyData WHERE puid=="..puid, true )
			data = data[1]
			xp = data.xp
			ply.xp = xp
		end

		return tonumber(xp)

	elseif CLIENT then

		return tonumber(ply:GetNWString("BWXP")) or 0

	end

end

PLAYER.GetXP = MODULE.GetXP


function MODULE:LoadLevel(dat, write)
	local money = dat.money

	if not money then --bruh
		money = BaseWars.Config.StartMoney
		--write.money = money
		
		MODULE.Log("Reset money for \"%s\" (%s) to starting money (%s)",
			self:Nick(), self:SteamID64(), Language.Price(money))
	end

	self:SetMoney(money, true)

end

hook.Add("BW_LoadPlayerData", tag .. ".Load", MODULE.LoadLevel)
--hook.Add("BW_SavePlayerData", tag .. ".Save", MODULE.SaveMoney)