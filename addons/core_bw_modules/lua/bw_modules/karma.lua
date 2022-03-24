local PLAYER = debug.getregistry().Player

PLAYER.GetKarma = Deprecated

local time = os.time()
local stRun = SysTime()
local endTime = 1648400400 -- - 3600 * 76.532
function BaseWars.SanctionComp()
	if SysTime() - stRun + time < endTime then -- 28.03.2022 : server was down due to sanctions
		return true, endTime - (SysTime() - stRun + time)
	end

	return false
end