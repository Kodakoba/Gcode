local dumbShit = {
	[1] = 1742,
	[2] = 1743,
	[3] = 1746,
	[4] = 1747,
	[5] = 1748,
	[6] = 1749
}

function CleanupDumbDoors()
	for k,v in ipairs(dumbShit) do
		local ent = ents.GetMapCreatedEntity(v)
		if ent:IsValid() then
			ent:Remove()
		end
	end
end

hook.Add("InitPostEntity", "FuckYou", CleanupDumbDoors)
hook.Add("PostCleanupMap", "FuckYou", CleanupDumbDoors)