--hairy balls

function Research.HookPerk(name, func)
	hook.Add(name, name, function(...)

	end)
end

function Research.HookHealth(self)
	local ply = self:GetOwner()
	local lv = self:GetLevel()


end

hook.Add("PlayerSpawn", "ApplyResearch", function()


end)


function Research.BeginResearch(ply, perk, ent)
	local lv = ply:GetPerk(perk.ID)

	local reqs = perk.Levels[lv + 1]
	if not reqs then print("no requirements for", lv + 1) return end

	reqs = reqs.reqs 

	local enough = true 

	for k,v in pairs(reqs) do 
		if not Inventory.EnoughItem(ply, k, v) then enough = false break end 
	end 

	if enough then 
		ent:QueueResearch(ply, perk, lv+1)
	end

end