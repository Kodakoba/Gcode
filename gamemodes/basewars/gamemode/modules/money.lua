local PLAYER = debug.getregistry().Player

function PLAYER.GetMoney(ply)
	return tonumber(ply:GetNWString("BaseWars.Money")) or 0
end
