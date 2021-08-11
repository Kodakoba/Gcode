--

local bw = BaseWars.Bases
local pg = bw.PowerGrid

function pg:GetPower()
	return self:GetNW():Get("Power", 0)
end

function pg:GetPowerIn()
	return self:GetNW():Get("PowerIn", 0)
end

function pg:GetPowerOut()
	return self:GetNW():Get("PowerOut", 0)
end