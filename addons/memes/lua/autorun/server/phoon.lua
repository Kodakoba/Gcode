
util.AddNetworkString("gachiHop")
local violated = {}

hook.Add("Simplac.PlayerViolation", "dontforgettoxd", function(ply, sid64, viol)
	viol = viol:sub(1,2)

	if viol=="BH" then 
		violated[ply] = CurTime()
		net.Start("gachiHop")
			net.WriteBool(true)
		net.Send(ply)
	end
end)

hook.Add("Think", "dontforgettoxd", function()
	for k,v in pairs(violated) do 
		if CurTime() - v > 5 then 
			net.Start("gachiHop")
				net.WriteBool(false)
			net.Send(k)
			violated[k] = nil
		end
	end

end)

local god = "ger"
local oh = "ig"

local nwords = {
	"n" .. oh .. god,
	"negro",
	"n" .. oh .. "er",
	"n" .. oh .. "ga",
	"the nword",
}

hook.Add("PlayerSay","__getdownmrpresident", function(ply, txt)
	local newtxt = txt
	local repped = false
	for k,v in pairs(nwords) do
		if txt:find(v) then 
			newtxt = txt:gsub(v, ":HYPERBRUH:")
			repped = true
		end 
	end
	if repped then 
		timer.Simple(0, function() hook.Run("PlayerSay", ply, newtxt) end)
		return newtxt
	end
end)