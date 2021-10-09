local god = "ger"
local oh = "ig"

local nwords = {
	"n" .. oh .. god,
	"negro",
	"n" .. oh .. "er",
	"n" .. oh .. "ga",
	"the nword",
}

hook.Add("PlayerSay", "!!getdownmrpresident", function(ply, txt)
	local newtxt = txt
	local repped = false
	--[[for k,v in pairs(nwords) do
		if txt:find(v) then
			--newtxt = txt:gsub(v, ":HYPERBRUH:")
			repped = true
		end
	end
	if repped then
		timer.Simple(0, function() hook.Run("PlayerSay", ply, newtxt) end)
		--return newtxt
	end]]
end)

hook.Add("PlayerSpawn", "jihadi", function(ply)
	if ply:GetUserGroup() == "terrorism_funder" then
		local wep = ply:Give("arccw_nade_frag")
		wep.DisallowDrop = true
	end
end)